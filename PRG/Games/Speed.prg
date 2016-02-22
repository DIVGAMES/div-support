compiler_options _extended_conditions;
//------------------------------------------------------------------------------
//TITLE:      SPEED_FOR_DUMMIES
//AUTHOR:       DANIEL NAVARRO
//DATE:        DIV GAMES STUDIO (c) 2000
//-----------------------------------------------------------------------------

PROGRAM Speed_for_dummies;

GLOBAL
    car_1[]=8,-12,-11,10,11,12,13,14,-13;
    car_2[]=8,-22,-21,20,21,22,23,24,-23;
    car_3[]=8,-32,-31,30,31,32,33,34,-33;
    car_4[]=8,-42,-41,40,41,42,43,44,-43;

    number;
    first_point=44;

    slights;
    smotor;
    scrash;
    scoli;

    channels[4];

    option;

    first;
    second;
    third;
    fourth;
    level=0;
    tlevel[]="EASY","NORMAL","HARD";

    route=0;
    troute[]="NORMAL","DESERT";

    returns=0;
    treturns[]="3 ROUNDS","6 ROUNDS","9 ROUNDS";
    treturns2[]="/3","/6","/9";

    computer_cars_speed;

LOCAL
    speed;
    max_speed;
    pos;
    ret;
    counter_ret;
    where;
    point;

PRIVATE
    car1;
    car2;
    car3;
    car4;
    id_objects;
    fin_usuario=FALSE;

