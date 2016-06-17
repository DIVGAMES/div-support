
//------------------------------------------------------------------------------
// TITLE:       FOSTIATOR
// AUTHOR:      DANIEL NAVARRO
// DATE:        DIV GAMES STUDIO (c) 2000
//------------------------------------------------------------------------------

PROGRAM fostiator;

CONST
    // Different characters' states
    _quiet=0;
    _forwarding=1;
    _backwarding=2;
    _crouching=3;
    _crouched=4;
    _standing_up=5;
    _jumping=6;
    _low_punch=7;
    _punch=8;
    _turning_kick=9;
    _normal_kick=10;
    _flying_kick=11;
    _touched=12;
    _dead=13;

    // Different characters' positions
    jump=0;
    crouch=1;
    forward=2;
    backward=3;
    hit=4;

    // Type of character's control
    keyboard_control1=1;
    keyboard_control2=2;
    computer_control=0;

    default_fps=30; // Number of frames per second

GLOBAL
    // Animation sequence for each one of the characters' states
    anim0[]=1,1,1,14,14,15,15,16,16,17,17,17,16,16,15,15,14,14;
    anim1[]=1,2,3,4,5,6,7,8;
    anim2[]=1,8,7,6,5,4,3,2;
    anim3[]=8,9,10,11,12,13;
    anim4[]=13;
    anim5[]=13,12,11,10,9,8;
    anim6[]=18,19,20,21,21,22,22,22,22,23,23,23,23,24,24,24,24,24,24,24,24;
    anim7[]=52,54,54,54,54,53,53,52,51;
    anim8[]=25,26,27,28,28,28,28,27,27,26,25;
    anim9[]=29,30,31,32,33,33,34,35,36,37,38,39;
    anim10[]=29,30,31,32,32,32,31,31,30,30,29;
    anim11[]=18,19,20,21,21,22,22,24,40,41,41,41,41,41,41,41,41,41,41,41,41,41;
    anim12[]=1,42,42,43,43,42,42;
    anim13[]=1,42,42,43,43,44,44,45,45,46,46,47,47,48,48,49,49,50;

    s_hit1;        // Sounds' identifiers
    s_hit2;
    s_hit3;
    s_touched1;
    s_touched2;
    s_touched3;
    s_air1;
    s_air2;
    s_air3;
    s_air4;
    s_air5;
    s_dead;

    id_fighter1,id_fighter2;  // Identifier for both fighters
    id_auxiliary;             // Auxiliary identifier

    rounds1;      // Number of rounds won by the first player
    rounds2;      // Number of rounds won by the second player

    game_state;   // 0-quiet, 1-playing, 2-end of round

    scenary;      // fighting scenary 0 / 1

    fighter1=1;   // 0-Ripley, 1-Bishop, 2-Alien, 3-Nostromo
    fighter2=2;   // 0-Ripley, 1-Bishop, 2-Alien, 3-Nostromo

    level=1;      // Game's difficulty (0..2)
    mode;         // Game's mode (look at modes[])
    blood=1;      // Blood's level (look at bloods[])

    // Text for the round's options
    names[]="RIPLEY","BISHOP","ALIEN","NOSTROMO";
    scenaries[]="SCENARY 1 : IKA'S CASTLE","SCENARY 2 : THE CAVE","SCENARY 3: DESERT";
    levels[]="DIFFICULTY : EASY","DIFFICULTY : NORMAL","DIFFICULTY : HARD";
    modes[]="COMPUTER vs COMPUTER"," CURSOR KEYS vs COMPUTER",
            "QA-RT-X KEYS vs COMPUTER","QA-RT-X KEYS vs CURSOR KEYS";
    bloods[]="LEVEL OF BLOOD : NO BLOOD","LEVEL OF BLOOD : NORMAL","LEVEL OF BLOOD : EXTASIS";

    struct text[6] // Texts where the round's options are stored
        x,y;
        code;
    END = 320,480,0,
          320,90,0,
          320,120,0,
          320,150,0,
          100,364,0,
          320,364,0,
          540,364,0;

    option;         // Selected option from the menu
    previous_option;

    esc_pressed;    // Tells you if abort was made trhough ESC

    greys[255]=     // Colour convertion table to greys
        0,236,203,220,159,156,155,153,151,150,134,89,90,92,94,94,
        45,46,69,59,103,93,90,134,150,151,155,156,159,220,203,236,
        41,43,46,47,69,59,101,94,40,41,43,43,44,45,46,47,
        40,41,44,45,45,46,47,68,69,58,58,59,58,58,106,101,
        43,45,47,47,47,68,68,68,68,58,59,101,101,101,59,59,
        45,59,101,94,90,90,90,90,90,89,90,90,90,93,94,94,
        69,59,58,106,103,101,101,103,101,101,59,59,94,92,94,93,
        101,94,93,93,94,92,93,89,89,134,134,134,151,150,150,153,
        101,90,89,90,134,134,134,134,134,90,89,134,134,150,150,151,
        103,134,134,134,150,150,150,151,153,153,153,155,156,156,159,159,
        90,89,150,151,153,155,156,219,219,220,223,203,203,203,236,235,
        134,150,150,151,153,153,153,151,155,156,156,159,220,223,236,237,
        134,153,155,156,156,159,219,220,220,201,203,203,201,203,203,236,
        151,155,156,156,219,219,220,159,155,155,159,219,220,219,220,223,
        151,159,153,155,220,220,159,155,223,236,235,235,236,237,238,237,
        155,153,203,223,237,238,247,247,248,247,238,237,235,236,203,220;

    total_blood;   // Particles of blood that have remained on the map
    text_angle;    // Text movement on the options' menu

LOCAL
    state;          // Identifier of the current animation
    a_step;         // Step of the current animation
    inc_y,inc_x;    // Characters' shifts
    enemy;          // Enemy's identifier
    control_type;   // Device that controls the character
    energy;         // Character's energy

