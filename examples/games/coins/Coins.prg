
//-----------------------------------------------------------------------------
// TITLE:      WORLD CAPS CHAMPIONSHIP
// AUTHOR:       DIV GAMES
// DATE:       (C) DIV Games Studio
//-----------------------------------------------------------------------------

PROGRAM coins;

CONST


    power_maximum=38;
    minimum_force=2;
    maximum_incline=pi;
    minimum_incline=-pi;

    graphics_map=100;
    map_wide=1134;
    map_stop=790;
    detect_hit_map=101;

    colour_control_1=200;
    colour_control_2=156;
    colour_control_3=115;
    put_colour=246;
    outside_colour=192;
    object_colour=141;

    returns=1;
    previous_speed=16;
    maximum_advance=7;
    point_complete=48;

GLOBAL
    graphics_file;

    source1;
    source2;
    source3;
    source4;

    sound1;
    sound2;
    sound3;
    channels=-1;

    program_state=1;
    new_state=0;

    turn=1;
    touch=1;
    id_coins[1]=0,0;
    initial_position_x[1]=325,325;
    initial_position_y[1]=691,659;
    number_of_players=0;
    game_way;

    id_camera;
    camera_x=0;
    camera_y=0;
    moving=FALSE;

    id_process_direction=0;
    id_process_incline=0;
    id_process_force=0;
    objective=0;
    counter0=0;

LOCAL
    force_ini;
    x_resol=0;
    y_resol=0;
    my_turn=0;
    id_pos_ant=0;
    force=minimum_force;
    direction=0;
    incline=0;
    inc_incline=0;
    movement=0;
    num_launching=1;
    present_return=0;
    control[3]=FALSE,FALSE,FALSE;
    was=FALSE;
    coins_collision=0;
    animation=17;

BEGIN

    priority=1;


    source1=load_fnt("coins\titulo.fnt");
    source2=load_fnt("coins\opcion.fnt");
    source3=load_fnt("coins\juego.fnt");
    source4=load_fnt("coins\credits.fnt");


    sound1=load_pcm("coins\tic7.pcm",1);
    sound2=load_pcm("coins\metal4.pcm",0);
    sound3=load_pcm("coins\metal10.pcm",0);

    LOOP


        SWITCH (program_state);
            CASE 1:
                title();
                timer[0]=0;
            END
            CASE 2:
                gameplay();
            END
            CASE 3:
                credits();
            END
            CASE 4:
                exit("Thanks for playing!",0);
            END
            DEFAULT:



                IF (program_state==-1 AND timer[0]>1000)
                    new_state=3;
                    timer[0]=0;
                END
            END
        END
        FRAME;
    END
END






PROCESS title();

BEGIN
    program_state=-1;

    new_state=0;
    set_mode(m320x240);

    graphics_file=load_fpg("coins\porchapa.fpg");
    // put_screen(graphics_file,1);
    load_fpg("coins\porchapa.fpg");
    xput(1, 1, 160,120,0, 50, 0, 0);
    load_pal("coins\porchapa.fpg");
    fade_on();


    write(source4,75,110,3,"1 Practice");
    write(source4,75,130,3,"2 Human Vs Human");
    write(source4,75,150,3,"3 Human Vs Machine");
    write(source4,75,190,3,"ESC Exit to DOS");
    write(source4,160,230,4,"(c) 2000 Div Games Studio");
    write(source2,160,30,4,"WORLD COINS");
    write(source2,160,60,4,"CHAMPIONSHIP");

    WHILE (new_state==0)

        IF (key(_1))
            number_of_players=1;
            game_way=1;
            new_state=2;
        END
        IF (key(_2))
            number_of_players=2;
            game_way=2;
            new_state=2;
        END
        IF (key(_3))
            number_of_players=2;
            game_way=3;
            new_state=2;
        END
        IF (key(_esc))
            new_state=4;
        END

        FRAME;

    END

    fade_off();

    unload_fpg(graphics_file);
    delete_text(all_text);
    program_state=new_state;
