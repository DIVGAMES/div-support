
//------------------------------------------------------------------------------
//TITLE:      NOID SCREEN EDITOR
//AUTHOR:      DANIEL NAVARRO
//DATE:        DIV GAMES STUDIO (c) 2000
//------------------------------------------------------------------------------

PROGRAM map_noid;

GLOBAL
    
    brick_g[]=10,11,12,13,14,15,20,30;

    brick_x;     
    brick_y;
    s_brick;     

    map[16*14];    
    mapid[16*14];  
    screen_bottom;  
    sound0;        

BEGIN

    load_pal("noid\noid.fpg");  
    load_fpg("noid\noid.fpg");  
    sound0=load_pcm("noid\billar0.pcm",0);  
    fade(100,100,100,8);        
    put(0,100,0,0);             

    
    write(0,272,0,0,"O,P,Q,A");
    write(0,272,10,0,"Move");
    write(0,272,20,0,"cursor");
    write(0,272,30,0,"W,S");
    write(0,272,40,0,"Change");
    write(0,272,50,0,"wall");
    write(0,272,60,0,"L,¥");
    write(0,272,70,0,"Change");
    write(0,272,80,0,"background");
    write(0,272,90,0,"Space");
    write(0,272,100,0,"Put");
    write(0,272,110,0,"wall");
    write(0,272,120,0,"F1");
    write(0,272,130,0,"Load");
    write(0,272,140,0,"map");
    write(0,272,150,0,"F2");
    write(0,272,160,0,"Save");
    write(0,272,170,0,"map");

    
    brick_x=0;
    brick_y=0;

    WHILE (NOT key (_esc))

        
        IF (key(_q) AND brick_y>0) brick_y--; END
        IF (key(_a) AND brick_y<13) brick_y++; END
        IF (key(_o) AND brick_x>0) brick_x--; END
        IF (key(_p) AND brick_x<15) brick_x++; END

        
        IF (key(_w) AND s_brick>0) s_brick--; END
        IF (key(_s) AND s_brick<7) s_brick++; END

        
        IF (key(_l) AND screen_bottom>0)
            screen_bottom--;
            clear_screen();                 
            put(0,100+screen_bottom,0,0);   
        END
        IF (key(_semicolon) AND screen_bottom<3)
            screen_bottom++;
            clear_screen();
            put(0,100+screen_bottom,0,0);
        END

        
        IF (key(_space))
            sound(sound0,256,256);          

            
            IF (map[brick_y*16+brick_x]==brick_g[s_brick])
                map[brick_y*16+brick_x]=0;
                signal(mapid[brick_y*16+brick_x],s_kill);
                mapid[brick_y*16+brick_x]=0;
            ELSE

                
                IF (mapid[brick_y*16+brick_x])
                signal(mapid[brick_y*16+brick_x],s_kill);
                END
                mapid[brick_y*16+brick_x]=brick(16+brick_x*16,12+brick_y*8,brick_g[s_brick]);
                map[brick_y*16+brick_x]=brick_g[s_brick];
            END
            WHILE (key(_space)) END
        END

        
        IF (key(_f1))
            save("dat\noid\screen.blk",&map,16*14);
        END

        
        IF (key(_f2))
            FROM x=0 TO 223;            
                IF (mapid[x])
                    signal(mapid[x],s_kill);
                    mapid[x]=0;
                END
            END
            load("dat\noid\screen.blk",&map);
            FROM y=0 TO 13;             
                FROM x=0 TO 15;
                    IF (map[y*16+x]<>0)
                        mapid[y*16+x]=brick(16+x*16,12+y*8,map[y*16+x]);
                    END
                END
            END
        END

        
        x=16+brick_x*16;
        y=12+brick_y*8;
        graph=brick_g[s_brick];
        flags=flags XOR 1;
        FRAME;
    END
END







PROCESS brick(x,y,graph)

BEGIN
    LOOP        
        FRAME;
    END
END