PRIVATE
    map_code1;    // Background screen loaded on that very moment
    map_code2;
    counter0;     // General purpouse counter
    text_id;

BEGIN
    set_mode(m640x480);     // Sets video mode
    max_process_time=1500;  // Leaves more time for the process to be executed
    priority=-10;           // Sets very low priority

    intro();                // Plays the game's intro
    FRAME;                  // Necessary to stop this process
    LOOP // Main loop

        set_fps(default_fps,0);     // Number of frames per second
        map_code1=load_map("fostiato\menu.map");  // Loads the menu's screen
        load_pal("fostiato\menu.map");
        put_screen(0,map_code1);  // Puts the menu's screen
        unload_map(map_code1);    // And discharges it from the memory, so you have more free...

        fade_on();          // Fades the screen on

        option=0;           // Initializes the options variable

        WHILE (option==0)   // Loop of the presentation menu
            IF (key(_1) OR key(_space) OR
                key (_enter)) option=1; END    // Game
            IF (key(_2) OR key (_esc)) option=2; END    // Exit
            FRAME;
        END

        fade_off();             // Fades the screen off

        IF (option==2)          // Choosed option: Exit the game
            credits();         // Shows the credits
            signal(id,s_kill);  // Eliminates this process
            FRAME;              // And stops.
        END

        // Loads the graphics for the options screen
        map_code1=load_map("fostiato\options.map");
        load_pal("fostiato\options.map");
        put_screen(0,map_code1);  // Puts the background graphic
        unload_map(map_code1);    // Discharges the graphic from memory

        option=0;                   // Initializes the options variable
        text_angle=0;               // Sets to zero the shift angle of the selected text
        show_information();         // Prints all the texts and graphics
        fade_on();                  // Fades the screen on

        LOOP
            // Moves the text that is selected on that very moment
            move_text(text[option].code,text[option].x+get_disty(text_angle,8),text[option].y);
            previous_option=option; // Saves the option, so it changes smoothly

            // Reads the keys
            IF (key(_right) OR key(_down))
                option++;
            END
            IF (key(_left) OR key(_up))
                option--;
            END

            // The option has changed to a new one
            IF (option<>previous_option)

                // Waits until it stops
                WHILE (get_disty(text_angle,8)<>0)
                    text_angle+=22500;
                    move_text(text[previous_option].code,
                              text[previous_option].x+get_disty(text_angle,8),
                              text[previous_option].y);
                    FRAME;
                END

                // Normalizes the options
                IF (option==7) option=0; END
                IF (option==-1) option=6; END

                // Waits for the key to be released
                WHILE (key(_right) OR key(_down) OR key(_left) OR key(_up))
                    FRAME;
                END
            ELSE
                text_angle+=22500;    // Keeps on moving the text
            END

            // An option has been chosen
            IF (key(_enter) OR key(_space) OR key (_control))
                SWITCH(option)

                    // Start the game
                    CASE 0: BREAK; END

                    // Game's mode (1/2 players)
                    CASE 1:
                        mode++;
                        IF (mode==4) mode=0; END
                    END

                    // Game's level (Easy/Hard)
                    CASE 2:
                        level++;
                        IF (level==3) level=0; END
                    END

                    // Level of blood printing
                    CASE 3:
                        blood++;
                        IF (blood==3) blood=0; END
                    END

                    // Selects player1's character
                    CASE 4:
                        fighter1++;
                        IF (fighter1==4) fighter1=0; END
                    END

                    // Selects the scenary
                    CASE 5:
                        scenary++;
                        IF (scenary==3) scenary=0; END
                    END

                    // Selects player2's character
                    CASE 6:
                        fighter2++;
                        IF (fighter2==4) fighter2=0; END
                    END
                END
                show_information();  //Refreshes the screen's information
                WHILE (key(_enter) OR key(_space) OR key (_control)) // Waits for the key to be released
                    FRAME;
                END
            END
            IF (key(_esc))    // The 'ESC' key has been pressed
                esc_pressed=1;// Sets the escape key pressed variable to 1
                BREAK;        // And gets out of the loop
            END
            FRAME;
        END

        IF (esc_pressed)    // Exits the options' menu if the 'ESC' key was pressed
            esc_pressed=0;  // Sets the variable to zero for the next time
            fade_off();     // Fades the screen off
            let_me_alone(); // Leaves only the main process (this one)
            delete_text(all_text);//Deletes any remaining text
            CONTINUE;       // Exits the next loop
        END
        // Loads all the needed graphics for the chosen scenary
        SWITCH (scenary)
            CASE 0:
                map_code1=load_map("fostiato\backgrn1.map");
                map_code2=load_map("fostiato\landscp1.map");
            END
            CASE 1:
                map_code1=load_map("fostiato\backgrn2.map");
                map_code2=load_map("fostiato\landscp2.map");
            END
            CASE 2:
                map_code1=load_map("fostiato\backgrn3.map");
                map_code2=load_map("fostiato\landscp1.map");
            END
        END

        // Loads the necessary graphics for player 1
        SWITCH(fighter1)
            CASE 0: load_fpg("fostiato\woman.fpg"); END
            CASE 1: load_fpg("fostiato\man1.fpg"); END
            CASE 2: load_fpg("fostiato\skeleton.fpg"); END
            CASE 3: load_fpg("fostiato\man2.fpg"); END
        END

        // Loads the necessary graphics for player2
        SWITCH(fighter2)
            CASE 0: load_fpg("fostiato\woman.fpg"); END
            CASE 1: load_fpg("fostiato\man1.fpg"); END
            CASE 2: load_fpg("fostiato\skeleton.fpg"); END
            CASE 3: load_fpg("fostiato\man2.fpg"); END
        END

        // If both players are equal, converts to grey one of them
        IF (fighter1==fighter2)
            FROM counter0=1 TO 54;
                // Changes the 54 first graphics of the file
                // to the grey palette
                convert_palette(2,counter0,&greys);
            END
            convert_palette(2,100,&greys);// Also converts the small graphics
            convert_palette(2,101,&greys);// of the faces
        END

        rounds1=0;    // Initializes the game's variables
        rounds2=0;
        total_blood=0;

        REPEAT          // Game's loop

            fade_off(); // Fades the screen off

            // Deletes any texts, process, or 'scrolls' that were open
            let_me_alone();
            delete_text(all_text);
            stop_scroll(0);
            clear_screen();

            // Selects the number of screens per second, and the type of screen restore
            set_fps(100,0);
            restore_type=complete_restore;

            // Sets the screen to white
            fade(200,200,200,8);
            WHILE (fading) FRAME; END // Waits while the screen fades on

            // Changes the type of restore of the screen, so you win some speed
            restore_type=no_restore;

            game_state=0; // For the game, to set all

            // Initializes the scroll
            start_scroll(0,0,map_code1,map_code2,0,0);
            scroll.x0=160;

            // Creates the characters that have been chosen
            // and the type of control they have
            SWITCH(mode)

                // Computer vs computer
                CASE 0:
                    id_fighter1=character(260,440,1,1,computer_control,fighter1);
                    id_fighter2=character(700,440,2,0,computer_control,fighter2);
                END

                // Player vs computer
                CASE 1:
                    id_fighter1=character(260,440,1,1,keyboard_control1,fighter1);
                    id_fighter2=character(700,440,2,0,computer_control,fighter2);
                END

                // Computer vs player
                CASE 2:
                    id_fighter1=character(260,440,1,1,keyboard_control2,fighter1);
                    id_fighter2=character(700,440,2,0,computer_control,fighter2);
                END

                // Player vs player
                CASE 3:
                    id_fighter1=character(260,440,1,1,keyboard_control2,fighter1);
                    id_fighter2=character(700,440,2,0,keyboard_control1,fighter2);
                END
            END

            // Initializes the enemy's variables of those characters that are
            // identifiers of the enemy process
            id_fighter1.enemy=id_fighter2;
            id_fighter2.enemy=id_fighter1;

            objects(0,320,49,200,0,0); // Puts the energy indicators
            objects(0,194,38,201,0,1);
            objects(0,446,38,202,0,2);

            define_region(1,0,0,640,480);   // Defines the regions for the movement
            define_region(2,0,0,640,480);   // of the screen

            // Writes the name of the scenary
            write(1,320,0,1,scenaries[scenary]);

            // Puts the pictures and names of the characters
            objects(id_fighter1.file,44,52,100+rounds2,1,0);
            write(1,45,100,1,names[fighter1]);
            objects(id_fighter2.file,596,52,100+rounds1,0,0);
            write(1,596,100,1,names[fighter2]);

            // Creates the stars that indicates how many rounds have been won
            make_stars();

            // Shows the start round message
            SWITCH(rounds1+rounds2)
                CASE 0:
                    text_id=write(2,320,200,4,"ROUND 1");
                END
                CASE 1:
                    text_id=write(2,320,200,4,"ROUND 2");
                END
                CASE 2:
                    text_id=write(2,320,200,4,"ROUND 3");
                END
            END

            fade(100,100,100,10);       // Shows the screen
            WHILE (fading) FRAME; END

            // Depending on the level, the game goes faster or slower
            set_fps(default_fps+level*2,8);
            FRAME(4800);    // Makes a small pause

            // Deletes the text of the start round message
            delete_text(text_id);

            game_state=1;             // Unpauses the game

            REPEAT  // Loop of each round

                // Places the scroll, depending on the position of the characters
                scroll.x0=(id_fighter1.x+id_fighter2.x)/4-80;
                FRAME;

                // Refreshes the scores
                define_region(1,296-id_fighter1.energy,28,id_fighter1.energy+1,20);
                define_region(2,345,29,id_fighter2.energy+1,20);

                // Checks if the 'ESC' key has been pressed
                IF (key(_esc)) esc_pressed=1; END

            // Repeats until the 'ESC' key is pressed or a fighter wins
            UNTIL (game_state==2 OR esc_pressed)

            // If the 'ESC' key has not been pressed, a fighter has won
            IF (NOT esc_pressed)
                IF (id_fighter1.energy==0) // Player 2 wins
                    rounds2++;
                ELSE
                    rounds1++;            // Player 1 wins
                END
                make_stars();   // Refreshes the stars
                FRAME(4800);
            END

        // Repeats until either player wins twice or the 'ESC' key is pressed
        UNTIL (rounds1==2 OR rounds2==2 OR esc_pressed)

        // If the 'ESC' key has not been pressed, show the end of the fight
        IF (NOT esc_pressed)

            // Show the number of images per second as in the menu
            set_fps(100,0);

            fade(200,200,200,10);       // Puts the screen on white
            WHILE (fading) FRAME; END   // Waits for the screen to turn white

            // Prints winer's name
            IF (rounds1==2)
                write(2,320,160,4,names[fighter1]);
            ELSE
                write(2,320,160,4,names[fighter2]);
            END

            // And the 'wins' message
            write(2,320,220,4,"WINS");

            fade(100,100,100,10);       // Fades the screen on
            WHILE (fading) FRAME; END   // Waits until it turns on

            // Sets the number of images per second as in the game
            set_fps(default_fps+level*2,8);

            FRAME(9600);                // Waits a little bit...

        ELSE
            // Refreshes the variable that stores the 'ESC' key pressed state
            esc_pressed=0;
        END

        fade_off(); // Fades the screen off

        // Initializes everything, deletes process, remaining texts, scrolls, etc
        stop_scroll(0);             // For scrolls
        unload_fpg(1);              // Discharges graphics' files
        unload_fpg(2);
        unload_map(map_code1);      // Discharges graphic maps
        unload_map(map_code2);
        let_me_alone();             // Deletes process
        delete_text(all_text);      // Deletes texts

        // Changes the type of screen restore
        restore_type=complete_restore;

    END
