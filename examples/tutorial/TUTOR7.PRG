//----------------------------------------------------------------------
// Program:  Tutorial 7
// Author:   Daniel Navarro
// Date:     20/09/97
//----------------------------------------------------------------------

PROGRAM Tutorial_7;

GLOBAL
    // Tables with graphics' codes in 16 different positions
    // Chair's codes
    chair[]=16,100,101,101,103,104,105,106,107,
            108,109,110,111,112,113,114,115;
    // Trunk's codes
    trunk[]=16,200,201,202,203,204,205,206,207,
            208,209,210,211,212,213,214,215;
    // Table's codes
    table[]=16,300,301,302,303,304,305,306,307,
            300,301,302,303,304,305,306,307;
    // Hunger's codes
    hunger[]=16,400,401,402,403,400,401,402,403,
            400,401,402,403,400,401,402,403;
    // Chest's codes
    chest[]=16,500,501,502,503,504,505,506,507,
            508,509,510,511,512,513,514,515;
    // Couch's codes
    couch[]=16,600,601,602,603,604,605,606,607,
            608,609,610,611,612,613,614,615;

BEGIN
    // Sets video mode
    set_mode(m640x480);

    // Loads the requiered graphics' file
    load_fpg("fpg/tutorial/tutor7.fpg");

    // Fades the screen on
    fade_on();

    m7.camera=id;       // Forces camera to follow this process (main process)
    m7.height=512;      // Camera's height
    m7.distance=640;    // Camera distance to the observation point
    // Initiates mode7, or dejected plane
    start_mode7(0,0,1,0,0,128);
    // Writes an informative message
    write(0,320,0,1,"Use cursor keys to move camera");

    // Creates table type objects
    object(&table,128,128,0,600);
    object(&table,600,440,0,600);
    object(&table,600,340,0,600);

    // Creates chair type objects
    object(&chair,64,64,-pi/2,400);
    object(&chair,192,64,-pi/2,400);
    object(&chair,64,192,pi/2,400);
    object(&chair,192,192,pi/2,400);

    // Creates chest type objects
    object(&chest,32,384,0,600);
    object(&chest,384,32,-pi/2,600);

    // Creates trunk type objects
    object(&trunk,64,440,pi/2,800);
    object(&trunk,128,440,pi/2,800);
    object(&trunk,384,440,pi/2,800);

    // Creates hunger type objects
    object(&hunger,192,440,0,600);

    // Creates couch type objects
    object(&couch,512,32,-pi/2,400);
    object(&couch,600,128,-pi,400);

    // Sets coordinates for this process, which is the camera's
    x=320; y=240;
    LOOP
        // If cursor keys are pressed, camera's angle variates (it moves)
        if (key(_right)) angle-=pi/24; END
        if (key(_left)) angle+=pi/24; END
        FRAME;
    END
END

//----------------------------------------------------------------------
// Process object
// Visualizes all objects
// Entries: xgraph = Pointer to the graphics' table of object
//          x,y    = Coordinates
//          angle  = Object's angle
//          size   = Object's size, on percentage
//----------------------------------------------------------------------

PROCESS object(xgraph,x,y,angle,size)

BEGIN
    z=-16;          // Chooses a depth
    ctype=c_m7;     // Introduces the process within mode 7
    LOOP
        FRAME;      // Shows the graphic
    END
END