END






PROCESS credits();

PRIVATE

    id_title_text;
    id_prog_text_1;
    id_prog_text_2;
    id_graphics_text_1;
    id_graphics_text_2;
    id_music_text_1;
    id_music_text_2;
    id_copy_text;

BEGIN
    program_state=-3;
    //set_mode(m640x480);
    graphics_file=load_fpg("coins\porchapa.fpg");
    xput(graphics_file, 1, 160,120,0, 50, 0, 0);
    load_pal("coins\porchapa.fpg");
    fade_on();
    WHILE (fading)
        FRAME;
    END

    x=60;
    y=240;


    id_title_text=write(source4,x,y,1,"WORLD COINS CHAMPIONSHIP");
    id_prog_text_1=write(source4,x,y+40,0,"Programming:");
    id_prog_text_2=write(source4,x,y+60,0,"  Manuel Caba¤as Venera");
    id_graphics_text_1=write(source4,x,y+100,0,"Graphics:");
    id_graphics_text_2=write(source4,x,y+120,0,"  Pablo de la Sierra");
    id_music_text_1=write(source4,x,y+160,0,"Original idea:");
    id_music_text_2=write(source4,x,y+180,0,"  Luis F. Fernandez");
    id_copy_text=write(source4,160,y+220,1,"(c) Daniel Navarro DIV Games Studio");
    scan_code=0;
    FRAME;

    REPEAT

        IF (scan_code<>0 OR y<-280) BREAK; END

        y-=2;
        move_text(id_title_text,160,y);
        move_text(id_prog_text_1,x,y+40);
        move_text(id_prog_text_2,x,y+60);
        move_text(id_graphics_text_1,x,y+100);
        move_text(id_graphics_text_2,x,y+120);
        move_text(id_music_text_1,x,y+160);
        move_text(id_music_text_2,x,y+180);
        move_text(id_copy_text,160,y+220);
        FRAME;
    UNTIL (program_state==1)
    fade_off();

    delete_text(all_text);
    unload_fpg(graphics_file);
    program_state=1;
END






PROCESS gameplay();

BEGIN
    program_state=-2;

    new_state=0;
    turn=1;
    touch=1;
    objective=0;

    set_mode(m320x240);
    graphics_file=load_fpg("coins\chapas.fpg");


    start_scroll(0,graphics_file,graphics_map,0,0,3);
    load_pal("coins\chapas.fpg");
    fade_on();

    moving=TRUE;

    beginning_gameplay();

    id_camera=pricipal_camera();
    id_process_direction=coins_direction();
    id_process_incline=coins_incline();
    id_process_force=coins_force();


    changes_movement(id_coins[0].x-160,id_coins[0].y-100);


    write(source3,2,2,0,"turn");
    write_int(source3,70,2,0,&turn);
    write(source3,2,22,0,"Goes");
    write_int(source3,70,22,0,&touch);

    FRAME;
    LOOP

        counter0=0;
        WHILE (counter0<number_of_players)
            IF (id_coins[counter0].present_return<returns)
                counter0++;
            ELSE
                BREAK;
            END
        END


        IF (counter0<number_of_players)
            new_state=1;
            BREAK;
        END


        IF (key(_esc))
            new_state=1;
            BREAK;
        END

        FRAME;

    END


    signal(type player_coin,s_kill_tree);
    signal(type rival,s_kill_tree);
    signal(id_camera,s_kill);
    signal(id_process_direction,s_kill_tree);
    signal(id_process_incline,s_kill_tree);
    signal(id_process_force,s_kill_tree);

    stop_scroll(0);
    fade_off();
    delete_text(all_text);
    unload_fpg(graphics_file);
    program_state=new_state;
END






PROCESS beginning_gameplay();

PRIVATE
    player;

