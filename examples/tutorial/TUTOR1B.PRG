
//-------------------------------------------------------------------
// TITLE:   Tutorial 1
// AUTHOR:  Antonio Marchal
// DATE:    10/10/97
//-------------------------------------------------------------------

PROGRAM Tutorial_1;

GLOBAL
    score=0;     // Variable used to store the score

BEGIN
    load_fpg("tutorial/tutor1.fpg");  // Loads graphics' file
    load_fnt("tutorial/tutor1.fnt");  // Loads font type

    set_mode(m640x480);               // Sets video mode to 640x480
    set_fps(24,0);                    // Number of frames per second
    put_screen(0,63);                 // Puts background screen
    ship(320,240,41);                 // Creates ship process

    write_int(1,320,0,1,OFFSET score);     // Shows the score
    FROM x=1 TO 4; asteroid(1); END        // Creates 4 big asteroids
    FROM x=1 TO 4; asteroid(21); END       // Creates 4 small asteroids
END

//-------------------------------------------------------------------
// Handles player's ship
// Entries: Coordinates and graphic's code number
//-------------------------------------------------------------------

PROCESS ship(x,y,graph)
BEGIN
    LOOP
        // Checks if left or right key are pressed
        // And modifies angles if they are so
        IF (key(_left)) angle=angle+10000; END
        IF (key(_right)) angle=angle-10000; END
        // If up key is pressed, the ship advances
        IF (key(_up)) advance(8); END
        // If control key is pressed, creates a shot type process
        IF (key(_control)) shot(x,y,angle); END
        // Finds new coordinates, so the ship reappears on screen
        new_coordinates();
        FRAME;  // Prints ship's graphic on screen
    END
END

//-------------------------------------------------------------------
// Process shot
// Creates ship's shots
// Entries: Shot's coordinates and angle
//-------------------------------------------------------------------

PROCESS shot(x,y,angle)
BEGIN
    // Makes an initial advance, and defines the graphic to be used
    advance(24); graph=42;
    // While the graphic is inside the screen
    WHILE (NOT out_region(id,0))
        // Makes it to advance on the predefined angle it had
        advance(16);
        FRAME;  // Shows graphic on screen
    END
END

//-------------------------------------------------------------------
// Process asteroid
// Handles all asteroids, bigs and small ones
// Entries: Asteroid type code number, which is it's initial graphic
//-------------------------------------------------------------------

PROCESS asteroid(codenumber)
BEGIN
    LOOP
        // Creates an asteroid on left top corner
        // (Coordinates: 0,0) and assigns code number to graphic
        x=0; y=0; graph=codenumber;
        // Chooses an angle randomly
        angle=rand(-180000,180000);
        LOOP
            // Animates the graphic, by adding one to it's code number
            graph=graph+1;
            // If animation's limit is overpassed, reinitializes it
            IF (graph==codenumber+20) graph=codenumber; END
            // Makes graphic to advance on the defined direction
            advance(4);
            // If it collides with shot's graphic then
            // exits loop, which another way would be endless
            IF (collision (TYPE shot)) BREAK; END
            // Finds new coordinates, so it keeps on screen
            // forcing it to appear by the opposite side of screen
            new_coordinates();
            FRAME;      // Shows graphic on screen
        END
        score=score+5;    // Adds 5 point to total score
        // Plays explosion's animation through a loop
        FROM graph=43 TO 62; FRAME; END
    END
END

//-------------------------------------------------------------------
// Process new_coordinates
// Finds new coordinates for the process that called this process
//-------------------------------------------------------------------

PROCESS new_coordinates()
BEGIN
    // If it gets out by the left, forces it to appear by the right
    // subtracting screen's wide
    IF (father.x<-20) father.x=father.x+680; END
    // If it gets out by the right, forces it to appear by the left
    IF (father.x>660) father.x=father.x-680; END
    // If it gets out by the top, forces it to appear by the bottom
    IF (father.y<-20) father.y=father.y+520; END
    // If it gets out by the bottom, forces it to appear by the top
    IF (father.y>500) father.y=father.y-520; END
END