END

//------------------------------------------------------------------------------
// Process show_information
// Puts the texts and graphics on the options' screen
//------------------------------------------------------------------------------

PROCESS show_information()

BEGIN
    // Deletes everything, to print it refreshed
    delete_text(all_text);  // Deletes any remaining text

    signal(id_fighter1,s_kill);     // Eliminates the characters' process
    signal(id_fighter2,s_kill);
    signal(id_auxiliary,s_kill);

    // Puts the 'non selectionable' texts
    write(2,320,0,1,"OPTIONS");
    write(2,320,156,1,"VERSUS");

    // Puts 'selectionable' texts
    text[0].code=write(2,320,480,7,"START GAME");
    text[1].code=write(1,320,90,1,modes[mode]);
    text[2].code=write(1,320,120,1,levels[level]);
    text[3].code=write(1,320,150,1,bloods[blood]);

    // Puts the chosen characters' graphics and scenary
    id_fighter1=objects(0,100,256,310+fighter1,1,0);
    id_fighter2=objects(0,540,256,310+fighter2,0,0);
    id_auxiliary=objects(0,320,300,300+scenary,0,0);

    // Puts the texts of the chosen scenary and characters
    text[4].code=write(1,100,364,1,names[fighter1]);
    text[5].code=write(1,320,364,1,scenaries[scenary]);
    text[6].code=write(1,540,364,1,names[fighter2]);

    // Moves the chosen text
    move_text(text[option].code,
              text[option].x+get_disty(text_angle,8),
              text[option].y);
