compiler_options _extended_conditions;
//-----------------------------------------------------------------------------
// TITLE:      BLAST EM UP!
// AUTHOR:       LUIS SUREDA / MANUEL CABA¥AS
// DATE:       DIV GAMES STUDIO (c) 2000
//-----------------------------------------------------------------------------


PROGRAM blastemup;

CONST
    firing_max=4;
    normal_movement=2;
    lives_max=5;

    max_ani=5;
    max_traject=10;

GLOBAL
    file1;

    fontfile1,fontfile2,fontfile3,fontfile4,fontfile5;

    sound1,sound2,sound3,sound4,
    sound5,sound6,sound7,sound8;

    program_state=1;
    state_new=0;
    movement_speed;


    id_ship_princ;
    state_ship;
    score;
    n_lives;


    posic_x_bonus[]=495,526,557,588,619;
    posic_x_lives[lives_max]=37,73,108;
    id_bonus[5];
    id_lives[lives_max];


    group_actual;
    complete_group;
    group_screen;
    alive[3];
    no_bonus[3];


    bonus_x;
    bonus_y;

    level_actual;


    STRUCT animation_enemy[max_ani];
        n_images;
        graphics[31];
    END =
        16,200,201,202,203,204,205,206,207,208,209,210,211,
        212,213,214,215,16 DUP(0),

        16,220,221,222,223,224,225,226,227,228,229,230,231,
        232,233,234,235,16 DUP(0),

        20,250,251,252,253,254,254,255,256,257,258,258,257,
        256,255,254,254,253,252,251,250,12 DUP(0),

        32,240,240,240,241,242,243,244,245,246,247,247,247,
        247,247,247,247,247,247,247,247,247,247,247,246,
        245,244,243,242,241,240,240,240,

        8,260,261,262,263,264,265,266,267,24 DUP(0),


        1,600,31 DUP(0);


        STRUCT trajectory[max_traject];
        n_section;
        x_ini;
        y_ini;
            STRUCT traject[18];
                images_per_section;
                speed_x;
                speed_y;
                acceleration_x;
                acceleration_y;
            END
        END=
            19,630,240,
            12,0,-8,0,0,    24,0,8,0,0,
            12,0,-8,0,0,    15,-32,-15,0,1,
            30,16,0,0,0,    12,0,8,0,0,
            15,-32,15,0,    -1,30,16,0,0,0,
            12,0,-8,0,0,    30,-16,0,0,0,
            30,16,0,0,0,    15,-32,15,0,-1,
            24,0,-8,0,0,    30,16,0,0,0,
            15,-32,15,0,-1, 30,16,0,0,0,
            15,-32,-15,0,1, 12,0,8,0,0,
            30,16,0,0,0,

            1,650,280,
            80,-35,0,1,0 , 18 DUP(0,0,0,0,0),

            2,300,20,
            18,1,1,1,1, 30,15,15,-5,1,  17(0,0,0,0,0),

            7,0,60,
            22,25,0,0,0,    5,0,10,0,0,      20,-25,10,0,0,
            20,0,-10,0,0,   20,25,10,0,0,    5,0,10,0,0,
            20,-25,0,-1,0,  12(0,0,0,0,0),

            6,630,150,
            5,-8,0,0,0,      8,-6,-9,0,0,    16,-7,9,0,0,
            16,-6,-9,0,0,    16,-7,9,0,0,    20,-10,0,-2,0,
            13(0,0,0,0,0),

            6,630,200,
            5,-8,0,0,0,      8,-6,9,0,0,     16,-7,-9,0,0,
            16,-6,9,0,0,     16,-7,-9,0,0,   20,-10,0,-2,0,
            13(0,0,0,0,0),

            5,630,250,
            26,-15,0,0,0,    12,-12,-10,2,0, 12,15,0,0,0,
            12,12,10,-2,0,   20,-15,0,-1,0,  14(0,0,0,0,0),

            7,630,110,
            10,0,10,0,0,     32,-10,0,0,0,   8,-10,10,0,0,
            8,10,10,0,0,     34,10,0,0,0,    8,0,-10,0,0,
            40,-10,0,-1,0,   12(0,0,0,0,0),

            8,630,0,
            25,-10,25,0,-1,  20,-20,-10,2,0, 20,20,10,-2,0,
            20,-20,-10,2,0,  20,20,10,-2,0,  20,-20,-10,2,0,
            20,20,10,-2,0,   30,-10,0,-2,0,  11(0,0,0,0,0),

            7,0,220,
            22,25,0,0,0,     5,0,10,0,0,     20,-25,10,0,0,
            20,0,-10,0,0,    20,25,10,0,0,   5,0,10,0,0,
            20,-25,0,-1,0,   12(0,0,0,0,0),

            6,640,140,
            8,-10,0,0,3,  16,-10,21,0,-3, 16,-10,-24,0,3,
            16,-10,21,0,-3, 16,-10,-24,0,3,  16,-10,21,0,-3,
            13(0,0,0,0,0);

