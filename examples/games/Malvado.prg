compiler_options _extended_conditions;


//-----------------------------------------------------------------------------
// TITLE:      CASTLE OF DR MALVADO
// AUTHOR:     DANIEL NAVARRO
// DATE:       DIV GAMES STUDIO (c) 2000
//-----------------------------------------------------------------------------

PROGRAM castle_of_dr_malvado;

GLOBAL
    level=1;         // Number of levels
    lifes=10;        // Number of lifes
    score=0;         // Score's variable
    bonus=0;         // Number of collected bonus
    font1,font2;     // Fonts' identifiers

    s_fish;          // Identifier for fishes' sound
    s_touch;         // Identifier for touches' sound
    s_star;          // Identifier for stars' sound
    s_spider;        // Identifier for spiders' sound
    s_bear;          // Identifier for bears' sound
    s_bee;           // Identifier for bees' sound
    s_ghost;         // Identifier for ghosts' sound
    s_jump1;         // Identifier for jump1's sound
    s_jump2;         // Identifier for jump2's sound
    s_fall;          // Identifier for falling' sound
    s_bubble;        // Identifier for bubbles' sound
    s_bonus;         // Identifier for collecting bonus' sound
    s_malvado;       // Identifier for Dr.Malvado's death

    energy_enemy;     // Final bosses enemies' energy level variable
    id_enemy_bar;     // Identifier to quit energy bar
    level_end=false;  // Variable to control when a level has been finished
    idlifetext;       // Variables that handle text when a life appears
    countlifetext;
    withlifetext=0;
    mainid;
LOCAL
    gravity_speed;   // Variable for storing falling speed (gravity)
    speed=0;         // Variable for storing horizontal character's speed
    death;           // Variable for storing if the character is dead
    angle2;          // Variable for general angles

PRIVATE
    _screen=1;       // Screen that is seen as menu
    _quit=0;         // 1= Quit game
BEGIN

    mainid=id;
    set_fps(24,4);      // Sets screen frame rate to 24 frames per second
                        // With a maximum error of 4 screens jumps
    // Loads the general graphics file
    load_fpg("malvado\malvado.fpg");

    // Loads font types files
    font1=load_fnt("malvado\number.fnt");
    font2=load_fnt("malvado\letters.fnt");

    // Loads game sounds
    s_fish=load_pcm("malvado\fish.pcm",0);
    s_touch=load_pcm("malvado\hit.pcm",0);
    s_star=load_pcm("malvado\star.pcm",0);
    s_spider=load_pcm("malvado\spider.pcm",0);
    s_bear=load_pcm("malvado\bear.pcm",0);
    s_bee=load_pcm("malvado\bee.pcm",0);
    s_ghost=load_pcm("malvado\ghost.pcm",0);
    s_jump1=load_pcm("malvado\jump1.pcm",0);
    s_jump2=load_pcm("malvado\jump2.pcm",0);
    s_fall=load_pcm("malvado\fall.pcm",0);
    s_bubble=load_pcm("malvado\bubble.pcm",0);
    s_bonus=load_pcm("malvado\bonus.pcm",0);
    s_malvado=load_pcm("malvado\malvado.pcm",0);

    LOOP                    // Main loop
        timer=1000;         // Initializes out of time, so it is changed when just entered
        _screen=3;          // Selects the other screen, because it changes when just entered

        REPEAT                              // Presentation screens' loop
            IF (timer>500)                  // After 5 secs, changes screen
                timer=0;
                IF (_screen==1)
                    _screen=3;             //  3:Credits' screen
                ELSE
                    _screen=1;
                END                         //  1:Menu screen
                fade_off();
                put_screen(0,_screen);
                fade_on();
            END
            angle+=10000;
            FRAME;
        until (scan_code<>0);
        // Waits for a key to be pressed

        // If 'ESC' was pressed, exits game
        IF (key(_esc))
            fade_off();
            exit("Thanks for playing!",0);
        END

        fade_off();                     // Fades screen off
        // Initializes game's variables
        // Level=1, lifes=3, score=0, bonus=0
        level=1;
        lifes=3;
        score=0;
        bonus=0;

        REPEAT              // Loop for 'loading...' screen
            fade_on();      // Fades screen on
            put_screen(0,2);// Puts background screen
            write(font2,138,77,4,"LEVEL");
            write_int(font2,208,77,4,&level);
            WHILE (fading)  // Waits while everything is initiated, which
                FRAME;      // will happen when screen is faded off
            END
            delete_text(all_text);
            // Puts scores, lifes and bonus graphics
            object(0,222,16,16,-512,0);     // Prints lifes
            write(font1,36,16,4,"x");
            write_int(font1,44,16,3,&lifes);
            write_int(font1,160,16,4,&score);  // Prints score
            object(0,216,270,17,-512,0);       // Prints bonus
            write(font1,288,16,4,"x");
            write_int(font1,296,16,3,&bonus);
            level_end=false;                // Initializes the variable
                                            // that controls stage/level end
            // Puts texts when a level is started
            SWITCH (level)      // Loop for levels
                CASE 1:         // Initializes level one
                    // Loads graphics for level one
                    load_fpg("malvado\level1.fpg");

                    // Initializes scroll
                    start_scroll(0,1,1,3,0,4);
                    // Defines scroll region after which it will move
                    scroll.region1=define_region(1,96,100,1,1);


                    // Initializes objects that overlap other objects
                    object(1,20,2080,122,-256,1); // Graphics for door frames
                    object(1,21,2102,34,-256,1);
                    object(1,22,3286,72,32,1);    // Graphics for overlapping bubbles (cauldron)

                    // Initializes first plane objects
                    first_plane(12,200);        // Bushes graphic
                    first_plane(10,500);        // Casttle direction signal
                    first_plane(11,780);        // Grave
                    first_plane(12,1300);       // Bushes
                    first_plane(13,2150);       // Candle
                    first_plane(13,2800);       // Candle

                    // Initializes objects for platforms chains
                    chain(2840,8,0,pi/48,pi/4);
                    chain(3133,8,pi,pi/32,pi/4);
                    chain(3660,80,0,pi/24,pi/4);

                    // Initializes character's object
                    jack(8,0);

                    // Initializes bears' objects
                    bear(82,189,-1);
                    bear(256,274,-2);
                    bear(484,158,-3);
                    bear(580,247,-2);
                    bear(798,189,-3);
                    bear(1053,191,-3);
                    bear(1675,100,-4);
                    bear(2036,175,-6);

                    // Initializes bees' objects
                    flying(310,0,600,140,110,64,100,64);
                    flying(310,0,900,140,110,64,160,100);
                    flying(310,0,1300,170,90,48,200,50);
                    flying(310,0,1320,150,95,60,150,75);
                    flying(310,0,1820,100,48,36,64,64);

                    // Initializes ghosts' objects
                    flying(320,4,2170,100,48,36,64,64);
                    flying(320,4,2329,224,100,24,220,32);
                    flying(320,4,2865,100,48,36,96,96);
                    flying(320,4,3100,64,100,36,96,96);

                    // Initializes spiders' objects
                    spider(2349,63,65);
                    spider(2218,152,78);
                    spider(2534,0,77);

                    // Initializes fire objects
                    fire(2280,256,10);
                    fire(2390,256,11);

                    // Takes control points from bonus map
                    FROM z=0 TO 25;
                        get_point(1,1,z,&x,&y); // Takes control point
                        p_bonus(x,y);              // Puts bonus
                    END
                END

                CASE 2:         // Initializes level two
                    // Loadsd level two's graphics file
                    load_fpg("malvado\level2.fpg");

                    // Initializes scroll for level 2
                    start_scroll(0,1,1,3,0,4);
                    // Selects scroll region after which it moves
                    scroll.region1=define_region(1,160,150,1,1);

                    // Initializes metallic platforms met licas that are set diagonally
                    metal_platform(214,1590,128,1443,2);
                    metal_platform(108,1249,212,1249,1);
                    metal_platform(212,1193,212,1056-58,2);
                    metal_platform(108,1193,108,1056+64,1);
                    metal_platform(158,582,158,624,5);

                    // Initializes spikes ball
                    spikes_ball(157,1121);
                    chain(160,532,0,pi/24,pi/10);  // Initializes chain

                    // Initializescharacter
                    jack(8,1971);

                    // Initializes pumpkins
                    pumpkin(100,1855,2);
                    pumpkin(100,1583,2);
                    pumpkin(233,1311,1);
                    pumpkin(219,313,2);
                    pumpkin(208,189,3);

                    // Initializes spitting heads
                    head(264,1894,1,24);
                    head(264,1515,1,96);
                    head(264,465,1,26);
                    head(56,1515,0,96);
                    head(56,1298,0,26);
                    head(264,792,1,26);
                    head(56,174,0,24);

                    // Initializes spiders
                    spider(74,1612,100);
                    spider(245,955,274);
                    spider(75,285,83);
                    spider(245,23,71);

                    // Initializes ghosts
                    flying(320,4,158,1760,90,70,80,80);
                    flying(320,4,158,1145,140,110,80,80);
                    flying(320,4,158,616,48,64,80,120);
                    flying(320,4,158,190,64,96,90,110);

                    // Takes control points for bonus
                    FROM z=0 TO 25;
                        get_point(1,1,z,&x,&y); // Takes control point
                        p_bonus(x,y);              // Puts bonus
                    END
                END

                CASE 3:         // Initializes level three
                    // Loads level three's graphics file
                    load_fpg("malvado\level3.fpg");

                    // Initializes scroll for level 3
                    start_scroll(0,1,1,3,0,4);
                    // Defines scroll region after which it will move
                    scroll.region1=define_region(1,160,100,1,1);

                    // Initializes character
                    jack(64,0);

                    // Initializa final boss monster (doctor malvado)
                    malvado();           // Monster object
                    energy_enemy=16;     // Amount of energy
                    // Necessary identifier, just in case you pass with cheats
                    id_enemy_bar=energy_bar(); // Initializes energy bar
                END

            END

            fade_off();             // Fades screen off
            clear_screen();         // Erases screen
            fade_on();              // Fades screen on

            REPEAT                  // Main game loop
                IF (level==1)
                    // Creates decorative fishes and bubbles
                    SWITCH (rand(0,24))
                        CASE 0: fish(rand(380,700),292); END
                        CASE 1: fish(rand(1290,1354),288); END
                        CASE 2: fish(rand(1848,1948),250); END
                        CASE 3,4: bubble(rand(3270,3300),70); END
                    END
                END
                // If all the keys that conform 'DIV' word
                // you will pass of level
                IF (key(_d) AND key (_i) AND key(_v))
                    level_end=true;
                END
                FRAME;
            // Repeats until you pass the level, or you have no lifes left
            UNTIL (level_end OR lifes<0 OR key (_esc))
            IF (key(_esc))
                _quit=1;
            END
            IF (level_end)        // If the level has been finished
                level++;          // Increments level
                level_end=false;  // Initializes level control variable
            END
            IF (lifes<0)
                write(font2,160,100,4,"GAME OVER");
            END
            IF (level==4)
                write(font2,160,100,4,"WELL DONE");
            END

            FRAME(2400);             // Waits a sec
            fade_off();              // Fades screen off
            stop_scroll(0);          // Stops scroll
            // Ends all object process that overlap graphics
            signal(TYPE object,s_kill);
            // Ends first plane object process
            signal(TYPE first_plane,s_kill);
            // Stops all sounds
            stop_sound(all_sound);
            // Erases all texts
            delete_text(all_text);
            // Unloads graphics file
            unload_fpg(1);
            // Quits final boss' energy bar
            signal(id_enemy_bar,s_kill);
        // Repeats until you have no more lifes left, or you reach level 4
        UNTIL (lifes<0 OR level==4 OR key (_esc) OR _quit)
        _quit=0;
    END