BEGIN


    slights=load_pcm("speed\barco.pcm",0);
    smotor=load_pcm("speed\tractor.pcm",1);
    scrash=load_pcm("speed\choque.pcm",0);
    scoli=load_pcm("speed\metal7.pcm",0);

    set_fps(32,0);


    load_fpg("speed\speed.fpg");
    load_fpg("speed\pantalla.fpg");


    load_fnt("speed\menu.fnt");
    load_fnt("speed\g_numero.fnt");
    load_fnt("speed\g_mayusc.fnt");

    LOOP

        load_pal("speed\pantalla.fpg");
        fade_on();
        put_screen(1,1);


        file=1;
        graph=5;
        flags=0;
        x=160;
        y=100;

        FROM size=0 TO 95 STEP 5;
            FRAME;
        END

        menu();


        FROM size=100 TO 62 STEP -2;
            angle-=pi/10;
            x+=5;
            y+=3;
            FRAME;
        END

        graph=6;
        size=100;
        angle=0;

        minicar(26,128);

        option=0;

        REPEAT
            IF (key(_enter) OR key (_space) OR key (_control))
                option=(son.y-110)/18;
            END
            IF (key(_esc))
                option=4;
            END
            IF (option==3)
                menu_options();
                option=0;
            END
            FRAME;
        UNTIL (option<>0)

        signal(TYPE minicar,s_kill);
        signal(TYPE menu,s_kill_tree);

        fade_off();
        timer=0;
        IF (option==4)
            put_screen(1,2);
            graph=0;


            write (1,120,50,4,"- CREDITS -");
            write (1,120,75,4,"CODER:");
            write (1,120,90,4,"DANIEL NAVARRO");
            write (1,120,110,4,"GRAPHICS:");
            write (1,120,125,4,"RAFAEL BARRASO");
            write (1,120,145,4,"SOUNDS:");
            write (1,120,160,4,"LUIS SUREDA");
            write (1,120,180,4,"DIV GAMES STUDIO");
            fade_on();


            REPEAT
                FRAME;
            UNTIL (scan_code<>0)

            fade_off();
            delete_text(all_text);
            exit("Thanks!",0);
            FRAME;
        END


        computer_cars_speed=500+level*100;

        IF (route==0)
            load_fpg("speed\bosque.fpg");
            load_pal("speed\bosque.fpg");
            number=194;
        ELSE
            load_fpg("speed\desierto.fpg");
            load_pal("speed\desierto.fpg");
            number=192;
        END
        channels[0]=sound(smotor,100,256);
        channels[1]=sound(smotor,100,256);

        clear_screen();

        IF (option==1)
            channels[2]=sound(smotor,100,256);
            channels[3]=sound(smotor,100,150);
            define_region(1,0,0,320,64);
            start_scroll(0,2,101,0,1,15);
            start_mode7(0,2,100,0,0,64);
            m7.color=203;
            m7.height=128;
            m7.focus=224;


            car1=player(&car_1,0,first_point,_left,_right,_up,_down);

            m7.camera=car1;


            car2=car(&car_2,first_point+1);
            car3=car(&car_3,first_point+2);
            car4=car(&car_4,first_point+3);


            write(3,160,0,1,"POS");
            write_int(2,160,14,1,&car1.pos);
            write(3,278,0,1,"ROUND");
            write(2,290,14,1,treturns2[returns]);
            write_int(2,254,14,1,&car1.counter_ret);

        ELSE
            channels[2]=sound(smotor,100,150);
            channels[3]=sound(smotor,100,150);

            define_region(1,0,0,320,16);
            define_region(2,0,0,320,99);
            define_region(3,0,100,320,16);
            define_region(4,0,100,320,99);
            start_scroll(0,2,101,0,1,15);
            start_scroll(1,2,101,0,3,15);
            start_mode7(0,2,100,0,2,16);
            start_mode7(1,2,100,0,4,16);
            scroll.y0=48;
            scroll[1].y0=48;
            m7.color=203;
            m7.height=78;
            m7.focus=224;
            m7[1].color=203;
            m7[1].height=78;
            m7[1].focus=224;


            car1=player(&car_1,0,first_point,_left,_right,_up,_down);
            car2=player(&car_2,1,first_point+1,_r,_t,_q,_a);
            m7[0].camera=car1;
            m7[1].camera=car2;


            car3=car(&car_3,first_point+2);
            car4=car(&car_4,first_point+3);


            write(3,140,-4,1,"POS");
            write_int(3,170,-4,1,&car1.pos);
            write(3,140,96,1,"POS");
            write_int(3,170,96,1,&car2.pos);
            write(3,260,-4,1,"RND");
            write(3,300,-4,1,treturns2[returns]);
            write_int(3,285,-4,1,&car1.counter_ret);
            write(3,260,96,1,"RND");
            write(3,300,96,1,treturns2[returns]);
            write_int(3,285,96,1,&car2.counter_ret);

        END


        FROM z=0 TO 9;
            get_point(2,100,z,&x,&y);
            object(200,x,y);
        END

        FROM z=10 TO 14;
            get_point(2,100,z,&x,&y);
            object(201,x,y);
        END
        FROM z=15 TO 19;
            get_point(2,100,z,&x,&y);
            object(202,x,y);
        END

        minimap();
        fade_on();
        priority=-1;
        file=0;
        graph=200;
        x=160;
        y=100;
        z=-512;

        REPEAT


            car1.pos=1;
            car2.pos=1;
            car3.pos=1;
            car4.pos=1;

            IF (car1.where>car2.where)
                car2.pos++;
            ELSE
                car1.pos++;
            END
            IF (car1.where>car3.where)
                car3.pos++;
            ELSE
                car1.pos++;
            END
            IF (car1.where>car4.where)
                car4.pos++;
            ELSE
                car1.pos++;
            END

            IF (car2.where>car3.where)
                car3.pos++;
            ELSE
                car2.pos++;
            END
            IF (car2.where>car4.where)
                car4.pos++;
            ELSE
                car2.pos++;
            END
            IF (car3.where>car4.where)
                car4.pos++;
            ELSE
                car3.pos++;
            END



            IF (option==1)
                IF (car1.pos==1)
                    IF (car4.max_speed<computer_cars_speed+64)
                        car2.max_speed++;
                        car3.max_speed++;
                        car4.max_speed++;
                    END
                END
                IF (car1.pos==4)
                    IF (car4.max_speed>computer_cars_speed-64)
                        car2.max_speed--;
                        car3.max_speed--;
                        car4.max_speed--;
                    END
                END
            ELSE
                IF (car1.pos+car2.pos==3)
                    IF (car4.max_speed<computer_cars_speed+64)
                        car3.max_speed++;
                        car4.max_speed++;
                    END
                END
                IF (car1.pos+car2.pos==7)
                    IF (car4.max_speed>computer_cars_speed-64)
                        car3.max_speed--;
                        car4.max_speed--;
                    END
                END
                IF (car1.pos<car2.pos)
                    car1.max_speed=700;
                    car2.max_speed=900;
                ELSE
                    car1.max_speed=900;
                    car2.max_speed=700;
                END
            END


            IF (timer>800 AND timer<900)
                graph=0;
                signal(id_objects,s_kill);
                timer=900;
            ELSE
                IF (timer>600 AND timer<700)
                    sound(slights,1000,500);
                    sound(slights,1000,256);
                    id_objects.x+=56;

                    id_objects.graph++;
                    flags=4;
                    timer=700;
                ELSE
                    IF (timer>400 AND timer<500)
                        sound(slights,200,256);
                        id_objects.x+=56;
                        timer=500;
                    ELSE
                        IF (timer>200 AND timer<300)
                            sound(slights,200,256);
                            id_objects=object2(201,103,100,-600);
                            timer=300;
                        END
                    END
                END
            END


            IF (key(_esc)) fin_usuario=TRUE; END

            FRAME;

        UNTIL ((car1.ret==returns*3+4 AND option==1) OR (car1.ret>=returns*3+4 AND car2.ret>=returns*3+4) OR fin_usuario)

        IF (fin_usuario)
            fade_off();
        ELSE
            fade(0,0,0,1);
            WHILE (fading)
                FRAME;
            END
        END


        unload_fpg(2);
        graph=0;
        signal(id,s_kill_tree);
        signal(id,s_wakeup);
        delete_text(all_text);
        stop_sound(all_sound);
        stop_scroll(0);
        stop_scroll(1);
        stop_mode7(0);
        stop_mode7(1);


        IF (NOT fin_usuario)
            put_screen(0,400);
            object2(401,119,163,0);


            IF (option==1)
                IF (car1.pos==1)
                    object2(402,160,16,0);
                ELSE
                    object2(403,160,16,0);
                END
            ELSE
                IF (car1.pos==1)
                    object2(404,168,34,0);
                ELSE
                    IF (car2.pos==1)
                        object2(405,168,34,0);
                    ELSE
                        object2(406,160,16,0);
                    END
                END
            END


            write(3,260,76,4,troute[route]);
            write(3,260,92,4,tlevel[level]);
            write(3,260,108,4,treturns[returns]);


            select_position(car1.pos,car1.xgraph);
            select_position(car2.pos,car2.xgraph);
            select_position(car3.pos,car3.xgraph);
            select_position(car4.pos,car4.xgraph);
            podium_cars(first,120,118);
            podium_cars(second,120-80,118+16);
            podium_cars(third,120+80,118+32);
            object2([fourth+3],280,220,1);
            fade_on();


            WHILE (NOT key(_esc) AND NOT key(_enter))
                smoke(280+rand(-8,8),210+rand(-8,8));
                FRAME;
            END


            fade_off();
            delete_text(all_text);
            signal(id,s_kill_tree);
            signal(id,s_wakeup);
        ELSE
            fin_usuario=FALSE;
        END
    END