LOCAL
    info;
    energy;
    id_collision;

BEGIN
    set_mode(m640x480);


    fontfile1=load_fnt("blastup\opciones.fnt");
    fontfile2=load_fnt("blastup\marcador.fnt");
    fontfile3=load_fnt("blastup\juego.fnt");
    fontfile4=load_fnt("blastup\creditos.fnt");


    sound1=load_pcm("blastup\faser.pcm",0);
    sound2=load_pcm("blastup\laser.pcm",0);
    sound3=load_pcm("blastup\disparo2.pcm",0);
    sound4=load_pcm("blastup\explosio.pcm",0);
    sound5=load_pcm("blastup\ding.pcm",0);
    sound6=load_pcm("blastup\buiu.pcm",0);
    sound7=load_pcm("blastup\fx1.pcm",0);
    sound8=load_pcm("blastup\cosa_a.pcm",0);


    LOOP
        SWITCH (program_state);
            CASE 1: title(); END
            CASE 2: play();  END
            CASE 3: credits(); END
            CASE 4: exit("Thanks for Playing!",0); END
        END
        FRAME;
    END
END






PROCESS enemy(type_enemy,tray,aggressiveness,n_group);

PRIVATE
    n_animation_s;
    animation=0;
    counter=0;
    speed_x;
    speed_y;

    acceleration_x;
    acceleration_y;

    number_section=0;
    actual_section=0;
    points;
    damage;

    xtime=0;
    ytime=0;

    counter1=0;
    counter2=0;

    images;
    death=0;

BEGIN
    region=1;
    info=type_enemy;


    n_animation_s=animation_enemy[type_enemy].n_images;
    graph=animation_enemy[type_enemy].graphics[animation];


    points=(type_enemy+3)*50;
    energy=type_enemy+1;
    IF (type_enemy==5) energy=40; END


    number_section=trajectory[tray].n_section;
    images=trajectory[tray].traject[actual_section].images_per_section;

    speed_x=trajectory[tray].traject[actual_section].speed_x;
    speed_y=trajectory[tray].traject[actual_section].speed_y;
    acceleration_x=trajectory[tray].traject[actual_section].acceleration_x;
    acceleration_y=trajectory[tray].traject[actual_section].acceleration_y;

    x=trajectory[tray].x_ini;
    y=trajectory[tray].y_ini;

    IF (type_enemy==4)
        y=rand(50,430);
        sound(sound8,512,256);

    END

    alive[n_group]++;

    LOOP


        IF (counter>=images)
            actual_section++;
            counter=0;
            IF (actual_section>=number_section)
                actual_section=0;
            END


            images=trajectory[tray].traject[actual_section].images_per_section;
            speed_x=trajectory[tray].traject[actual_section].speed_x;
            speed_y=trajectory[tray].traject[actual_section].speed_y;
            acceleration_x=trajectory[tray].traject[actual_section].acceleration_x;
            acceleration_y=trajectory[tray].traject[actual_section].acceleration_y;
        END
        speed_x+=acceleration_x;
        speed_y+=acceleration_y;
        x+=speed_x;
        y+=speed_y;


        animation++;
        IF (animation>=n_animation_s)
            animation=0;
        END
        graph=animation_enemy[type_enemy].graphics[animation];

        damage=0;


        IF (energy>damage AND (id_collision=collision(TYPE ball_shield)))
            explosion(rand(0,2),rand(0,19)+30);
            IF (info!=5)
                damage++;
            END
        END


        IF (energy>damage AND (id_collision=collision(TYPE bullet)))
            explosion(rand(0,2),rand(0,19)+20);
            signal(id_collision,s_kill);
            damage++;
        END

        IF (damage)
            IF (graph==240)
                graph=248;
                sound(sound5,256,256);
            ELSE
                IF (graph==600)
                    graph=601;
                END
                energy-=damage;
            END
        END


        IF (energy<=0)
            death=1;
            IF (info!=5)
                explosion(rand(0,2),80);
            ELSE
                xtime=x;
                ytime=y;
                FROM counter1=0 TO 19;
                    FROM counter2=0 TO 4;
                        x=xtime+rand(0,99)-50;
                        y=ytime+rand(0,99)-50;
                        explosion(rand(0,2),counter1*5+counter2+1);
                    END

                    x=xtime;
                    y=ytime;
                    FRAME;
                END
            END
            score+=points;
        END

        IF (rand(0,199)<aggressiveness)

            IF ((type_enemy!=4) AND (graph<>247))
                bullet_enemy(type_enemy,x,y,get_angle(id_ship_princ));
            END
        END

        FRAME;
        counter++;

        IF ((out_region(id,1)) OR (death))
            IF (death==0)
                no_bonus[n_group]=1;
            END
            alive[n_group]--;
            IF ((alive[n_group]==0) AND (no_bonus[n_group]==0))
                bonus_x=x;
                bonus_y=y;
            END
            RETURN();
        END
    END
