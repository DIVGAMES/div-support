compiler_options _extended_conditions;

//--------------------------------------------------------------------
// Title:   Tutorial 4
// Author:  Daniel Navarro Medrano
// Date:    28/04/97
//--------------------------------------------------------------------

PROGRAM Tutorial_4;

GLOBAL
    worm_length=8;       // Worms tail length
    apples=0;            // Number of apples on screen
    score=0,topscore=0;  // Variables for topscore and score

BEGIN

    load_fpg("tutorial/tutor4.fpg");    // Loads graphics' file
    put_screen(0,1);                    // Puts background screen

    // Puts score and topscore texts
    write_int(0,64,8,0,&score);
    write_int(0,256,8,0,&topscore);

    // Creates worm head which controls the rest of the body
    worm_head(8,96,8,0);

    LOOP                                // Enters an endless loop
        FRAME;                          // Shows everything on screen
        // An apple is printed randomly
        // or not at all, but always while there are less than 3 apples
        IF (rand(0,32)==0 and apples<3)
            // Puts an apple and increments apples' counter
            apple(rand(1,38)*8,rand(3,23)*8);
            apples++;
        END
    END
END

//--------------------------------------------------------------------
// Process worm_head
// Handles worm's head
// Entries: x,y   = Graphic's coordinates
//          xi,yi = Horizontal and vertical increments
//--------------------------------------------------------------------

PROCESS worm_head(x,y,ix,iy)

PRIVATE
    apple_id;  // Identifier to the apple process

BEGIN
    graph=2;                // Puts the graphic

    // And a worm body is created, that creates the other ones
    worm_segment(128,1);

    REPEAT
        FRAME;              // Visualizes everything

        // Checks cursor keys, and changes increments
        IF (key(_right))
            ix=8; iy=0;
        END
        IF (key(_left))
            ix=-8; iy=0;
        END
        IF (key(_down))
            ix=0; iy=8;
        END
        IF (key(_up))
            ix=0; iy=-8;
        END

        // Checks if worm has collided with apple
        IF (apple_id=collision(TYPE apple))
            // Eliminates that apple
            signal(apple_id,s_kill);
            apples--;         // Reduces apples' counter
            worm_length+=4;   // Increments worm's tail
            score+=10;        // Adds 10 points to score
        END
        // Moves worm on the desired direction
        x=x+ix;
        y=y+iy;
    // Repeats until it crashes with the wall (get_pixel) or
    // with it's own body
    UNTIL (get_pixel(x,y)!=0 or collision(type worm_segment));

    // Fades screen on and off, for the next step
    fade_off();
    fade_on();

    // Checks if topscore has been reached, and refreshes it
    IF (score>topscore)
        topscore=score;
    END

    // Reinitiates score and tail length variables
    score=0;
    worm_length=8;
    // Eliminates all worm_segment type process
    signal(son,s_kill_tree);
    // Creates a new worm, creating it's head
    worm_head(8,96,8,0);
END

//--------------------------------------------------------------------
// Process worm_segment
// Handles worm's body segments
// Entries: n        = Number of body (total=128)
//          priority = Priority of process in execution
//--------------------------------------------------------------------

PROCESS worm_segment(n,priority)

BEGIN

    z=-1024;
    // If it is not the last body, creates another one with higher priority
    // and a minor number of body
    IF (n>0) worm_segment(n-1,priority+1); END

    LOOP        // Enters an endless loop

        // Checks priority which indicates tail's order
        // if it is within tail's length
        IF (priority<worm_length)
            // If it is within length, prints it
            graph=2;
        ELSE
            // If not, doesn't put a graphic
            graph=0;
        END
        // Takes father's variables, the body that is ahead,
        // without refreshing, that means, where it was
        x=father.x;
        y=father.y;
        FRAME;
    END
END

//--------------------------------------------------------------------
// Process apple
// Handles apples' graphics
// Entraies: x,y = Graphics' coordinates
//--------------------------------------------------------------------

PROCESS apple(x,y)

BEGIN
    graph=3;    // Chooses the graphic, and enters an endless loop
    LOOP FRAME; END
END

