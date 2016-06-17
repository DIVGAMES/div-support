//-------------------------------------------------------------------------
// Program:   Tutorial 6
// Author:    Antonio Marchal
// Date:      3/10/97
//-------------------------------------------------------------------------

PROGRAM Tutorial_6;

GLOBAL
    board[99]= 100 dup (1);    // Stores 100 boardboxes of game board

LOCAL
    counter;                   // General purpouse counters
    counter2;

BEGIN
    load_fpg("Tutor6.fpg");     // Loads graphics' file
    load_fnt("Tutor6.fnt");     // Loads font type file
    set_mode(m640x480);         // Selects video mode
    put_screen(0,1);            // Puts background screen
    mouse.graph=999;            // Selects mouse cursor graphic
    mouse.file=0;
    board[44]=0;                // Puts center board box changed
    paint_board();              // Process that creates the game board

    // Repeats until 'ESC' is pressed, or the game is over
    WHILE (NOT key (_esc) AND NOT completed_board())
        IF(key(_space))         // If the space key is pressed
            // Empties board, and puts it as it was initially
            FROM counter=0 TO 99; board[counter]=1; END
            board[44]=0;
        END
        FRAME;
    END
    // If the loop was exit because the board was completed
    IF (completed_board())
        // Eliminates any remaining process
        let_me_alone();
        // Prints a congratulations messages
        write(1,320,240,4,"CONGRATULATIONS !!!");
        // And waits for space key to be pressed
        WHILE (NOT key (_space))
            FRAME;
        END
    END
    // Exits game
    exit("Thanks for playing !!!",0);
END

//-------------------------------------------------------------------------
// Process paint_board
// Creates process of all board boxes
//-------------------------------------------------------------------------

PROCESS paint_board()

BEGIN
    // With a loop, all board boxes process are created
    FROM counter=0 to 99;
        boardbox(140+((counter MOD 10)*40),60+((counter/10)*40),100+board[counter],0,counter);
    END
END

//-------------------------------------------------------------------------
// Process boardbox
// Handles each one of the boardboxes
// Entries: x,y        = coordinates
//          graph,file = graphic
//          number     = number of boardbox on board
//-------------------------------------------------------------------------

PROCESS boardbox(x,y,graph,file,number)

BEGIN
    LOOP
        // Checks if boardbox is colliding with mouse
        IF (collision(TYPE mouse))
            // If so, and the mouse button is pressed, changes boardboxes
            // which get implied with a change_boardbox process
            IF (mouse.left) change_boardbox(number MOD 10,number/10); END
            // Refreshes graphic to the new position
            graph=board[number]+100;
            // Rpeats until mouse button is released
            WHILE (mouse.left) FRAME; END
        END
        // Refreshes graphic to the new position
        graph=board[number]+100;
        FRAME;
    END
END

//-------------------------------------------------------------------------
// Process change_boardbox
// Makes the change of the indicated boardbox, and it's neighbours
// Entries: boardbox_x, boardbox_y = Boardbox coordinates on game board
//-------------------------------------------------------------------------

PROCESS change_boardbox(boardbox_x,boardbox_y)

PRIVATE
    realx;  // Real coordinates of each boardbox
    realy;

BEGIN
    // Makes two loops, one vertical, and another horizontal
    FOR (counter=boardbox_x-1;counter<boardbox_x+2;counter++)
        FOR (counter2=boardbox_y-1;counter2<boardbox_y+2;counter2++)
            // Stores boardbox' coordinates on it's real coordinates
            realx=counter; realy=counter2;

            // Checks if boardbox is out of board
            // and forces boardbox to be the one on the opposite extrem
            IF (counter<0) realx=counter+10; END
            IF (counter>9) realx=counter-10; END
            IF (counter2<0) realy=counter2+10; END
            IF (counter2>9) realy=counter2-10; END

            // Changes boardbox' state
            IF (board[realx+(realy*10)]==1)
                board[realx+(realy*10)]=0;
            ELSE
                board[realx+(realy*10)]=1;
            END
        END
    END
END

//-------------------------------------------------------------------------
// Process completed_board
// Checks if game board has been completed
// Returns: 'true' if completed
//-------------------------------------------------------------------------

PROCESS completed_board()

BEGIN
    // Sets done boardboxes counter to 0
    counter2=0;

    // Looks through a loop all boardboxes, and increments
    // counter of dones, each time he finds one
    FROM counter=0 TO 99;
        IF (board[counter]==0) counter2++; END
    END

    // If 100 done has been counted, that means the board has been completed
    // if not, returns a 'false'
    IF (counter2==100) return(true);ELSE return(false); END

END