END

//-----------------------------------------------------------------------------
// Process for main character
// Entries: horizontal and vertical coordinates
//-----------------------------------------------------------------------------

PROCESS jack(x,y);

PRIVATE
    incx=0;       // Variable for wall checking
    last_y=0;     // Variable used to see if he goes up
    last_speed=0; // Variable for wall checking
    id2;          // General purpouse identifier

BEGIN
    ctype=c_scroll;             // Puts within scroll
    scroll.camera=id;           // Makes camera follow him
    graph=100;
    priority=1;

    LOOP
        // Reads keyboard and joystick
        IF ((key(_right) OR joy.right) AND speed<8)
            speed+=2;           // Increases speed to the right
            flags=0;            // Looks to the right
        ELSE
            IF ((key(_left) OR joy.left) AND speed>-8)
                speed-=2;       // Increases speed to the left
                flags=1;        // Looks to the left
            ELSE                // If no key is pressed
                IF (speed>0)    // Brakes to the right
                    speed--;
                END
                IF (speed<0)    // Or brakes to the left
                    speed++;
                END
            END
        END

        // Checks if character collides with walls
        last_speed=speed;                // Saves speed on 'last_speed'
        IF (last_speed<>0)               // And if he moves
            incx=last_speed/abs(last_speed); // Finds the direction
            WHILE (last_speed<>0)            // 'last_speed' serves as counter
                // Checks that it doesn't touches upwards
                IF (map_get_pixel(1,2,(x+incx)/2,(y-2)/2)<>120)
                    // Nor downwards
                    IF (map_get_pixel(1,2,(x+incx)/2,(y-32)/2)<>120)
                        x+=incx;    // And if so, moves character
                    END
                END
                last_speed-=incx;   // Subtracts 'last_speed' until it reaches 0
            END
        END

        // If he collides with a platform, creates a new character
        IF (id2=collision(TYPE platform))
            // He must be going down, and over the platform
            IF (gravity_speed>0 AND abs(x-id2.x)<50 AND y<=id2.y+24)
                jack_platform(x-id2.x,id2,50,8);
            END
        END

        // If he collides with a metallic platform, creates a new character
        IF (id2=collision(TYPE metal_platform))
            // He must be going down, and over the platform
            IF (gravity_speed>0 AND abs(x-id2.x)<36 AND y<=id2.y+12)
                jack_platform(x-id2.x,id2,36,-7);
            END
        END

        gravity();         // Function that calculates character's gravity

        IF (on_screen())   // If character is not going down
            IF (speed<>0)    // But he moves
                graph++;     // Changes graphic to animate it
                IF (graph>106)
                    graph=100;
                END
            ELSE
                graph=101;      // If he doesn't move, puts default graphic
            END
            // Reads action keys (Space and Control) or joystick button
            IF (key(_space) OR key(_control) OR joy.button1)
                sound(s_jump2,100,rand(256,512));   //If pressed plays sound
                gravity_speed=-18;                  // and jumps
            END
        ELSE                    // If character goes down
            graph=108;          // Puts 'going down' graphic
        END

        IF (last_y<y)            // Checks if going down
            death=true;         // If so, he can kill
        ELSE
            death=false;        // If he goes up or he is stopped, he can die
        END

        // Checks collision with bears
        IF (id2=collision(TYPE bear))
            score+=350;
        ELSE
            // Checks collision with bees and ghosts
            IF (id2=collision(TYPE flying))
                score+=575;
            ELSE
                // Checks collision with spiders
                IF (id2=collision(TYPE spider))
                    score+=825;
                ELSE
                    // Checks collision with monster's heads
                    IF (id2=collision(TYPE head))
                        score+=150;
                    ELSE
                        // Checks collision with pumpkins
                        IF (id2=collision(TYPE pumpkin))
                            score+=425;
                        END
                    END
                END
            END
        END

        IF (id2)            // Checks for any kind of collision
            IF (death)     // And if going down, he can kill
                gravity_speed=-12;     // Makes Jack jump
                stars(id2.x,id2.y);     // Creates 'wonderful' stars
                signal(id2,s_kill);         // Eliminates the monster that originated collision
                sound(s_bubble,100,512);    // And plays a bubble sound
            ELSE       // If he cannot kill, then Jack
                kill_jack();            // is dead
            END
        END

        // If it is fire, Jack dies no matter what...
        IF (collision(TYPE fire)) kill_jack(); END

        // If they are balls, Jack dies no matter what...
        IF (collision(TYPE ball)) kill_jack(); END

        // If it is a head's shot, Jack dies no matter what...
        IF (collision(TYPE head_shot)) kill_jack(); END

        // If they are spike balls, Jack dies no matter what...
        IF (collision(TYPE ball_end)) kill_jack(); END

        // Checks for collision with bonus
        IF (id2=collision(TYPE p_bonus))
            sound(s_bonus,150,256);     // Plays sound
            bonus++;                    // Increments number of bonus
            score+=1000;                // Adds score
            stars(id2.x,id2.y);     // Cretes 'wonderful' stars
            signal(id2,s_kill);         // Eliminates bonuses on screen
            IF (bonus>=10)              // And if he has over 10 bonuses
                bonus-=10;              // Subtracts 10 bonus
                lifes++;                // And adds a life
                // Prints an 'EXTRA LIFE' message
                idlifetext=write(font1,160,150,4,"EXTRA LIFE");
                countlifetext=0;
                withlifetext=1;
            END
        END

        // Waits 4 secs before erasing message
        IF (withlifetext==1)
            countlifetext++;
        END
        IF (countlifetext>99 AND withlifetext==1)
            delete_text(idlifetext);
            withlifetext=2;
        END
        // Refreshes zero scroll's internal variables
        move_scroll(0);

        IF (level==1)                   // On level one
            IF (y>300)                  // If he passed the inferior edge
                kill_jack();          // Kills Jack
            END
            IF (x>3400)                 // If he reached the right edge
                // If he hasn't finished the level and the first monster has not been created
                IF (not level_end AND not get_id(TYPE malvado_son_head))
                    malvado_son();         // Creates final boss monster
                    energy_enemy=16;        // Creates monster's energy bar
                    id_enemy_bar=energy_bar();   // Saves energy bar's identifier
                                                    // to quit it if you are passing with cheats
                ELSE   // If monster is already created
                       // Checks for collision with Jack
                    IF (collision(TYPE malvado_son))
                        kill_jack();                  // And if he collides, he kills Jack
                    END
                END
            END
        ELSE
            // If you are on level two, and at the end possition
            IF (level==2 AND x==58 AND y==53)
                level_end=true;   // Finishes level
            END
        END

        last_y=y;   // Saves 'y' on last_y to check later if it goes down
        FRAME;
    END
