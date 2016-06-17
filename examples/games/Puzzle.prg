
//--------------------------------------------------------------------
// TITLE: PUZZLE 'O' MATIC
// AUTHOR:  DANIEL NAVARRO
// DATE:   DIV GAMES STUDIO (c) 2000
//--------------------------------------------------------------------

PROGRAM puzzle;

GLOBAL

    taken;
    rotation;
    completed_z;
    pieces_placed;

    level;
    level2;

    source;


    sources[]=
        "puzzle\puzzle1.fnt","puzzle\puzzle2.fnt","puzzle\puzzle3.fnt",
        "puzzle\puzzle4.fnt","puzzle\puzzle5.fnt";

    file_;


    file_s[]=
        "puzzle\puzzle.fpg","puzzle\puzzle2.fpg","puzzle\puzzle3.fpg",
        "puzzle\puzzle4.fpg","puzzle\puzzle5.fpg";

    time;
    time_previous;
    time_rest;


    times[]=
        250,200,150,100,50;

    r‚cord;
    message_r‚cord;


    r‚cords[]=
        250,250,250,250,250;


    text1,text2,text3,text4,text5;


    idsound1,idsound2,idsound3,idsound4,idsound5,idsound6,idsound7;

BEGIN

    set_mode(m640x480);
    set_fps(32,0);


    idsound1=load_pcm("puzzle\cogida.pcm",0);
    idsound2=load_pcm("puzzle\dejada.pcm",0);
    idsound3=load_pcm("puzzle\girando.pcm",0);
    idsound4=load_pcm("puzzle\colocada.pcm",0);
    idsound5=load_pcm("puzzle\alarma.pcm",0);
    idsound6=load_pcm("puzzle\acaba.pcm",0);
    idsound7=load_pcm("puzzle\consigue.pcm",0);


    load("puzzle\puzzle.dat",offset r‚cords);


    FROM x=0 TO 34;
        load_map("puzzle\puzzle.map");
    END


    LOOP

        fade_on();


        load_pal("puzzle\puzmenu.map");
        graph=load_map("puzzle\puzmenu.map");
        put_screen(0,graph);
        unload_map(graph);                      
        graph=0;                                

        
        REPEAT

            FRAME;

            
            IF (key(_esc))
                fade_off();
                save("puzzle\puzzle.dat",offset r‚cords,sizeof(r‚cords));
                exit("",0);
            END

        UNTIL (key(_f1));

        fade_off();             
        clear_screen();

                                
        level=0 ;
        time_rest=0;

                                
        LOOP

            
            file_=load_fpg(file_s[level]);
            source=load_fnt(sources[level]);
            load_pal(file_s[level]);
            put_screen(0,2);
            mouse.graph=200;    


            
            FROM y=0 TO 6;
                FROM x=0 TO 4;

                   
                   map_block_copy(0,1000+y*5+x,0,0,1,x*64,y*64,64,64);

                   
                   piece(1000+y*5+x,rand(32,608),rand(200,448),rand(0,3)*90000,192+x*64,48+y*64);
                END
            END
            fade_on();          

            
            taken=0;                               
            rotation=0;                              
            completed_z=-1;                            
            pieces_placed=0;                     
            level2=level+1;                         
            time=times[level]+time_rest;  
            r‚cord=r‚cords[level];                  

            
            write(source,72,0,1," TIME ");
            write_int(source,72,24,1,&time);
            write(source,72,80,1,"RECORD");
            write_int(source,72,104,1,&r‚cord);
            text1=write(source,320,240,4,"PRESS MOUSE");
            text2=write(source,320,264,4,"TO PLAY A LEVEL");
            text3=write_int(source,320,290,4,&level2);
            IF (level>0)
                text4=write(source,320,120,4,"TIME AMOUNT");
                text5=write_int(source,320,150,4,&time_rest);
            END

            
            REPEAT FRAME; UNTIL (mouse.left);

            
            delete_text(text1);
            delete_text(text2);
            delete_text(text3);
            IF (level>0)
                delete_text(text4);
                delete_text(text5);
            END

            
            message_r‚cord=FALSE;   
            timer=0;                

            
            REPEAT

                
                time_previous=time;
                time=times[level]+time_rest-timer/100;
                r‚cord=r‚cords[level]-timer/100;

                
                IF (time_previous==121 AND time==120) message("ONLY 2 MINUTES",220); END
                IF (time_previous==61 AND time==60) message("ONLY 1 MINUTE!",220); END
                IF (time_previous==11 AND time==10) message("ONLY 10 SECONDS!!!",220); END
                IF (time_previous==6 AND time==5) message("FIVE SECONDS!",220); END
                IF (time<0) time=0; END

                
                IF (r‚cord<0)
                    r‚cord=0;
                    
                    IF (NOT message_r‚cord)
                        message_r‚cord=TRUE;
                        message("YOU LOOSE!",260);
                    END
                END

                
                IF (key(_esc)) time=-1; BREAK; END
                FRAME;

            
            UNTIL (pieces_placed==35 OR time==0);

            
            IF (pieces_placed==35)   
                sound(idsound7,128,256);

                
                write(source,320,220,4,"CONGRATULATIONS!");

                
                IF (r‚cords[level]>times[level]+time_rest-time)
                    write(source,320,245,4,"NEW RECORD!!!");
                    r‚cords[level]=times[level]+time_rest-time;
                END

                
                write(source,320,290,4,"TIME AMOUNT");
                write_int(source,320,320,4,&time);
                time_rest=time;

            ELSE    

                sound(idsound6,128,256);   

                
                IF (time>=0)
                    write(source,320,220,4,"OHHH, OUT OF TIME!");
                ELSE
                    time=0;
                END
                write(source,320,260,4,"GAME OVER");
            END

            
            write(source,320,440,4,"PRESS MOUSE TO CONTINUE");
            WHILE (mouse.left) FRAME; END

            
            REPEAT FRAME; UNTIL (mouse.left);
            fade_off();             
            delete_text(all_text);  

            
            signal(TYPE piece,s_kill);
            unload_fnt(source);
            unload_fpg(file_);


            level++;            

            
            IF (level>4) level=4; final_screen(); FRAME; END

            
            IF (pieces_placed<35) BREAK; END
        END

        
        fade_off();
        let_me_alone();
    END
