compiler_options _extended_conditions;


//------------------------------------------------------------------------------
//TITLE:      PACOMAN
//AUTHOR:       DANIEL NAVARRO
//DATE:       DIV GAMES STUDIO (c) 2000
//------------------------------------------------------------------------------

PROGRAM pacoman;

GLOBAL


    time_capsules[]=0,300,240,180,140,120,100,80,60,40,0;


    intelligence[]=0,10,30,50,65,75,85,90,95,100,100;


    fruit_value[]=0,100,300,500,500,700,700,1000,1000,2000,2000;


    g_fruit_value[]=0,54,55,56,56,57,57,58,58,59,59;


    g_fruit[]=0,48,49,50,50,51,51,52,52,53,53;

    old_score=0;
    score=0;
    level;
    points=0;

    lives[10];
    ilives=0;
    score_max=10000;
    idpaco;

    s_beginning;
    s_eat_ghost;
    s_eat_fruit;
    s_eat_point;
    s_eat_pointgr;
    s_begins;
    s_death;
    channel_s_beginning;


LOCAL
    state=0;
    model;

BEGIN
    set_mode(m640x480);


    s_eat_ghost=load_pcm("pacoman\comefant.pcm",0);
    s_eat_fruit=load_pcm("pacoman\comefrut.pcm",0);
    s_eat_point=load_pcm("pacoman\comecoco.pcm",0);
    s_eat_pointgr=load_pcm("pacoman\comegcoc.pcm",0);
    s_begins=load_pcm("pacoman\comienzo.pcm",0);
    s_death=load_pcm("pacoman\muerto.pcm",0);
    s_beginning=load_pcm("pacoman\tambor2.pcm",1);


    load("dat\pacoman\pacoman.dat",&score_max);


    define_region(1,105,0,640-209,480);

    load_pal("pacoman\pacoman.fpg");
    load_fpg("pacoman\pacoman.fpg");
    load_fnt("pacoman\pacoman.fnt");

    power_pill(128,56);
    power_pill(512,56);
    power_pill(128,364);
    power_pill(512,364);



    WHILE (NOT (key(_esc)))


        channel_s_beginning=sound(s_beginning,512,256);

        level=1;


        xput(0,1,320,240,0,100,4,0);

        titles(write(1,320,320,1,"Press a key to play"));
        write(1,320,80,1,"Record");
        write_int(1,320,110,1,&score_max);
        write(1,320,430,1,"(c)2000 DIV GAMES");

        ghost(320,177,12);
        son.flags=son.flags OR 4;
        ghost(290,223,16);
        son.flags=son.flags OR 4;
        ghost(320,223,20);
        son.flags=son.flags OR 4;
        ghost(352,223,24);
        son.flags=son.flags OR 4;

        fade_on();


        WHILE (scan_code==0)
            FRAME;
        END

        IF (key(_esc))
            fade_off();
            exit("Thanks for playing!",0);
        END


        stop_sound(channel_s_beginning);


        fade_off();
        let_me_alone();
        delete_text(all_text);

        power_pill(128,56);
        power_pill(512,56);
        power_pill(128,364);
        power_pill(512,364);

        clear_screen();
        put(0,1,320,240);

        xput(0,47,56,260,pi/2,100,0,0);
        xput(0,47,585,260,-pi/2,100,0,0);

        write_int(1,100,0,2,&score);

        ilives=0;
        lives[ilives]=life((ilives*26)+552);
        ilives++;
        lives[ilives]=life((ilives*26)+552);
        ilives++;

        points=0;
        score=0;

        beginning_play();



        WHILE (ilives>=0 AND NOT key(_esc))

            IF (points==246)
                level++;
                level=level MOD 11;
                fade_off();
                let_me_alone();

                power_pill(128,56);
                power_pill(512,56);
                power_pill(128,364);
                power_pill(512,364);

                put(0,1,320,240);

                points=0;
                beginning_play();
            END


            IF (points==100 OR points==200)
                fruit();
                points++;
            END


            IF (score>=10000 AND old_score<10000)
                lives[ilives]=life(ilives*26+552);
                ++ilives;
            END


            IF (score>=50000 AND old_score<50000)
                lives[ilives]=life(ilives*26+552);
                ++ilives;
            END

            old_score=score;

            FRAME;
        END
        let_me_alone();


        write(1,320,197,1,"Game Over");
        FRAME(4000);
        fade_off();
        delete_text(all_text);
        clear_screen();


        IF (score>score_max)
            score_max=score;

            save("dat\pacoman\pacoman.dat",&score_max,1);
        END
    END