END






PROCESS menu_options();

PRIVATE
    text[3];
    enter_pressed=FALSE;

BEGIN


    text[0]=write(1,0,0,4,tlevel[level]);
    text[1]=write(1,0,0,4,troute[route]);
    text[2]=write(1,0,0,4,treturns[returns]);
    text[3]=write(1,0,0,4,"EXIT");


    signal(father,s_freeze);
    signal(TYPE minicar,s_sleep);

    file=1;
    graph=7;
    x=104;
    y=-40;
    shade_menu();
    WHILE (y<45)
        y+=4;
        move_text(text[0],104,y-28);
        move_text(text[1],104,y-28+18);
        move_text(text[2],104,y-28+18*2);
        move_text(text[3],104,y-28+18*3);
        FRAME;
    END
    minicar(26,21);
    minicar(182,21);
    LOOP
        IF (key(_enter))
            IF (NOT enter_pressed)
                SWITCH ((son.y-3)/18);
                    CASE 1:
                        delete_text(text[0]);
                        level=(level+1)%3;
                        text[0]=write(1,104,y-28,4,tlevel[level]);
                    END
                    CASE 2:
                        delete_text(text[1]);
                        route=++route MOD 2;
                        text[1]=write(1,104,y-28+18,4,troute[route]);
                    END
                    CASE 3:
                        delete_text(text[2]);
                        returns=++returns MOD 3;
                        text[2]=write(1,104,y-28+18*2,4,treturns[returns]);
                    END
                    DEFAULT:
                        BREAK;
                    END
                END
                enter_pressed=TRUE;
            END
        ELSE
            enter_pressed=FALSE;
        END
        IF (key(_esc))
            BREAK;
        END
        FRAME;
    END
    signal(TYPE minicar,s_sleep);
    FROM y=45 TO -40 STEP -4;
        move_text(text[0],104,y-28);
        move_text(text[1],104,y-28+18);
        move_text(text[2],104,y-28+18*2);
        move_text(text[3],104,y-28+18*3);
        FRAME;
    END


    delete_text(all_text);
    signal(father,s_wakeup);
    signal(TYPE minicar,s_wakeup);
    signal(id,s_kill_tree);
END






PROCESS object2(graph,x,y,z);

BEGIN
    LOOP
        FRAME;
    END
END






PROCESS podium_cars(xgraph,x,y);