END

//------------------------------------------------------------------------------
// Process for Jack, for when he is over a moving platform
// so he moves at the same time the platform does
// Entries: `relativex`         Relative horizontal possition of
//                              Jack respect the center of the
//                              platform
//          `id2`               Platform identifier
//          `platform_size`     Size (length) of platform
//          `incy`              Relative vertical possition of
//                              Jack respect the center of the
//                              platform
//-----------------------------------------------------------------------------

PROCESS jack_platform(relativex,id2,platform_size,incy);

BEGIN

    // Puts to sleep father's process (the one that called him)
    // while this process is active
    signal(father,s_sleep);
    ctype=c_scroll;     // Puts whithin scroll
    graph=100;          // Puts appropiate graphic
    flags=father.flags; // Takes father's flags (left/right)
    priority=1;         // Gives priority 1 so it refreshes
                        // Jack before scroll
    scroll.camera=id;   // Makes camara follow Jack

    LOOP
        // Reads right key and joystick
        IF ((key(_right) OR joy.right) AND speed<8)
            speed+=2;       // Increments right speed
            flags=0;        // Puts him facing right
        ELSE
            IF ((key(_left) OR joy.left) AND speed>-8)
                speed-=2;       // Increments left speed
                flags=1;        // Puts him facing left
            ELSE                // If no direction key has been pressed
                IF (speed>0)
                    speed--;    // Brakes to the right
                END
                IF (speed<0)
                    speed++;    // Brakes to the left
                END
            END
        END

        relativex+=speed;          // Adds speed to relative possition
        x=relativex+id2.x;         // Converts relative possition into real
        y=id2.y+incy;

        IF (speed<>0)           // If Jack was moving
           graph++;             // Changes graphic to animate it
           IF (graph>106)
              graph=100;
           END
        ELSE
            graph=101;          // If not, puts graphic for when stopped
        END

        // If the jump key is pressed (space or control or joystick)
        IF (key(_space) OR key(_control) OR joy.button1)
            signal(father,s_wakeup);                    // Awakes previous process (the father)
            father.x=x;                                 // Refreshes coordinate x
            father.y=y;                                 // Refreshes coordinate y
            father.speed=speed+id2.speed;               // Refreshes speed
            father.gravity_speed=-18;                   // Makes Jack jump
            father.flags=flags;                         // Refreshes flags (left/right)
            sound(s_jump2,100,rand(256,512));           // Plays jump2 sound
            scroll.camera=father;                       // Forces camera to follow Jack
            signal(id,s_kill);                          // Eliminates current process
            FRAME;
        END

        // If Jack is out of platform
        IF (abs(x-id2.x)>=platform_size+4)
            signal(father,s_wakeup);                    // Awakes previous process
            father.x=x;                                 // Refreshes x
            father.y=y;                                 // Refreshes y
            father.speed=speed+id2.speed;               // Refreshes speed
            father.flags=flags;                         // Refreshes flags (left/right)
            father.gravity_speed=0;                     // Leaves Jack floating in the air
            scroll.camera=father;                       // Makes camera follow Jack
            signal(id,s_kill);                          // Eliminates current process
            FRAME;
        END

        // Checks for collision with bees and ghosts
        IF (collision(TYPE flying))
            signal(father,s_kill);      // Eliminates previous process
            kill_jack();              // Kills Jack
        END

        // Checks for collision with first monster
        IF (collision(TYPE malvado_son))
            signal(father,s_kill);      // Eliminates previous process
            kill_jack();              // Kills Jack
        END

        // Checks for collision with heads' shots
        IF (collision(TYPE head_shot))
            signal(father,s_kill);      // Eliminates previous process
            kill_jack();              // Kills Jack
        END

        // Checks for collision with spikes ball
        IF (collision(TYPE ball_end))
            signal(father,s_kill);      // Eliminates previous process
            kill_jack();              // Kills Jack
         END

        // Refreshes internal coordinates of scroll
        move_scroll(0);
        FRAME;
    END

