
//-----------------------------------------------------------------------
// TITLE:   Tutorial 0
// AUTHOR:  Daniel Navarro
// DATE:    15/09/97
//-----------------------------------------------------------------------

PROGRAM Tutorial_0;
BEGIN
    load_fpg("tutorial/tutor0.fpg"); // Loads graphics' file
    put_screen(0,2);  // Sets graphic number 2 as background screen
    ship();           // Creates "ship" type process

    LOOP
        // If a random number between 0 and 100 is minor than 30, then creates
        // an "enemy" type process on top of screen
        IF (rand(0,100)<30)
            enemy(rand(0,320),rand(-4,4),rand(6,12));
        END
        FRAME;        // Shows next image
    END
END

//-----------------------------------------------------------------------
// Handles player's ship
//-----------------------------------------------------------------------

PROCESS ship()
BEGIN
    graph=1; x=160; y=180;    // Selects graphic and it's coordinates

    LOOP
        x=mouse.x;            // Puts ship on x mouse coordinate
        IF (mouse.left)       // When the left mouse button is pressed
            shot(x,y-20);     // creates a "shot" type process
        END
        FRAME;                // Shows next ship image
    END
END

//-----------------------------------------------------------------------
// Handles ship's shots
// Entries: Graphic's coordinates
//-----------------------------------------------------------------------

PROCESS shot(x,y)
BEGIN
    graph=3;    // Selects graphic

    REPEAT
        y-=8;  // Moves it upwards 16 points
        FRAME(50);  // Shows next image
    UNTIL (y<0) // Repeats until it reaches top screen end
END

//-----------------------------------------------------------------------
// Enemies that fall from top of screen
// Entries: x coordinate, x increment, and y increment (for each image)
//-----------------------------------------------------------------------

PROCESS enemy(x,inc_x,inc_y)
BEGIN
    graph=4;            // Selects a graphic for the process (the 4th on file)
    y=-20;              // Places graphic on top of screen
    size=rand(25,100);  // Sets it's size randomly (between 25% and 100%)

    REPEAT
      x+=inc_x;         // Adds x increment to x coordinate
      y+=inc_y;         // Same thing with y coordinate
      FRAME;
    // Repeats until it gets out of screen or collides with a shot
    UNTIL (y>220 OR collision(TYPE shot));
    clone
    FROM graph=5 TO 10; // Prints an explosion on enemy's position
        FRAME;          // (explosion's graphics range from the 5th to the 10th)
    END
    end

    //size=100;
    while(size>0)
    size-=5;
    frame;
    //(1000);

    //end

    end


END
