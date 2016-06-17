//--------------------------------------------------------------------
// Title:   Tutorial 5
// Author:  Daniel Navarro Medrano
// Date:    26/01/97
//--------------------------------------------------------------------

PROGRAM Tutorial_5;

GLOBAL
    body_counter=0;  // Counts the number of bodies

BEGIN
    // Loads game's graphics file
    load_fpg("Tutor5.fpg");
    // Prints an informative message and erases the screen
    write(0,160,192,1,"Use mouse to move snake.");
    fade_on();

    // Puts coordinates resolution with two decimals
    resolution=100;
    // Selects head's graphic
    graph=1;
    // Initiates background screen
    start_scroll(0,0,4,5,0,0);
    // Creates initial body segment
    segment();
    LOOP
        // Makes head follow mouse movement
        x=mouse.x*100;
        y=mouse.y*100;
        // Moves both scroll
        scroll.x0=scroll.x0+1; scroll.y0=scroll.y0+1;
        scroll.x1=scroll.x1-1; scroll.y1=scroll.y1-1;
        FRAME;  // Makes everything appear on screen
    END
END

PROCESS segment()

PRIVATE
    x0,y0;  // Temporary coordinates for calculus stuff

BEGIN
    // Makes coordinates to use two decimals
    resolution=100;
    // Increments body segments counter
    body_counter=body_counter+1;
    // Sets depth depending on body's number
    z=-body_counter;

    // If it is the end of the tail, makes it smaller
    IF (body_counter>156) size=256-body_counter; END

    // Keeps on creating other body segments up to 256
    IF (body_counter<256) segment(); END

    // Selects the graphic, but with transparency
    graph=2; flags=4;
    LOOP
          // Calculates coordinates by finding the middle
          // between the current position and the position
          // of the body that called him, which is the one that is ahead
          x=x0; x0=father.x; x=(x+x0*3)/4; x0=x;
          y=y0; y0=father.y; y=(y+y0*3)/4; y0=y;
        FRAME; // Prints graphic on screen
    END
END