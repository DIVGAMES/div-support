compiler_options _extended_conditions;


//------------------------------------------------------------------------------
//TITLE:      TOTAL POOL
//AUTHOR:       DANIEL NAVARRO
//DATE:       DIV GAMES STUDIO (c) 2000
//------------------------------------------------------------------------------

PROGRAM spanish_billards;

CONST
    ball_rad=14;                      
    x_reg_pulls=62-ball_rad;           
    y_reg_pulls=104-ball_rad;
    wide_reg_pulls=580-62+ball_rad*2; 
    stop_reg_pulls=375-104+ball_rad*2;

    pos_touches_x=604;                    
    pos_touches_y=452;

GLOBAL
    score1;    
    score2;    

    target;         
    yello;
    red;

    complete;         
    who;          
    turn;          

    sound0;        
    sound1;

    vtotal0;        
    vtotal1;        
    choices[]="Select","Effect","Shoot";
    txt_score[]="7 Points","21 Points","40 Points";
    score=0;   
    scorees[]=7,21,40;
    txt_choice;       
    choice;           
    id_effects;     
    effect_vert;    
    effect_horiz;   
    opposite_hit=0; 
    red_hit=0;  
LOCAL
    speed=0;    
    aspeed=0;   
    ang=0;          

    x_resol;        
    y_resol;

    incr_x;         
    incr_y;         

PRIVATE
     angle2=0;      
    inc_ angle2=0;

    option=0;       
    options[2];    
    end_play=0;    
    complete_x;       
    complete_y;
