compiler_options _extended_conditions;
//-----------------------------------------------------------------------------
//TITLE:      Super Alien
//AUTHOR:       Div Games
//DATE:       DIV GAMES STUDIO (c) 2000
//-----------------------------------------------------------------------------

PROGRAM super_alien;

CONST
    pi_quarter=PI/4;
    pi_eigth=PI/8;
    pi_half=PI/2;

GLOBAL
    enemy_f;
    score;


    s_alien;
    s_firing;
    s_bip;
    s_explosion;
    s_explosion2;
    s_firing_t;
    s_motor;
    s_pum;

    selection=0;
    file1;
    file2;
    source_s;
    source_m;
    source_j;
    source_c;
    source_d;
    id_menu;
    id_robot;
    id_c_robot;
    id_missiles;
    number_of_missiles;
    table_missiles[30];
    missiles_library;
    energy_robot;
    max_x=319;
    max_y=199;
    nomover;
    freq_t_d;
    freq_h_d;
    is_dead=0;

LOCAL
    graphic_number;
    it_moves;
    x_res;
    y_res;
    Velocity;
     angle0;
    energy;
    _sound;

BEGIN


    start_fli("alien\intro.fli",0,0);

    WHILE (frame_fli()<>0 AND scan_code==0 AND NOT mouse.left)
        FRAME;
    END

    end_fli();
    fade_off();
    id_menu=id;

    file2=load_fpg("alien\suprimer.fpg");
    source_d=load_fnt("alien\aliend.fnt");
    load_pal("alien\suprimer.fpg");


    put_screen(file2,2);
    write (source_d,320,200,4,"LOADING DATA");
    fade_on();

    WHILE (fading)
        FRAME;
    END



    file1=load_fpg("alien\alien.fpg");


    source_m=load_fnt("alien\alienm.fnt");
    source_s=load_fnt("alien\aliens.fnt");
    source_j=load_fnt("alien\alienj.fnt");
    source_c=load_fnt("alien\alienc.fnt");


    s_firing=load_pcm("alien\laser6.pcm",0);
    s_firing_t=load_pcm("alien\esco_at1.pcm",0);
    s_pum=load_pcm("alien\golpe20.pcm",0);
    s_alien=load_pcm("alien\alien.pcm",0);
    s_bip=load_pcm("alien\bip.pcm",0);
    s_explosion=load_pcm("alien\explosio.pcm",0);
    s_explosion2=load_pcm("alien\explosi8.pcm",0);
    s_motor=load_pcm("alien\motor.pcm",1);

    delete_text(all_text);



    intro();
    FRAME;

    set_mode(m320x240);



    WHILE (selection<>2)

        load_pal("alien\suprimer.fpg");

        xput(file2,3,160,120,0,50,0,0);
        xput(file2,15,160,60,0,50,0,0);
        write(source_m,160,140,4,"PLAY");
        write(source_m,160,170,4,"EXIT");
        fade_on();


        cursor();
        WHILE (selection==0)
            FRAME;
        END
        fade_off();

        IF (selection==1)
            delete_text(all_text);

            load_pal("alien\alien.fpg");

            start_scroll(0,file1,1,0,0,0);
            scroll.x0=20;
            scroll.y0=2700;

            pause();


            nomover=0;
            enemy_f=1;
            number_of_missiles=6;
            missiles_library=1;
            freq_t_d=18;
            freq_h_d=40;
            graph=0;
            score=0;

            write_int(source_s,320,0,2,&score);
            fade_on();



            id_robot=robot_legs();
            enemy_thrower();
            id_missiles=misil();


            WHILE (NOT key(_esc) & is_dead==0)
                FRAME;

            END


            fade_off();
            is_dead=0;
            selection=0;
            stop_sound(all_sound);
            delete_text(all_text);
            let_me_alone();

        END
            break;
    END
    let_me_alone();


END











PROCESS robot();

PRIVATE
    graphic_firing=0;
    i_can_shoot=1;
    i_can_shoot_missiles=1;
    id_sound_firing=0;