BEGIN


    IF (number_of_players==1)
        id_coins[0]=player_coin(1);
    ELSE
        player=rand(0,number_of_players-1);
        IF (player==0)
            id_coins[0]=player_coin(1);
            IF (game_way==2)
                id_coins[1]=player_coin(2);
            ELSE
                id_coins[1]=rival(2);
            END
        ELSE
            IF (game_way==2)
                id_coins[1]=player_coin(1);
            ELSE
                id_coins[1]=rival(1);
            END
            id_coins[0]=player_coin(2);
        END
    END
END






PROCESS check_position(identity);

PRIVATE
    colour;

BEGIN


    colour=map_get_pixel(graphics_file,detect_hit_map,(identity.x)/2,(identity.y)/2);


    SWITCH (colour)
        CASE outside_colour:
            identity.was=TRUE;
        END
        CASE object_colour:
            identity.was=TRUE;
        END
        CASE colour_control_1:

            IF (NOT identity.was)
                identity.control[0]=TRUE;
            END
        END
        CASE colour_control_2:

            IF (NOT identity.was AND identity.control[0])
                identity.control[1]=TRUE;
            END
        END
        CASE colour_control_3:

            IF (NOT identity.was AND identity.control[1])
                identity.control[2]=TRUE;
            END
        END
        CASE put_colour:

            IF (NOT identity.was AND identity.control[2])
                identity.control[2]=identity.control[1]=identity.control[0]=FALSE;
                identity.present_return++;
            END
        END
    END
END






PROCESS calculate_movement();

PRIVATE
    previous_angle;
    distance_angle;

BEGIN


    SWITCH (father.movement);

        CASE 1,2:


            father.x_resol+=get_distx(father.direction,2000);
            father.y_resol+=get_disty(father.direction,2000);

            check_position(father);

            father.x=father.x_resol/1000;
            father.y=father.y_resol/1000;
        END

        CASE 3,4:

            x=father.x;
            y=father.y;

            previous_angle=get_angle(father.id_pos_ant);
            distance_angle=get_dist(father.id_pos_ant);

            IF (distance_angle<previous_speed)

                father.x=father.id_pos_ant.x;
                father.y=father.id_pos_ant.y;

                father.was=FALSE;
                father.direction=0;

                IF (father.my_turn==turn AND father.movement==3)
                    turn++;
                    IF (turn>number_of_players) turn=1; END
                END
                father.movement=0;
                signal(father.id_pos_ant,s_kill);
            ELSE

                father.x+=get_distx(previous_angle,previous_speed);
                father.y+=get_disty(previous_angle,previous_speed);
            END

            father.x_resol=father.x*1000;
            father.y_resol=father.y*1000;
        END
        DEFAULT:
        END
    END


    IF (father.x<10)
        father.movement=3;
        father.force=0;
        father.x=10;
        father.x_resol=10000;
        father.direction=0;
        father.incline=0;
    END


    IF (father.x>map_wide-10)
        father.movement=3;
        father.force=0;
        father.x=map_wide-10;
        father.x_resol=(map_wide-10)*1000;
        father.direction=0;
        father.incline=0;
    END


    IF (father.y<10)
        father.movement=3;
        father.force=0;
        father.y=10;
        father.y_resol=10000;
        father.direction=0;
        father.incline=0;
    END


    IF (father.y>map_stop-10)
        father.movement=3;
        father.force=0;
        father.y=map_stop-10;
        father.y_resol=(map_stop-10)*1000;
        father.direction=0;
        father.incline=0;
    END

END






PROCESS changes_movement(x,y);

BEGIN



    IF (x<0)
        x=0;
    ELSE
        IF (x>map_wide-320)
            x=map_wide-320;
        END
    END
    IF (y<0)
        y=0;
    ELSE
        IF (y>map_stop-200)
            y=map_stop-200;
        END
    END


    camera_x=x;
    camera_y=y;
END






PROCESS coins_direction();

