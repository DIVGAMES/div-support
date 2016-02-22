
//-----------------------------------------------------------------------
// TITTLE:  Tutorial 0
// AUTHOR:  Daniel Navarro
// DATE:    15/09/97
//-----------------------------------------------------------------------

PROGRAM Tutorial_0;
BEGIN
    load_fpg("Tutor0.fpg"); // Loads grphics' file
    put_screen(0,2);  // Sets graphic number 2 as screen background
    ship();           // Creates a "ship" type process
END

//-----------------------------------------------------------------------
// Handles player's ship
//-----------------------------------------------------------------------

PROCESS ship()
BEGIN
    graph=1; x=160; y=180;    // Selects graphic and coordinates
    LOOP                      // Enters an infinite loop
        x=mouse.x;            // Puts ship on x mouse's coordinate
        IF (mouse.left)       // When left mouse button is pressed
            shot(x,y-20);  // creates a "shot" type process
        END
        FRAME;                // Shows next image of ship
    END
END

//-----------------------------------------------------------------------
// Handles ship's shots
// Entries: Graphic's coordinates 
//-----------------------------------------------------------------------

PROCESS shot(x,y)
BEGIN
    graph=3;    // Selects graphic
    REPEAT      // Repeated loop
        y-=16;  // Moves upwards 16 points
        FRAME;  // Shows next image
    UNTIL (y<0) // Repeats until it gets out of top screen
END