BEGIN
    ctype=c_scroll;
    z=-5;
    priority=10;
    file=file1;
    LOOP

        IF (key(_alt) AND number_of_missiles>0)
            IF (i_can_shoot_missiles)
                graphic_firing=1;
                i_can_shoot_missiles=0;
                firing_missiles();
                number_of_missiles--;
            END
        ELSE
            i_can_shoot_missiles=1;
        END

        IF (key(_control))
            IF (i_can_shoot)


                stop_sound(id_sound_firing);


                graphic_firing=1;
                i_can_shoot=0;


                firing_robot(x-18,y-21);
                firing_robot(x+19,y-21);


                id_sound_firing=sound(s_firing,100,256);
            END
        ELSE

            i_can_shoot=1;
        END


        graph=3+graphic_firing;
        graphic_firing=0;
        FRAME;
    END
END






PROCESS robot_legs();

PRIVATE
    number_of_steps=0;
    follow_x_map;
    follow_y_map;
    obstacle;
    qty0;
    lives;
    x_map;
    y_map;
    increase_x;
    increase_y;

BEGIN
    ctype=c_scroll;
    priority=15;
    file=file1;
    lives=3;
    life();

    write_int(source_s,30,0,0,&lives);
    energy_robot=8000;
    sweep_energy();


    WHILE (lives>0)
        x_map=scroll.x0+160;
        y_map=scroll.y0+180;
        increase_x=0;
        increase_y=0;
        graphic_number=0;
        id_c_robot=robot();
        REPEAT


            increase_x=0;
            increase_y=0;


            IF (key(_up)) increase_y=-5; END
            IF (key(_down)) increase_y=5; END
            IF (key(_left)) increase_x=-5; END
            IF (key(_right)) increase_x=5; END

            it_moves=1;

            SWITCH ((increase_y*10)+increase_x)
                CASE 0: it_moves=0; END
                CASE -5: graphic_number=2; END
                CASE 5:  graphic_number=6; END
                CASE -50:graphic_number=4; END
                CASE 50: graphic_number=0; END
                CASE -55:graphic_number=3; END
                CASE -45:graphic_number=5; END
                CASE 45: graphic_number=1; END
                CASE 55: graphic_number=7; END
            END


            follow_x_map=x_map+increase_x;
            follow_y_map=y_map+increase_y;


            IF (map_get_pixel(file1,2,follow_x_map/2,(follow_y_map/2)+12)==24)
                obstacle=TRUE;
            ELSE
                obstacle=FALSE;
            END


            IF (it_moves<>0 AND obstacle==FALSE)

                IF (number_of_steps<4)
                    number_of_steps=number_of_steps+1;
                ELSE
                    number_of_steps=1;
                END


                IF ((increase_x>0 AND x_map<350) OR (increase_x<0 AND x_map>10))
                    IF ((increase_x>0 AND scroll.x0<40 AND x_map-scroll.x0>60) OR (increase_x<0 AND scroll.x0>0 AND x_map-scroll.x0<260))                        scroll.x0+=increase_x;
                    END
                    x_map=follow_x_map;
                END


                IF ((increase_y>0 AND y_map<2890 AND ((nomover==0 OR enemy_f==0) OR y_map<scroll.y0+190)) OR (increase_y<0 AND y_map>scroll.y0 AND y_map>scroll.y0+10))
                    IF ((increase_y>0 AND scroll.y0<2700 AND y_map-scroll.y0>190) OR (increase_y<0 AND scroll.y0>0 AND y_map-scroll.y0<150) AND (nomover==0 OR enemy_f==0))
                        scroll.y0+=increase_y;
                    END
                    y_map=follow_y_map;
                END

            ELSE
                number_of_steps=0;
            END


            x=x_map;
            y=y_map;
            id_c_robot.x=x;
            id_c_robot.y=y;
            graph=10+(graphic_number*5)+number_of_steps;
            FRAME;
        UNTIL (energy_robot<0)

        FRAME;
        signal(id_c_robot,s_kill);
        explosion_2(x,y-16,50);

        FRAME;
        IF (it_moves==1)

                IF (number_of_steps<4)
                    number_of_steps=number_of_steps+1;
                ELSE
                    number_of_steps=1;
                END
                graph=10+(graphic_number*5)+number_of_steps;

                x=x+get_distx( angle0,increase_x);
                y=y+get_disty( angle0,increase_y);

                FRAME(1000);
        END

        energy_robot=8000;
        lives--;

        IF (lives>0)
           signal(type sweep_energy,s_kill);
           sweep_energy();
        ELSE
            write(source_j,160,100,4,"GAME OVER");
        END

        graph=0;
        explosion_1(x,y);
        FRAME(1000);
    END


    stop_sound(all_sound);
    selection=0;

    WHILE (NOT key(_space))
        FRAME;
    END
    is_dead=1;