BEGIN
    file=graphics_file;
    ctype=c_scroll;

    z=-1;
    priority=-1;
    size=50;

    LOOP

        IF (objective<>0)



            x=objective.x+get_distx(objective.direction,24);
            y=objective.y+get_disty(objective.direction,24);


            angle=objective.direction;


            IF (objective.my_turn==1)
                graph=400;
            ELSE
                graph=401;
            END
        ELSE
            graph=0;
        END
        FRAME;
    END
END






PROCESS bottom_incline();

BEGIN
    file=graphics_file;
    graph=200;
    x=father.x;
    y=father.y;
    z=-2;
    LOOP
        FRAME;
    END
END






PROCESS coins_incline();

BEGIN
    file=graphics_file;
    graph=201;
    x=281;
    y=38;
    z=-3;
    priority=-1;
    bottom_incline();

    LOOP

        IF (objective<>0)

            angle=(objective.incline/2);
        ELSE

            angle=0;
        END
        FRAME;
    END
END






PROCESS bottom_force();

BEGIN
    file=graphics_file;
    graph=300;
    x=father.x;
    y=father.y;
    z=-2;
    LOOP
        FRAME;
    END
END







PROCESS coins_force();

BEGIN
    file=graphics_file;
    graph=301;
    x=281;
    y=161;
    z=-3;
    priority=-1;
    bottom_force();
    LOOP
        IF (objective<>0)

            angle=-((objective.force-minimum_force)*3*pi)/(2*(power_maximum-minimum_force));
        ELSE

            angle=0;
        END
        FRAME;
    END
END






PROCESS player_coin(my_turn);

PRIVATE

    force_loaded=FALSE;
    force_arrives=TRUE;

BEGIN

    file=graphics_file;
    graph=17;
    flags=0;

    x=initial_position_x[my_turn-1];
    y=initial_position_y[my_turn-1];

    x_resol=x*1000;
    y_resol=y*1000;
    ctype=c_scroll;
    FRAME;

    LOOP


        IF (turn==my_turn AND movement==0)
            objective=id;
            WHILE (moving)
                FRAME;
            END

            IF (key(_o) OR key(_left))
                direction=direction+(pi/32);
            END
            IF (key(_p) OR key(_right))
                direction=direction-(pi/32);
            END
            IF (key(_a) OR key(_down))
                incline=incline+pi/8;
                IF (incline>maximum_incline)
                    incline=maximum_incline;
                END
            END
            IF (key(_q) OR key(_up))
                incline=incline-pi/8;
                IF (incline<minimum_incline)
                    incline=minimum_incline;
                END
            END


            IF (key(_space) OR key(_enter))
                IF (force==minimum_force AND channels==-1)
                    channels=sound(sound1,256,492);
                END
                force_loaded=TRUE;
                IF (force_arrives)
                    force=force+2;
                    IF (force>power_maximum)
                        force_arrives=FALSE;
                        force=power_maximum;
                    END
                ELSE
                    force=force-2;
                    IF (force<minimum_force)
                        force=minimum_force;
                        force_arrives=TRUE;
                    END
                END
                change_sound(channels,256,512-force*10);
            END


            IF ((NOT key(_space) AND NOT key(_enter)) AND force_loaded)
                stop_sound(channels);
                channels=-1;
                sound(sound2,132+force*30,700);
                id_pos_ant=point(x,y);
                num_launching++;
                force_loaded=FALSE;
                was=FALSE;
                movement=1;
                force_arrives=TRUE;
                inc_incline=(-incline*2)/force;
                objective=0;
                force_ini=force;
            END
            touch=num_launching;
        END

        IF (movement<>0)
            animation=66-animation;
            SWITCH (movement)
                CASE 1,2:
                    incline+=inc_incline;
                    direction+=inc_incline;


                    FOR (counter0=0;counter0<force;counter0+=2)
                        calculate_movement();


                        IF(was AND force==force_ini)
                            was=FALSE;
                        END
                        IF (movement==1 AND game_way==3 AND (coins_collision=collision(TYPE rival)))
                            impact();
                        END
                        IF (game_way==2)
                            WHILE ((coins_collision=collision(TYPE player_coin)))

                                IF (coins_collision<>id) impact(); END
                            END
                        END
                    END
                    force-=2;

                    IF (force<=0)
                        force=minimum_force;
                        IF (was)
                            IF (movement<3)
                                movement+=2;
                            END
                        ELSE
                            IF (turn==my_turn AND movement==1)
                                turn++;
                                IF (turn>number_of_players)
                                    turn=1;
                                END
                            END
                            signal(id_pos_ant,s_kill);
                            movement=0;
                        END
                    END
                END
                CASE 3:
                    calculate_movement();
                END
                CASE 4:
                    calculate_movement();
                    IF (game_way==3 AND (coins_collision=collision(TYPE rival)))
                        IF (coins_collision.movement<>3)
                            impact();
                        END
                    END
                    IF (game_way==2)
                        WHILE ((coins_collision=collision(TYPE player_coin)))
                            IF (coins_collision<>id AND coins_collision.movement<>3)
                                impact();
                            END
                        END
                    END
                END
            END
        END


        IF (direction>pi)
            direction-=2*pi;
        END
        IF (direction<-pi)
            direction+=2*pi;
        END

        changes_graphics(id);

        IF (turn==my_turn)
            IF (movement==0)
                camera();
            ELSE
                camera_2();
            END
        END
        FRAME;
    END