END

//------------------------------------------------------------------------------
// Process control
// Moves the characters, through either keyboard or computer control
// Entries: 'action' : Action to be checked if done
//------------------------------------------------------------------------------

PROCESS control(action)

PRIVATE
    dist;   // Distance between characters

BEGIN

    // Checks that the game is unpaused
    IF (game_state<>1) return(0); END

    // Reads the key depending on the type of control
    SWITCH(father.control_type)     // Looks who handles the character

        CASE keyboard_control1:      // If it is controlled through keyboard1

            // It looks which action wants to be done
            // And reads the keys that are used to do so
            SWITCH(action)              // Looks which action is being checked
                CASE jump:
                    RETURN(key(_up));   // Returns TRUE if the key is pressed
                END
                CASE crouch:
                    RETURN(key(_down));
                END
                CASE forward:
                    IF (father.flags)    // Depending on where is he facing
                        RETURN(key(_right));    // It reads a key...
                    ELSE
                        RETURN(key(_left));     // Or the other one
                    END
                END
                CASE backward:
                    IF (father.flags)
                        RETURN(key(_left));
                    ELSE
                        RETURN(key(_right));
                    END
                END
                CASE hit:
                    RETURN(key(_control));
                END
            END
        END
        CASE keyboard_control2:      // Keyboard 2 is being used
            SWITCH(action)           // It is checked as before
                CASE jump:
                    RETURN(key(_q));
                END
                CASE crouch:
                    RETURN(key(_a));
                END
                CASE forward:
                    IF (father.flags)
                        RETURN(key(_t));
                    ELSE
                        RETURN(key(_r));
                    END
                END
                CASE backward:
                    IF (father.flags)
                        RETURN(key(_r));
                    ELSE
                        RETURN(key(_t));
                    END
                END
                CASE hit:
                    RETURN(key(_x));
                END
            END
        END
        CASE computer_control:         // Computer handles the character
            dist=abs(id_fighter1.x-id_fighter2.x);      // Finds the distance between both characters
            SWITCH(father.state)       // Looks what is needed to be checked

                // Looking what action is wanted to be done
                // And checks if it is suitable
                CASE _quiet:
                    SWITCH(action)
                        CASE jump:
                            // If it is at the right distance and...
                            // You are on luck, returns TRUE
                            IF (dist<160 AND rand(0,35)==0)
                                RETURN(1);
                            END
                        END
                        CASE crouch: // Same thing for the remaining actions
                            IF (dist<160 AND rand(0,25)==0)
                                RETURN(1);
                            END
                        END
                        CASE forward:
                            IF (dist>400)
                                IF (rand(0,4)==0)
                                    RETURN(1);
                                END
                            ELSE
                                IF (dist>120 AND rand(0,8)==0)
                                    RETURN(1);
                                END
                            END
                        END
                        CASE backward:
                            IF (dist<180 AND rand(0,25)==0)
                                RETURN(1);
                            END
                            IF (dist<80 AND rand(0,5)==0)
                                RETURN(1);
                            END
                        END
                        CASE hit:
                            IF (dist<180 AND dist>60 AND rand(0,5)==0)
                                RETURN(1);
                            END
                        END
                    END
                END
                CASE _forwarding:
                    SWITCH(action)
                        CASE jump:
                            IF (dist>180 AND dist<300 AND rand(0,8)==0)
                                RETURN(1);
                            END
                        END
                        CASE hit:
                            IF (dist<140)
                                RETURN(1);
                            END
                        END
                    END
                END
                CASE _backwarding:
                    SWITCH(action)
                        CASE jump:
                            IF (dist<120 AND rand(0,6)==0)
                                RETURN(1);
                            END
                        END
                        CASE hit:
                            IF (dist>70 AND dist<150)
                                RETURN(1);
                            END
                        END
                    END
                END
                CASE _crouched:
                    SWITCH(action)
                        CASE crouch:
                            IF (rand(0,5)<>0)
                                RETURN(1);
                            END
                        END
                        CASE hit:
                            IF (dist<180 AND rand(0,5)==0)
                                RETURN(1);
                            END
                        END
                    END
                END
                CASE _jumping:
                    SWITCH(action)
                        CASE hit:
                            IF (rand(0,10)==0)
                                RETURN(1);
                            END
                        END
                    END
                END
            END
            // If the action is correct returns 1, if not, a 0
            RETURN(0);  // Doesn't make any action
        END
    END
