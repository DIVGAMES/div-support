compiler_options _extended_conditions;


//------------------------------------------------------------------------------
//TITLE:      NOID
//AUTHOR:       DANIEL NAVARRO
//DATE:       DIV GAMES STUDIO (c) 2000
//------------------------------------------------------------------------------

PROGRAM noid;

//    import "ascii.dll";

CONST
    speed_r=8;


GLOBAL
    small_r[2];

    s_hit;
    s_bonus;
    s_fire;
    s_metal;
    s_bat;

    map[16*14];
    lives;
    nballs;
    nbricks;
    direction;
    bounce;

    fin_play;
    phase;
    score;
    demo;
    id_ball;
    id_text;


    phases[]=
             "dat/noid/screen.1",
             "dat/noid/screen.2",
             "dat/noid/screen.3",
             "dat/noid/screen.4",
             "dat/noid/screen.5",
             "dat/noid/screen.6",
             "dat/noid/screen.7",
             "dat/noid/screen.8",
             "dat/noid/screen.9",
             "dat/noid/screen.10",
             "dat/noid/screen.11",
             "dat/noid/screen.12";

LOCAL
    state=0;

    size_bat=4;
    unused=0;
    speed=0;

BEGIN
    set_fps(30,0);
    load_fpg("noid/noid.fpg");
    load_fpg("noid/noid2.fpg");

    //import "hboy.so_";

    s_hit=load_pcm("noid/caida7.pcm",0);
    s_bonus=load_pcm("noid/fx34.pcm",0);
    s_fire=load_pcm("noid/disparo5.pcm",0);
    s_metal=load_pcm("noid/metal10.pcm",0);
    s_bat=load_pcm("noid/tubo.pcm",0);

    load_fnt("noid/noid.fnt");

    LOOP
        scan_code=0;
        WHILE (scan_code<>0)
            FRAME;
        END

        delete_text(all_text);
        let_me_alone();
        put_screen(1,1);
        load_pal("noid/noid2.fpg");
        fade_on();

        REPEAT
            FRAME;
        UNTIL (scan_code<>0)
        fade_off();
        load_pal("noid/noid.fpg");
        fin_play=0;
        demo=1;
        text_demo();

        write_int(1,310,180,2,&score);


        fin_play=0;
        phase=1;
        score=0;
        lives=3;

        small_r[0]=small_bat(296,16+11*0);
        small_r[1]=small_bat(296,16+11*1);
        small_r[2]=small_bat(296,16+11*2);
        scan_code=0;
        REPEAT
            fade_on();
            clear_screen();
            put(0,100+phase%4,0,0);
            put(0,900,319,0);
            nballs=0;
            direction=1;
            bounce=1;
            id_ball=ball(bat());


            load(phases[phase],&map);
            nbricks=0;
            FROM y=0 TO 13;
                FROM x=0 TO 15;
                    IF (map[y*16+x]<>0)
                        brick(16+x*16,12+y*8,map[y*16+x]);

                        IF ((map[y*16+x]<20) OR (map[y*16+x]>=30))
                            nbricks++;
                        END
                    END
                END
            END
            write_int(1,310,180,2,&score);
            LOOP
            IF (key (_esc))
                   IF (demo)
                   credits();
                   FRAME;
                ELSE
                   let_me_alone();
                   score=0;
                   demo=1;
                   fin_play=1;
                   text_demo();
                END
                   END
                FRAME;

                IF (((nbricks<=0) OR (fin_play)) AND (NOT (get_id(type bonus))) AND (NOT (get_id(type reduce))))
                    BREAK;
                END
            END


            signal(TYPE ball,s_kill);
            signal(TYPE bat,s_kill);
            signal(TYPE bonus,s_kill);
            signal(TYPE laser,s_kill);
            signal(TYPE caido,s_kill);
            signal(TYPE reduce,s_kill);
            signal(TYPE brick,s_kill);

            phase++;
            fade_off();
        UNTIL ((phase>11) OR (fin_play))

        fin_play=0;
        fade_off();

        delete_text(all_text);
        clear_screen();
        signal(type small_bat,s_kill);
    END
    signal(id,s_kill_tree);
END

PROCESS bat();

PRIVATE
    incr_x=0;
    incr_y=0;
    fire_preunused=1;
    id2;
    id3;

