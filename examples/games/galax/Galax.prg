compiler_options _extended_conditions;
//------------------------------------------------------------------------------
// TITLE:      GALAX
// AUTHOR:       LUIS SUREDA
// DATE:       DIV GAMES STUDIO (c) 2000
//------------------------------------------------------------------------------

PROGRAM galax;

CONST
    wide_swarm=12;
    stop_swarm=4;

    n_enemies= wide_swarm*stop_swarm;

    wide_ship=20;
    stop_ship=20;
    move_swarm=1;

GLOBAL
    x_swarm=60;
    y_swarm=20;

    option=0;

    laser=0;
    laser2=0;
    atack3=0;
    atack1=0;
    explo=0;

    score;
    max_score=0;
    level;
    next_level;
    lives;
    lose_life;
    enemies;
    change_dir;
    dir;
    missile_flag;
    idship;



    formacion[n_enemies]=3,3,3,3,3,0,0,3,3,3,3,3,
                          0,2,2,2,0,2,2,0,2,2,2,0,
                          2,1,2,1,0,2,2,0,1,2,1,2,
                          1,1,0,1,1,0,0,1,1,0,1,1;

    tipo_enemigo[n_enemies];

LOCAL
    numero=0;

PRIVATE
    contador0=0;

BEGIN

    load_fpg("galax\galax.fpg");
    load_fpg("galax\galax2.fpg");
    load_fnt("galax\galax.fnt");


    laser=load_pcm("galax\laser.pcm",0);
    laser2=load_pcm("galax\laser2.pcm",0);
    explo=load_pcm("galax\laser3.pcm",0);
    atack3=load_pcm("galax\buiu.pcm",0);
    atack3=load_pcm("galax\fx1.pcm",0);

    priority=-1;

    LOOP

        load_pal("galax\galax2.fpg");
        put_screen(1,1);

        fade_on();

        option=0;
        lives=3;
        level=1;
        scan_code=0;

        REPEAT
            FRAME;
        UNTIL (scan_code<>0)


        IF (key (_esc)) BREAK; END


        lose_life=0;


        IF (score>max_score) max_score=score; END
        score=0;


        delete_text(all_text);

        fade_off();
        load_pal("galax\galax.fpg");
        put_screen(0,1);


        write(1,0,0,0,"  SCORE  ");
        write(1,320,0,2,"HIGH SCORE");
        write(1,110,0,0,"LIVES");
        write(1,160,0,0,"LEVEL");
        write_int(1,0,8,0,&score);
        write_int(1,120,10,0,&lives);
        write_int(1,175,10,0,&level);
        write_int(1,320,10,2,&max_score);

        set_fps(30,0);
        fade_on();

        idship=ship();

        LOOP
            next_level=0;


            x_swarm=60;
            enemies=0;


            FOR (contador0=0;contador0<n_enemies;contador0++)
                tipo_enemigo[contador0]=formacion[contador0];
                IF (tipo_enemigo[contador0]<>0)
                    enemies++;
                    enemigo(contador0,tipo_enemigo[contador0]);
                END
            END

            dir=1;
            change_dir=0;

            REPEAT
                REPEAT
                    FRAME;
                    IF (dir==0)
                        x_swarm-=move_swarm;
                        IF (x_swarm<0) change_dir=1; END
                    ELSE
                        x_swarm+=move_swarm;
                        IF (x_swarm>320) change_dir=1;  END
                    END

                    IF (change_dir==1)
                        dir=dir XOR 1;
                        change_dir=0;
                    END

                    IF (key(_esc))
                        lose_life=1;
                        lives=0;
                    END

                UNTIL (next_level OR lose_life)


                WHILE (get_id(TYPE explosion))
                    FRAME;
                END

                IF (lose_life==1)
                    lives--;
                    lose_life=0;
                    fade_off();

                    signal(TYPE enemigo,s_kill);
                    signal(TYPE fuego,s_kill);

                    idship=ship();
                    FOR (contador0=0;contador0<n_enemies;contador0++)
                        IF (tipo_enemigo[contador0]<>0)
                            enemigo(contador0,tipo_enemigo[contador0]);
                        END
                    END
                    fade_on();
                END
                IF (next_level==1) BREAK; END
            UNTIL (lives<0)

            IF (lives<0) BREAK; END

            fade_off();
            fade_on();

            level++;
        END

        let_me_alone();
        delete_text(all_text);
    END
    creditos();
END






PROCESS ship();

PRIVATE
    velocidad=0;

BEGIN
    graph=13;
    x=160;
    y=188;
    missile_flag=0;
    LOOP


        IF (key(_right) AND velocidad<6)
            velocidad+=2;
        ELSE
            IF (velocidad>0)  velocidad--; END
        END
        IF (key(_left) AND velocidad>-6)
            velocidad-=2;
        ELSE
            IF (velocidad<0)  velocidad++; END
        END
        x+=velocidad;

        IF (x>310)
            x=310;
            velocidad=0;
        END
        IF (x<10)
            x=10;
            velocidad=0;
        END

        IF (key(_space) OR key (_control))
            IF (missile_flag==0)
                sound(laser,40,50);
                missile_flag=1;
                misil(x,y-10);
            END
        END

        FRAME;
    END
END







PROCESS misil(x,y);

BEGIN
    graph=14;
    REPEAT
        y-=8;
        IF (graph==14)
            graph=15;
        ELSE
            graph=14;
        END

        FRAME;
    UNTIL (out_region(id,0))
    missile_flag=0;