END






PROCESS life();

BEGIN
    file=file1;graph=3;
    x=15; y=17;
    size=70;
    LOOP FRAME; END
END






PROCESS firing_robot(x,y);

PRIVATE
    touch;

BEGIN
    ctype=c_scroll;
    z=10;
    priority=5;
    file=file1;
    graph=100;


    WHILE (NOT out_region(id,0))

        IF (touch=collision(TYPE helicopter1))
            BREAK;
        ELSE
            IF (touch=collision(TYPE helicopter2))
                BREAK;
            ELSE
                IF (touch=collision(TYPE helicopter3))
                    BREAK;
                END
            END
        END
        y-=12;
        FRAME;
    END


    IF (touch)
        touch.energy-=300;
        impact(x,y);
    END
END






PROCESS firing_missiles();

PRIVATE
    j=0;

BEGIN
    ctype=c_scroll;
    z=father.z-1;
    priority=5;
    file=file1;
    graph=103;
    x=father.x;
    y=father.y;
    smoke(25,x,y);


    FROM j=0 TO 10;
        y-=12;
        z=y;
        FRAME;
    END

    explosion_3(x,y);
END






PROCESS firing_tank();

PRIVATE
    angle_a_robot;
    x1=0;
    y1=0;
    x2=0;
    y2=0;

BEGIN
    ctype=c_scroll;
    file=file1;
    graph=104;



    get_point(file1,father.graph,1,&x1,&y1);
    get_point(file1,father.graph,2,&x2,&y2);


    angle_a_robot=fget_angle(x1,y1,x2,y2);



    get_point(file1,father.graph,0,&x1,&y1);
    get_point(file1,father.graph,2,&x2,&y2);


    x=(x2-x1)+(father.x);
    y=(y2-y1)+(father.y);

    sound(s_firing_t,100,512);

    Velocity=5;

    WHILE (NOT out_region(id,0) AND NOT collision(TYPE robot) AND NOT collision(TYPE robot_legs))
        x=x+get_distx(angle_a_robot,Velocity);
        y=y+get_disty(angle_a_robot,Velocity);
        angle=angle_a_robot;
        FRAME;
    END

    IF (NOT out_region(id,0))
        impact(x,y);
        energy_robot-=1000;
    END
END






PROCESS firing_helicopter();

PRIVATE
    angle_a_robot;
    id_smoke;

BEGIN
    z=-48;
    ctype=c_scroll;
    file=file1;
    graph=102;
    sound(s_explosion,64,512);
    x_res=father.x*10000;
    y_res=father.y*10000;
    x=x_res/10000;
    y=y_res/10000;
    angle=get_angle(id_robot);
    id_smoke=smoke(25,x,y);
    Velocity=40000;


    WHILE (NOT out_region(id,0) AND NOT collision(TYPE robot) AND NOT collision(TYPE robot_legs))

        x_res=x_res+get_distx(angle,Velocity);
        y_res=y_res+get_disty(angle,Velocity);
        x=x_res/10000;
        y=y_res/10000;
        IF (Velocity<80000)
            Velocity+=5000;
        END
        FRAME;
    END

    IF (NOT out_region(id,0))
        impact(x,y);
        energy_robot-=1000;
    END
    signal(id_smoke,s_kill_tree);
END






PROCESS smoke(size,x_res,y_res);

BEGIN

    IF (size>5)
        smoke(size-5,x_res,y_res);
    END
    ctype=c_scroll;
    graph=105;
    file=file1;
    flags=4;
    LOOP
        x=x_res;
        y=y_res;
        IF (father)
            x_res=father.x;
            y_res=father.y;
        END
        FRAME;
    END
END






PROCESS enemy_thrower();