END

//------------------------------------------------------------------------------
// Process character
// Handles all kind of characters
// Entries: 'x,y'          : Initial coordinates
//          'file'         : File where the graphics are stored
//          'flags'        : Where is the character facing (left/right)
//          'control_type' : Who is handling the character (keyb1/keyb2/cpu)
//          'fighter'      : Which one of the two fighters
//------------------------------------------------------------------------------

PROCESS character(x,y,file,flags,control_type,fighter)

PRIVATE
    new_state;          // Temporary variable for the character's state
    new_step;           // Temporary variable for the character's animation position
    hit_x,hit_y;        // Variables to store the control points of the hits
                        // Strength for each one of the hits
    hit_strength[]=35,35,55,35,35;
    counter0;           // General purpouse counter
    add_strength;        // Variable strength depending on the level and the fighter

BEGIN
    ctype=c_scroll;     // Puts it withing the scroll
    energy=203;         // Initializes energy
    FRAME;
    shadow();           // Creates the character's shadow

    IF (control_type<>0)                        // If the computer is not handling this character
        IF (enemy.control_type==0)              // But handles the enemy
            SWITCH(level)                       // Depending on the game level (difficulty)
                CASE 1: add_strength=-10; END   // Causes that hits substract less energy
                CASE 2: add_strength=-18; END
            END
        ELSE
            add_strength=10; // Human vs Human, have same strength
        END
    END

    SWITCH(fighter)        // Depending on the type of fighter
        CASE 0: add_strength-=8; END // Ripley hits less
        CASE 1: add_strength+=6; END // Bishop is the second hardest hitter
        CASE 2: add_strength+=4; END // Alien is the second softest hitter
        CASE 3: add_strength+=8; END // Nostrodomo hits more than any one else
    END

    // Refreshes hits' strength depending on the players
    FROM counter0=0 TO 4; hit_strength[counter0]+=add_strength; END

    LOOP
        new_state=state;    // Refreshes the temporary variable of the characters' state
        SWITCH(state)       // Checks the character's state
            CASE _quiet:
                graph=anim0[a_step++];       // Animates the graphic
                IF (a_step==sizeof(anim0))   // If there ain't no graphics left on the animation
                    a_step=0;                // Starts from 0
                END
                IF (flags)                   // Causes characters to face one another
                    IF (enemy.x<x) flags=0; END
                ELSE
                    IF (enemy.x>x) flags=1; END
                END
                // Checks if you want to change of state
                IF (control(hit))       // Checks if you want to hit
                    new_state=_punch;   // And hits...
                END
                IF (control(jump))        // Checks if you wanto to jump
                    new_state=_jumping;   // And jumps...
                    inc_y=-16; inc_x=0;   // Initializes the jump's increments
                END
                IF (control(crouch))       // Checks if you want to crouch
                    new_state=_crouching;  // And crouches...
                END
                IF (control(backward))       // Checks if you want to go backwards
                    new_state=_backwarding;  // And goes backwards...
                END
                IF (control(forward))        // Checks if you want to go forward
                    new_state=_forwarding;   // And goes forwards...
                END
            END

            CASE _forwarding:                 // If you are going forward
                graph=anim1[a_step++];        // Animates the graphic
                IF (a_step==sizeof(anim1))    // Checks that the animation's end has not been reached
                    new_state=_quiet;       // And if reached, changes of state
                END
                IF (flags)                  // Moves the character depending on where is he facing
                    x+=4;
                ELSE
                    x-=4;
                END
                // Checks if you want to do any other action
                IF (control(hit))               // You want to do a hit...
                    new_state=_normal_kick;
                END
                IF (control(jump))              // You want to jump...
                    new_state=_jumping;
                    inc_y=-16;
                    IF (flags)
                        inc_x=12;
                    ELSE
                        inc_x=-12;
                    END
                END
            END

            CASE _backwarding:                // Looks if you are going backwards
                graph=anim2[a_step++];        // Animates the graphic
                IF (a_step==sizeof(anim2))    // If the end has been reached
                    new_state=_quiet;         // Changes of state
                END
                IF (flags)                    // Moves the character depending on where is he facing
                    x-=4;
                ELSE
                    x+=4;
                END
                // Checks for any other available action to be done
                IF (control(hit))
                    new_state=_turning_kick;
                    inc_y=-10;
                END
                IF (control(jump))
                    new_state=_jumping;
                    inc_y=-16;
                    IF (flags)
                        inc_x=-8;
                    ELSE
                        inc_x=8;
                    END
                END
            END

            CASE _crouching:                  // Checks if you are crouching
                graph=anim3[a_step++];        // Plays the animation
                IF (a_step==sizeof(anim3))    // Until it reaches the end
                    new_state=_crouched;      // And then turns the state to crouched
                END
            END

            CASE _crouched:         // Checks if you are crouched
                graph=anim4[0];     // Puts the necessary graphic
                IF (flags)          // Puts the graphic facing the other one
                    IF (enemy.x<x)
                        flags=0;
                    END
                ELSE
                    IF (enemy.x>x)
                        flags=1;
                    END
                END
                // Checks if you want to do any other action
                IF (control(hit))            // Checks if you want to hit
                    new_state=_low_punch;
                END
                IF (NOT control(crouch))     // If you don't want to crouch
                    new_state=_standing_up;  // It stands up
                END
            END

            CASE _standing_up:                // Checks if you are standing up
                graph=anim5[a_step++];        // Animates it
                IF (a_step==sizeof(anim5))    // If finished
                    new_state=_quiet;         // Changes the state to quiet
                END
            END

            CASE _jumping:                // Checks if you are jumping
                graph=anim6[a_step++];    // Animates the graphics
                IF (a_step>4)             // If the animation's point has been reached
                    x+=inc_x;             // Moves the character
                    y+=inc_y*3;
                    inc_y+=2;           // Changes the increment so it bounces
                    IF (y>=440)         // Checks if it has touched the floor
                        y=440;
                        dust(x,y);     // Creates a dust cloud when falling
                        // Looks if you want to jump again
                        IF (control(jump))
                            new_state=_quiet;
                        ELSE
                            new_state=_crouching;
                        END
                    END
                END
                IF (control(hit))       // Checks if you want to hit
                    new_state=_flying_kick;
                    new_step=a_step;
                END
            END

            // Checks if you are making a low punch
            CASE _low_punch:
                graph=anim7[a_step++];        // Animates the graphic
                IF (a_step==sizeof(anim7))    // If the animation is over
                    new_state=_crouched;      // Changes of state
                END
                IF (flags)                  // Checks where is he facing
                    x++;                    // And moves a little bit
                ELSE
                    x--;
                END
                // If the right point on the animation has been reached
                IF (a_step==2)
                    sound(s_air1,rand(50,75),256);         // Plays the sound
                    get_real_point(1,&hit_x,&hit_y);       // Takes the control point of the fist
                    ahit(hit_x,hit_y,hit_strength[0]);     // And checks if he has touched
                    IF (hit_strength[0]>2)       // Reduces hit's strength
                        hit_strength[0]--;       // For the next time
                    END
                END
            END
            // Checks if you are punching
            CASE _punch:
                graph=anim8[a_step++];        // Animates the graphic
                IF (a_step==sizeof(anim8))    // Until the animation is finished
                    new_state=_quiet;         // And changes to a new state
                END
                IF (flags)                  // Checks where is he facing
                    x++;                    // And moves
                ELSE
                    x--;
                END
                IF (a_step==4)    // If the point on the animation has been reached
                    // Makes a hit
                    sound(s_air2,rand(50,75),256);
                    get_real_point(1,&hit_x,&hit_y);    // Calculates the point where the hit will be done
                    ahit(hit_x,hit_y,hit_strength[1]);  // Checks if the hit is done
                    IF (hit_strength[1]>2)              // Reduces strength to the hit
                        hit_strength[1]--;
                    END
                END
            END

            CASE _turning_kick: // Checks the turning kick like on the previous hits
                graph=anim9[a_step++];
                IF (a_step==sizeof(anim9))
                    new_state=_quiet;
                END
                y+=inc_y; inc_y+=2;
                IF (y>440)
                    y=440;
                END
                IF (a_step==5)
                    sound(s_air3,rand(50,75),256);
                    get_real_point(1,&hit_x,&hit_y);
                    ahit(hit_x,hit_y,hit_strength[2]);
                    IF (hit_strength[2]>2)
                        hit_strength[2]--;
                    END
                END
            END

            CASE _normal_kick:    // Checks the normal kick
                graph=anim10[a_step++];
                IF (a_step==sizeof(anim10))
                    new_state=_quiet;
                END
                IF (a_step==4)
                    sound(s_air4,rand(50,75),256);
                    get_real_point(1,&hit_x,&hit_y);
                    ahit(hit_x,hit_y,hit_strength[3]);
                    IF (hit_strength[3]>2)
                        hit_strength[3]--;
                    END
                END
            END

            CASE _flying_kick:     // Checks the flying kick
                graph=anim11[a_step++];
                IF (a_step>4)
                    x+=inc_x;
                    y+=inc_y*3;
                    inc_y+=2;
                    IF (y>=440)
                        y=440;
                        dust(x,y);
                        IF (control(jump))
                            new_state=_quiet;
                        ELSE
                            new_state=_crouching;
                        END
                    END
                END
                IF (a_step==10 OR a_step==19)
                    sound(s_air5,rand(50,75),256);
                    get_real_point(1,&hit_x,&hit_y);
                    ahit(hit_x,hit_y,hit_strength[4]);
                    IF (hit_strength[4]>2)
                        hit_strength[4]--;
                    END
                END
            END

            CASE _touched:   // Checks if the character has been touched
                graph=anim12[a_step++];       // Animates the graphic
                IF (a_step==sizeof(anim12))   // Until it is over
                    // Play a sound randomly from the available ones
                    SWITCH(rand(0,3))
                        CASE 0:
                            sound(s_hit1,rand(25,50),256);
                        END
                        CASE 1:
                            sound(s_hit2,rand(25,50),256);
                        END
                        CASE 2:
                           sound(s_hit3,rand(25,50),256);
                        END
                    END
                    new_state=_quiet;    // Changes the state
                    y=440;               // Falls on the floor
                END
                x+=inc_x;      // And moves the character a bit
                // If the character was moving, it stops it
                IF (inc_x<0)   // If it was moving to the left
                    inc_x++;   // It stops
                END
                IF (inc_x>0)   // If it was moving to the right
                    inc_x--;   // It stops
                END
                IF (y<440)     // If it was jumping
                    y+=8;      // Makes it to go down
                END
                IF (y>=440)    // If it was under the inferior limit
                    y=440;     // It replaces it properly
                END
            END

            CASE _dead:   // Checks if the character has died
                IF (a_step==0)
                sound(s_dead,25,256);     // Plays the sound of dying
                END
                graph=anim13[a_step++];       // Animates the graphic with a sequence
                IF (a_step==sizeof(anim13))   // And leaves it stopped
                    a_step--;
                END
                x+=inc_x;           // Moves the coordinates until they match
                // Like on the previous case (touched), stops the character
                IF (inc_x<0)
                    inc_x++;
                END
                IF (inc_x>0)
                    inc_x--;
                END
                IF (y<440)
                    y+=8;
                END
                IF (y>=440)
                    y=440;
                END
            END

        END

        IF (state<>new_state)   // Refreshes the character's state
            state=new_state;
            a_step=new_step;    // And the step within the animation
            new_step=0;
        END

        IF (x<60)               // Checks that the character hasn't gone out of the screen
            x=60;               // And places the graphic on the right position, if it has done so
        END
        IF (x>900)
            x=900;
        END

        FRAME;
    END
