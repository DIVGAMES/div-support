//---------------------------------------------------------------------------
// Program: Tutorial 3
// Author:  Daniel Navarro Medrano
// Date:    27/2/97
//---------------------------------------------------------------------------

PROGRAM Tutorial_3;

GLOBAL
    raquet1,raquet2; // Raquets' identifiers

BEGIN
    // Loads file with game's graphic
    load_fpg("tutorial/tutor3.fpg");

    put_screen(0,1);    // Puts background screen
    fade_on();          // Fades screen on
    // Creates both raquets and takes its' identifiers
    raquet1=raquet(6,24,_q,_a);
    raquet2=raquet(314,24,_p,_l);
    // Creates ball type process
    ball(160,100,1,1);
END

//---------------------------------------------------------------------------
// Process ball
// Handles game ball
// Entries: x,y   = Graphic's coordinate
//          ix,iy = Increments on each one of the coordinates
//---------------------------------------------------------------------------

PROCESS ball(x,y,ix,iy);

BEGIN
    graph=3;    // Selects graphic
    REPEAT
        FRAME(25);  // Shows it on screen more times than the rest of graphics
        // Checks if bounces with top and bottom edges
        IF (y==14 or y==186)
            iy=-iy; // Changes vertical direction
        END
        // Checks if bounces with raquets
        IF ((x==10 and abs(y-raquet1.y)<22) or
           (x==310 and abs(y-raquet2.y)<22))
            ix=-ix; // Changes horizontal direction
        END
        // Moves ball
        x=x+ix;
        y=y+iy;
    UNTIL (out_region(id,0))    // Repeats until it gets out of screen
    ball(160,100,ix,iy);        // Creates a new ball
END

//---------------------------------------------------------------------------
// Process raquet
// Handles players' raquets
// Entries: x,y    = Graphics' coordinates
//          up     = Key to move upwards
//          down   = Key to move downwards
//---------------------------------------------------------------------------

PROCESS raquet(x,y,up,down)

BEGIN
    graph=2;        // Selects graphic
    LOOP
        FRAME;      // Shows it
        // If up key is pressed and the limit has not been reached
        IF (key(up) and y>24)
            y=y-4;  // Moves raquet
        END
        // If down key is pressed and the limit has not been reached
        IF (key(down) and y<176)
            y=y+4; // Moves raquet
        END
    END
END