BEGIN



    bunker(90,54,1506);
    bunker(90,32,1184);
    bunker(90,122,463);
    bunker(92,329,2248);
    bunker(92,306,1942);
    bunker(92,306,1234);

    cannon_tank(50,2600,0);
    cannon_tank(359,2539,-1);   
    cannon_tank(359,2484,0);    
    cannon_tank(100,2146,0);    
    cannon_tank(322,2146,0);    
    cannon_tank(75,2080,1);
    cannon_tank(225,1767,0);
    cannon_tank(129,1767,0);
    cannon_tank(140,1629,1);
    cannon_tank(319,1375,-1);
    cannon_tank(169,1014,0);
    cannon_tank(273,1014,0);
    cannon_tank(65,1014,0);
    cannon_tank(253,871,-1);
    cannon_tank(137,600,-1);
    cannon_tank(215,600,1);
    cannon_tank(286,359,0);
    cannon_tank(225,302,0);
    cannon_tank(142,258,0);

    enemy_final();

    
    WHILE (scroll.y0>2410)
        FRAME;
    END
    
    helicopter3();
    WHILE (scroll.y0>2210)
        FRAME;
    END
    helicopter3();
    WHILE (scroll.y0>2110)
        FRAME;
    END
    helicopter3();
    WHILE (scroll.y0>1990)
        FRAME;
    END
    helicopter2();
    WHILE (scroll.y0>1850)
        FRAME;
    END
    helicopter1();
    WHILE (scroll.y0>1700)
        FRAME;
    END
    helicopter1();
    freq_t_d=16;
    freq_h_d=30;
    WHILE (scroll.y0>1390)
        FRAME;
    END
    helicopter2();
    helicopter3();
    WHILE (scroll.y0>1280)
        FRAME;
    END
    helicopter3();
    WHILE (scroll.y0>1110)
        FRAME;
    END
    helicopter1();
    WHILE (scroll.y0>930)
        FRAME;
    END
    helicopter1();
    helicopter3();
    WHILE (scroll.y0>770)
        FRAME;
    END
    helicopter3();
    WHILE (scroll.y0>670)
        FRAME;
    END
    helicopter1();
    freq_t_d=14;    
    freq_h_d=25;
    WHILE (scroll.y0>620)
        FRAME;
    END
    helicopter1();
    WHILE (scroll.y0>490)
        FRAME;
    END
    helicopter3();
    WHILE (scroll.y0>350)
        FRAME;
    END
    helicopter1();
    helicopter3();
    WHILE (scroll.y0>300)
        FRAME;
    END
    helicopter3();
    WHILE (scroll.y0>260)
        FRAME;
    END
    helicopter3();

END






PROCESS explosion_1(x,y);

BEGIN
    ctype=c_scroll;                 
    file=file1;
    size=50;
    graph=301;
    z=-50;
    sound(s_explosion,100,256);     
    WHILE (graph<=315)
        FRAME;
        graph=graph+1;              
    END
END






PROCESS explosion_2(x,y,size);

BEGIN
    ctype=c_scroll;                 
    file=file1;
    graph=321;
    z=-50;                          
    sound(s_explosion2,100,300);    
    WHILE (graph<=359)
        FRAME;
        graph=graph+1;              
    END
END






PROCESS explosion_3(x,y);

BEGIN
    z=-50;
    ctype=c_scroll;
    file=file1;
    size=100;                               
    sound(s_explosion2,150,300);            
    CLONE                                   
        size=30+rand(0,35);                 
        x=x+rand(0,60)-30;                  
        y=y+rand(0,60)-30;
        angle=rand(0,2*pi)+1;               
        CLONE                               
            z=z-1;                          
            size=30+rand(0,35);             
            x=x+rand(0,60)-30;              
            y=y+rand(0,60)-30;
            angle=rand(0,2*pi)+1;
            CLONE                           
                z=z-1;                      
                size=60;                    
                x=x+rand(0,60)-30;          
                y=y+rand(0,60)-30;
                angle=rand(0,2*pi)+1;       
            END
        END
    END
    graph=321;                              
    WHILE (graph<=359)
        FRAME;
        graph=graph+1;                      
    END
END






PROCESS cannon_tank(x,y,direction);

PRIVATE
    id_tank;          
    id_s_motor;         
    firing=0;          
    
    Graphics_table[]=16,60,59,58,57,56,55,54,53,52,68,67,65,64,63,62,61;