END

//-----------------------------------------------------------------------------
// Process to invoke Jacks dead
//-----------------------------------------------------------------------------

PROCESS kill_jack()

PRIVATE
    incr_y=-12;                          // Variable for moving graphic little by lttle

BEGIN
    ctype=c_scroll;                      // Puts within scroll
    graph=116;                           // Puts adequate graphic
    priority=1;                          // Gives it maximum priority
    signal(father,s_sleep);              // Puts to sleep father's process (Jack's one)
    x=father.x;                          // Takes Jack's x (father process)
    y=father.y;                          // Takes y

    // If on level one
    IF (level==1)
        scroll.camera=id;                // Makes camera follow Jack
    END
    y-=12;                               // Moves character downwards

    REPEAT
        y+=incr_y;                           // Keeps on moving graphic downwards
        incr_y++;                            // Each time slower
        angle+=pi/16;                        // At the same time it rotates
        size+=4;                             // And is 'zoomed' or rescaled
        FRAME;
    UNTIL (out_region(id,0));                // While it is not out of the screen
    // Fades screen off, if there are lifes left
    IF (lifes>0)
        fade_off();
    ELSE
        mainid.x=father.x;
        mainid.y=father.y;
        scroll.camera=mainid;
    END
    lifes--;
    IF (lifes>-1)                       // If no lifes left
        SWITCH (level)                  // Depending on level
            CASE 1:

                SWITCH(father.x)         // And the place he reached on level
                    CASE 0..799:         // creates a new character
                        jack(8,0);       // on the proper possition
                    END
                    CASE 800..1959:
                        jack(800,0);
                    END
                    CASE 1960..2531:
                        jack(1960,0);
                    END
                    CASE 2532..3283:
                        jack(2532,0);
                    END
                    DEFAULT:
                        jack(3284,0);
                    END
                END
            END
            CASE 2:
                SWITCH(father.y)
                    CASE 0..390:
                        jack(203,422);
                    END
                    CASE 391..950:
                        jack(68,921);
                    END
                    CASE 951..1400:
                        jack(72,1392);
                    END
                    CASE 1401..2000:
                        jack(8,1971);
                    END
                END
            END
        END
        signal(father,s_kill);          // Eliminates previous character
        //Fades screen on
        fade_on();
    ELSE
        signal(TYPE energy_bar,s_kill_tree); // Eliminates final stage bar
    END                                         // if needed

END

//-----------------------------------------------------------------------------
// Process to invoke special Jack's dead
// when fighting final boss monster that shoots bombs
//-----------------------------------------------------------------------------

PROCESS kill_jack2();

PRIVATE
    id2;                      // Identifier for previous character
    incr_y=-12;               // Variable for moving graphic down little by little


BEGIN

    ctype=c_scroll;           // Puts graphic within scroll
    graph=116;                // Takes 'dead' graphic
    id2=get_id(TYPE jack);    // Takes character's identifier
    signal(id2,s_sleep);      // And puts it to sleep
    x=id2.x;                  // Takes Jack's x
    y=id2.y-12;               // And y, but a little bit down

    REPEAT
        y+=incr_y;                // Moves graphic downwards
        incr_y++;                 // Each time slower
        angle+=pi/16;             // Rotates graphic
        size+=4;                  // And rescales it
        FRAME;
    UNTIL (out_region(id,0))      // Until it gets out of the screen
    // Fades screen off if lifes left
    IF (lifes>0)
        fade_off();
    ELSE
        mainid.x=father.x;
        mainid.y=father.y;
        scroll.camera=mainid;
    END
    lifes--;                  // Takes a life off
    IF (lifes>-1)             // And if you still have lifes left
        fade_on();            // Fades screen on
        jack(320,0);          // Creates a new character
        signal(id2,s_kill);   // And eliminates previous one
    ELSE
        signal(TYPE energy_bar,s_kill_tree); // If the game is finished
    END                                         // quits final boss' energy bar
END

//-----------------------------------------------------------------------------
// Process used to calculate floors and character's gravity
//-----------------------------------------------------------------------------

PROCESS gravity();

PRIVATE
    vgravity;        // Variable for gravity temporary storing

BEGIN
    // Takes coordinate after character's gravity (father)
    vgravity=(father.gravity_speed+=2);   // But incremented by 2
    IF (vgravity>16)                      // If higher than 16
        father.gravity_speed=16;          // Makes character's gravity equal to 16
        vgravity=16;                      // And the temporary variable too
    END

    IF (vgravity<0)                        // If gravity is negative
        WHILE (vgravity++!=0)              // While not zero, increments it
            // If not, the ceiling is touched
            IF (map_get_pixel(1,2,father.x/2,(father.y-24)/2)<>252)
                father.y--;                 // Makes Jack go up
            ELSE                            // If not, sets gravity to zero
                father.gravity_speed=0;
                BREAK;
            END
        END
    ELSE                                   // If gravity is zero or positive
        father.y+=vgravity;                // Jack's coordinates are added
        // Checks vertical range of Jack's movement
        FROM vgravity=-16 TO 7 STEP 2;     // Ends process if floor is touched
            IF (map_get_pixel(1,2,father.x/2,(father.y+vgravity)/2)==136)
                BREAK;                      // Exit if floor is touched
            END
        END
        IF (vgravity<8)                    // If floor is collided
            father.y+=vgravity;            // Refreshes with maximum available for movement
            father.gravity_speed=0;        // And gravity is set to 0
        END
    END

END

//-----------------------------------------------------------------------------
// Process used to check if floor is being touched
// Returns: True/False, Depending if floor is touched or not
//-----------------------------------------------------------------------------

PROCESS on_screen()

BEGIN

    IF (map_get_pixel(1,2,father.x/2,father.y/2)==136)
        RETURN(TRUE);   // If floor is touched, returns true
    ELSE
        RETURN(FALSE);  // If not, returns false
    END

END

//-----------------------------------------------------------------------------
// Process for first plane objects
// Entries: 'graph'        number of graphic
//          'relativex'    relative horizontal possition (x) of
//                         graphic compared to scroll
//-----------------------------------------------------------------------------

PROCESS first_plane(graph,relativex);

BEGIN
    file=1;
    LOOP
        y=400-scroll.y0*2;
        x=(relativex-scroll.x0)*2;  // Finds relative possition respect scroll's
        FRAME;
    END
END

//-----------------------------------------------------------------------------
// Process used to print objects that overlap other objects
// Entries: 'file'  graphics file used
//          'graph' number of graphic
//          'x' 'y' Graphic's coordinates 'x' and 'y'
//          'z'     Graphic's depth on screen
//          'ctype' Variable used to check it is within scroll
//-----------------------------------------------------------------------------

PROCESS object(file,graph,x,y,z,ctype);

BEGIN
    LOOP
        FRAME;
    END
END

//-----------------------------------------------------------------------------
// Process used to put bonuses' objects
// Entries: 'x' 'y' objects' coordinates
//-----------------------------------------------------------------------------

PROCESS p_bonus(x,y);