BEGIN
    set_mode(m640x480);
    set_fps(30,0);

    load_fpg("pool\billar.fpg");   
    load_fpg("pool\b_menu.fpg");

    load_fnt("pool\billar.fnt");   
    load_fnt("pool\numeros.fnt");
    load_fnt("pool\titulo.fnt");
    load_fnt("pool\menu.fnt");

    sound0=load_pcm("pool\billar0.pcm",0); 
    sound1=load_pcm("pool\banda.pcm",0);

    
    define_region(1,x_reg_pulls,y_reg_pulls,wide_reg_pulls,stop_reg_pulls);

    LOOP
        
        load_pal("pool\b_menu.fpg");
        put_screen(1,1);    

        
        write(3,320,4,1,"TOTAL POOL");
        options[0]=write(4,400,320,0,"Start");
        options[1]=write(4,400,354,0,txt_score[score]);
        options[2]=write(4,400,388,0,"Exit");
        write(4,320,480,7,"Daniel Navarro  DIV Games Studio");

        
        file=1;
        graph=2;

        
        y=342; incr_y=0;  angle2=0;
        option=0;

        fade_on();  

        REPEAT  
            complete_y=mouse.y;   
            x=17+get_distx(ang,16);
            IF ((ang+=pi/8)>pi)
                ang-=2*pi;
            END

            
            IF (option<>0 AND ang<pi/15 AND ang>-pi/15)
                incr_x=400;
                
                REPEAT
                    move_text(options[option-1],incr_x+=16,incr_y);
                    FRAME;
                UNTIL (incr_x>640)  
                
                IF (option==2)
                    delete_text(options[1]);
                    score=++score%3;
                    options[1]=write(4,incr_x=640,incr_y,0,txt_score[score]);
                    REPEAT
                        move_text(options[1],incr_x-=16,incr_y);
                        FRAME;
                    UNTIL (incr_x==400)
                    option=0;
                    incr_y=0;
                ELSE
                    option-=4;
                END
            END
            IF (incr_y==0)          
                IF (key(_enter) OR mouse.left OR
                    key(_control) OR key(_space))    
                    incr_y=y-22;
                    option=(y-342)/34+1;
                ELSE
                    IF ((key(_down) OR mouse.y>complete_y) AND y<410)   
                        incr_y=y+17;
                         angle2=pi/2;
                        inc_ angle2=-pi/8;
                    END
                    IF ((key(_up) OR mouse.y<complete_y)  AND y>342)     
                        incr_y=y-17;
                         angle2=-pi/2;
                        inc_ angle2=pi/8;
                    END
                END
            END

            IF (inc_ angle2<>0)       
                 angle2+=inc_ angle2;
                y=incr_y+get_disty( angle2,17);
                IF (inc_ angle2<0)
                    IF ( angle2<-pi/2)
                        y=incr_y+17;
                        incr_y=0;
                        inc_ angle2=0;
                    END
                ELSE
                    IF ( angle2>pi/2)
                        y=incr_y-17;
                        incr_y=0;
                        inc_ angle2=0;
                    END
                END
            END
            
            IF (key(_esc))
                option=-1;
            END
            FRAME;
        UNTIL (option<0)
        
        fade_off();
        clear_screen();
        delete_text(all_text);
        graph=0;
        FRAME;

        IF (option==-1)     
            exit("Thanks for Playing!!!",0);
            FRAME;
        END

        load_pal("pool\billar.fpg"); 

        
        write(1,12,6,0,"Player 1");
        write(1,628,6,2,"Player 2");
        write_int(2,115,0,0,&score1);
        write_int(2,525,0,2,&score2);

        
        put(0,1,320,240);
        put(0,8,pos_touches_x,pos_touches_y);

        
        id_effects=effect();

        
        write(1,12,428,0,"Player");
        write_int(1,98,428,0,&turn);
        fade_on();

        
        target=ball(3,320,240);
        yello=ball(4,128,240-48);
        red=ball(5,128,240+48);


        
        end_play=0;
        opposite_hit=0;
        red_hit=0;
        score1=0;
        score2=0;
        complete=0;
        who=0;
        turn=2;

        REPEAT  
            
            IF (target.speed==0 AND yello.speed==0 AND red.speed==0 AND NOT get_id(TYPE cue))
                
                
                IF (NOT (opposite_hit AND red_hit))
                    
                    IF (turn==1)
                        turn=2;
                    ELSE
                        turn=1;
                    END
                ELSE
                    
                    IF (turn)  
                        
                        IF (++score1==scorees[score])
                            x=800;
                            who=write(1,x,240,4,"Player one win");
                            FROM x=800 TO 319 STEP -8;
                                move_text(who,x,240);
                                FRAME;
                            END
                            FROM x=0 TO 29;
                                FRAME;
                            END
                            end_play=1;
                        END
                    ELSE
                        
                        IF (++score2==scorees[score])
                            x=800;
                            who=write(1,x,240,4,"Player two win");
                            FROM x=800 TO 320 STEP -8;
                                move_text(who,x,240);
                                FRAME;
                            END
                            FROM x=0 TO 29;
                                FRAME;
                            END
                            end_play=1;
                        END
                    END
                END

                
                IF (NOT end_play)
                    
                    IF (turn)
                        cue(target);
                    ELSE
                        cue(yello);
                    END
                    opposite_hit=0;
                    red_hit=0;
                END
            END

            
            IF (key(_esc))
                end_play++;
            END
            FRAME;
        UNTIL (end_play)

        fade_off();
        signal(id,s_kill_tree);
        signal(id,s_wakeup);
        clear_screen();
        delete_text(all_text);
        FRAME;
    END
END






PROCESS ball(graph,x,y);

PRIVATE
    id_collisions;  
    dir_final;      

    final_speed_x;  
    final_speed_y;

    longitude;       

    complete_pos_x;   
    complete_pos_y;