END

//------------------------------------------------------------------------------
// Process shadow
// Handles the characters' shadow
//------------------------------------------------------------------------------

PROCESS shadow()

BEGIN
    ctype=c_scroll; // Puts it within the scroll
    graph=1;        // Selects the graphic
    priority=-1;    // Gives it a low priority, so it executes later
    z=1;            // Puts it under the character's graphic
    y=440;          // Initializes the vertical coordinate
    flags=4;        // And makes it transparent
    LOOP
        x=father.x; // Causes to follow the character
        FRAME;
    END
END

//------------------------------------------------------------------------------
// Process dust
// Creates a dust cloud when the character falls after jumping
// Entries: Coordinates where the graphic will appear
//------------------------------------------------------------------------------

PROCESS dust(x,y)

BEGIN
    FRAME;
    ctype=c_scroll;      // Puts it within the scroll
    flags=4;             // Makes it tranparent
    z=-1;                // Puts it before the character
    FROM graph=2 TO 12;  // Animates the graphic
        FRAME;
    END                  // Ends, killing this process
END

//------------------------------------------------------------------------------
// Process ahit
// Handles the hits characters make
// Entries: Coordinates where the hits are really done
//           'damage' Energy that is substracted to the enemy
//------------------------------------------------------------------------------

PROCESS ahit(x,y,damage)

