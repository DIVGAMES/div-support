
//-----------------------------------------------------------------------------
// TITLE: CHECK OUT
// AUTHOR:  DANIEL NAVARRO MEDRANO
// DATE:  DIV GAMES STUDIO (c) 2000
//-----------------------------------------------------------------------------

PROGRAM Checkout;

CONST
    player_piece=42;
    computer_piece=50;
    no_piece=36;
    prof_min=3;

GLOBAL

    files1,files2;
    letters1;
    letters2,letters3,letters4,letters5,letters6;
    final_game=0;
    who_wins=0;
    selected;
    the_piece;
    mover;
    present_level;
    colour;
    moves;
    whostarts;
    board[35];

    strategy1[35];
    strategy2[35];

    levels[]=

          2,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0,
          0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,0,0,0,1,

          0,2,2,0,0,0, 2,0,2,0,0,0, 2,2,0,0,0,0,
          0,0,0,0,1,1, 0,0,0,1,0,1, 0,0,0,1,1,0,

          2,2,2,0,0,0, 2,0,2,0,0,0, 2,2,0,0,0,0,
          0,0,0,0,1,1, 0,0,0,1,0,1, 0,0,0,1,1,1,

          2,2,2,0,0,0, 2,2,2,0,0,0, 2,2,0,0,0,0,
          0,0,0,0,1,1, 0,0,0,1,1,1, 0,0,0,1,1,1,

          2,2,2,2,0,0, 2,0,2,0,0,0, 2,2,0,0,0,1,
          2,0,0,0,1,1, 0,0,0,1,0,1, 0,0,1,1,1,1,

          2,2,2,2,0,0, 2,2,2,0,0,0, 2,2,0,0,0,1,
          2,0,0,0,1,1, 0,0,0,1,1,1, 0,0,1,1,1,1;

    strategy[]=

       3072,133,33,12,08,04,
         133,33,10,06,02,00,
          33,10,04,01,01,02,
          12,06,01,00,05,08,
          08,02,01,05,05,20,
          04,00,02,08,20,30,

       4096,256,40,20,08,04,
         256,40,20,06,02,08,
          40,20,04,10,04,10,
          20,06,10,06,08,20,
          08,02,04,08,30,40,
          04,08,10,20,40,75,

        4096,80,40,20,10,10,
          80,40,20,10,05,05,
          40,20,10,05,10,10,
          20,10,05,10,20,20,
          10,05,10,20,40,40,
          10,05,10,20,40,75,

        5096,60,20,10,08,08,
          60,20,10,08,05,05,
          20,10,08,05,10,10,
          10,08,05,10,20,20,
          08,05,10,20,40,40,
          08,05,10,20,40,75,

        6096,40,20,10,08,08,
          40,20,10,08,05,05,
          20,10,08,05,10,10,
          10,08,05,10,20,20,
          08,05,10,20,40,40,
          08,05,10,20,40,75;

    id_pieces=0;
    score;

    blinking;
    option;

LOCAL

    move_counter;
    movement_type;
    displacement_inc;
    better_move;
    board_column;
    piece_type;
    piece_row;
    piece_column;
    pause_counter;
    texts1;

    num_mov;
    tmovements[3*20]= 60 dup (0);
    side;
    level_number;
    row_counter;
    column_counter;
    depth;
    level;
    square_number;
    piece_number;

BEGIN

    max_process_time=3000;

    initialisation();

    REPEAT
        menu_options();
        WHILE (son) FRAME; END
        SWITCH (option)
            CASE 0:
                player_control();
                WHILE (son)
                    IF (key(_esc))
                        let_me_alone();
                        fade_off();
                        clear_screen();
                        delete_text(all_text);
                    ELSE
                        FRAME;
                    END
                END
            END
            CASE 2:
            /*
                instructions();
                WHILE (son) FRAME; END
                */
            END
        END
    UNTIL (option==1)
    credits();
END






PROCESS initialisation()

BEGIN

    set_mode(m640x480);
    set_fps(32,4);


    files1=load_fpg("checkout\checkout.fpg");
    files2=load_fpg("checkout\checkmnu.fpg");


    letters1=load_fnt("checkout\check.fnt");
    letters2=load_fnt("checkout\checkmn2.fnt");
    letters3=load_fnt("checkout\checkmnu.fnt");
    letters4=load_fnt("checkout\checkmn3.fnt");
    letters5=load_fnt("checkout\checkgam.fnt");
    letters6=load_fnt("checkout\checkgm2.fnt");
