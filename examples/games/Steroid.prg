compiler_options _extended_conditions;
//-----------------------------------------------------------------------------
//TITLE:        STEROID
//AUTHOR:       DANIEL NAVARRO
//DATE:         DIV GAMES STUDIO (c) 2000
//-----------------------------------------------------------------------------

PROGRAM steroid;

GLOBAL
    score=0;
    lives=3;
    life[2];
    death=0;
    level=1;
    exit_=0;

    sound_fire;
    sound_explosion;
    sound_acceleration;
    sound_hyperspace;

    volume=0;
    id_sound;

PRIVATE
    number0=0;
    id2;
BEGIN


    set_mode(m640x480);
    load_fpg("steroid\steroid.fpg");
    load_fnt("steroid\steroid.fnt");


    sound_fire=load_pcm("steroid\tubo8.pcm",0);
    sound_explosion=load_pcm("steroid\tubo5.pcm",0);
    sound_acceleration=load_pcm("steroid\nave.pcm",1);
    sound_hyperspace=load_pcm("steroid\fx33.pcm",0);


    FROM number0=0 TO 499;
        put_pixel(rand(0,639),rand(0,479),127);
    END


    write(1,320,0,1,"STEROIDS Version 1.0");
    write(1,320,15,1,"(c) DIV GAMES STUDIO");
    write(1,0,480,6,"LEVEL");
    write(1,640,480,8,"< >:rotate ^:move SPC:shoot H:hyperspace");
    write_int(1,640,0,2,&score);
    write_int(1,64,480,6,&level);


    id_sound=sound(sound_acceleration,volume,200);

    LOOP
        fade_on();
        score=0;
        level=1;
        lives=3;
        volume=0;

        id2=write(1,320,240,1,"PRESS A KEY TO PLAY");

        scan_code=0;
        REPEAT
            FRAME;
        UNTIL (scan_code==0)

        REPEAT
            IF (key (_esc))
                fade_off();
                exit_=1;
            END
            FRAME;
        UNTIL (scan_code<>0 OR (exit_==1))

        IF (exit_==1)
            let_me_alone();
            BREAK;
        ELSE
            exit_=0;
        END
        delete_text(id2);

        ship(320,240);


        FOR (number0=0;number0<2+level;number0++)
            asteroid(-16,-16,3);
        END


        life[0]=ship_small(16,16);
        life[1]=ship_small(48,16);
        life[2]=ship_small(80,16);
        LOOP

            IF (key(_esc))
                lives=0;
                let_me_alone();
                fade_off();
                BREAK;
            END

            IF (death)
                signal(life[--lives],s_kill);
                signal(TYPE asteroid,s_kill);
                signal(TYPE firing_ship,s_kill);
                death=0;

                IF (lives==0)
                    fade_off();
                    let_me_alone();
                    BREAK;
                END
                fade(0,0,0,8);
                WHILE (fading)
                    FRAME;
                END

                ship(320,240);
                FOR (number0=0;number0<2+level;number0++)
                    asteroid(-16,-16,3);
                END

                fade(100,100,100,8);
            END

            IF (get_id(TYPE asteroid)==0)
                fade(0,0,0,8);
                WHILE (fading)
                    FRAME;
                END
                level++;
                WHILE (id2=get_id(TYPE firing_ship))
                    signal(id2,s_kill);
                END
                signal(get_id(TYPE ship),s_kill);   
                ship(320,240);                      
                FOR (number0=0;number0<2+level;number0++) 
                    asteroid(-16,-16,3);
                END
                fade(100,100,100,8);                
            END

            FRAME;
            change_sound(id_sound,volume,200);    
        END
    END
    fade_off(); 
END




PROCESS ship(x,y);

PRIVATE
    firing=1;              
    hiper=1;                
    speed_x=0;          
    speed_y=0;          