END






PROCESS group(n_group);

PRIVATE
    n_enemys_g;
    counter_enemys=0;
    slow_down_counter=1;
    type_enem=0;
    trajectory1;
    slow_down_enemy;
    aggressiveness=0;

BEGIN
    group_screen++;
    alive[n_group]=0;
    no_bonus[n_group]=0;
    IF (group_actual==complete_group)
        type_enem=5;
        trajectory1=0;
        n_enemys_g=0;
        aggressiveness=30;
    ELSE
        n_enemys_g=rand(2,5);
        type_enem=rand(0,4);
        IF (type_enem==4)
            trajectory1=1;
            n_enemys_g+=3;
        ELSE
            trajectory1=rand(2,max_traject);
            aggressiveness=rand(0,5-group_screen)+level_actual;
        END
        slow_down_enemy=rand(5,15);
    END

    REPEAT
        slow_down_counter--;
        IF (slow_down_counter<=0)

            enemy(type_enem,trajectory1,aggressiveness,n_group);
            slow_down_counter=slow_down_enemy;
            counter_enemys++;
        END
        FRAME;
    UNTIL (counter_enemys>n_enemys_g)

    REPEAT
        FRAME;
    UNTIL (alive[n_group]==0)
    FRAME;

    IF (no_bonus[n_group]==0)
        IF (rand(0,2)==0)
            bonus(bonus_x,bonus_y,7);
        ELSE
            bonus(bonus_x,bonus_y,rand(1,7));
        END
    END
    group_screen--;

END






PROCESS play();

PRIVATE
    counter1=0;
    slow_down_group;