END






PROCESS menu_options()

BEGIN

    load_pal("checkout\checkmnu.fpg"):
    put_screen(1,1);

    fade_on();


    write(letters2,320,-16,1,"CHECKOUT");
    write(letters3,320,64,1,"The PC game");
    write(letters3,320,390,1,"Start                 Exit");


    xput(1,2,320,420,0,100,4,0);

    
    mouse.file=files2;
    mouse.graph=4;

    
    option=-1;
    WHILE (option<0)

        
        IF (key(_esc)) option=1; END

        
        IF (key(_space) OR key(_enter)) option=0; END

        
        IF (mouse.left AND mouse.y>370)
            
            IF (mouse.x<214)
                option=0;
            ELSE
                IF (mouse.x>426)
                    option=1;
                ELSE
                    option=2;
                END
            END
        END
        FRAME;
    END

    
    fade_off();
    clear_screen();
    delete_text(all_text);
    present_level=1;
END






PROCESS credits()

BEGIN

    
    put_screen(1,3);
    fade_on();

    
    write(letters4,320,0,1,"Coder:");
    write(letters3,320,20,1,"Daniel Navarro");
    write(letters4,320,80,1,"Original Idea:");
    write(letters3,320,100,1,"Luis F. Fern ndez");
    write(letters4,320,160,1,"Graphics:");
    write(letters3,320,180,1,"M. Jes£s Recio");
    write(letters3,320,220,1,"Pablo de la Sierra");
    write(letters3,320,260,1,"J. Ricardo Avella");

    
    mouse.file=files2;
    mouse.graph=4;

    
    scan_code=0;
    REPEAT
        FRAME;
    UNTIL (mouse.right OR mouse.left OR scan_code<>0)
    let_me_alone();

END






PROCESS instructions()

BEGIN
    
    put_screen(files2,5);
    fade_on();

    
    REPEAT
        FRAME;
    UNTIL (mouse.right OR key(_esc) OR mouse.left)

    
    fade_off();
    clear_screen();
    delete_text(all_text);
END






PROCESS player_control()

PRIVATE
    idmov;           
    possible_moves;    