BEGIN
    graph=3;
    x=140;
    y=188;

    WHILE(NOT id_ball) FRAME; END
    LOOP

        IF (NOT demo)

            IF (direction==1)

                IF (key(_left) AND incr_x>-speed_r)
                    incr_x-=4;
                ELSE
                    IF (key(_right) AND incr_x<speed_r)
                        incr_x+=4;
                    ELSE
                        IF (incr_x>0)
                            incr_x-=2;
                        END
                        IF (incr_x<0)
                            incr_x+=2;
                        END
                    END
                END
            END
            IF (direction==-1)

                IF (key(_right) AND incr_x>-speed_r)
                    incr_x-=4;
                ELSE
                    IF (key(_left) AND incr_x<speed_r)
                        incr_x+=4;
                    ELSE
                        IF (incr_x>0)
                            incr_x-=2;
                        END
                        IF (incr_x<0)
                            incr_x+=2;
                        END
                    END
                END
            END

        ELSE
            IF ((x>7) AND (x<310)) x=id_ball.x; END
            IF (scan_code<>0)
                delete_text(all_text);
                signal(type text_demo,s_kill);
                demo=0;
                nbricks=0;
                phase=-1;
                lives=3;
                score=0;
                write_int(1,310,180,2,&score);
            END
            IF (score>200)
                nbricks=0;
                phase=rand(-1,10);
                score=0;
            END
        END


        IF ( (key(_space) OR key (_control) OR (demo AND rand(0,10)==0)) AND graph==6)
            IF (fire_preunused==1)
                laser(x-16,y-8);
                laser(x+16,y-8);
                IF (NOT demo) fire_preunused=0; END
            END
        ELSE
            fire_preunused=1;
        END


        IF (id2=collision(TYPE bonus))
            IF (id2.size==100)
                sound(s_bonus,80,256);
                score+=50;
                SWITCH (id2.graph);
                    CASE 200:
                        IF (size_bat<8)
                            size_bat+=4;
                        END
                        IF (size_bat==4)
                            graph=3;
                        ELSE
                            graph=4;
                        END

                        WHILE (id3=get_id(TYPE ball))
                            id3.unused=0;
                        END
                    END
                    CASE 201:
                        size_bat=4;
                        graph=5;
                    END
                    CASE 202:
                        size_bat=4;
                        graph=6;
                        WHILE (id3=get_id(TYPE ball))
                            id3.unused=0;
                        END
                    END
                    CASE 203:
                        IF (lives<3)
                            lives++;
                            small_r[lives-1]=small_bat(296,16+11*(lives-1));
                        END;
                    END
                    CASE 204:
                        direction=direction*-1;
                    END
                    CASE 205:
                        IF (size_bat>0)
                            size_bat-=4;
                        END
                        IF (size_bat==0)
                            graph=2;
                        ELSE
                            graph=3;
                        END
                        WHILE (id3=get_id(TYPE ball))
                            id3.unused=0;
                        END
                    END
                    CASE 206:

                        WHILE (id3=get_id(TYPE ball))
                            IF (id3.speed>800)
                                id3.speed-=400;
                            ELSE
                                id3.speed=400;
                            END
                        END
                    END
                    CASE 207:
                        bounce=bounce XOR 1;
                        WHILE (id3=get_id(TYPE ball))
                            id3.graph=1+(1-bounce)*8;
                        END
                    END
                    CASE 208:
                        FRAME(0);

                        WHILE (id3=get_id(TYPE brick))
                            IF ((id3.graph>=20) AND (id3.graph<30))
                                brick(id3.x,id3.y,14);
                                signal(id3,s_kill);
                                id3.graph=14;
                                nbricks++;
                            END
                        END
                    END

                    CASE 209:
                        get_id(TYPE ball).state=1;
                    END

                END
            END
            id2.state=1;
        END

        IF (NOT demo) x+=incr_x; END


        IF (x<23+size_bat)
            x=23+size_bat;
            incr_x=0;
        END
        IF (x>248-size_bat)
            x=248-size_bat;
            incr_x=0;
        END
        FRAME;
    END
END






PROCESS ball(id_bat);

PRIVATE
    incr_x;
    incr_y;
    x_resol;
    y_resol;
    completed_x_resol;
    completed_y_resol;
     angle0;
    aspeed;
    dist_bat;
    pos_ball_bat;
    id_brick;

