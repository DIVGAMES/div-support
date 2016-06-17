
//--------------------------------------------------------------------
// Program:   Tutorial 2
// Author:    Daniel Navarro Medrano
// Date:      20/10/97
//--------------------------------------------------------------------

PROGRAM Tutorial_2;

BEGIN
    // Loads graphics' file
    load_fpg("tutorial\tutor2.fpg");
    // Sets the number of frames per second
    set_fps(24,0);
    // Puts background screen
    put_screen(0,41);
    // Writes an explanable message
    write(0,160,2,1,"Press space bar to create planets");
    // Creates an endless loop, since no process has been created yet,
    // and program will end if this loop didn't exist
    LOOP
        // Each time the space key is pressed, an earth type
        // process is created
        IF (key(_space)) earth(); END
        FRAME;
    END
END

//--------------------------------------------------------------------
// Process earth
// Handles earth's animations
//--------------------------------------------------------------------

PROCESS earth();

PRIVATE
    velocity_x;         // Horizontal coordinate increment
    velocity_y;         // Vertical coordinate increment
    initial_velocity_y; // Bounce length

BEGIN
    // Creates process on left middle side
    x=0; y=1800;
    resolution=10;  // Forces coordinates to use one decimal
    // Initiates horizontal increment from 1 to 8 points
    velocity_x=rand(10,80);
    // Reinitiates initial bounce length from 8 to 25 points
    initial_velocity_y=rand(-80,-250);
    // Vertical increment equals bounce length
    velocity_y=initial_velocity_y;
    // Creates an endless loop
    LOOP
        // Creates a loop that goes over every single image
        // that composes the animation, which ranges from code numbers 0 to 40
        FROM graph=1 TO 40;
            // Moves process horizontally
            x=x+velocity_x;
            // If either side of screen is reached
            IF (x<0 OR x>3200)
                // Changes increment sign, so does
                // with movement direction
                velocity_x=-velocity_x;
            END
            // Moves process vertically
            y=y+velocity_y;
            // If bounce height has reached it's limit
            IF (-velocity_y<=initial_velocity_y)
                // Reinitiates length to the initial one
                velocity_y=-velocity_y;
            ELSE
                // Decreases increment on bounce length
                velocity_y=velocity_y+20;
            END
            FRAME;  // Shows process on screen
        END
    END
END