BEGIN
    
    load_pal("checkout\checkout.fpg");
    put_screen(0,100);
    fade_on();

    
    mouse.file=files1;
    mouse.graph=4;
    final_game=0;

    REPEAT  

        
        put_screen(0,100);

        who_wins=0;

        REPEAT  

            
            pon_level(0);
            colour=0;
            id_pieces=pieces();

            
            write(letters1,320,28,4,"Use mouse to select side");
            write(letters1,290,48,4,"Level :");
            write_int(letters1,366,48,4,&present_level);
            num_mov=2*3; 
            tmovements[0]=0;
            tmovements[3]=35;
            the_piece=no_piece;

            REPEAT      
                signal(id_pieces,s_kill_tree);  
                id_pieces=pieces();             
                FRAME;
            UNTIL (mouse.left!=0 AND selected!=no_piece)

            
            IF (selected==0)
                colour=3; moves=2; 
            ELSE
                colour=0; moves=1; 
            END
            fade_off();

            
            pon_level(present_level);        
            signal(id_pieces,s_kill_tree);  
            id_pieces=pieces();             
            delete_text(all_text);          

            
            FROM square_number=0 TO 35;
                strategy1[square_number]=strategy[square_number]+rand(0,5)-2;
                strategy2[35-square_number]=strategy[square_number]+rand(0,5)-2; 
            END
            fade_on();

            REPEAT  
                SWITCH (moves)
                    CASE 1: 
                        the_piece=no_piece;
                        idmov=thinks(0,moves,1); 
                        num_mov=idmov.num_mov;
                        FROM move_counter=0 TO 59;
                            tmovements[move_counter]=idmov.tmovements[move_counter];
                        END
                        IF (the_piece!=no_piece) 
                            REPEAT  
                                delete_text(all_text);          

                                
                                write(letters1,320,28,4,"Please, select unit");
                                mouse.file=files1;
                                mouse.graph=4;

                                
                                the_piece=no_piece;
                                signal(id_pieces,s_kill_tree);      
                                id_pieces=pieces();                 

                                
                                REPEAT
                                    signal(id_pieces,s_kill_tree);  
                                    id_pieces=pieces();             
                                    FRAME;
                                
                                UNTIL (mouse.left!=0 AND selected!=no_piece)
                                the_piece=selected;

                                
                                delete_text(all_text);          

                                
                                write(letters1,320,28,4,"Please, select movement");
                                blinking=0;
                                REPEAT
                                    
                                    IF (blinking==1) blinking=0; ELSE blinking=1; END
                                    signal(id_pieces,s_kill_tree);  
                                    id_pieces=pieces();             
                                    FRAME;
                                
                                UNTIL ((mouse.left!=0 AND selected!=no_piece) || mouse.right==1)

                            UNTIL (mouse.right!=1)
                            mover=selected;

                            
                            piece_type=board[the_piece];
                            movement();
                            WHILE (board[mover]!=piece_type) FRAME; END  
                        END
                    END

                    CASE 2: 
                        delete_text(all_text);  

                        
                        write(letters1,320,28,4,"Please wait... I'm thinking");
                        mouse.graph=0;
                        the_piece=no_piece;
                        signal(id_pieces,s_kill_tree);  
                        id_pieces=pieces();             

                        FRAME;                          
                        thinks(prof_min,moves,1);       

                        
                        IF (the_piece!=no_piece)
                            piece_type=board[the_piece];
                            movement();
                            WHILE (board[mover]!=piece_type) FRAME; END  
                        END
                    END
                END

            
            
            UNTIL (board[0]==1 OR board[35]==2 OR the_piece==no_piece)

            
            IF (board[0]==1) who_wins=1;END
            IF (board[35]==2) who_wins=2; END
            IF (the_piece==no_piece)
                IF (moves==1) who_wins=2; END
                IF (moves==2) who_wins=1; END
            END
        UNTIL (who_wins<>0)
        

        
        delete_text(all_text);

        
        write(letters1,320,28,4,"Game Over");
        write(letters1,320,48,4,"Press mouse botton");
        mouse.file=files1;
        mouse.graph=4;
        the_piece=no_piece;
        num_mov=0;

        
        scan_code=0; pause_counter=0;
        REPEAT
            signal(id_pieces,s_kill_tree);  
            id_pieces=pieces();             
            ++pause_counter;
            FRAME;
        UNTIL (mouse.left OR mouse.right OR scan_code<>0 OR pause_counter>100)


        
        fade_off();
        clear_screen();
        delete_text(all_text);
        signal(id_pieces,s_kill_tree);
        fade_on();

        
        
        IF (who_wins==1)
            IF (present_level+1<6)   
                present_level++;
            ELSE
                final_game=2;       
            END
        END

        
        IF (who_wins==2)
            IF (present_level-1>0)   
                present_level--;
            ELSE
                final_game=1;       
            END
        END
    UNTIL (final_game>0)

    
    put_screen(0,100);

    
    IF (final_game==1)  
        texts1=write(letters5,320,500,4,"GAME OVER");
    ELSE                
        texts1=write(letters5,320,500,4,"YOU WIN!");
    END

    
    scan_code=0; pause_counter=500;
    REPEAT
        pause_counter-=2;
        if (pause_counter>239) move_text(texts1,320,pause_counter); END
        FRAME;
    UNTIL (mouse.left OR mouse.right OR scan_code<>0 OR pause_counter<201)
    fade_off();

    
    clear_screen();
    delete_text(all_text);

END









PROCESS thinks(depth,side,level)