END







PROCESS fuego(x,y,tipo_fuego);

PRIVATE
    id_proceso;
    x_avance;

BEGIN
    graph=tipo_fuego;
    sound(laser2,256,300);
    resolution=100;

    IF (idship.y==y)
        x_avance=0;
    ELSE




        x_avance=(((idship.x-x)*resolution)*3)/(idship.y-y);


        IF (x_avance>100) x_avance=100; END
        IF (x_avance<-100) x_avance=-100; END
    END

    y=y*resolution;
    x=x*resolution;

    REPEAT
        IF ((graph==16) OR (graph==17))
            IF (graph=16)
                graph=17;
            ELSE
                graph=16;
            END
        END
        
        y+=300;
        x+=x_avance;

        
        IF (id_proceso=collision(TYPE ship))
            
            explosion(id_proceso.x,id_proceso.y,100);
            sound(explo,80,100);
            
            signal(id_proceso,s_kill);
            signal(id,s_kill);
            lose_life=1;       
        END
        FRAME;
    UNTIL (out_region(id,0))

END









PROCESS enemigo(numero_enemigo,enemigo_tipo);

PRIVATE
    fila;               
    col;
    num_aleatorio;      
    id_proceso;         
    ahora=0;            
    animacion[]=        
        8,9,10,11,10,9;
    abajo=0;            
                        
    velocidad;          

BEGIN
    numero=numero_enemigo;

    fila=numero/wide_swarm;    
    col=numero MOD wide_swarm;

    x=col*wide_ship+x_swarm;   
    y=fila*stop_ship+y_swarm;

    SWITCH (enemigo_tipo)           
        case 1: graph=2; END
        case 2: graph=animacion[0]; END
        case 3: graph=12; END
    END

    LOOP
        IF (enemigo_tipo==1)        
            graph++;
            IF (graph==7) graph=2; END
        END

        IF (enemigo_tipo==2)        
            ahora++;
            IF (ahora>5) ahora=0; END
            graph=animacion[ahora];
        END

        IF (y<130)                  
            num_aleatorio=rand(0,1500);     
            IF (enemigo_tipo==3 AND num_aleatorio<=level*2)
                fuego(x,y+4,18);
            END
            IF (enemigo_tipo==2 AND num_aleatorio<=level)
                fuego(x,y+4,16);
            END
        END

        IF (abajo==1)           
            y+=2;
            
            IF (out_region(id,0))
                
                y=0;
                x=col*wide_ship+x_swarm;
                abajo=3;
            END
            IF (x>idship.x)     
                IF (velocidad>-enemigo_tipo-2) velocidad--; END
            ELSE
                IF (velocidad<enemigo_tipo+2) velocidad++; END
            END
            x+=velocidad;
        END

        IF (abajo==3)           
            y++;
            IF (y==fila*stop_ship+y_swarm) abajo=0; END
            
            IF (enemies<level*3) abajo=1; END
        END

        IF ((abajo==0) OR (abajo==3)) 
            num_aleatorio=rand(1,4000);
            
            IF (num_aleatorio<level*2)
                abajo=1;
                IF (enemigo_tipo==3)
                    SOUND(atack3,200,300);
                END
                IF (enemigo_tipo==1)
                    SOUND(atack1,200,300);
                END
            END

            IF (dir==0)         
                x-=move_swarm;

                
                IF (x<20) change_dir=1; END

            ELSE                
                x+=move_swarm;
                IF (x>300) change_dir=1; END 
            END
        END

        
        IF (id_proceso=collision(TYPE ship))
            lose_life=1;
            signal(id_proceso,s_kill);
        ELSE
            IF (id_proceso=collision(TYPE misil))  
                signal(id_proceso,s_kill);
                score+=10;                    
                
                IF (score MOD 1000==0) lives++; END
                missile_flag=0;        
            END
        END

        IF (id_proceso)                 
            enemies--;
            tipo_enemigo[numero]=0;     
            IF (enemies==0) next_level=1; END
            explosion(x,y,100);         
            sound(explo,80,100);
            signal(id,s_kill);
        END
        FRAME;
    END
END






PROCESS explosion(x,y,size);

BEGIN
    graph=19;               
    REPEAT
        IF (size>50 AND rand(0,100)<size/8) 
            CLONE
                x+=rand(-8,8);
                y+=rand(-8,8);
            END
        END
        size-=4;            
        FRAME;
    UNTIL (size<25)         
END




PROCESS creditos()

PRIVATE
    fuentec;            

BEGIN
    
    fade_off();
    delete_text(all_text);  
    put_screen(1,2);        

    
    fuentec=load_fnt("galax\galax2.fnt");

    
    write(fuentec,160,30,4,"- CREDITS -");
    write(fuentec,160,60,4,"CODER: LUIS SUREDA");
    write(fuentec,160,80,4,"GRAPHICS: JOSE FERNANDEZ");
    write(fuentec,160,100,4,"SOUNDS: CARLOS ILLANA");
    write(fuentec,160,120,4,"COPYRIGHT 1997");
    write(fuentec,160,140,4,"DIV GAMES STUDIO");
    fade_on();  

    
    scan_code=0;
    WHILE (scan_code==0)
        FRAME;
    END
    fade_off();
    exit("Thanks for Playing!",0);   
END