END






PROCESS paco()

PRIVATE
    image;
    speed_paco=2;
    incr_x=0;
    incr_y=0;
    counter0;
    eaten;
    old_graphic;
    steps[]=0,1,2,1;
    step2=0;
    initial_graphic=3;
    points_eaten=200;

BEGIN
    idpaco=id;
    region=1;
    graph=3;
    x=320;
    y=364;
    LOOP

        IF (key(_space))
            speed_paco=4;
        ELSE
            speed_paco=2;
        END


        IF (key(_right) AND way_paco(x+2,y))
            initial_graphic=3;
            flags=0;
            incr_x=2;
            incr_y=0;
        END


        IF (key(_left) AND way_paco(x-2,y))
            initial_graphic=3;
            flags=1;
            incr_x=-2;
            incr_y=0;
        END


        IF (key(_down) AND way_paco(x,y+2))
            initial_graphic=6;
            flags=0;
            incr_y=2;
            incr_x=0;
        END


        IF (key(_up) AND way_paco(x,y-2))
            initial_graphic=6;
            flags=2;
            incr_y=-2;
            incr_x=0;
        END


        IF (way_paco(x+incr_x,y))
            x+=incr_x;
        ELSE
            incr_x=0;
            step2=1;
        END


        IF (way_paco(x,y+incr_y))
            y+=incr_y;
        ELSE
            incr_y=0;
            step2=1;
        END


        graph=initial_graphic+steps[step2];


        IF (image>=speed_paco)
            FRAME;
            image=0;

            IF (eaten=collision(TYPE ghost))


                IF (abs(x-eaten.x)>10 OR abs(y-eaten.y)>10)
                    eaten=0;
                END

            END

            IF (incr_x<>0 OR incr_y<>0)
                step2=(step2+1) MOD 4;
            END
        END
        image++;


        IF (x<=95)
            x+=450;
        END

        IF (x>=546)
            x-=450;
        END


        IF (point(x,y)==14)
            points++;
            score+=10;
            put(0,9,x,y);
            image++;
            sound(s_eat_point,128,256);
        END


        IF (point(x,y)==10)
            sound(s_eat_pointgr,512,256);
            points++;
            score+=50;
            points_eaten=0;

            put(0,10,x,y);


            WHILE (counter0=get_id(TYPE ghost))
                counter0.state=time_capsules[level];
            END
        END


        IF (eaten)
            IF (eaten.state>0)
                sound(s_eat_ghost,512,256);


                WHILE (counter0=get_id(TYPE ghost))
                    signal(counter0,s_freeze);
                END

                old_graphic=graph;
                graph=0;
                eaten.graph=42+points_eaten;

                FRAME(1500);


                WHILE (counter0=get_id(TYPE ghost))
                    signal(counter0,s_wakeup);
                END
                graph=old_graphic;
                eyes(eaten.x,eaten.y,eaten.model);
                signal(eaten,s_kill);
                SWITCH (points_eaten);
                    CASE 0: score+=200; END
                    CASE 1: score+=400; END
                    CASE 2: score+=800; END
                    CASE 3: score+=1600; END
                    CASE 4: score+=3200; END
                END
                points_eaten++;
            ELSE


                WHILE (counter0=get_id(TYPE ghost))
                    signal(counter0,s_freeze);
                END
                FRAME(1500);


                signal(TYPE ghost,s_kill);
                signal(TYPE eyes,s_kill);
                signal(TYPE fruit,s_kill);
                flags=0;
                sound(s_death,512,256);
                FROM counter0=34 TO 41;
                    graph=counter0;
                    FRAME(400);
                END
                FRAME(800);
                IF (ilives<>0)
                    signal(lives[ilives],s_kill);
                    ilives--;
                    beginning_play();
                ELSE
                    ilives--;
                END
                signal(id,s_kill);
                FRAME;
            END
            eaten=0;
        END
    END