BEGIN
    
    square_number=0; num_mov=0;

    
    IF (side==1)    
        
        FROM square_number=0 TO 35;
            
            IF (square_number MOD 6<4)
                
                
                IF (board[square_number+1]==2 AND board[square_number]==1 AND board[square_number+2]==0)
                    
                    tmovements[num_mov]=square_number;          
                    tmovements[num_mov+1]=square_number+2;      

                    
                    
                    
                    
                    tmovements[num_mov+2]=strategy1[square_number+2]-strategy1[square_number]+strategy2[square_number+1]+50;

                    
                    num_mov=num_mov+3;
                END

                
                
                IF (board[square_number+1]==2 AND board[square_number+2]==1 AND board[square_number]==0)

                    
                    tmovements[num_mov]=square_number+2;
                    tmovements[num_mov+1]=square_number;
                    tmovements[num_mov+2]=strategy1[square_number]-strategy1[square_number+2]+strategy2[square_number+1]+50;
                    num_mov=num_mov+3;
                END
            END

            
            IF (square_number<24)

                
                
                IF (board[square_number+6]==2 AND board[square_number]==1 AND board[square_number+12]==0)

                    
                    tmovements[num_mov]=square_number;
                    tmovements[num_mov+1]=square_number+12;
                    tmovements[num_mov+2]=strategy1[square_number+12]-strategy1[square_number]+strategy2[square_number+6]+50;
                    num_mov=num_mov+3;
                END

                
                
                IF (board[square_number+6]==2 AND board[square_number+12]==1 AND board[square_number]==0)

                    
                    tmovements[num_mov]=square_number+12;
                    tmovements[num_mov+1]=square_number;
                    tmovements[num_mov+2]=strategy1[square_number]-strategy1[square_number+12]+strategy2[square_number+6]+50;
                    num_mov=num_mov+3;
                END
            END
        END
    ELSE
        
        FROM square_number=0 TO 35;

            
            IF (square_number MOD 6<4)
                IF (board[square_number+1]==1 AND board[square_number]==2 AND board[square_number+2]==0)

                    
                    tmovements[num_mov]=square_number;
                    tmovements[num_mov+1]=square_number+2;
                    tmovements[num_mov+2]=strategy2[square_number+2]-strategy2[square_number]+strategy1[square_number+1]+42;
                    num_mov=num_mov+3;
                END
                IF (board[square_number+1]==1 AND board[square_number+2]==2 AND board[square_number]==0)

                    
                    tmovements[num_mov]=square_number+2;
                    tmovements[num_mov+1]=square_number;
                    tmovements[num_mov+2]=strategy2[square_number]-strategy2[square_number+2]+strategy1[square_number+1]+42;
                    num_mov=num_mov+3;
                END
            END
            
            IF (square_number<24)
                IF (board[square_number+6]==1 AND board[square_number]==2 AND board[square_number+12]==0)

                    
                    tmovements[num_mov]=square_number;
                    tmovements[num_mov+1]=square_number+12;
                    tmovements[num_mov+2]=strategy2[square_number+12]-strategy2[square_number]+strategy1[square_number+6]+42;
                    num_mov=num_mov+3;
                END
                IF (board[square_number+6]==1 AND board[square_number+12]==2 AND board[square_number]==0)

                    
                    tmovements[num_mov]=square_number+12;
                    tmovements[num_mov+1]=square_number;
                    tmovements[num_mov+2]=strategy2[square_number]-strategy2[square_number+12]+strategy1[square_number+6]+42;
                    num_mov=num_mov+3;
                END
            END
        END
    END
    
    IF (num_mov>0)

        
        better_move=-1; move_counter=2;

        
        REPEAT
            IF (tmovements[move_counter]>1000) better_move=move_counter-2; END
        UNTIL ((move_counter+=3)>num_mov)

        
        IF (better_move>=0)

            
            score=tmovements[better_move+2];

            
            IF (level==1)

                
                the_piece=tmovements[better_move];
                mover=tmovements[better_move+1];
                moves=moves XOR 3;
            END
        ELSE    

            
            IF (num_mov>3 OR level>1)
                move_counter=0;
                REPEAT  

                    
                    board[tmovements[move_counter]]=0;
                    board[tmovements[move_counter+1]]=side;
                    board[(tmovements[move_counter]+tmovements[move_counter+1])/2]=0;

                    
                    thinks(depth,side XOR 3,level+1);

                    
                    tmovements[move_counter+2]=tmovements[move_counter+2]-score;

                    
                    board[tmovements[move_counter]]=side;
                    board[tmovements[move_counter+1]]=0;
                    board[(tmovements[move_counter]+tmovements[move_counter+1])/2]=side XOR 3;
                UNTIL ((move_counter+=3)==num_mov)
            END

            
            better_move=0;
            score=tmovements[2];
            move_counter=2;

            
            WHILE ((move_counter+=3)<num_mov)
                IF (tmovements[move_counter]>score)
                    better_move=move_counter-2;
                    score=tmovements[move_counter];
                END
            END

            
            
            IF (level==1)
                the_piece=tmovements[better_move];
                mover=tmovements[better_move+1];
                moves=moves XOR 3;
            END
        END
    ELSE 

        
        piece_number=0;
        num_mov=0;

        
        IF (side==1)

            
            FROM square_number=0 TO 35;
                board_column=square_number MOD 6;   

                
                IF (board[square_number]==1)

                    
                    piece_number=piece_number+1;

                    
                    
                    IF (board_column>0 AND board[square_number-1]==0)

                        
                        tmovements[num_mov]=square_number;      
                        tmovements[num_mov+1]=square_number-1;  

                        
                        
                        tmovements[num_mov+2]=strategy1[square_number-1]-strategy1[square_number];

                        
                        num_mov=num_mov+3;
                    END
                    
                    IF (square_number>=6)

                        
                        IF(board[square_number-6]==0)

                            
                            tmovements[num_mov]=square_number;
                            tmovements[num_mov+1]=square_number-6;
                            tmovements[num_mov+2]=strategy1[square_number-6]-strategy1[square_number];
                            num_mov=num_mov+3;
                        END
                    END
                ELSE

                    
                    IF(board[square_number]==2)
                        piece_number=piece_number+1;
                    END
                END
            END
        ELSE    

            
            FROM square_number=0 TO 35;
                board_column=square_number MOD 6;
                IF (board[square_number]==2)
                    piece_number=piece_number+1;
                    IF (square_number<35)
                        IF (board_column<5 AND board[square_number+1]==0)
                            tmovements[num_mov]=square_number;
                            tmovements[num_mov+1]=square_number+1;
                            tmovements[num_mov+2]=strategy2[square_number+1]-strategy2[square_number];
                            num_mov=num_mov+3;
                        END
                    END
                    IF (square_number<30)
                        IF(board[square_number+6]==0)
                            tmovements[num_mov]=square_number;
                            tmovements[num_mov+1]=square_number+6;
                            tmovements[num_mov+2]=strategy2[square_number+6]-strategy2[square_number];
                            num_mov=num_mov+3;
                        END
                    END
                ELSE
                    IF(board[square_number]==1)
                        piece_number=piece_number+1;
                    END
                END
            END
        END

        
        IF (num_mov==0)

            
            IF (level==1)
                the_piece=36;       
            ELSE                    
                score=-2048;   
            END
        ELSE                        

            
            better_move=-1;
            move_counter=2;

            
            REPEAT
                IF (tmovements[move_counter]>1000)
                    better_move=move_counter-2;
                END
            UNTIL ((move_counter+=3)>num_mov)

            
            IF (better_move>=0)
                
                score=tmovements[better_move+2];
                
                IF (level==1)
                    
                    
                    the_piece=tmovements[better_move];
                    mover=tmovements[better_move+1];
                    moves=moves XOR 3;
                END
            ELSE    

                
                IF (level==1)
                    
                    IF (piece_number<6)
                        depth=depth+2;          
                                                            
                    ELSE
                        
                        
                        IF (piece_number<8)
                            depth=depth+1;
                        END
                    END
                END

                
                IF (depth>0)
                    move_counter=0;
                    
                    REPEAT
                        
                        board[tmovements[move_counter]]=0;
                        board[tmovements[move_counter+1]]=side;
                        
                        thinks(depth-1,side XOR 3,level+1);
                        
                        tmovements[move_counter+2]=tmovements[move_counter+2]-score;
                        
                        board[tmovements[move_counter]]=side;
                        board[tmovements[move_counter+1]]=0;
                    UNTIL ((move_counter=move_counter+3)==num_mov)
                END

                
                better_move=0;
                score=tmovements[2];
                move_counter=2;

                
                WHILE ((move_counter+=3)<num_mov)
                    
                    IF (tmovements[move_counter]>score)
                        better_move=move_counter-2;
                        score=tmovements[move_counter];
                    END
                END

                
                IF (level==1)
                    
                    the_piece=tmovements[better_move];
                    mover=tmovements[better_move+1];
                    moves=moves XOR 3;
                END
            END
        END
    END