BEGIN
    ctype=c_scroll;         // Puts it within scroll
    graph=216;              // Puts initial graphic of object

    LOOP                    // Plays graphics' animation
        graph++;
        IF (graph>220)
            graph=216;
        END
        FRAME;
    END
END

//-----------------------------------------------------------------------------
// Process used to put stars' objects
// Entries: 'x' 'y' Initial stars' coordinates
//-----------------------------------------------------------------------------

PROCESS stars(x,y);

PRIVATE
    incr_x;                // Horizontal increment
    n_stars;               // Number of stars (counter)

BEGIN
    ctype=c_scroll;            // Puts within scroll
    graph=200;                 // Puts initial star's graphic

    FROM n_stars=0 TO 11;            // Creates 12 stars equally
        CLONE
            BREAK;
        END
    END

    incr_x=rand(-6,6);             // Chooses randomly an horizontal increment
    gravity_speed=rand(-24,-8);    // And vertical too
    n_stars=32;

    WHILE (n_stars-->0);          // While there are stars left (n_stars= number of stars)
        // Plays graphics' animation
        graph++;
        IF (graph>204) graph=200; END
        x+=incr_x;              // Moves stars horizontally
        y+=gravity_speed;       // And vertically
        gravity_speed+=2;       // And reduces vertical increment (gravity)
        FRAME;
    END

END

//-----------------------------------------------------------------------------
// Process used to put bears' objects
// Entries:  'x' 'y' Objects' coordinates
//           'incr_x' Horizontal increment (to the left and right)
//-----------------------------------------------------------------------------

PROCESS bear(x,y,incr_x);

BEGIN
    graph=300;      // Number of graphic
    ctype=c_scroll; // Puts it within scroll
    LOOP

        // Plays a bear sound from time to time (randomly)
        IF (rand(0,48)==0) play_sound(s_bear,50,256); END
        x+=incr_x;             // Moves graphic horizontally

        // If the end of platform has been reached
        IF (NOT on_screen())
            incr_x=-incr_x;        // Changes horizontal increment
            x+=incr_x*2;           // Moves the graphic a little bit
            // Turns graphic to the opposite side
            IF (flags==0)
                flags=1;
            ELSE
                flags=0;
            END
        END

        // Plays graphics' animation
        graph++;
            IF (graph>304) graph=300; END
        FRAME;
    END
END

//-----------------------------------------------------------------------------
// Process used to put pumpkins' objects
// Entries: 'x'        Object's x coordinates
//          'last_y'   Special object's y coordinate
//          'incr_x'   Horizontal increment (direction left/right)
//-----------------------------------------------------------------------------

PROCESS pumpkin(x,last_y,incr_x);

PRIVATE
    anim;                   // Makes animation to be intermittent
    jump=-5;                // Variable to process pumpkin's jumps
    y_temp;                 // Temporary variable for y

BEGIN
    graph=340;              // Selects initial graphic
    ctype=c_scroll;         // Introduces object within scroll
    y=last_y;               // Loads 'y' with process' entry ('y' special)

    LOOP
        // Plays bear's sound from time to time (rand)
        IF (rand(0,48)==0) play_sound(s_bear,30,512); END
        x+=incr_x;          // Moves graphic horizontally
        y_temp=y;           // Stores 'y' temporaly to check platforms
        y=last_y;           // And loads it with initial 'y'

        // If it gets out of the platform where it is
        IF (NOT on_screen())
            incr_x=-incr_x;         // Changes direction
            x+=incr_x*2;            // And moves it a bit
        END

        y=y_temp;          // Restores refreshed 'y'
        y+=jump;           // Adds jump to 'y'
        jump++;            // Increments 'y' to move graphic
        IF (jump==6)       // Checks if limit has been reached
            jump=-5;       // To start again
        END


        IF (anim)           // Checks if it must animate the graphic
            graph++;        // Animates graphics
            IF (graph>344)
                graph=340;
            END
        END

        anim=NOT anim;      // Makes animation a little bit slower
        FRAME;
    END
END

//-----------------------------------------------------------------------------
// Process used for shooting heads' objects
// Entries: 'x' 'y'    Graphic's coordinates
//          'flags'    Direcci¢n hacia donde mira el gr fico
//          'f_pause'  Number of frames it is paused
//-----------------------------------------------------------------------------

PROCESS head(x,y,flags,f_pause);

BEGIN
    ctype=c_scroll;                 // Puts it within scroll
    z=2;                            // Puts it over other graphics

    LOOP
        graph=350;                  // Selects initial graphic
        FRAME(f_pause*100);         // Waits indicated frames (f_pause=frames)

        WHILE (graph<355)           // Animates it until reaches limit
            graph++;
            FRAME(200);             // Waits two frames
        END

        // Plays sound of horizontal drops shooting
        play_sound(s_touch,20,768);
        // Makes horizontal drops shots
        head_shot(x+20-flags*40,y,4-flags*8,flags);
    END

END

//-----------------------------------------------------------------------------
// Process used for horizontal drops shooting
// Entries: 'x' 'y' Objects coordinates
//          'incx'  Horizontal incremento (direction)
//          'flags' Position to which graphic is facing
//                  horizontally
//-----------------------------------------------------------------------------

PROCESS head_shot(x,y,incx,flags);

BEGIN
    ctype=c_scroll;               // Puts it within scroll
    graph=356;                    // Select appropiate graphic

    REPEAT
        x+=incx;                  // Moves it horizontally
        FRAME;
    UNTIL (out_region(id,0))      // Until it gets out of screen

END

//-----------------------------------------------------------------------------
// Process used for bees and ghost objects
// Entries:  'gr'            Type of graphic (bee/ghost)
//           'flags'         Type of transparency
//           'relativex'     Reference 'x' position
//           'relativey'     Reference 'y' position
//           'incx' 'incy'   Frecuency of turn on both axis
//           'distx' 'disty' Distance of turn on both axis
//-----------------------------------------------------------------------------

PROCESS flying(gr,flags,relativex,relativey,incx,incy,distx,disty);

PRIVATE
    angle3;
    id2;

BEGIN
    graph=gr;            // Selects initial graphic
    ctype=c_scroll;      // Puts within scroll

    LOOP
        // Plays a sound from time to time
        IF (rand(0,48)==0)
            // Ghost's sound
            IF (flags==4)
                play_sound(s_ghost,50,256);
            // Bee's sound
            ELSE
                play_sound(s_bee,150,256);
            END
        END

        angle2+=pi/incx;                 // Finds size increments
        angle3+=pi/incy;                 // that will be done on both coordinates
        x=relativex+get_distx(angle2,distx);    // Increments x coordinate
        y=relativey+get_disty(angle3,disty);    // Increments y coordinate

        // Plays graphics' animation
        graph++;
        IF (graph==gr+6)
            graph=gr;
        END
        FRAME;
    END
END

//-----------------------------------------------------------------------------
// Process used for bubble's objects
// Entries: 'x' 'y' Objects coordinates on screen
//-----------------------------------------------------------------------------

PROCESS bubble(x,y);

BEGIN
    z=64;                // Puts graphics a little bit behind
                         // so they are overlapped by cauldron
    graph=430;           // Selects graphic
    ctype=c_scroll;      // Puts it within scroll
    WHILE (size>0)       // While size (rescaling) is greater thab zero
        y-=2;            // Moves object upwards
        size-=2;         // And reduces it's size
        FRAME;
    END
END