BEGIN

    shade(6);      

    x_resol=x*100;  
    y_resol=y*100;

    LOOP

        aspeed+=speed;

        
        WHILE (aspeed>100)

            aspeed-=100;        

            complete_pos_x=x_resol;   
            complete_pos_y=y_resol;

            
            incr_x=get_distx(ang,100);
            x_resol+=incr_x;
            incr_y=get_disty(ang,100);
            y_resol+=incr_y;

            
            IF ((y_resol<=10400 AND incr_y<0) OR (y_resol>=37400 AND incr_y>0))
                speed=speed*7/10;               
                sound(sound1,80*speed/4000,100);   
                
                ang=fget_angle(x,y,x+incr_x,y-incr_y)+effect_horiz*(pi/96);
                
                effect_vert=80;
                effect_horiz=0;
            END

            
            IF ((x_resol<=6200 AND incr_x<0) OR (x_resol>=57900 AND incr_x>0))
                speed=speed*7/10;
                sound(sound1,30+50*speed/5000,100);
                ang=fget_angle(x,y,x-incr_x,y+incr_y)+effect_horiz*(pi/96);
                effect_vert=80;
                effect_horiz=0;
            END

            
            x=x_resol/100;
            y=y_resol/100;

            
            IF (id_collisions=collision(TYPE ball))
                
                IF (complete<>id_collisions+id OR who<>id)
                    
                    who=id;
                    complete=id_collisions+id;

                    
                    IF (complete==target+yello)
                        opposite_hit=TRUE;
                    END

                    
                    IF (turn)
                        
                        IF (id_collisions+id==target+red)
                            red_hit=TRUE;
                        END
                    ELSE
                        IF (id_collisions+id==yello+red)
                            red_hit=TRUE;
                        END
                    END

                    sound(sound0,512,256); 

                    aspeed+=100;
                    
                    
                    incr_x=get_distx(ang,speed);
                    incr_y=get_disty(ang,speed);

                    
                    id_collisions.incr_x=get_distx(id_collisions.ang,id_collisions.speed);
                    id_collisions.incr_y=get_disty(id_collisions.ang,id_collisions.speed);

                    
                    vtotal0=speed+id_collisions.speed;

                    
                    dir_final=get_angle(id_collisions)+effect_horiz*(pi/96);

                    
                    final_speed_x=incr_x+id_collisions.incr_x;
                    final_speed_y=incr_y+id_collisions.incr_y;

                    
                    
                    longitude=fget_dist(x,y,x+final_speed_x,y+final_speed_y)*effect_vert/100;

                    
                    effect_vert=80;
                    effect_horiz=0;

                    
                    
                    incr_x-=get_distx(dir_final,longitude);
                    incr_y-=get_disty(dir_final,longitude);

                    
                    ang=fget_angle(x,y,x+incr_x,y+incr_y);
                    speed=fget_dist(x,y,x+incr_x,y+incr_y);

                    
                    
                    id_collisions.incr_x+=get_distx(dir_final,longitude);
                    id_collisions.incr_y+=get_disty(dir_final,longitude);

                    
                    id_collisions.ang=fget_angle(x,y,x+id_collisions.incr_x,y+id_collisions.incr_y);
                    id_collisions.speed=fget_dist(x,y,x+id_collisions.incr_x,y+id_collisions.incr_y);

                    
                    
                    vtotal1=speed+id_collisions.speed;
                    speed=vtotal0*speed/vtotal1;
                    id_collisions.speed=vtotal0*id_collisions.speed/vtotal1;

                    aspeed=speed;
                    id_collisions.aspeed=id_collisions.speed;

                END

                x_resol=complete_pos_x;     
                y_resol=complete_pos_y;

            ELSE
                
                
                IF (who==id)
                    complete=0;
                END

            END

            FRAME(0);       

        END

        x=x_resol/100;
        y=y_resol/100;

        FRAME;
        
        IF (speed>10)
            speed-=10;
            IF (effect_vert>80)
                effect_vert-=2;
                speed+=(effect_vert-80)/10;
            END
            IF (effect_vert<80)
                effect_vert++;
                speed-=(80-effect_vert)/2;
            END
        ELSE
            
            speed=0;
        END

    END
END






PROCESS shade(graph);

BEGIN
    region=1;               
    z=1;                    
    flags=4;                
    priority=-1;            
    LOOP
        angle=father.angle; 
        x=father.x+8;       
        y=father.y+8;       
        FRAME;
    END
END





PROCESS cue(idball);

PRIVATE
    complete_pos_mousepos;   
    real_x_mousepos;       
    real_y_mousepos;
    force;             
    distance;          
     angle_res;         