BEGIN
    clear_screen();
    set_fps(18,0);
    program_state=-2;

    load_pal("blastup\juego.fpg");
    file1=load_fpg("blastup\juego.fpg");
    put(file1,2,320,20);
    put(file1,3,320,460);
    define_region(1,0,41,640,398);
    start_scroll(0,file1,1,0,1,3);
    fade_on();
    FRAME;
    n_lives=lives_max;
    score=0;
    id_ship_princ=ship_principal();

    FOR (counter1=0;counter1<n_lives;counter1++)
        id_lives[counter1]=vida(counter1);
    END

    FROM counter1=0 TO 4;
        id_bonus[counter1]=0;
    END

    write_int(fontfile2,360,454,2,&score);


    complete_group=109;
    group_actual=0;
    group_screen=0;
    level_actual=0;
    slow_down_group=200;

    counter1=0;
    movement_speed=normal_movement;
    LOOP


        IF ((group_actual>complete_group) AND (group_screen==0))
            state_new=0;
            write(fontfile3,320,220,4,"CONGRATULATIONS");
            BREAK;
        END

        IF (group_actual<=complete_group)
            slow_down_group++;
        END

        IF (((slow_down_group*(level_actual+1)*3/2)>500) AND (group_screen<=(level_actual/3)))
            slow_down_group=rand(200,450);
            IF ((group_actual MOD 10)==0)
                display_level(level_actual+1);
                level_actual++;
                FROM counter1=0 TO 99;
                    IF (key(_esc))
                        state_new=1;
                        write(fontfile3,320,240,4,"GAME OVER");
                        FRAME(2000);
                        stop_scroll(0);
                        FRAME;
                        fade_off();
                        program_state=state_new;
                        delete_text(all_text);
                        signal(id,s_kill_tree);
                        signal(type bonus,s_kill);
                        unload_fpg(file1);
                        clear_screen();
                        fade_on();
                        RETURN;
                    END
                    FRAME;
                    scroll.x0+=movement_speed;
                END
            END
            counter1=0;


            WHILE (alive[counter1]>0) counter1++; END

            group(counter1);
            group_actual++;
        END


        IF (group_actual>complete_group)
            movement_speed=0;
        ELSE
            movement_speed=normal_movement;
        END

        scroll.x0+=movement_speed;


        counter1=0;
        WHILE (id_bonus[counter1] AND counter1<5)
            counter1++;
        END

        IF (counter1==5)
            sound(sound7,256,256);


            FROM counter1=0 TO 4;
                signal(id_bonus[counter1],s_kill);
                id_bonus[counter1]=0;
            END


            IF (n_lives<lives_max)
                id_lives[n_lives]=vida(n_lives);
                n_lives++;
            ELSE
                shield();
            END
        END
        FRAME;

        IF (n_lives<0 OR key(_esc))
            state_new=1;
            write(fontfile3,320,240,4,"GAME OVER");
            BREAK;
        END
    END

    FRAME(1000);
    stop_scroll(0);
    FRAME;
    fade_off();
    program_state=state_new;
    delete_text(all_text);
    signal(id,s_kill_tree);
    signal(type bonus,s_kill);
    unload_fpg(file1);
    clear_screen();
    fade_on();
END






PROCESS title();

BEGIN
    program_state=-1;
    state_new=0;
    file1=load_fpg("blastup\titulo.fpg");
    put_screen(file1,1);
    load_pal("blastup\titulo.fpg");
    FRAME;
    fade_on();


    write(fontfile1,8,340,0,"1 Play");
    write(fontfile1,8,370,0,"2 Credits");
    write(fontfile1,8,400,0,"3 Exit");
    write(fontfile1,320,460,4,"(c) 2000 DIV Games Studio");


    WHILE (state_new==0)


        IF (key(_1) OR key (_space) OR key (_enter)) state_new=2; END
        IF (key(_2)) state_new=3; END
        IF (key(_3) OR key (_esc)) state_new=4; END

        FRAME;
    END


    fade_off();
    unload_fpg(file1);
    delete_text(all_text);
    program_state=state_new;
END






PROCESS credits();

BEGIN
    program_state=-3;
    load_pal("blastup\creditos.fpg");
    file1=load_fpg("blastup\creditos.fpg");
    put_screen(file1,1);
    FRAME;
    fade_on();


    write(fontfile4,40,0,0,"Coders:");
    write(fontfile4,100,40,0,"Manuel Caba¤as");
    write(fontfile4,100,80,0,"Luis Sureda");
    write(fontfile4,40,300,0,"Graphics:");
    write(fontfile4,100,340,0,"Jos‚ Fern ndez");
    write(fontfile4,40,390,0,"Music:");
    write(fontfile4,100,430,0,"Moises D¡az Toledano");

    FRAME;

    scan_code=0;

    WHILE (scan_code==0)
        FRAME;
    END
    fade_off();
    delete_text(all_text);
    unload_fpg(file1);
    program_state=1;
END






PROCESS ship_principal();

PRIVATE

    shooting=0;

    bank;
    inc_x=0;
    inc_y=0;

    type_firing;