BEGIN
    size=50;
    LOOP
        angle+=pi/12;
        FRAME;
    END
END






PROCESS select_position(pos,xgraph);

BEGIN
    SWITCH (pos);
        CASE 1:
            first=xgraph;
        END
        CASE 2:
            second=xgraph;
        END
        CASE 3:
            third=xgraph;
        END
        CASE 4:
            fourth=xgraph;
        END
    END
END






PROCESS menu();

BEGIN
    file=1;
    graph=3;
    x=104;
    y=155;
    shade_menu();

    FROM size=0 TO 95 STEP 5;
        FRAME;
    END
    LOOP
        FRAME;
    END
END






PROCESS shade_menu();

BEGIN
    FRAME(0);
    file=1;
    graph=4;
    flags=4;
    z=1;
    priority=-1;
    LOOP
        x=father.x;
        y=father.y;
        size=father.size;
        FRAME;
    END
END






PROCESS minicar(x,arrives);

PRIVATE
    cont_graphics=0;

BEGIN
    file=1;
    y=arrives;
    LOOP
        IF (key(_down)AND y<arrives+18*3)
            y+=18;
        END
        IF (key(_up)AND y>arrives)
            y-=18;
        END
        cont_graphics++;
        cont_graphics=cont_graphics MOD 8;
        graph=10+cont_graphics;
        FRAME(200);
    END
END










PROCESS player(xgraph,pan,point,left,right,arrives,down);

PRIVATE
    hspeed;
    colour;
    id2;
    counter0;
    s_volume;
    cont_channels;

BEGIN

    max_speed=800;
    speed=0;
    ret=1;


    get_point(2,100,point,&x,&y);


    resolution=100;
    x=x*resolution;
    y=y*resolution;
    ctype=c_m7;

    shade();
    ball([xgraph+7]+1,id);

    where=look_where();
    WHILE (timer<700)
        FRAME;
    END

    LOOP

        change_sound(channels[3-pan],200,abs(speed)+150);


        where=look_where();

        IF (key(left))
            scroll[pan].x0-=max_speed/64;
            angle+=pi/(51200/max_speed);
        END

        IF (key(right))
            scroll[pan].x0+=max_speed/64;
            angle-=pi/(51200/max_speed);
        END


        IF (key(arrives)AND speed<max_speed)
            speed+=max_speed/50;
        END


        IF (key(down)AND speed>-max_speed/2)
            speed-=max_speed/50;
        END

        advance(speed);


        IF (speed>max_speed/100)
            speed-=max_speed/100;
        ELSE
            IF (speed<-max_speed/100)
                speed+=max_speed/100;
            ELSE
                speed=0;
            END
        END


        IF (id2=get_id(TYPE player))
            counter0=get_dist(id2);
            IF (counter0<1600)
                IF(timer[2]>60)
                    timer[2]=0;
                    sound(scoli,500,256);
                END

                IF (where<id2.where)
                    IF (speed>0)
                        speed=speed*9/10;
                    END
                ELSE
                    IF (id2.speed>0)
                        id2.speed=id2.speed*9/10;
                    END
                END
                IF (rand(0,10)==0)
                    smoke((x+id2.x)/200,(y+id2.y)/200);
                END
            END
        END


        cont_channels=0;
        WHILE (id2=get_id(TYPE car))
            counter0=get_dist(id2);
            s_volume=counter0/16;
            IF (s_volume>600) s_volume=600; END
            change_sound(channels[cont_channels],600-s_volume,700);
            cont_channels++;
            IF (counter0<1600)
                IF(timer[1]>60)
                    timer[1]=0;
                    sound(scoli,500,256);
                END
                IF (where<id2.where)
                    IF (speed>0)
                        speed=speed*9/10;
                    END
                ELSE
                    IF (id2.speed>0)
                        id2.speed=id2.speed*9/10;
                    END
                END

                IF (rand(0,10)==0)
                    smoke((x+id2.x)/200,(y+id2.y)/200);
                END
            END
        END


        colour=map_get_pixel(2,100,x/100,y/100);

        IF (colour<208 AND colour>191)
            sound(scrash,1000,256);
            change_sound(channels[3-pan],100,150);

            FROM counter0=0 TO 9;
                smoke(x/100+rand(-8,8),y/100+rand(-8,8));
            END

            speed=-speed/6;
            hspeed=24;
            REPEAT
                FRAME;
                advance(speed);
                height+=hspeed;
                hspeed-=4;
            UNTIL (height<0)

            height=12;
            hspeed=12;
            REPEAT

                FRAME;
                advance(speed);
                height+=hspeed;
                hspeed-=4;
            UNTIL (height<0)

            height=0;
        END
        FRAME;
    END
