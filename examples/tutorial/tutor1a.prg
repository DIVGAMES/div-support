
//-------------------------------------------------------------------
// Program:   Tutorial 1
// Author:    Antonio Marchal
// Date:      10/10/97
//-------------------------------------------------------------------

PROGRAM Tutorial_1;
BEGIN
    // Loads the required graphics' file
    load_fpg("tutorial\tutor1.fpg");
    set_mode(m640x480); // Sets video mode to 640x480
    put_screen(0,63);   // Puts background screen
    ship(320,240,41);   // Creates ship process
    // Creates with a loop 4 big asteroids
    FROM x=1 TO 8; asteroid(); END
END

//-------------------------------------------------------------------
// Process ship
// Handles player's ship
// Entries: Coordinates and graphic's code number
//-------------------------------------------------------------------

PROCESS ship(x,y,graph)
BEGIN
    LOOP
        // Checks if left or right keys are pressed
        // And modifies angle if they are so
        IF (key(_left)) angle=angle+10000; END
        IF (key(_right)) angle=angle-10000; END
        // If up key is pressed, moves ship upwards
        IF (key(_up)) advance(8); END
        FRAME;  // Shows ship's graphic on screen
    END
END

//-------------------------------------------------------------------
// Process asteroid
// Handles all game asteroids, big and small ones
//-------------------------------------------------------------------

PROCESS asteroid()
BEGIN
    LOOP
        // Creates an asteroid on top left corner
        // (Coordinates: 0,0) and asigns a code number to the graphic
        x=0; y=0; graph=1;
        // Chooses an angle randomly
        angle=rand(-180000,180000);
        // Repeats while it is on screen
        WHILE (x>=0 AND x<=640 AND
               y>=0 AND y<=480)
            // Animates graphic, adding one to it's code number
            graph=graph+1;
            // If animation's limit is overpassed, reinitializes it
            IF (graph==21) graph=1; END
            // Makes graphic to advance into a certain direction
            advance(4);
            FRAME;      // Prints graphic on screen
        END
    END
END