END






PROCESS pieces()

PRIVATE
    x_selected,y_selected;     
    mouse_selection;

BEGIN

    
    
    y_selected=-(mouse.x*265/10-46*(mouse.y+17)-2438)/2438;
    x_selected=(mouse.x*265/10+46*(mouse.y-300))/2438;

    
    mouse_selection=y_selected*6+x_selected;

    
    selected=36;
    move_counter=0;

    
    IF (the_piece==36)
        
        WHILE (move_counter<father.num_mov)
            
            IF (father.tmovements[move_counter]==mouse_selection)
                
                selected=mouse_selection;
            END
            move_counter+=3;
        END
    ELSE    
            
        WHILE (move_counter<father.num_mov)

            
            IF (father.tmovements[move_counter]==the_piece AND
                father.tmovements[move_counter+1]==mouse_selection)
                
                selected=mouse_selection;
            END
            move_counter+=3;
        END
    END

    FROM row_counter=0 TO 5;         
        FROM column_counter=0 to 5;   
            
            IF (row_counter*6+column_counter==selected)
                
                IF (board[row_counter*6+column_counter]!=0)
                    
                    piece(320+(column_counter-row_counter)*46,124+(column_counter+row_counter)*265/10,board[row_counter*6+column_counter] XOR colour,4);
                ELSE    
                        
                    IF (the_piece<36)
                        
                        piece(320+(column_counter-row_counter)*46,124+(column_counter+row_counter)*265/10,moves XOR colour XOR 3,4);
                    END
                END
            ELSE        

                
                IF (row_counter*6+column_counter==the_piece AND blinking)
                    
                    piece(320+(column_counter-row_counter)*46,124+(column_counter+row_counter)*265/10,board[row_counter*6+column_counter] XOR colour,4);
                ELSE
                    
                    IF (board[row_counter*6+column_counter]!=0)
                        
                        piece(320+(column_counter-row_counter)*46,124+(column_counter+row_counter)*265/10,board[row_counter*6+column_counter] XOR colour,0);
                    END
                END
            END
        END
    END
    LOOP FRAME; END