BEGIN
    firing=freq_t_d;
    xgraph=&Graphics_table;     
    _sound=1;
    file=file1;
    id_tank=tank();
    ctype=c_scroll;
    z=10;
    energy=2500;
    graph=64;                   
    WHILE (out_region(id,0))    
        FRAME;
    END
    id_s_motor=sound(s_motor,130,256);
    WHILE (energy>0)           

        
        IF (out_region(id,0))
            IF (_sound)
                stop_sound(id_s_motor);
                _sound=0;
            END
        ELSE
            IF (NOT _sound)
                id_s_motor=sound(s_motor,130,256);
                _sound=1;
            END
        END

        
        IF (map_get_pixel(file1,101,x+10,y)<>58)
            x+=direction;
        END
        angle=get_angle(id_robot);  
        IF (_sound)
            IF (firing==0)
                firing_tank();
                firing=freq_t_d;
            ELSE
                firing--;
            END
        END
        FRAME;
    END
    
    signal(id_tank,s_kill);
    stop_sound(id_s_motor);
    IF (energy<=0)
        smoke_tank(x,y);
        explosion_1(x,y);
        score+=100;
    END
END






PROCESS tank();

PRIVATE
    if_i_touch;  

BEGIN
    z=15;
    ctype=c_scroll;     
    graph=50;
    file=file1;      
    LOOP
        
        IF (if_i_touch=collision(TYPE firing_robot))
            impact(if_i_touch.x,if_i_touch.y);
            signal(if_i_touch,s_kill);
            
            father.energy=father.energy-175;
        ELSE
            IF (if_i_touch=collision(TYPE explosion_3))
                father.energy=father.energy-100;
            END
        END
        x=father.x;                 
        y=father.y;
        FRAME;
    END
END






PROCESS smoke_tank(x,y);

PRIVATE
    if_i_touch;    

BEGIN
    z=100;
    ctype=c_scroll;
    graph=50;
    file=file1;
    energy=1400;   


    WHILE (energy>0)
        smoke2(x+rand(0,8)-4,y+rand(0,8)-4);     
        IF (if_i_touch=collision(TYPE firing_robot))
            impact(if_i_touch.x,if_i_touch.y);
            signal(if_i_touch,s_kill);
            energy=energy-175;
        ELSE
            
            IF (collision(TYPE explosion_3))
                energy-=100;
            END
        END
        FRAME;
    END

    
    explosion_2(x,y,100);
    score+=50;
END






PROCESS smoke2(x,y);

BEGIN
    size=80;
    ctype=c_scroll;             
    graph=105;
    file=file1;
    flags=4;                    
    REPEAT                      
        x+=rand(-1,1);
        y-=4;
        size-=8;
        FRAME;
    UNTIL (size<=0)
END






PROCESS impact(x,y);

BEGIN
    sound(s_explosion,48,1024);
    ctype=c_scroll;
    file=file1;
    graph=105;
    size=26;                        
    REPEAT                          
        size-=2;
        FRAME;
    UNTIL (size==2)                 
END






PROCESS bunker(graph,x,y);

PRIVATE
    if_i_touch;    
    firing;        

BEGIN
    file=file1;
    ctype=c_scroll; 
    z=10;
    energy=3000;   

    WHILE (out_region(id,0))    
        FRAME;
    END

    WHILE (energy>0)

        
        IF (if_i_touch=collision(TYPE firing_robot))
            impact(if_i_touch.x,if_i_touch.y);
            signal(if_i_touch,s_kill);
            energy-=175;
        ELSE
            IF (collision(TYPE explosion_3))
                energy-=100;
            END
        END

        
        IF (NOT out_region(id,0))
            IF (firing--==0)
                firing=10;
                IF (graph==90)
                    firing_bunker(x+38,y+26,94,8,8);
                ELSE
                    firing_bunker(x-32,y+28,95,-8,8);
                END
                sound(s_firing_t,100,512);
            END
        END
        FRAME;
    END

    
    graph++;
    explosion_2(x,y,100);
    score+=200;

    LOOP
        smoke2(x+rand(0,8)-4,y+rand(0,8)-4);
        FRAME;
    END
END






PROCESS firing_bunker(x,y,graph,ix,iy);

BEGIN
    file=file1;
    ctype=c_scroll;
    z=10;
    
    WHILE (NOT out_region(id,0) AND NOT collision(TYPE robot) AND NOT collision(TYPE robot_legs))
        x+=ix;
        y+=iy;
        FRAME;
    END
    
    IF (NOT out_region(id,0))
        impact(x,y);
        energy_robot-=1000;
    END
END






PROCESS missiles(x,y);