END






PROCESS way_paco(x,y)

PRIVATE
    colour_number;

BEGIN
    colour_number=colour(x,y);
    RETURN(colour_number==10 OR
           colour_number==12 OR
           colour_number==14);
END






PROCESS point(x,y)

BEGIN
    IF (get_pixel(x,y)==16)
        RETURN(0);
    ELSE
        RETURN(colour(x,y));
    END
END






PROCESS way_ghost(x,y,dir)

PRIVATE
    n_colour;

BEGIN

    SWITCH (dir)
        CASE 0: n_colour=colour(x-2,y); END
        CASE 1: n_colour=colour(x+2,y); END
        CASE 2: n_colour=colour(x,y+2); END
        CASE 3: n_colour=colour(x,y-2); END
    END


    IF (n_colour==11 AND dir==2 AND colour(x,y)==12)
        n_colour=0;
    END


    RETURN(n_colour==11 OR n_colour==10 OR n_colour==12 OR n_colour==14);
END






PROCESS colour(x,y)

BEGIN

    IF ((x<105 OR x>534) AND (y==225 OR y==226))
        RETURN(12);
    END


    RETURN(map_get_pixel(0,2,(x-105)/2,(y-1)/2));
END






PROCESS ghost(x,y,model)

PRIVATE
    image;
    num_imagees;
    dir=3;

BEGIN
    region=1;

    LOOP

        IF (colour(x,y)==11 OR state>0)
            num_imagees=1;
        ELSE
            num_imagees=2;
        END


        IF (counts_dir(x,y)>2)
            dir=selects_dir(x,y,dir);
        ELSE

            IF (NOT way_ghost(x,y,dir))
                dir=selects_dir(x,y,dir);
            END


            IF (rand(0,1000)<2)
                dir=selects_dir(x,y,dir XOR 1);
            END
        END

        SWITCH (dir)
            CASE 0: x-=2; END
            CASE 1: x+=2; END
            CASE 2: y+=2; END
            CASE 3: y-=2; END
        END


        IF (x<=95) x+=450; END
        IF (x>=546) x-=450; END


        IF (state==0)
            graph=model+dir;
        ELSE

            IF (state<70 AND state/7)
                graph=28;
            ELSE
                graph=11;
            END
            state--;
        END


        IF (image>=num_imagees)
            FRAME;
            image=0;
        END
        image++;
    END
END






PROCESS selects_dir(x,y,old_dir)

PRIVATE
  dir[3];
  num_dir=0;
  counter0=0;
  dir1;
  dir2;