BEGIN
    z=-3;
    graph=1+(1-bounce)*8;
    speed=400;
     angle0=3*pi/8;

    LOOP

        IF (NOT unused)
            nballs++;
            unused=1;
            pos_ball_bat=0;
        ELSE
            pos_ball_bat=x-id_bat.x;
        END

        WHILE (unused)

            x=id_bat.x+pos_ball_bat;
            y=id_bat.y-8;

            IF (key(_space) OR key (_control) OR demo)
                unused=0;
                x_resol=x*100;
                y_resol=y*100;
            END
            FRAME;
        END

        REPEAT

            IF (state==1)
                nballs+=2;
                CLONE
                     angle0+=pi/32;
                    CLONE
                         angle0+=pi/32;
                    END
                END
                state=0;
            END

            aspeed+=speed;

            WHILE (aspeed>100)

                aspeed-=100;

                completed_x_resol=x_resol;
                completed_y_resol=y_resol;

                incr_x=get_distx( angle0,100);
                x_resol+=incr_x;
                incr_y=get_disty( angle0,100);
                y_resol+=incr_y;


                dist_bat=x-id_bat.x;


                IF (y_resol>=18000 AND y_resol<=18800 AND incr_y>0 AND (dist_bat>-18-id_bat.size_bat AND dist_bat<18+id_bat.size_bat))

                     angle0=fget_angle(0,0,incr_x,-incr_y)-(dist_bat*pi/60);


                    IF ( angle0<pi/8)
                         angle0=pi/8;
                    END
                    IF ( angle0>pi*7/8)
                         angle0=pi*7/8;
                    END

                    IF (id_bat.graph==5)
                        unused=1;
                        BREAK;
                    END

                    sound(s_bat,100,256);
                END


                IF (y_resol<=1200 AND incr_y<0)
                     angle0=fget_angle(0,0,incr_x,-incr_y);
                    sound(s_bat,80,500);
                END


                IF ((x_resol<=1200 AND incr_x<0) OR (x_resol>=26000 AND incr_x>0))
                     angle0=fget_angle(0,0,-incr_x,incr_y);
                    sound(s_bat,80,600);
                END


                x=x_resol/100;
                y=y_resol/100;


                IF (id_brick=collision(TYPE brick))
                    score+=5;
                    speed+=4;
                    FRAME(0);
                    y=completed_y_resol/100;


                    IF (id_brick==collision(TYPE brick))
                            IF (bounce OR (id_brick.graph>=20 AND id_brick.graph<30))
                            sound(s_metal,100,256);

                             angle0=fget_angle(0,0,-incr_x,incr_y)+rand(-4000,4000);
                            IF (( angle0<pi/8) AND ( angle0>-pi/8))
                                 angle0=fget_angle(0,0,-incr_x,incr_y);
                            END
                            IF (( angle0>pi*7/8) AND ( angle0<pi*9/8))
                                 angle0=fget_angle(0,0,-incr_x,incr_y);
                            END
                        END

                    ELSE
                        IF (bounce OR (id_brick.graph>=20 AND id_brick.graph<30))
                            sound(s_metal,100,256);


                             angle0=fget_angle(0,0,incr_x,-incr_y)+rand(-4000,4000);
                            IF (( angle0<pi/8) AND ( angle0>-pi/8))
                                 angle0=fget_angle(0,0,incr_x,-incr_y);
                            END
                            IF (( angle0>pi*7/8) AND ( angle0<pi*9/8))
                                 angle0=fget_angle(0,0,incr_x,-incr_y);
                            END
                        END

                    END

                    x_resol=completed_x_resol;
                    y_resol=completed_y_resol;

                    IF (id_brick.graph>=20 AND id_brick.graph<30)
                        id_brick.state=1;
                    ELSE

                        IF (id_brick.graph>=30 AND id_brick.graph<33)
                            id_brick.graph++;
                            IF (id_brick.graph==33)
                                signal(id_brick,s_kill);
                                nbricks--;
                            END
                        ELSE// Aqui se comprueban bricks normales

                            IF (rand(0,100)<20)
                                bonus(id_brick.x,id_brick.y,rand(202,209));
                            END

                            caido(id_brick.x,id_brick.y,id_brick.graph);

                            signal(id_brick,s_kill);
                            nbricks--;

                        END
                    END

                END

                FRAME(0);
            END
            x=x_resol/100;
            y=y_resol/100;
            FRAME;
        UNTIL (y>200 OR unused)

        IF (NOT unused)

            speed=400;
             angle0=3*pi/8;
            nballs--;
            IF (nballs>0)
                BREAK;
            ELSE
                fade_off();
                fade_on();
                direction=1;
                bounce=1;
                graph=1;
                id_bat.graph=3;
                IF(lives>0)
                    signal(small_r[lives-1],s_kill);
                END
                signal(type bonus,s_kill);
                IF (NOT demo)
                    lives--;
                    IF (lives<0)
                        fin_play=1;
                        BREAK;
                    END
                END
            END
        END

    END