BEGIN
    file=file1;
    graph=103;
    size=100;               
    LOOP
        FRAME;              
    END
END






PROCESS misil();

PRIVATE
    xm=65;      
    ym=10;      
    c=0;        

BEGIN
    
    FOR (c=1;c<=number_of_missiles;c++)
        table_missiles[missiles_library++]=missiles(xm,ym);
        xm+=7;
    END
    LOOP
        c=number_of_missiles;
        WHILE (c==number_of_missiles)  
            FRAME;
        END
        
        signal(table_missiles[--missiles_library],s_kill);
        xm-=7;
    END
END






PROCESS sweep_energy();

PRIVATE
    wide;       

BEGIN
    file=file1;
    region=1;
    x=180;
    y=10;
    z=-100;
    graph=101;                  
    wide=120;                   
    energy=energy_robot;
    define_region(1,119,0,wide+1,20); 

    LOOP
        
        WHILE (energy==energy_robot)
            FRAME;
        END
            wide=wide-16;
            IF (wide<0) wide=0; END
            define_region(1,119,0,wide+1,20); 
            energy=energy_robot;
    END

END






PROCESS pause();

PRIVATE
    text_pause;     

BEGIN
    LOOP
        WHILE (NOT key(_p))         
            FRAME;
        END
        WHILE (KEY(_p)) FRAME; END
        text_pause=write(source_j,160,100,4,"PAUSE");
        FRAME;
        REPEAT  UNTIL (KEY(_p));    
        delete_text(text_pause);
        WHILE (KEY(_p)) END         

    END
END






PROCESS blades();

PRIVATE
    sign=1; 

BEGIN
    ctype=c_scroll;
    size=father.size;
    graph=86;
    flags=4;                
    file=file1;          
    z=father.z-1;
    angle=0;
    priority=1;

    CLONE                   
        angle=pi_quarter;   
        sign=-1;            
    END

    LOOP                    
        x=father.x;
        y=father.y;
        angle=angle+pi_eigth*sign;
        FRAME;
    END
END






PROCESS helicopter1();

PRIVATE
    id_blades; 
    _cx;        
    _cy;        
    p;          
    firing;    
    Graphics_table[]=16,81,80,79,78,77,76,75,74,73,72,71,70,85,84,83,82;

BEGIN
    priority=2;
     angle0=pi;
    firing=rand(0,freq_h_d*2-1);
    p=20;
    z=-48;
    CLONE                           
         angle0=0;
        p=300;
    END
    xgraph=&Graphics_table;         

    nomover++;
    ctype=c_scroll;
    file=file1;
    size=100;
    graph=11;
    id_blades=blades();   
    energy=1500;
    x=scroll.x0+160;        
    y=scroll.y0-10;

    _cx=x;

    
    WHILE (energy>0 AND y<scroll.y0+220)
        y++;
        x=_cx+get_distx( angle0,120);
        FRAME;
         angle0+=pi_quarter/32;
        angle=get_angle(id_robot);
        IF (firing==0)            
            firing_helicopter();
            firing=freq_h_d*2;
        ELSE
            firing--;
        END
    END

    IF (energy>0)
        angle=get_angle(id_robot);      
         angle0=fget_angle(x,y,scroll.x0+p,scroll.y0+20);
    END

    WHILE (energy>0 AND y>scroll.y0+20)
        x=x+get_distx( angle0,4);
        y=y+get_disty( angle0,4);
        angle=get_angle(id_robot);      
        
        IF (firing==0)
            firing_helicopter();
            firing=freq_h_d;
        ELSE
            firing--;
        END

        FRAME;
    END

    IF (energy>0)
         angle0=get_angle(id_robot);        
    END

    
    WHILE (energy>0 AND NOT out_region(id,0))
        x=x+get_distx( angle0,7);
        y=y+get_disty( angle0,7);
        angle=get_angle(id_robot);
        IF (firing==0)
            firing_helicopter();
            firing=freq_h_d;
        ELSE
            firing--;
        END
        FRAME;
    END

    
    IF (energy<=0)
        explosion_1(x,y);
        score+=125;
    END

    signal(id_blades,s_kill_tree);
    nomover--;
END






PROCESS helicopter2();

PRIVATE
    id_blades=0;   
    firing;        
    Graphics_table[]=16,81,80,79,78,77,76,75,74,73,72,71,70,85,84,83,82;
    inc_x=1;    
    inc_y=1;    