BEGIN


    FROM counter0=0 TO 3;

        IF (way_ghost(x,y,counter0) AND old_dir<>(counter0 XOR 1))
            dir[num_dir]=counter0;
            num_dir++;
        END
    END


    IF (num_dir==0)
        dir[num_dir]=old_dir XOR 1;
        num_dir++;
    END


    counter0=dir[rand(0,num_dir-1)];

    IF (rand(0,100)<intelligence[level])
        IF (father.state==0)
            IF (idpaco)


                IF (abs(idpaco.x-father.x)>abs(idpaco.y-father.y))

                    IF (idpaco.x>father.x)
                        dir1=1;
                    ELSE
                        dir1=0;
                    END
                    IF (idpaco.y>father.y)
                        dir2=2;
                    ELSE
                        dir2=3;
                    END
                ELSE
                    IF (idpaco.y>father.y)
                        dir1=2;
                    ELSE
                        dir1=3;
                    END
                    IF (idpaco.x>father.x)
                        dir2=1;
                    ELSE
                        dir2=0;
                    END
                END
            END
        ELSE


            IF (abs(idpaco.x-father.x)<abs(idpaco.y-father.y))

                IF (idpaco.x>father.x)
                    dir1=0;
                ELSE
                    dir1=1;
                END
                IF (idpaco.y>father.y)
                    dir2=3;
                ELSE
                    dir2=2;
                END
            ELSE

                IF (idpaco.y>father.y)
                    dir1=3;
                ELSE
                    dir1=2;
                END
                IF (idpaco.x>father.x)
                    dir2=0;
                ELSE
                    dir2=1;
                END
            END
        END


        IF (old_dir==dir1 AND way_ghost(x,y,dir1))
            RETURN(dir1);
        ELSE
            IF (NOT way_ghost(x,y,dir1) AND old_dir==dir2 AND way_ghost(x,y,dir2))
                RETURN(dir2);
            END
        END

        IF (way_ghost(x,y,dir1) AND old_dir<>(dir1 XOR 1))
            counter0=dir1;
        ELSE
            IF (way_ghost(x,y,dir2) AND old_dir<>(dir2 XOR 1))
                counter0=dir2;
            END
        END
    END
    RETURN(counter0);
END






PROCESS counts_dir(x,y)

PRIVATE
    dir=0;
    counter0=0;

BEGIN
    REPEAT

        IF (way_ghost(x,y,counter0))
            dir++;
        END
    UNTIL (counter0++==3)
    RETURN(dir);
END






PROCESS eyes(x,y,model)

PRIVATE
    image;

BEGIN
    LOOP

        IF (x<105) x=105; END
        IF (x>554) x=554; END


        SWITCH (map_get_pixel(0,33,(x-105)/2,(y-1)/2))
            CASE 14: x-=2; graph=29; END
            CASE 10: x+=2; graph=30; END
            CASE 12: y+=2; graph=31; END
            CASE 9:  y-=2; graph=32; END

            CASE 11: image=0; signal(id,s_kill); ghost(x,y,model); END
        END

        IF ((image AND 3)==0) FRAME; END
        image++;
    END
END






PROCESS life(x)

BEGIN
    y=14;
    graph=4;
    LOOP
        FRAME;
    END
END






PROCESS power_pill(x,y)

BEGIN
    z=10;
    LOOP
        graph=10;
        FRAME(300);
        graph=0;
        FRAME(300);
    END
END






PROCESS fruit()

PRIVATE
    timefruit=100;

BEGIN
    x=320;
    y=270;
    graph=g_fruit[level];
    z=10;


    WHILE (timefruit>0)
        timefruit--;

        IF (collision(TYPE paco))
            sound(s_eat_fruit,512,256);
            timefruit=-20;
            score+=fruit_value[level];
            graph=g_fruit_value[level];
        END
        FRAME;
    END


    WHILE (timefruit<0)
        timefruit++;
        FRAME;
    END
END






PROCESS titles(txt)

PRIVATE

    graphics_table[]=50,52,53,54,54,53,52,50,48,47,46,46,47,48;
    counter0=0;

BEGIN
    graph=47;
    x=320;
    z=-10;
    LOOP
        counter0=(counter0+1) MOD 14;


        IF (counter0==0) move_text(txt,320,320); END


        IF (counter0==7) move_text(txt,320,640); END

        y=graphics_table[counter0];
        FRAME;
    END
END






PROCESS beginning_play()

PRIVATE
    text1;
    text2;
    text3;
    counter0;

BEGIN


    stop_sound(all_sound);
    fade_on();


    sound(s_begins,512,256);
    text1=write(1,320,243,1,"Ready!");
    text2=write(1,300,152,1,"Level");
    text3=write_int(1,376,152,1,&level);

    FRAME(9000);


    delete_text(text1);
    delete_text(text2);
    delete_text(text3);


    paco();
    ghost(320,177,12);
    ghost(290,223,16);
    ghost(320,223,20);
    ghost(352,223,24);
END