PRIVATE
    characters_id; // Identifier to the characters
    counter0;      // General purpouse counter

BEGIN
    ctype=c_scroll;     // Introduces the process within the scroll
    z=-1;               // Puts it before the characters
    graph=100;          // Chooses the graphic of a ball, so it embraces a bigger region
    // Checks if a character is being touched
    characters_id=collision(type character);
    IF (characters_id==father)      // And that it is not the same that called this process
        characters_id=collision(type character);  // If it is the same, it tries to take the other identifier
    END

    IF (characters_id)              // If it has touched
        // Plays a sound randomly from the available ones
        SWITCH (rand(0,2))
            CASE 0:
                sound(s_touched1,rand(25,75),256);
            END
            CASE 1:
                sound(s_touched2,rand(25,75),256);
            END
            CASE 2:
                sound(s_touched3,rand(25,75),256);
            END
        END
        characters_id.a_step=0;             // Refreshes the animation of the character that has been touched
        characters_id.energy-=damage/2;     // Substracts him energy
        IF (characters_id.energy<=0)        // If he has no energy left
            characters_id.energy=0;         // Is because he is dead
            characters_id.state=_dead;
            game_state=2;
        ELSE
            characters_id.state=_touched;   // Or else, he has been just touched
        END
        IF (characters_id.flags)            // Moves the graphic a bit backwards
            characters_id.inc_x=-8;
        ELSE
            characters_id.inc_x=8;
        END
        SWITCH(blood)          // Creates the blood
            // Depending on the chosen level on the options
            CASE 0:     // Hit with no blood at all
                noblood_hit(x,y);
            END
            CASE 1:     // Hit with blood
                counter0=damage/3+1;
                WHILE (counter0>0)
                    blood_particle(x,y,characters_id.inc_x+rand(-2,2),rand(-4,0),rand(10,20));
                    counter0--;
                END
            END
            CASE 2:    // Hit with a lot of blood
                counter0=damage+2;
                WHILE (counter0>0)
                    blood_particle(x,y,characters_id.inc_x*2+rand(-4,4),rand(-8,2),rand(15,30));
                    counter0--;
                END
            END
        END
    END
END

//------------------------------------------------------------------------------
// Process blood_particle
// Handles the blood that appears when a character hits the other
// Entries: 'x,y'        : Coordinates from which appears the blood
//          'inc_x,inc_y': Increments on the blood's movement (falling)
//          'time_count' : Counter for the time blood will remain on the screen
//------------------------------------------------------------------------------

PROCESS blood_particle(x,y,inc_x,inc_y,time_count)

BEGIN
    ctype=c_scroll;         // Puts it within the scroll
    // If it is on the blodiest level, waits a bit so all the blood doesn't appear at the same time
    IF (blood==2)
        FRAME(rand(0,400)); // Waits a while randomly
    END
    graph=rand(50,53);      // Chooses one of the available graphics randomly
    flags=4;                // Makes it transparent
    z=-2;                   // Puts it over everything else
    WHILE (time_count>0)    // Moves the blood while there is enough time left
        x+=inc_x;           // Makes the increments on the coordinates
        y+=inc_y;
        inc_y++;            // Causes blood to fall faster
        IF (inc_x>0)        // But moves it slower horizontally
            inc_x--;
        END
        IF (inc_x<0)
            inc_x++;
        END
        IF (y>410)          // Checks if it has touched the floor
            // Leaves blood stucked to the floor in a randomly way
            IF (rand(0,80)==0 AND total_blood<50 AND y<480)
                z=256;          // Puts it behind
                total_blood++;  // Increments the blood counter
                LOOP
                    FRAME;      // Leaves it on a loop so it remains on the screen
                END
            END
        END
        time_count--;           // Increments the time counter
        FRAME;
    END