END






PROCESS shade();

BEGIN
    ctype=c_m7;
    graph=100;
    flags=4;
    resolution=100;
    priority=-1;
    z=1;
    LOOP
        x=father.x;
        y=father.y;
        FRAME;
    END
END






PROCESS smoke(x,y);

BEGIN
    ctype=father.ctype;
    graph=101;
    flags=4;
    REPEAT
        IF (ctype==c_m7)
            height+=4;
        ELSE
            y-=2;
        END
        size-=5;

        FRAME;
    UNTIL (size<=0)
END







PROCESS car(xgraph,point);

PRIVATE
    following_p;
    following_p_x;
    following_p_y;

BEGIN

    max_speed=computer_cars_speed;
    speed=0;
    ret=1;

    get_point(2,100,point,&x,&y);
    following_p=point+2;

    resolution=100;
    x*=resolution;
    y*=resolution;
    ctype=c_m7;

    shade();
    ball([xgraph+7]+1,id);


    get_point(2,100,following_p,&following_p_x,&following_p_y);
    following_p_x*=100;
    following_p_y*=100;

    where=look_where();
    WHILE (timer<700)
        FRAME;
    END

    LOOP


        where=look_where();


        angle=fget_angle(x,y,following_p_x,following_p_y);

        advance(speed);

        IF (speed<max_speed)
            speed+=10;
        END
        IF (speed>max_speed)
            speed=max_speed;
        END


        IF (fget_dist(x,y,following_p_x,following_p_y)<1600)
            following_p+=2;

            IF (rand(0,8)==0)
                following_p=(following_p&-2)+rand(0,1);
            END

            IF (following_p>=first_point+number)
                following_p-=number;
            END


            get_point(2,100,following_p,&following_p_x,&following_p_y);
            following_p_x*=100;
            following_p_y*=100;
        END
        FRAME;
    END
END






PROCESS object(graph,x,y);

BEGIN
    file=2;
    ctype=c_m7;
    LOOP
        FRAME;
    END
END






PROCESS minimap();

BEGIN
    x=36;
    y=36;
    file=2;
    z=1;
    flags=4;
    graph=104;

    IF (option==2)
        CLONE
            y+=100;
        END
    END

    LOOP
        FRAME;
    END
END






PROCESS ball(graph,idcar);

PRIVATE
    coord_y=0;

BEGIN
    IF (option==2)
        CLONE
            coord_y=100;
        END
    END

    LOOP
        x=idcar.x/1600+4;
        y=idcar.y/1600+4+coord_y;
        FRAME;
    END
END






PROCESS look_where();

PRIVATE
    distance=0;

    min_point=0;
    min_where1=0;
    min_where2=0;
    min_where3=0;

    min_distance1=-1;
    min_distance2=-1;
    min_distance3=-1;


BEGIN
    ret=father.ret;
    point=(father.point&-2)-10;

    IF (point<first_point)
        point+=number;
        ret--;
    END

    FROM z=0 TO 10;
        get_point(2,100,point,&x,&y);

        distance=fget_dist(father.x/100,father.y/100,x,y);

        IF (distance>512)
            distance=0;
        ELSE
            distance=512-distance;
        END


        IF (distance>min_distance1)
            min_where3=min_where2;
            min_distance3=min_distance2;
            min_where2=min_where1;
            min_distance2=min_distance1;
            min_point=point;
            min_where1=point+ret*200;
            min_distance1=distance;
        ELSE
            IF (distance>min_distance2)
                min_where3=min_where2;
                min_distance3=min_distance2;
                min_where2=point+ret*200;
                min_distance2=distance;
            ELSE
                IF (distance>min_distance3)
                    min_where3=point+ret*200;
                    min_distance3=distance;
                END

            END
        END
        IF ((point+=2)>=first_point+number)
            point-=number;
            ret++;
        END
    END


    IF (min_point+number/2<father.point)
        father.ret++;
    END

    IF (min_point>father.point+number/2)
        father.ret--;
    END


    IF (father.ret<1)
        father.counter_ret=1;
    ELSE
        IF (father.ret>returns*3+3)
            father.counter_ret=returns*3+3;
        ELSE
            father.counter_ret=father.ret;
        END
    END


    father.point=min_point;

    distance=min_distance1+min_distance2+min_distance3;

    IF (distance<>0)
        where=(min_where1*100*min_distance1+min_where2*100*min_distance2+min_where3*100*min_distance3)/distance;
    ELSE
        where=min_where3;
    END

    return(where);

END