END






PROCESS brick(x,y,graph);

PRIVATE
    incr_x=1;

BEGIN
    z=-1;
    SWITCH (graph);
        CASE 15:
            LOOP

                IF (x==16) incr_x=1; END
                IF (x==256) incr_x=-1; END
                x+=incr_x;

                IF (collision(type brick))
                    incr_x=-incr_x;
                    x+=incr_x;
                END
                FRAME;
            END
        END
        CASE 20:
            LOOP
                IF (state>0)
                    SWITCH (state++);
                        CASE 1:
                            graph=21;
                        END
                        CASE 2:
                            graph=22;
                        END
                        CASE 3:
                            graph=21;
                        END
                        CASE 4:
                            graph=20;
                            state=0;
                        END
                    END
                END
                FRAME;
            END
        END
        DEFAULT:
            LOOP
                FRAME;
            END
        END
    END
END






PROCESS bonus(x,y,graph);

BEGIN
    z=-2;

    WHILE (NOT out_region(id,0) AND state==0)
        y+=2;
        FRAME;
    END

    WHILE (NOT out_region(id,0) AND size>0)
        size-=10;
        y+=1;
        FRAME;
    END
END






PROCESS laser(x,y);

PRIVATE
    id_brick;

BEGIN
    graph=8;
    sound(s_fire,80,400);
    WHILE (y>8)

        IF (id_brick=collision(TYPE brick))
            signal(id,s_kill);


            IF (id_brick.graph>=20 AND id_brick.graph<30)

                id_brick.state=1;
            ELSE


                IF (id_brick.graph>=30 AND id_brick.graph<40)

                    id_brick.graph++;

                    IF (id_brick.graph==33)

                        nbricks--;

                        reduce(id_brick.x,id_brick.y,id_brick.graph);
                        signal(id_brick,s_kill);
                    END
                ELSE

                    IF (rand(0,100)<20)
                        bonus(id_brick.x,id_brick.y,rand(200,209));
                    END

                    reduce(id_brick.x,id_brick.y,id_brick.graph);
                    signal(id_brick,s_kill);
                    nbricks--;
                END
            END
        END
        y-=8;
        FRAME;
    END
END






PROCESS caido (x,y,graph)

PRIVATE
    iangle;

BEGIN

    sound(s_hit,200,256);

    iangle=rand(-pi/8,pi/8);

    REPEAT
        FRAME;
        y+=5;
        angle+=iangle;
    UNTIL (out_region(id,0))

END






PROCESS reduce(x,y,graph)

BEGIN
    REPEAT
        FRAME;
        size-=6;
    UNTIL (size<0)
END






PROCESS small_bat(x,y)

BEGIN
   graph=7;
   LOOP
        FRAME;
   END
END






PROCESS text_demo()

BEGIN
    LOOP

        id_text=write(1,90,100,0,"PRESS A KEY TO PLAY");
        FRAME (2000);
        delete_text(id_text);
        FRAME (2000);
    END
END





PROCESS credits()

PRIVATE
    font;

BEGIN
    fade_off();
    delete_text(all_text);
    let_me_alone();
    put_screen(1,2);
    load_pal("noid/noid2.fpg");

    font=load_fnt("noid/noid2.fnt");


    write(font,160,30,4,"- CREDITS -");
    write(font,160,60,4,"CODER: LUIS SUREDA");
    write(font,160,80,4,"GRAPHICS: JOSE FERNANDEZ");
    write(font,160,100,4,"SOUNDS: CARLOS ILLANA");
    write(font,160,120,4,"COPYRIGHT 1997");
    write(font,160,140,4,"DIV GAMES STUDIO");
    fade_on();


    WHILE (scan_code==0)
        FRAME;
    END
    fade_off();
    exit("Thanks for Playing!",0);
END