END








PROCESS piece(graph,x,y,angle,mi_x,mi_y);

PRIVATE
    number;       
    incr_x,incr_y;  

BEGIN
    LOOP
        
        IF (NOT taken AND mouse.left)

            
            IF (collision(TYPE mouse))
                sound(idsound1,128,256);
                taken=1;       
                z=completed_z;     
                completed_z--;

                
                incr_x=x-mouse.x;
                incr_y=y-mouse.y;

                
                REPEAT
                    
                    x=mouse.x+incr_x;
                    y=mouse.y+incr_y;

                    
                    IF (angle MOD 360000==0)

                        
                        IF (fget_dist(x,y,mi_x,mi_y)<6)
                            sound(idsound4,128,256);

                            
                            x=mi_x; y=mi_y; z=1;
                            pieces_placed++;
                            taken=0;

                            
                            LOOP FRAME; END
                        END
                    END
                    FRAME;
                UNTIL (mouse.left==0);

                taken=0;   
                
                sound(idsound2,128,256);
            END
        END

        
        IF (NOT rotation AND mouse.right)

            
            IF (collision(TYPE mouse))
                sound(idsound3,64,96);

                
                rotation=1;
                z=completed_z;
                completed_z--;

                
                FROM number=0 TO 8; angle+=10000; FRAME; END

                
                IF (angle==360000) angle=0; END
                rotation=0;
            END
        END
        FRAME;
    END
END








PROCESS message(text,y);

PRIVATE
    idtext;    

BEGIN
    sound(idsound5,64,256);    

    
    idtext=write(source,320,y,4,text);

    
    FRAME(600);

    
    delete_text(idtext);

    
    FRAME(600);

    sound(idsound5,64,256);    

    
    idtext=write(source,320,y,4,text);
    FRAME(600);
    delete_text(idtext);
    FRAME(600);
    sound(idsound5,64,256);
    idtext=write(source,320,y,4,text);
    FRAME(600);
    delete_text(idtext);
    FRAME(600);
    sound(idsound5,64,256);
    idtext=write(source,320,y,4,text);
    FRAME(600);
    delete_text(idtext);   
END






PROCESS final_screen()
BEGIN

    
    fade_off();
    let_me_alone();                         
    load_pal("puzzle\puzfinal.map");
    graph=load_map("puzzle\puzfinal.map");  
    put_screen(0,graph);
    unload_map(graph);                      
    fade_on();                              

    
    WHILE (scan_code==0)
        FRAME;
    END
    exit("Thanks for playing!",0);           

END