BEGIN
    file1=file1;
    graph=100;
    x=32;
    y=240;
    z=-2;
    region=1;

    state_ship=1;
    type_firing=0;
    energy=1;

    write_int(fontfile2,600,448,2,&type_firing);

    FRAME;

    LOOP


        IF (inc_x>0) inc_x-=4; END
        IF (inc_x<0) inc_x+=4; END
        IF (inc_y>0) inc_y-=2; END
        IF (inc_y<0) inc_y+=2; END


        IF (key(_q) OR key(_up))
            inc_y=-12;
            bank--;
        END
        IF (key(_a) OR key(_down))
            inc_y=12;
            bank++;
        END
        IF (key(_o) OR key(_left))
            inc_x=-24;
        END
        IF (key(_p) OR key(_right))
            inc_x=24;
        END


        IF (bank>15) bank-=16; END
        IF (bank<-16) bank+=16; END


        IF (inc_y>-6 AND inc_y<6)
            IF (bank>0) bank--; END
            IF (bank<0) bank++; END
        END


        IF (bank<0)
            graph=116+bank;
        ELSE
            graph=100+bank;
        END


        IF ((y+inc_y)<66)
            y=66;
            inc_y=0;
        END
        IF ((y+inc_y)>414)
            y=414;
            inc_y=0;
        END
        IF ((x+inc_x)<30)
            x=30;
            inc_x=0;
        END
        IF ((x+inc_x)>610)
            x=610;
            inc_x=0;
        END
        x+=inc_x;
        y+=inc_y;


        IF (key(_space) OR key(_enter) OR key(_control))
            IF (shooting==0)
                firing(type_firing);
            END
            shooting++;
        ELSE
            shooting=0;
        END


        IF (energy>0 AND (id_collision=collision(TYPE enemy)))
            IF (id_collision.info!=5)
                IF (id_collision.graph!=240)
                      id_collision.energy--;
                  END
            END

        IF (state_ship!=2) energy--; END
        END


        IF (energy>0 AND (id_collision=collision(TYPE bullet_enemy)))
            signal(id_collision,s_kill);

            IF (state_ship!=2) energy--; END
        END


        IF (energy<=0)
            n_lives--;
            IF (type_firing>0) type_firing--; END
            graph=0;
            explosion(rand(0,2),100);
            IF (n_lives<0) BREAK; END
            signal(id_lives[n_lives],s_kill);
            FRAME(200);
            shield();
            graph=100;
            energy=1;
        END


        IF ((id_collision=collision(TYPE bonus)))
            sound(sound6,256,256);
            SWITCH (id_collision.info);
                CASE 1..5:
                    letra(id_collision.info);
                END
                CASE 6:
                    score+=1000;
                END
                CASE 7:
                    type_firing++;


                    IF (type_firing>firing_max)
                        type_firing=firing_max;
                        shield();
                    END

                END
            END
            signal(id_collision,s_kill);
        END

        FRAME;
    END
    signal(id,s_kill_tree);
END







PROCESS vida(position);

BEGIN
    y=460;
    x=posic_x_lives[position];
    graph=450;
    LOOP
        FRAME;
    END
END







PROCESS letra(position);

BEGIN


    IF (id_bonus[position-1])
        RETURN();
    END
    id_bonus[position-1]=id;
    y=21;
    x=posic_x_bonus[position-1];
    graph=320+position*10;
    LOOP
        FRAME;
    END
END









PROCESS bonus(x,y,info);

PRIVATE
    animation=0;
    graphics_base=0;

BEGIN
    z=1;
    priority=1;
    file1=file1;
    region=1;
    SWITCH (info);
        CASE 1..5:
            graphics_base=320+info*10;
        END
        CASE 6:
            graphics_base=300;
        END
        CASE 7:
            graphics_base=320;
        END
        DEFAULT:
            RETURN();
        END
    END
    REPEAT
        x-=6;
        graph=graphics_base+animation;
        FRAME;
        animation++;
        IF (animation==8)
            animation=0;
        END
    UNTIL (out_region(id,1))

END







PROCESS firing(info);

BEGIN
    sound(sound1,32*(info+1),256);

    SWITCH (info);
        CASE 0:
            bullet(father.x,father.y,0);
        END
        CASE 1:
            bullet(father.x,father.y-6,0);
            bullet(father.x,father.y+6,0);
        END
        CASE 2:
            bullet(father.x,father.y-6,pi/32);
            bullet(father.x,father.y+6,-pi/32);
        END
        CASE 3:
            bullet(father.x,father.y-8,pi/32);
            bullet(father.x,father.y,0);
            bullet(father.x,father.y+8,-pi/32);
        END
        CASE 4:
            bullet(father.x,father.y-8,pi/32);
            bullet(father.x,father.y-4,0);
            bullet(father.x,father.y+4,0);
            bullet(father.x,father.y+8,-pi/32);
        END
    END