END

//------------------------------------------------------------------------------
// Process noblood_hit
// Puts an alternative graphic to the blood, for those modes that doesn't have any blood at all
//------------------------------------------------------------------------------

PROCESS noblood_hit(x,y)

BEGIN
    ctype=c_scroll; // Puts it within the scroll
    z=-2;           // Before other graphics
    FROM graph=60 TO 66;
        FRAME;      // Animates the graphic
    END
END

//------------------------------------------------------------------------------
// Process objects
// Draws the static graphics of the scores and options' screen
// Entries: graphic file, coordinates, graphic, flag (right/left),
//          for the screen region
//------------------------------------------------------------------------------

PROCESS objects(file,x,y,graph,flags,region)

BEGIN
    z=10;   // Puts it behind other graphics
    LOOP
        FRAME;
    END
END

//------------------------------------------------------------------------------
// Process make_stars
// Handles the stars that indicate how many rounds have been won
//------------------------------------------------------------------------------

PROCESS make_stars()

BEGIN
    // Eliminates any previous star
    signal(type star,s_kill);

    // Puts player1's stars
    SWITCH(rounds1)
        // Dependinding on the number of rounds a character has won, it puts different types of star
        CASE 0:
            star(111,84,203);
            star(143,84,203);
        END
        CASE 1:
            star(111,84,204);
            star(143,84,203);
        END
        CASE 2:
            star(111,84,204);
            star(143,84,204);
        END
    END

    // Puts player2's stars
    SWITCH(rounds2)
        CASE 0:
            star(530,84,203);
            star(498,84,203);
        END
        CASE 1:
            star(530,84,204);
            star(498,84,203);
        END
        CASE 2:
            star(530,84,204);
            star(498,84,204);
        END
    END

END

//------------------------------------------------------------------------------
// Process star
// Prints the stars' graphics
// Entries: Coordinates and type of star's graphic
//------------------------------------------------------------------------------

PROCESS star(x,y,graph)

BEGIN
    LOOP
        FRAME;  // Prints it
    END
END

//------------------------------------------------------------------------------
// Process credits
// Draws the credits' screen
//------------------------------------------------------------------------------

PROCESS credits()

PRIVATE
    map_code1;    // Identifier to the graphic's file
    // Texts for the credits
    textos[]=
        "CODE","DANIEL NAVARRO","",
        "GRAPHICS","JOSE FERNANDEZ","RAFAEL BARRASO","",
        "SOUND","ANTONIO MARCHAL","",
        "PLAYABILITY","LUIS F. FERNANDEZ","",
        "GREETINGS GOES TO","FERNANDO PEREZ",
        "JORGE SANCHEZ","JAVIER CARRION","",
        "FOSTIATOR","DIV GAMES STUDIO";

BEGIN
    // Loads the background screen
    map_code1=load_map("fostiato\credits.map");
    load_pal("fostiato\credits.map");
    // Y el tipo de letras
    load_fnt("fostiato\credits.fnt");
    put_screen(0,map_code1);            // Puts the background
    FROM y=0 TO 19;                     // And writes the texts
        write(3,320,40+y*20,4,textos[y]);
    END
    fade_on();                          // Fades the screen on
    scan_code=0;
    REPEAT                              // Waits for a key to be pressed
        FRAME;
    UNTIL (scan_code<>0)
END

//------------------------------------------------------------------------------
// Process intro
// Plays the game's intro
//------------------------------------------------------------------------------

PROCESS intro();

PRIVATE
    counter0;      // General purpouse counter
    map_code;      // Identifier to discharge the graphics
    s_intro;       // Identifier of the intro's sound
BEGIN
    // For the general process to put this one
    signal(father,s_sleep);
    // Cause the screen to change rapidly
    set_fps(100,0);
    load_pal("fostiato\intro.map");               // Loads the coulors palette
    map_code=load_map("fostiato\intro.map");      // Loads the screen
    s_intro=load_pcm("fostiato\introhit.pcm",0);  // Loads the sound

    fade(200,200,200,8);        // Puts the screen on white
    WHILE (fading) FRAME; END   // Waits until the screen fades on
    sound(s_intro,100,256);     // Plays the sound
    put_screen(0,map_code);     // Puts the background screen
    unload_map(map_code);       // Discharges the graphic
    fade_on();                  // Fades the screen on
    WHILE (fading) FRAME; END   // Waits unteil the screen is lit

    // Loads sounds
    s_hit1=load_pcm("fostiato\uah00.pcm",0);
    s_hit2=load_pcm("fostiato\whimper2.pcm",0);
    s_hit3=load_pcm("fostiato\whimper3.pcm",0);
    s_touched1=load_pcm("fostiato\hit00.pcm",0);
    s_touched2=load_pcm("fostiato\hit01.pcm",0);
    s_touched3=load_pcm("fostiato\hit02.pcm",0);
    s_air1=load_pcm("fostiato\turn06.pcm",0);
    s_air2=load_pcm("fostiato\turn07.pcm",0);
    s_air3=load_pcm("fostiato\turn08.pcm",0);
    s_air4=load_pcm("fostiato\turn05.pcm",0);
    s_air5=load_pcm("fostiato\turn09.pcm",0);
    s_dead=load_pcm("fostiato\aaah01.pcm",0);

    // Loads the graphics and the font types
    load_fpg("fostiato\game.fpg");
    load_fnt("fostiato\ongame.fnt");
    load_fnt("fostiato\ongame2.fnt");

    // Waits until a key is pressed or a certain amount of time has expired
    WHILE (NOT key(_esc) AND NOT key (_space) AND counter0<200)
        FRAME;
        counter0++;
    END
    // Returns the control to the main process
    signal(father,s_wakeup);
END