BEGIN
    shade(7);      

    
    txt_choice=write(1,114,428,0,choices[choice=0]);

    mouse.x=320;    
    mouse.y=240;
    graph=2;        
    complete_pos_mousepos=mouse.x;
    
    x=idball.x;
    y=idball.y;
    angle=-pi/2;    
    
    id_effects.x=pos_touches_x;
    id_effects.y=pos_touches_y;

    LOOP
        
        IF (choice==0)
            
            angle-=(complete_pos_mousepos-mouse.x)*(pi/256);
            complete_pos_mousepos=mouse.x;
            
            IF (mouse.x<128)
                mouse.x+=320;
                complete_pos_mousepos=mouse.x;
            END
            IF (mouse.x>512)
                mouse.x-=320;
                complete_pos_mousepos=mouse.x;
            END
            
            IF (mouse.left)
                
                delete_text(txt_choice);
                txt_choice=write(1,114,428,0,choices[1]);
                
                mouse.x=320;
                mouse.y=240;
                
                REPEAT
                    FRAME;
                UNTIL (NOT mouse.left)
                
                choice=1;
                
                real_x_mousepos=mouse.x;
                real_y_mousepos=mouse.y;
            ELSE
                
                view(idball,angle+pi);
            END
        END
        
        IF (choice==1)

            
            id_effects.x=pos_touches_x+(mouse.x-real_x_mousepos)/3;
            id_effects.y=pos_touches_y+(mouse.y-real_y_mousepos)/3;

            
            distance=fget_dist(pos_touches_x,pos_touches_y,id_effects.x,id_effects.y);

            
            IF (distance>22)
                 angle_res=fget_angle(pos_touches_x,pos_touches_y,id_effects.x,id_effects.y);
                id_effects.x=pos_touches_x+get_distx( angle_res,22);
                id_effects.y=pos_touches_y+get_disty( angle_res,22);
            END

            
            IF (mouse.left)

                
                delete_text(txt_choice);

                
                txt_choice=write(1,114,428,0,choices[2]);

                
                mouse.x=320;
                mouse.y=240;

                
                REPEAT
                    FRAME;
                UNTIL (NOT mouse.left)
                
                complete_pos_mousepos=mouse.y;
                real_x_mousepos=x;
                real_y_mousepos=y;
                
                choice=2;
                
                effect_vert=id_effects.y-pos_touches_y;
                IF (effect_vert<0)
                    effect_vert=80-28*-effect_vert/22;
                ELSE
                    effect_vert=80+effect_vert*120/22;
                END
                effect_horiz=id_effects.x-pos_touches_x;
            END
        END
        
        IF (choice==2)
            
            x=real_x_mousepos+get_distx(angle,mouse.y-240);
            y=real_y_mousepos+get_disty(angle,mouse.y-240);
            
            IF (mouse.y<232)
                
                delete_text(txt_choice);
                
                sound(sound1,100,128);
                
                force=(complete_pos_mousepos-mouse.y)*100;
                
                IF (force<200)
                    force=200;
                END
                IF (force>8000)
                    force=8000;
                END
                
                idball.speed=force;
                
                idball.ang=angle+pi;
                
                complete=0;
                signal(id,s_kill);
                signal(son,s_kill);
            END
            
            IF (mouse.left)
                
                delete_text(txt_choice);
                txt_choice=write(1,112,428,0,choices[0]);
                
                x=idball.x;
                y=idball.y;
                
                mouse.x=320;
                mouse.y=240;
                
                REPEAT
                    FRAME;
                UNTIL (NOT mouse.left)
                
                complete_pos_mousepos=mouse.x;
                choice=0;
            ELSE
                
                complete_pos_mousepos=mouse.y;
            END
        END
        FRAME;
    END
END






PROCESS view(idball,ang);

PRIVATE
    impact=0;        
    id_ball2;         

BEGIN
    z=2;
    
    graph=idball.graph;
    
    x_resol=idball.x_resol;
    y_resol=idball.y_resol;
    REPEAT

        
        incr_x=get_distx(ang,100);
        x_resol+=incr_x;
        incr_y=get_disty(ang,100);
        y_resol+=incr_y;

        
        x=x_resol/100;
        y=y_resol/100;

        
        IF ((y_resol<=10400 AND incr_y<0) OR (y_resol>=37400 AND incr_y>0) OR (x_resol<=6200 AND incr_x<0) OR (x_resol>=57900 AND incr_x>0))
            impact=1;
        END

        
        WHILE (id_ball2=collision(TYPE ball))
            IF (id_ball2<>idball)
                impact=1;
            END
        END
        FRAME(0);   
    UNTIL (impact) 
    graph=9;        
    FRAME;          
END






PROCESS effect();

BEGIN
    
    x=pos_touches_x;
    y=pos_touches_y;
    graph=6;        
    size=29;        
    LOOP
        FRAME;
    END
END