END






PROCESS piece(x,y,graph,flags)

BEGIN
  LOOP FRAME; END
END






PROCESS pon_level(n_level)

BEGIN
    FROM square_number=0 TO 35;
        board[square_number]=levels[square_number+(n_level*36)];
    END
END






PROCESS movement()

PRIVATE
    x1,y1;          
    x2,y2;          

BEGIN
    mouse.graph=0;  

    
    signal(id_pieces,s_kill_tree);

    
    movement_type=mover-the_piece;   
    piece_type=board[the_piece];     

    
    IF (movement_type==2 OR movement_type==-2 OR movement_type==12 OR movement_type==-12)
        
        board[(the_piece+mover)/2]=0;
    END
    board[mover]=3;
    board[the_piece]=0;

    
    piece_row=the_piece/6;      
    piece_column=the_piece MOD 6;  

    
    x1=320+(piece_column-piece_row)*46;
    y1=124+(piece_column+piece_row)*265/10;

    
    piece_row=mover/6;
    piece_column=mover MOD 6;

    
    x2=320+(piece_column-piece_row)*46;
    y2=124+(piece_column+piece_row)*265/10;

    
    IF (movement_type==2 OR movement_type==-2 OR movement_type==1 OR movement_type==-1)

        
        FROM displacement_inc=0 TO 11;

            
            FROM row_counter=0 TO 5;

                
                FROM column_counter=0 TO 5;

                    
                    IF (board[row_counter*6+column_counter]!=0)

                        
                        IF (board[row_counter*6+column_counter]!=3)
                            
                            piece(320+(column_counter-row_counter)*46,124+(column_counter+row_counter)*265/10,board[row_counter*6+column_counter] XOR colour,0);
                        ELSE    
                            
                            piece((x1*(11-displacement_inc)+x2*displacement_inc)/11,(y1*(11-displacement_inc)+y2*displacement_inc)/11,piece_type XOR colour,0);
                        END
                    END
                END
            END
            FRAME;

            
            signal(id,s_kill_tree);
            signal(id,s_wakeup);
        END
    ELSE    
            
        FROM displacement_inc=0 TO 11;
            FROM column_counter=0 TO 5;
                FROM row_counter=0 TO 5;
                    IF (board[row_counter*6+column_counter]!=0)
                        IF (board[row_counter*6+column_counter]!=3)
                            piece(320+(column_counter-row_counter)*46,124+(column_counter+row_counter)*265/10,board[row_counter*6+column_counter] XOR colour,0);
                        ELSE
                            piece((x1*(11-displacement_inc)+x2*displacement_inc)/11,(y1*(11-displacement_inc)+y2*displacement_inc)/11,piece_type XOR colour,0);
                        END
                    END
                END
            END
            FRAME;
            signal(id,s_kill_tree);
            signal(id,s_wakeup);
        END
    END

    
    board[mover]=piece_type;

    
    id_pieces=id;

    
    FROM row_counter=0 TO 5;
        FROM column_counter=0 TO 5;
            IF (board[row_counter*6+column_counter]!=0)
                piece(320+(column_counter-row_counter)*46,124+(column_counter+row_counter)*265/10,board[row_counter*6+column_counter] XOR colour,0);
            END
        END
    END
    LOOP FRAME; END
END