END





PROCESS bullet (x,y,ang)

BEGIN
    file1=file1;
    region=1;
    z=1;
    graph=400;
    x+=34;
    REPEAT
        FRAME;
        IF (ang)
           x+=get_distx(ang,36);
           y+=get_disty(ang,36);
        ELSE
           x+=36;
        END
    UNTIL (out_region(id,1))
END





PROCESS bullet_enemy (info,x,y,bullet_angle)

BEGIN
    file1=file1;
    region=1;
    z=1;
    SWITCH (info)
        case 0 :
            graph=408;
            x-=32;
            y+=6;
            sound(sound2,256,256);
        END
        case 1 :
            graph=402;
            x-=32;
            sound(sound2,256,256);
        END
        case 2 :
            graph=403;
            x-=32;
            sound(sound2,256,256);
        END
        case 3 :
            graph=404;
            x-=32;
            y+=6;
            sound(sound3,256,256);
        END
        case 5 :
            graph=410;
            x-=90;
            y-=18;
            sound(sound2,256,256);
        END
        default :
            RETURN();
        END
    END

    REPEAT
        FRAME;

        SWITCH (info)
            case 0 :
                x+=get_distx(bullet_angle,8);
                y+=get_disty(bullet_angle,8);
            END
            case 1 :
                x-=20;
            END
            case 2 :
                x+=get_distx(bullet_angle,10);
                y+=get_disty(bullet_angle,10);
            END
            case 3 :
                x-=24;
            END
            case 5 :
                x+=get_distx(bullet_angle,14);
                y+=get_disty(bullet_angle,14);
                IF (graph==410)
                    graph=411;
                ELSE
                    graph=410;
                END
            END
        END

        IF (id_collision=collision(type ball_shield))

           explosion(rand(0,2),rand(0,19)+30);
           RETURN();
        END


        IF (info==3) smoke(); END


    UNTIL(out_region(id,1));
END







PROCESS smoke();

BEGIN
    file1=file1;
    region=1;
    z=2;
    flags=4;
    graph=405;
    x=father.x+12+rand(0,4);
    y=father.y;
    size=100;
    REPEAT
        FRAME;
        size-=20+rand(0,9);
    UNTIL (size<10)
END







PROCESS explosion(info,size);

PRIVATE
    animation;
    graphics_base;

BEGIN

    animation=0;
    file1=file1;
    region=1;
    x=father.x+rand(0,14)-7;
    y=father.y+rand(0,14)-7;
    z=-1;
    graphics_base=500+info*10;
    graph=graphics_base;
    sound(sound4,size*3,256);
    REPEAT
        FRAME;
        x-=6;
        graph++;
        animation++;
    UNTIL (animation==6)
END






PROCESS shield();

BEGIN
    state_ship=2;                  
    FROM info=0 TO 7;
        ball_shield(info);         
    END
END






PROCESS ball_shield(info);

PRIVATE
    counter=0;     
     angle_rotate;    

BEGIN
     angle_rotate=info*(pi/4);    
    region=1;
    
    x=id_ship_princ.x+get_distx( angle_rotate,70);
    y=id_ship_princ.y+get_disty( angle_rotate,50);
    z=2;

    IF (info)       
        graph=406;
    ELSE
        graph=407;
    END
    FRAME;
    REPEAT
         angle_rotate-=pi/16;
        counter++;
        IF (graph==406)         
            graph=407;
        ELSE
            graph=406;
        END
            x=id_ship_princ.x+get_distx( angle_rotate,70);
            y=id_ship_princ.y+get_disty( angle_rotate,50);
        FRAME;
    UNTIL (counter>72+info*4)
    REPEAT
        x-=30;                  
        FRAME;
    UNTIL (x<0)
    IF (info==7) state_ship=1; END  
END






PROCESS display_level(info);

PRIVATE
    id_text;    
    id_number;  
    counter=5; 

BEGIN
    REPEAT

        
        id_text=write(fontfile3,340,140,5,"LEVEL");
        id_number=write_int(fontfile3,370,140,3,&info);
        FRAME(400); 

        
        delete_text(id_text);
        delete_text(id_number);
        FRAME(400); 
        counter--;
    
    UNTIL (counter<1)
END