BEGIN
    graph=1;
    LOOP
        
        IF (key(_right)) angle-=pi/16; END
        IF (key(_left)) angle+=pi/16; END

        IF (key(_up))                       
            speed_x+=get_distx(angle,10);
            speed_y+=get_disty(angle,10);
            
            IF ((volume+=30) > 256) volume=256; END
        ELSE
            
            volume-=10;
            IF (volume<0) volume=0; END
        END

        x+=speed_x/10;
        y+=speed_y/10;

        
        IF (x<-16) x+=640+32; END
        IF (y<-16)  y+=480+32; END
        IF (x>640+16) x-=640+32; END
        IF (y>480+16) y-=480+32; END

        IF (key(_space) OR key (_control))      
            IF (firing)                        
                firing=0;
                firing_ship(x,y,angle);        
            END
        ELSE
            firing=1;                          
        END

        IF (key(_h))                            
            IF (hiper)                          
                hiper=0;
                hyperspace(x,y);
                x=rand(0,640);                  
                y=rand(0,480);
            END
        ELSE
            hiper=1;                            
        END

        FRAME;
    END
END






PROCESS firing_ship(x,y,angle);

PRIVATE
    cont=20;                        

BEGIN
    sound(sound_fire,100,100);    
    graph=2;                        
    REPEAT
        x+=get_distx(angle,16);     
        y+=get_disty(angle,16);

        
        IF (x<-16) x+=640+32; END
        IF (y<-16) y+=480+32; END
        IF (x>640+16) x-=640+32; END
        IF (y>480+16) y-=480+32; END

        FRAME;
    UNTIL (--cont==0)               
END







PROCESS asteroid(x,y,graph);

PRIVATE
    speed;                
    id2=0;                    
    incr_angle;              
    angle2;                  

BEGIN
    angle=angle2=rand(0,2*pi);     
    incr_angle=rand(-pi/32,pi/32); 
    speed=graph+level;          

    LOOP

        
        IF (id2=collision(TYPE firing_ship))
            score+=25*graph+(level-1)*25;  
            signal(id2,s_kill);                 
            sound(sound_explosion,30*(6-graph),33*graph);
            IF (graph<5)                        
                asteroid(x,y,graph+1);         
                asteroid(x,y,graph+1);
            END
            IF (graph==3)                       
                asteroid(x,y,graph+1);         
            END
            signal(ID,s_kill);                  
        END

        
        IF (id2=collision(TYPE ship))
            signal(id2,s_kill);             
            sound(sound_explosion,200,100);
            volume=0;

            piece(id2.x,id2.y,id2.angle,6); 
            piece(id2.x,id2.y,id2.angle,7);
            piece(id2.x,id2.y,id2.angle,8);
            piece(id2.x,id2.y,id2.angle,9);
        END

        x+=get_distx(angle2,speed);    
        y+=get_disty(angle2,speed);

        
        IF (x<-16)  x+=640+32;   END
        IF (y<-16)  y+=480+32;   END
        IF (x>640+16) x-=640+32; END
        IF (y>480+16) y-=480+32; END

        angle+=incr_angle;                 
        FRAME;
    END
END








PROCESS piece(x,y,angle,graph);

PRIVATE
    angle2;                        
    incr_angle;                    

BEGIN
    angle2=rand(0,2*pi);           
    incr_angle=rand(-pi/32,pi/32);

    REPEAT
        angle+=incr_angle;         
        x+=get_distx(angle2,2);    
        y+=get_disty(angle2,2);
        size-=2;                    
        FRAME;
    UNTIL (size<=0)

    death=1;                       
END






PROCESS ship_small(x,y);

BEGIN
    graph=1;                    
    size=75;                    

    LOOP
        angle+=pi/64;           
        FRAME;
    END

END







PROCESS hyperspace(x,y);

BEGIN
    sound(sound_hyperspace,180,400); 
    graph=10;                           
    WHILE (size>0)                      
        size-=5;                        
        FRAME;
    END
END