//-----------------------------------------------------------------------------
// Process used for fish's objects
// Entries:  'x'  Object's horizontal coordinate
//           'relativey' Graphic's special vertical coordinate
//-----------------------------------------------------------------------------

PROCESS fish(x,relativey);

PRIVATE
    incr_y;                 // Graphic's vertical increment

BEGIN
    z=-10;
    splash(x,relativey);  // Puts a splash of water
    graph=410;              // Takes initial fish graphic
    ctype=c_scroll;         // Puts it within scroll
    y=relativey;            // Refreshes with process' entry
    incr_y=-12;             // Initializes increment (upwards)
    // Plays fishes' sound
    play_sound(s_fish,25,512);

    // While movement limit is not reached
    WHILE (incr_y<12)
        // Plays graphic's animation, while moving (incr_y<>0)
        IF (incr_y AND graph<416)
            graph++;
        END
        y+=incr_y;          // Moves graphic vertically
        incr_y++;           // Refreshes vertical increment
        FRAME;
    END
    splash(x,relativey);  // Puts a splash of water
END

//-----------------------------------------------------------------------------
// Process used to play sounds
// Entries: 'x'          Sound's identifier
//          'volume'    Sound's volume
//          'frecuency' Sound's frecuency
//-----------------------------------------------------------------------------

PROCESS play_sound(x,volume,frecuency);

BEGIN
    // If graphic is on screen, plays sound
    IF (NOT (out_region(father,0)))
        sound(x,volume,frecuency);
    END
END

//------------------------------------------------------------------------------
// Process used to put splash objects
// Entraies: 'x' 'y' Object's coordinates
//------------------------------------------------------------------------------

PROCESS splash(x,y);

BEGIN
    ctype=c_scroll;     // Put within scroll
    // Plays graphic's animation
    FROM graph=400 TO 405;
        FRAME(200);     // Waits two frames
    END
END

//-----------------------------------------------------------------------------
// Process used for spider's objects
// Entries: 'x' 'y'    Object's coordinates
//           'height'  Object's height
//-----------------------------------------------------------------------------

PROCESS spider(x,y,height);

PRIVATE
    counter;                       // General purpouse counter

BEGIN
    z=-11;
    ctype=c_scroll;                // Puts it within graphic
    graph=330;                     // Selects initial graphic
    height=(height/4)*4;           // Makes height multiple of four

    LOOP
        FROM counter=0 TO 47;
            // Plays spider animation from time to time (rand)
            IF (rand(0,10)==0)
                graph++;
                IF (graph>335) graph=330; END
            END
            FRAME;
        END

        // Plays spider's sound
        play_sound(s_spider,200,256);
        // Moves object downwards 4 by 4 with the graphic static
        FOR (counter=0;counter<height;counter+=4);
            y+=4;
            FRAME;
        END

        // Moves object upwards 1 by 1 with the graphic animated
        FOR (counter=0;counter<height;counter++);
            y--;
            ++graph;
            IF (graph>335)
                graph=330;
            END
            FRAME;
        END
    END
END

//-----------------------------------------------------------------------------
// Process used for chains' objects
// Entries: 'x' 'y'  Objects coordinates
//          'ang'    Object's initial angle
//          'iang'   Increment speed within angle
//          'focus'  Total angle size (min-max)
//-----------------------------------------------------------------------------

PROCESS chain(x,y,ang,iang,focus);

BEGIN
    priority=10;      // Sets a lower priority than platform's
    ctype=c_scroll;   // Puts graphic within scroll
    file=1;           // Selects graphics' file 1
    graph=14;         // Takes chain graphic
    z=20;             // Puts graphic behind platform
    platform();       // Creates a platform

    LOOP
        ang+=iang;    // Increments angle
        // Takes cos angle to make a pendular movement with different velocities
        angle=get_distx(ang,focus);
        FRAME;
    END

END

//-----------------------------------------------------------------------------
// Process used for platform objects
//-----------------------------------------------------------------------------

PROCESS platform()

BEGIN
    priority=9;         // Sets higher priority than chain's one
    ctype=c_scroll;     // Puts object within scroll
    file=1;             // Uses graphics file 1
    graph=15;           // Takes platform graphic
    z=19;               // Puts graphic over chain

    LOOP
        // Takes platform coordinates respect chain's ones
        speed=father.x+get_distx(father.angle-pi/2,130)-x;
        x+=speed;
        y=father.y+get_disty(father.angle-pi/2,130);
        FRAME;
    END

END

//-----------------------------------------------------------------------------
// Process for metallic platform objects
// Entries: 'x1' 'y1' Initial platform coordinates
//          'x2' 'y2' Final platform coordinates
//          'istep'   % increment (speed)
//-----------------------------------------------------------------------------

PROCESS metal_platform(x1,y1,x2,y2,istep);

PRIVATE
    _step;           // Process movement counter (indicates where on the animation it is)

BEGIN
    priority=10;     // Gives a low priority
    ctype=c_scroll;  // Puts graphic within scroll
    file=1;          // Selects graphics file 1
    graph=16;        // Selects metallic platform graphic
    x=x1;            // Introduces initial coordinates
    y=y1;

    LOOP
        // Refreshes new coordinates
        x=(x1*_step+x2*(100-_step))/100;
        y=(y1*_step+y2*(100-_step))/100;
        // Adds the necessary increment
        _step+=istep;
        // If 100% has been reached
        IF (_step MOD 100==0)
            istep=-istep;               // Changes direction
            play_sound(s_star,12,512);  // Plays stars' sound
        END
    FRAME;
    END

END

//-----------------------------------------------------------------------------
// Process used for first level final boss monster object
//-----------------------------------------------------------------------------

PROCESS malvado_son();

PRIVATE
    counter;                       // General purpouse counter
    regionx=96;                    // Necessary for screen centering

BEGIN
    file=1;                        // Selects first graphics' file
    ctype=c_scroll;                // Introduces graphic within scroll
    x=3800;                        // Takes coordinates
    y=261;
    z=8;                           // Chooses depth (behind)
    graph=104;                     // Chooses initial graphic
    malvado_son_head();         // Creates monster's head

    // Modifies scroll's movement region
    // to center it, with monster, on the center of screen
    WHILE (regionx<160); // Modifies it little by little (smoothly)
        define_region(1,++regionx,100,1,1);
        FRAME;
    END

    LOOP
        graph=104;                  // Selects initial graphic
        flags=0;                    // With no mirror at all
        FRAME(5000);                // Puts the graphic and waits 50 frames (1 sec)
        graph=105;                  // Puts graphic of shooting ball
        FRAME(400);                 // Prints it and waits 4 frames
        graph=106;                  // Puts graphic of shooted ball
        ball(x-16,y-30,-6);         // Creates fire ball
        FRAME(400);                 // Waits 4 frames
        graph=105;                  // Puts the recovering graphic
        FRAME(400);                 // Waits 4 frames
        graph=104;                  // Puts initial graphic
        FRAME(5000);                // Waits 50 frames
        graph=107;                  // Puts ready to jump graphic
        // Moves graphic (jumps)
        FROM counter=-16 TO 16;
            y+=counter;
            x-=10;
            FRAME;
        END
        // Plays touch sound
        sound(s_touch,150,256);
        graph=104;                 // Initial graphic
        flags=1;                   // Mirrors so it faces Jack
        FRAME(5000);               // Repeats previous process
        graph=105;
        FRAME(400);
        graph=106;
        ball(x+16,y-30,6);
        FRAME(400);
        graph=105;
        FRAME(400);
        graph=104;
        FRAME(5000);
        graph=107;
        FROM counter=-16 TO 16;
            y+=counter;
            x+=10;
            FRAME;
        END
        // Touch sound played
        sound(s_touch,150,256);
    END