END






PROCESS impact();

PRIVATE
     angle0;

BEGIN

    sound(sound3,512,512);


    x=father.x;
    y=father.y;


    father.coins_collision.id_pos_ant=point(father.coins_collision.x,father.coins_collision.y);
     angle0=get_angle(father.coins_collision);


    father.coins_collision.x=x+get_distx( angle0,28);
    father.coins_collision.x_resol=father.coins_collision.x*1000;
    father.coins_collision.y=y+get_disty( angle0,28);
    father.coins_collision.y_resol=father.coins_collision.y*1000;
    father.coins_collision.was=FALSE;


    check_position(father.coins_collision);


    IF (father.force>minimum_force)

        father.coins_collision.force=father.force/2;
        father.coins_collision.direction= angle0;
        father.coins_collision.movement=2;
        father.coins_collision.incline=0;
        father.coins_collision.inc_incline=0;


        father.force-=(father.force/2);
        father.inc_incline=(-father.incline*2)/father.force;
        father.direction-=( angle0-father.direction);
    ELSE
        IF (NOT father.coins_collision.was)
            signal(father.coins_collision.id_pos_ant,s_kill);
        ELSE
            father.coins_collision.movement=4;
        END
    END
END






PROCESS changes_graphics(identity);

BEGIN


    identity.graph=(identity.incline)*8/pi;
    IF (identity.graph<-16)
        identity.graph=-16;
    END
    IF (identity.graph>15)
        identity.graph=15;
    END

    IF ((identity.graph)<>0)
        identity.angle=identity.direction;
        identity.graph+=17;
    ELSE
        identity.angle=0;
        identity.graph+=identity.animation;
    END
END






PROCESS camera();

BEGIN

    x=father.x+get_distx(father.direction,140)-160;
    y=father.y+get_disty(father.direction,80)-100;

    changes_movement(x,y);
END






PROCESS camera_2();

PRIVATE
    inc_x;
    inc_y;