BEGIN
    priority=2;
    x=scroll.x0+20;
    y=scroll.y0-10;
    firing=rand(0,freq_h_d*2-1);
    z=-48;
    CLONE       
        x+=300;
        y=scroll.y0-10;
    END

    xgraph=&Graphics_table;

    nomover++;
    ctype=c_scroll;         
    file=file1;
    size=100;
    id_blades=blades();   
    energy=1500;

    REPEAT
        
        IF (x<scroll.x0+20)  inc_x=rand(2,8);  END
        IF (x>scroll.x0+300) inc_x=rand(-8,-2); END
        IF (y<scroll.y0+20) inc_y=rand(2,4); END
        IF (y>scroll.y0+70) inc_y=rand(-4,-2); END

        x+=inc_x;
        y+=inc_y;

        IF (firing==0)
            firing_helicopter();
            firing=freq_h_d*rand(1,3);
        ELSE
            firing--;
        END

        angle=get_angle(id_robot);
        FRAME;
    UNTIL (energy<0 OR rand(1,200)>199)

    
    WHILE (energy>0 AND NOT out_region(id,0))
        x+=inc_x;
        y+=inc_y;
        angle=get_angle(id_robot);
        IF (firing==0)
            firing_helicopter();
            firing=freq_h_d;
        ELSE
            firing--;
        END
        FRAME;
    END

    
    IF (energy<=0)
        explosion_1(x,y);
        score+=125;
    END

    signal(id_blades,s_kill_tree);
    nomover--;

END






PROCESS helicopter3();

PRIVATE
    id_blades=0;   
    firing=0;      

    Graphics_table[]=16,81,80,79,78,77,76,75,74,73,72,71,70,85,84,83,82;
    inc_x=1;        
    inc_y=1;        
    posicion_x;

BEGIN
    posicion_x=rand(10,140);
    priority=2;
    x=scroll.x0+posicion_x;
    y=scroll.y0-10;     
    z=-48;
    CLONE               
        x=scroll.x0+320-posicion_x;
    END

    xgraph=&Graphics_table;  

    firing=rand(freq_h_d,freq_h_d*2);

    ctype=c_scroll;          
    file=file1;
    id_blades=blades();
    energy=1500;

    angle=get_angle(id_robot);
     angle0=angle;

    
    WHILE (energy>0 AND y<scroll.y0+220)
        x+=get_distx( angle0,2);
        y+=get_disty( angle0,2);
        angle=get_angle(id_robot);
        IF (firing==0)
            firing_helicopter();
            firing=freq_h_d;
        ELSE
            firing--;
        END
        FRAME;
    END
    
    IF (energy<=0)
        explosion_1(x,y);
        score+=125;
    END

    signal(id_blades,s_kill_tree);

END






PROCESS intro();

PRIVATE
    j;          
    id_sound;  

BEGIN
    signal(father,s_sleep);
    FRAME(200);
    file=file2;
    graph=10;               
    x=160;
    y=100;
    size=500;               
    angle=0;
    fade_on();
    
    FROM size=500 TO 110 STEP -10;
        angle=angle+(pi/20);
        IF (key(_space))
            BREAK;
        END
        FRAME;
    END

    IF (NOT key(_space))
        sound(s_pum,250,256);
        FROM j=0 TO 75;
            IF (j==30)
                id_sound=sound(s_alien,100,256);
            END
            IF (key(_space))    
                BREAK;
            END
            FRAME;
        END
        stop_sound(id_sound);
    END

    fade_off();                 
    clear_screen();
    signal(father,s_wakeup);
END






PROCESS cursor();

PRIVATE
    c;

BEGIN
    file=file2;
    graph=1;
    x=70;
    y=140;
    c=3;

    selection=0;
    WHILE (NOT key(_space) AND NOT key(_control) AND NOT key(_enter) AND selection==0)

        IF (key(_up) AND y>150)
            y=140;
            sound(s_bip,100,256);
            FRAME;
        END
        IF (key(_down) AND y<180)
            y=170;
            sound(s_bip,100,256);
        END
        x+=c;
        IF (x>=80)
            c=-3;
        END
        IF (x<=70)
            c=3;
        END
        FRAME;

        IF (key(_esc))
            selection=2;
            y=180;
        END

    END
    sound(s_firing,100,256);

    SWITCH (y);
        CASE 140:
            selection=1;
        END
        CASE 170:
            selection=2;
        END
    END