END

//-----------------------------------------------------------------------------
// Process used for first level monster's head object
//-----------------------------------------------------------------------------

PROCESS malvado_son_head();

PRIVATE
    angle0;                            // Variable used to move head in an alliptical way
    id2;                               // Jack's identifier and monster's body at the end (when monster is dead)
    // Creates a variable chain of 50 positions for graphics animation
    anim[]=40 DUP (100),101,101,102,102,103,103,102,102,101,101;
    ianim;                             // Counter inside chain animation
    incy=0;                            // Variable used to move head up and down
                                       // when Jack touches it and eliminates body
                                       // when the level is over
BEGIN
    file=1;                            // Selects graphics file 1
    graph=100;                         // Puts initial graphic
    ctype=c_scroll;                    // Puts it within scroll
    z=4;                               // Depth over body, and behind Jack
    REPEAT
        // Puts head backwards respect body, to place it
        IF (father.flags==1) flags=0; ELSE flags=1; END
        x=father.x+get_distx(angle0,6);   // Takes coordinates respect body
        y=father.y-70+get_disty(angle0,4);// But with an elliptical movement
        graph=anim[ianim];                // Takes the necessary graphic for the animation
        ianim=(ianim+1) mod 50;           // Increments counter within chain animation

        // Plays bear's sound after 40 animations
        IF (ianim==40) sound(s_bear,100,128); END
        angle0+=pi/48;

        // Checks if Jack has been touched
        IF (id2=collision(TYPE jack))
            // If Jack is higher than monster
            // and if Jack is alive
            IF (id2.death AND id2.y<=y)
                incy=64;                   // Moves down monster's head
                id2.gravity_speed=-26;     // Changes gravity
                score++;                   // Adds points
                energy_enemy--;            // Subtracts energy to monster
                stars(x,y);                // Puts 'wonderful' stars
                sound(s_bubble,100,256);   // Plays bubble's sound
            END
        END

        // Moves monster's head up, if this was down
        IF (incy>0)
            y+=incy/2;
            FRAME;
            incy--;
        ELSE
            FRAME;
        END
    UNTIL (energy_enemy==0)      // Repeats while monster has energy left

    s_malvado=load_pcm("malvado\malvado.pcm",0); // Malvado's death sound
    // Creates monster's body
    id2=object(1,104,father.x,father.y,8,1);
    signal(father,s_kill);      // And eliminates previous body
    incy=-24;                   // Increments y body coordinate
    sound(s_malvado,128,256);   // Plays sound
    REPEAT
        id2.y+=(incy/2);             // Moves body
        incy++;                      // Reduces falling speed
        y=id2.y-56;                  // Moves head
        IF (incy MOD 8==0)           // Creates stars every 8 animation
            stars(x,y);
        END
        FRAME;
    UNTIL (y>350);                   // While head doesn't reach the floor

    // Sets variable to one, to indicate that the level is over
    level_end=true;
END


//-----------------------------------------------------------------------------
// Process used for level three final monster's object
//-----------------------------------------------------------------------------
PROCESS malvado();

PRIVATE
    counter;                      // General purpouse counter
    headid;                       // Identifier for monster's head

BEGIN
    file=1;                         // Takes graphics file 1
    ctype=c_scroll;                 // Puts object within scroll
    x=552;                          // Initializes object's coordinates
    y=230;
    z=8;                            // Puts body behind (depth) head
    headid=malvado_head();        // Creates monster's head

    LOOP
        graph=200;                 // Puts initial graphic
        flags=0;                   // Puts it facing Jack (by default)
        FRAME(5000);               // Waits 50 frames (1 sec aprox.)
        graph=203;                 // Changes graphic to animate it
        FRAME(300);                // Waits 3 frames
        graph=204;                 // Changes graphic to animate it
        FRAME(300);                // Waits 3 frames
        graph=205;                 // Changes graphic of monster shooting bombs
        bomb(x-38,y+24,-6);       // Creates a bomb object
        FRAME(400);                // Waits 4 frames
        graph=200;                 // Changes graphic to animate it (initial)
        FRAME(5000);               // Waits 50 frames
        graph=201;                 // Changes graphic
        headid.graph=101;          // Changes monster's head graphic
        FROM counter=-16 TO 16;
            // If it is at the middle of animation
            IF (counter==0)
                graph=202;              // Changes body graphic
                headid.graph=102;       // Changes head graphic
            END
            // Moves monster (jump)
            y+=counter;
            x-=14;
            FRAME;
        END

        headid.graph=100;           // Changes head's graphic
        sound(s_touch,150,256);     // Plays touch sound
        graph=200;                  // Initial graphic
        flags=1;                    // Puts it facing Jack
        FRAME(5000);                // Repeats previous animation
        graph=203;
        FRAME(300);
        graph=204;
        FRAME(300);
        graph=205;
        bomb(x+38,y+24,6);         // Creates bomb
        FRAME(400);
        graph=200;
        FRAME(5000);
        // Jumps again to the other side
        graph=201;
        headid.graph=101;
        FROM counter=-16 TO 16;
            IF (counter==0)
                graph=202;
                headid.graph=102;
            END
            y+=counter;
            x+=14;
            FRAME;
        END

        headid.graph=100;
        // Plays touch sound
        sound(s_touch,150,256);
    END
END


//-----------------------------------------------------------------------------
// Process used for monster's head object
//-----------------------------------------------------------------------------


PROCESS malvado_head();

PRIVATE
    angle0;                                  // For elliptical movement
    id2;                                     // Identifier for creating a new body
    incy;                                    // To put head down and eliminate monster at the end
                                             // if Jack touches it or kills him
BEGIN
    file=1;                                  // Selects graphics file 1
    graph=100;                               // Selects initial graphic
    ctype=c_scroll;                          // Puts object within scroll
    z=4;                                     // Puts head over body

    REPEAT
        flags=father.flags;                         // Takes body position (left/right)
        x=father.x-18+flags*36+get_distx(angle0,6); // Takes coordinates respect body's ones
        y=father.y-32+get_disty(angle0,4);          // but with an elliptical movement
        angle0+=pi/48;                              // Increments elliptical movement
        FRAME;
    UNTIL (energy_enemy==0)                      // While monster has energy

    s_malvado=load_pcm("malvado\malvado.pcm",0); // Plays Malvado's death sound
    // Creates a new monster body
    id2=object(1,202,father.x,father.y,8,1);
    // To eliminate body's head
    signal(father,s_kill);
    incy=-24;                  // Selects downwards speed (increment)
    graph=103;                 // Selects a graphic of dead head
    flags=0;                   // Eliminates any type of mirror effect
    sound(s_malvado,100,256);  // Plays sound
    REPEAT
        id2.y+=incy/2;         // Moves body (downwards)
        incy++;                // Each time slower
        y=id2.y-32;            // Moves head downwards
        x=id2.x-18;            // And leftwards
        // Puts stars each 8 animations
        IF (incy mod 8==0)
            stars(x,y);
        END
        FRAME;
    UNTIL (y>350);             // Repeats while head doesn't touch floor
    level_end=true;            // Indicates that the level is over