BEGIN

    inc_x=father.x-scroll.x0;
    inc_y=father.y-scroll.y0;


    IF (inc_x>240 AND (father.direction>-pi/2 OR father.direction<pi/2 OR father.movement==3))

        inc_x-=240;
    ELSE
        IF (inc_x<80 AND (father.direction<-pi/2 OR father.direction>pi/2 OR father.movement==3))

            inc_x-=80;
        ELSE
            inc_x=0;
        END
    END



    IF (inc_y>120 AND (father.direction>-pi OR father.direction<0 OR father.movement==3))

        inc_y-=120;
    ELSE
        IF (inc_y<80 AND (father.direction>0 OR father.direction<pi OR father.movement==3))

            inc_y-=80;
        ELSE
            inc_y=0;
        END
    END


    IF (scroll.x0+inc_x>map_wide-320)
        inc_x=map_wide-320-scroll.x0;
    END
    IF (scroll.x0+inc_x<0)
        inc_x=-scroll.x0;
    END
    IF (scroll.y0+inc_y>map_stop-200)
        inc_y=map_stop-200-scroll.y0;
    END
    IF (scroll.y0+inc_y<0)
        inc_y=-scroll.y0;
    END

    changes_movement(scroll.x0+inc_x,scroll.y0+inc_y);
END






PROCESS point_control(point_n);

BEGIN

    get_point(graphics_file,graphics_map,point_n,&x,&y);
    LOOP
        FRAME;
    END
END





PROCESS rival(my_turn);

PRIVATE
    temp_x;
    temp_y;
    temp_return;
    temp_control[2];
    temp_force;
    temp_direction;
    id_point_control;
    point_actual=point_complete;
    point_avance=0;
    heads=1;
    distance0;
    distance1;
    distance2;
    fault=FALSE;