END






PROCESS enemy_final();

PRIVATE
    wait;
    firing_1=10;   
    firing_2=20;   
    if_i_touch;    
    qty0;              
    Graphics_table[]=8,402,402,402,400,400,400,401,402; 

BEGIN
    file=file1;
    x=180;
    y=130;
    ctype=c_scroll;                        
    energy=30000;
    xgraph=&Graphics_table;         
    WHILE (get_dist(id_robot)>160)
        FRAME;
    END
    enemy_f=0;
    WHILE (energy>0)
        IF (if_i_touch=collision(TYPE firing_robot))
            impact(if_i_touch.x,if_i_touch.y);
            signal(if_i_touch,s_kill);
            energy=energy-175;
        ELSE
            
            IF (if_i_touch=collision(TYPE explosion_3))
               energy=energy-100;
            END
        END
        FRAME;

        angle=get_angle(id_robot); 
        
        IF (nomover==0 AND get_dist(id_robot)<200)
            helicopter2();
        END

        IF (firing_1==0)
            firing_final(x,y);
            firing_1=30;
        ELSE
            firing_1--;
        END
        
        IF (firing_2==0)
            missiles_final(x,y,3);
            missiles_final(x,y,2);
            firing_2=25;
        ELSE
            firing_2--;
        END

        
        FRAME(0);
    END
    
    explosion_3(x,y);
    FRAME(400);
    explosion_3(x+30,y-30);
    FRAME(500);
    explosion_3(x-30,y+30);
    graph=0;
    xgraph=0;  
    WHILE (nomover>0)
        FRAME;
    END
    
    write(source_j,160,100,4,"YOU WON");
    
    wait=0;
    REPEAT
        wait++;
        FRAME;
    UNTIL (wait==100 OR key(_space) OR key(_enter) OR key(_esc))

    
    delete_text(all_text);
    let_me_alone();
    signal(id_menu,s_wakeup);
    stop_sound(all_sound);
    is_dead=1;
    selection=0;
    FRAME;

END






PROCESS firing_final(x,y);

PRIVATE
    x1=0;
    y1=0;

BEGIN
    file=file1;
    graph=106;
    ctype=c_scroll;                            
    get_point(file1,father.graph,1,&x1,&y1);
    x=x+x1-110;
    y=y+y1-90;                          
     angle0=father.angle;
    x_res=x*1000;
    y_res=y*1000;

    WHILE (NOT out_region(id,0) AND NOT collision(TYPE robot) AND NOT collision(TYPE robot_legs))
        x_res=x_res+get_distx( angle0,3000);
        y_res=y_res+get_disty( angle0,3000);      

        x=x_res/1000;
        y=y_res/1000;
        FRAME;
    END

    IF (NOT out_region(id,0))           
        impact(x,y);
        energy_robot-=2000;
    END
END






PROCESS missiles_final(x,y,n);

PRIVATE
    id_smoke;    
    x1;         
    y1;         
    inc_ angle;        

BEGIN
    ctype=c_scroll;
    file=file1;
    graph=102;                                  
    get_point(file1,father.graph,n,&x1,&y1); 
    x=x+x1-110;
    y=y+y1-90;                                  
    angle=father.angle;                         
    inc_ angle=get_angle(id_robot)/5;
    sound(s_explosion,64,512);
    x_res=x*10000;
    y_res=y*10000;

    id_smoke=smoke(25,x,y);                 

    Velocity=40000;                      
    
    WHILE (NOT out_region(id,0) AND NOT collision(TYPE robot) AND NOT collision(TYPE robot_legs))
        x_res=x_res+get_distx(angle,Velocity);
        y_res=y_res+get_disty(angle,Velocity);   
        IF (n==2)                           
            angle+=pi_eigth/inc_ angle;
        ELSE
            angle-=pi_eigth/inc_ angle;
        END

        x=x_res/10000;
        y=y_res/10000;
        IF (Velocity<80000)
            Velocity+=5000;
        END
        FRAME;
    END
    
    IF (NOT out_region(id,0))
        impact(x,y);
        energy_robot-=1000;
    END
    signal(id_smoke,s_kill_tree);
END