END

//-----------------------------------------------------------------------------
// Process used for balls level1's monster throws
// Entries: 'x' 'y'      Objects coordinates
//          'incr_x'     Movement increment (left/right)
//-----------------------------------------------------------------------------

PROCESS ball(x,y,incr_x);

BEGIN
    file=1;                             // Selects graphics file 1
    graph=108;                          // Puts fire ball graphic
    ctype=c_scroll;                     // Puts it within scroll
    z=4;                                // Before body and head, and behind Jack
    sound(s_touch,100,128);             // Plays touch sound

    REPEAT
        x+=incr_x;                      // Moves object
        graph++;
        // Plays graphics' animation
        IF(graph>110) graph=108; END
        FRAME;
    UNTIL (x<3000 OR x>4000)            // Repeats until it gets out of screen

END

//-----------------------------------------------------------------------------
// Process used for bombs thrown by level3's monster
// Entries: 'x' 'y' Objects coordinates
//          'inc'   Horizontal increment (left/right)
//-----------------------------------------------------------------------------


PROCESS bomb(x,y,incr_x);

PRIVATE
    incr_y;                             // Bomb's vertical position
    iymax;                              // Bomb's maximum vertical position
    id2;                                // Identifier for collisions
    _touch=false;                       // Variable used to check the bomb was thrown by the monster
                                        // or Jack

BEGIN
    file=1;                             // Selects graphics file 1
    graph=300;                          // Puts initial graphic
    ctype=c_scroll;                     // Puts it within scroll
    z=4;                                // Puts it behind Jack and over monster
    iymax=rand(-10,-22);                // Random maximum height for bomb
    incr_y=iymax;                       // Starts on maximum height
    sound(s_touch,50,128);              // Plays touch sound

    REPEAT
        y+=incr_y;                      // Moves bomb
        incr_y+=2;
        // Makes bomb bounce
        IF (incr_y>-iymax)
            iymax+=2;
            incr_y=iymax;
            sound(s_touch,25,768);      // Plays touch sound
        END
        x+=incr_x;

        // If the bomb was thrown by the monster
        IF (NOT _touch)
            // If Jack touches it
            IF (id2=collision(TYPE jack))
                _touch=TRUE;
                // If Jack is alive
                IF (id2.death)
                    incr_x=-incr_x;            // Changes bomb's direction
                    id2.gravity_speed=-20;     // Makes Jack bounce
                    stars(x,y);                // Puts stars
                    score++;                   // Adds score
                    sound(s_bubble,25,512);    // Puts bubble sound
                ELSE
                    kill_jack2();              // If not, Jack dies
                END
            END
        END

        // Bomb touches monster, and subtracts him energy
        IF (id2=collision(TYPE malvado))
            energy_enemy--;
            BREAK;
        END

        FRAME;
    // Repeats process until bomb is out of screen
    UNTIL (x<64 OR x>640-64 OR iymax>=0)

    // Plays touch sound
    sound(s_touch,200,128);
    // Plays animation
    FROM graph=301 TO 309;
        frame(200);                             // Waits two frames per graphic
    END

END

//-----------------------------------------------------------------------------
// Process used for fire's object
// Entries: 'x' 'y' Objects coordinates
//          'inc'   Maximum movement object will do
//-----------------------------------------------------------------------------

PROCESS fire(x,y,inc)

PRIVATE
    counter;                            // General purpouse counter

BEGIN
    ctype=c_scroll;                     // Puts graphic within scroll
    LOOP
        graph=0;                        // Selects a null graphic
        flags=0;                        // With no mirror effect type at all
        FROM counter=0 TO 23;           // Puts 24 graphics
            FRAME;
        END

        graph=420;                      // Selects initial graphic
        play_sound(s_touch,50,128);     // Plays touch sound

        FOR (counter=-inc;counter<=inc;counter++);        // Moves up to increment
            IF (graph==420)             // Alternates graphics
                graph=421;              // If it is not there, puts it
            ELSE                        // And if it is ther
                graph=420;              // Eliminates it
            END
            IF (counter==1)             // If top was reached
                flags=2;                // Turns graphic upside-down (facing down)
            END
            FRAME;
            y+=counter;                // Moves object
        END

    END
END

//-----------------------------------------------------------------------------
// Process used for bar energy's object
//-----------------------------------------------------------------------------

PROCESS energy_bar();

BEGIN
    graph=10;                               // Selects initial graphic
    x=160;                                  // Puts coordinates
    y=220;
    z=-9;                                   // Puts energy bar over all graphics

    WHILE (energy_enemy>0)                  // While there is any energy left
        // Rises energy bar from outside of screen to it's position
        IF (y>190)
            y--;
        ELSE
          IF (region!=10)                   // If it doesn't have a region, creates one
            region=10;
            object(0,11,160,190,-10,0);     // Creates the empty bar behind
          END
        END
        // Defines region respect energy bar's size
        // so you only see the area that represents it
        define_region(10,120,185,1+energy_enemy*5,10);
        FRAME;
    END

    // Eliminates the process of the bar that is behind (empty bar)
    signal(son,s_kill);
END

//-----------------------------------------------------------------------------
// Process used for spike ball's object
// Entries: 'x' 'y' Object's coordinates
//-----------------------------------------------------------------------------

PROCESS spikes_ball(x,y)

BEGIN
    file=1;                    // Selects graphics file 1
    graph=20;                  // Selects initial graphic
    ctype=c_scroll;            // Puts object within scroll
    priority=100;              // Sets a low priority to connect with chain
    chain_ball(id,20);        // Creates spikes chain
    z=-20;                     // Puts it over the screen

    LOOP
        angle2+=pi/64;         // Moves the chain and the spikes ball
        FRAME;
    END

END

//-----------------------------------------------------------------------------
// Process used for the chain object that links with spikes ball
// Entries: '_first'     Identifier to the link point
//          '_distance'  Distance to link
//-----------------------------------------------------------------------------

PROCESS chain_ball(_first,_distance)

BEGIN
    file=1;                             // Selects graphics file 1
    graph=21;                           // Selects initial graphic
    ctype=c_scroll;                     // Puts object within scroll
    z=-10;                              // Puts chain behind link

    IF (_distance<80)                     // If remaining size is enough big
        chain_ball(_first,_distance+20);  // Creates another chainball
    ELSE
        ball_end(_first,_distance+32);   // If not, creates the final spikes ball
    END

    LOOP
        angle2=_first.angle2;                     // Takes link angle
        x=_first.x+get_distx(angle2,_distance);   // Finds coordinates after
        y=_first.y+get_disty(angle2,_distance);   // link and angle
        FRAME;
    END

END

//-----------------------------------------------------------------------------
// Process used for the final spikes ball object
// Entries: '_first'     Identifier to the link point
//          '_distance'  Distance to link
//-----------------------------------------------------------------------------

PROCESS ball_end(_first,_distance)

BEGIN
    file=1;                                      // Selects graphics file 1
    graph=22;                                    // Puts initial graphic
    ctype=c_scroll;                              // within scroll
    z=-20;                                       // Before chain

    LOOP
        angle2=_first.angle2;                    // Takes link angle
        x=_first.x+get_distx(angle2,_distance);  // Refreshes coordinates after
        y=_first.y+get_disty(angle2,_distance);  // the distance to link and the angle
        // Plays stars' sound
        play_sound(s_star,10,768);
        FRAME;
    END

END