BEGIN
    file=graphics_file;
    graph=17;
    ctype=c_scroll;

    x=initial_position_x[my_turn-1];
    y=initial_position_y[my_turn-1];
    x_resol=x*1000;
    y_resol=y*1000;

    LOOP
        IF (turn==my_turn AND movement==0)
            changes_movement(x-160,y-100);
            touch=num_launching;
            FRAME;
            WHILE (moving)
                FRAME;
            END



            IF (point_actual>1)
                id_point_control=point_control(point_actual-1);
            ELSE
                id_point_control=point_control(point_complete);
            END
            distance0=get_dist(id_point_control);
            signal(id_point_control,s_kill);


            id_point_control=point_control(point_actual);
            distance1=get_dist(id_point_control);
            signal(id_point_control,s_kill);


            IF (point_actual<point_complete)
                id_point_control=point_control(point_actual+1);
            ELSE
                id_point_control=point_control(1);
            END
            distance2=get_dist(id_point_control);
            signal(id_point_control,s_kill);
            heads=1;

            WHILE (heads<>0)
                IF (heads==1)
                    point_actual++;
                    IF (point_actual>point_complete)
                        point_actual=1;
                    END
                    distance0=distance1;
                    distance1=distance2;


                    IF (point_actual<point_complete)
                        id_point_control=point_control(point_actual+1);
                    ELSE
                        id_point_control=point_control(1);
                    END
                    distance2=get_dist(id_point_control);
                    signal(id_point_control,s_kill);

                ELSE
                    point_actual--;
                    IF (point_actual<1)
                        point_actual=point_complete;
                    END
                    distance2=distance1;
                    distance1=distance0;


                    IF (point_actual>1)
                        id_point_control=point_control(point_actual-1);
                    ELSE
                        id_point_control=point_control(point_complete);
                    END
                    distance0=get_dist(id_point_control);
                    signal(id_point_control,s_kill);
                END


                IF (heads==1)
                    IF (distance0<distance2)
                        point_actual--;
                        IF (point_actual<1)
                            point_actual=point_complete;
                        END
                        heads=0;
                    END
                ELSE
                    IF (distance0>distance2)
                        point_actual++;
                        IF (point_actual>point_complete)
                            point_actual=1;
                        END
                        heads=0;
                    END
                END
            END

            IF (NOT fault)
                point_avance=maximum_advance;
            END

            REPEAT
                FRAME;

                IF ((point_actual+point_avance)>point_complete)
                    id_point_control=point_control(point_actual+point_avance-point_complete);
                ELSE
                    id_point_control=point_control(point_actual+point_avance);
                END


                distance0=get_dist(id_point_control);


                direction=get_angle(id_point_control);
                signal(id_point_control,s_kill);


                force=minimum_force;
                WHILE (distance0>((force+2)*force/4))
                    force+=2;
                    IF (force>power_maximum)
                        BREAK;
                    END
                END

                IF (force<=power_maximum)
                    movement=1;
                    was=FALSE;
                    temp_x=x;
                    temp_y=y;
                    temp_return=present_return;
                    temp_control[0]=control[0];
                    temp_control[1]=control[1];
                    temp_control[2]=control[2];
                    temp_force=force;
                    temp_direction=direction;


                    WHILE (movement==1)
                        incline+=inc_incline;
                        direction+=inc_incline;


                        FOR (counter0=0;counter0<force;counter0+=2)
                            calculate_movement();
                            IF (was)
                                movement=0;
                                BREAK;
                            END
                        END

                        force-=2;
                        IF (force<=0)
                            force=minimum_force;
                            movement=0;
                        END
                    END

                    x=temp_x;
                    y=temp_y;
                    x_resol=x*1000;
                    y_resol=y*1000;
                    present_return=temp_return;
                    control[0]=temp_control[0];
                    control[1]=temp_control[1];
                    control[2]=temp_control[2];
                ELSE
                    was=TRUE;
                END
                signal(id_point_control,s_kill);
                IF (was) point_avance--; END
            UNTIL (was==FALSE OR point_avance==0)

            FRAME;

            num_launching++;

            force=temp_force;
            direction=temp_direction;
            incline=0;
            movement=1;
            id_pos_ant=point(x,y);
            was=FALSE;
            fault=FALSE;
            touch=num_launching;
            sound(sound2,132+force*30,700);
        END

        IF (movement<>0)
            animation=66-animation;
            SWITCH (movement);

                CASE 1,2:
                    incline+=inc_incline;
                    direction+=inc_incline;


                    FOR (counter0=0;counter0<force;counter0+=2)
                        calculate_movement();


                        IF (movement==1)
                            IF ((coins_collision=collision(TYPE player_coin)))
                                impact();
                            END
                        END
                    END

                    force-=2;
                    IF (force<=0)
                        force=minimum_force;

                        IF (was)
                            IF (movement<3) movement+=2; END
                        ELSE
                            IF (turn==my_turn AND movement==1)
                                turn++;
                                IF (turn>number_of_players) turn=1; END
                            END
                            signal(id_pos_ant,s_kill);
                            movement=0;
                        END
                    END
                END

                CASE 3:
                    calculate_movement();
                    fault=TRUE;
                END

                CASE 4:
                    calculate_movement();
                    IF ((coins_collision=collision(TYPE player_coin)))
                        impact();
                    END
                END
            END

        END


        changes_graphics(id);

        IF (turn==my_turn AND movement<>0) camera_2(); END
        FRAME;
    END
END






PROCESS point(x,y);

BEGIN
    LOOP
        FRAME;
    END
END






PROCESS pricipal_camera();

PRIVATE

    distance;
    inc_x;
    inc_y;
    advance_angle;

BEGIN
    priority=-2;

    scroll.x0=0;
    scroll.y0=0;

    LOOP
        x=scroll.x0;
        y=scroll.y0;


            distance=fget_dist(x,y,camera_x,camera_y);


            IF (distance<=20)
                scroll.x0=camera_x;
                scroll.y0=camera_y;
                moving=0;
            ELSE
                moving=1;
                advance_angle=fget_angle(x,y,camera_x,camera_y);
                inc_x=get_distx(advance_angle,20);
                inc_y=get_disty(advance_angle,20);
                scroll.x0+=inc_x;
                scroll.y0+=inc_y;
            END
        FRAME;

    END
END



