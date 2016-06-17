compiler_options _extended_conditions;

//------------------------------------------------------------------------------
// TITLE: HELIO BALL
// AUTHOR: ANTONIO MARCHAL CORTS
// DATE:  DIV GAMES STUDIO (c) 2000
//------------------------------------------------------------------------------

PROGRAM helio_ball;

CONST
    player1=1;     // Constants for the type of player
    player2=2;
    computer1=3;
    computer2=4;

GLOBAL
    file1;         // Identifier to the game graphics
    file2;         // Identifier to the bonus graphics
    file3;         // Identifier to the menu graphics
    idstadium;     // Identifier to the stadium graphic
    font1;         // Identifiers to the font types used
    font2;
    font3;
    font4;
    score1,score2;        // Players' scores
    qplayer1=player1;     // Type of players
    qplayer2=player2;     // Default is player1 vs player2
    gamemode=0;           // Game mode (0=player1 vs player2
                          //            1=computer1 vs player2
                          //            2=player1 vs computer2
                          //            3=computer1 vs computer2
    totaltime=60;         // Match time
    gametime;             // Time left 'til the end
    idship1;              // Ships' identifiers
    idship2;
    idball0;              // Identifier to the ball
    bonusyes=0;           // Flag. 1= There is a bonu
    bonustime=-1;         // Bonus time
    counter;              // General purpouse counter

    idsscore;             // Identifiers to the sounds
    idsgoal;
    idsbump1;
    idsbump2;
    idsbump3;

LOCAL
    realangle;          // Real angle for the ships
    realspeed;          // Real speed for the ships
    ballspeed;          // Real speed for the ball
    ballangle;          // Real angle for the ball
    incr_x;             // Necessary for the ships' bounces
    incr_y;
    speed_inc_x=0;           // Horizontal increment for the ship
    speed_inc_y=0;           // Vertical increment for the ship
    which;                   // Selects what type of ship it is
    maxspeed=2000;           // Maximum speed for the ships
    otherstrength=0;         // Push strength added on the ships
    bonus=0;                 // Recollected bonus by the ship
    acceleration=400;        // Ships' acceleration
    brake=800;               // Ships' brake

PRIVATE
    // Texts for the options
    playertext[]="-","CURSOR KEYS","Q-A-R-T KEYS","COMPUTER 1","COMPUTER 2";
    timetext[]="-","060 SECONDS","120 SECONDS","180 SECONDS","240 SECONDS","300 SECONDS";
    idtext1,idtext2,idtext3;     // Identifiers to the texts
    timetype=1;                  // Match length
    idbckgr;                     // Identifier to put the backgrounds
    extracount;                  // Counter for the text on the extra time
    idextratime;                 // Identifier to the extra time text
    idsmenu;                     // Sound identifiers
    idsini;
    idsend;
    accept_button=0;                // Checks if an option from the menu was choosed
BEGIN
    set_mode(m640x480);             // Selects the video mode
    max_process_time=1000;          // We set it a little higher for slower machines

    // Loads the graphic files
    file1=load_fpg("heliobal\SHIPS.FPG");
    file2=load_fpg("heliobal\items.fpg");
    file3=load_fpg("heliobal\menu.fpg");

    // Loads the necessary fonts
    font1=load_fnt("heliobal\digital0.fnt");
    font2=load_fnt("heliobal\digital1.fnt");
    font3=load_fnt("heliobal\digital.fnt");
    font4=load_fnt("heliobal\digital2.fnt");

    // Loads the sound effects
    idsscore=load_pcm("heliobal\bonus.pcm",0);
    idsgoal=load_pcm("heliobal\goal.pcm",0);
    idsbump1=load_pcm("heliobal\CRASH1.PCM",0);
    idsbump2=load_pcm("heliobal\BUMP.PCM",0);
    idsbump3=load_pcm("heliobal\CRASH2.PCM",0);

    // Initially is computer vs computer
    gamemode=3;
    qplayer1=3;
    qplayer2=4;

    WHILE (NOT key(_esc))

        // Loads sound and screen with the initial palette
        idsmenu=load_pcm("heliobal\menu.pcm",0);
        idbckgr=load_map("heliobal\PANEL.MAP");
        load_pal("heliobal\PANEL.MAP");
        put_screen(0,idbckgr);    // Puts the screen
        fade_on();                // Fades the screen on and plays the sound
        sound(idsmenu,75,256);
        WHILE (scan_code==0 AND NOT mouse.left)
            FRAME;
        END                  // Waits for 'space' or 'ESC' key to be pressed
        IF (key(_esc))       // If 'ESC' was pressed, it exits the game
            fade_off();
            credits();
            FRAME;
        END
        fade_off();            // Fades the screen off
        unload_pcm(idsmenu);   // And unloads the sound to have more screen
        unload_map(idbckgr);
        idbckgr=load_map("heliobal\CITY.MAP");
        load_pal("heliobal\CITY.MAP");

        // Puts the background screen and writes the messages
        put_screen(0,idbckgr);
        idtext1=write(font1,320,37,4,playertext[qplayer1]);
        write(font1,320,87,4,"VS");
        idtext2=write(font1,320,137,4,playertext[qplayer2]);
        write(font1,320,237,4,"TIME");
        idtext3=write(font1,320,287,4,timetext[timetype]);

        // Creates the menu bars
        menu_bar(320,40,997,file3,0,5);
        menu_bar(320,40,995,file3,4,10);
        menu_bar(320,140,997,file3,0,5);
        menu_bar(320,140,995,file3,4,10);
        menu_bar(320,290,998,file3,0,5);
        menu_bar(320,290,996,file3,4,10);
        menu_bar(320,450,994,file3,0,5);
        menu_bar(320,450,993,file3,4,10);


        // Assigns the graphic for the mouse cursor
        mouse.graph=999;mouse.file=file3;
        fade_on();                      // Fades the screen on
        accept_button=0;                // Reinitializes the check variable
        WHILE (accept_button==0 AND NOT key(_esc))
            // Checks if mouse is clicked and on what position
            IF (mouse.x>20 AND mouse.x<620 AND
                mouse.y>12 AND mouse.y<68
                AND mouse.left)         // Changes the type of player on the left
                WHILE(mouse.left) FRAME; END   // Waits for the mouse to be released
                delete_text(idtext1);  // Deletes the previous text
                IF (qplayer1==1)
                    qplayer1=3;        // Computer
                ELSE
                    qplayer1=1;        // Human
                END
                // Puts the new text
                idtext1=write(font1,320,37,4,playertext[qplayer1]);
            END
            // Checks if mouse is clicked and on what position
            IF (mouse.x>20 AND mouse.x<620 AND
                mouse.y>112 AND mouse.y<168
                AND mouse.left)         // Changes the type of player on the right
                WHILE(mouse.left) FRAME; END   // Waits for the mouse to be released
                delete_text(idtext2);  // Deletes the previous text
                IF (qplayer2==2)
                    qplayer2=4;        // Computer
                ELSE
                    qplayer2=2;        // Human
                END
                // Puts the new text
                idtext2=write(font1,320,137,4,playertext[qplayer2]);
            END
            // Checks if mouse is clicked and on what position
            IF (mouse.x>113 AND mouse.x<527 AND
                mouse.y>262 AND mouse.y<318
                AND mouse.left)         // Changes match length
                WHILE(mouse.left) FRAME; END   // Waits for the mouse to be released
                delete_text(idtext3);  // Deletes the previous text
                timetype++;
                IF (timetype>5) timetype=1; END
                // Puts the new text
                idtext3=write(font1,320,287,4,timetext[timetype]);
            END
            // Checks if mouse is clicked and on what position
            IF (mouse.x>202 AND mouse.x<438 AND
                mouse.y>422 AND mouse.y<478
                AND mouse.left)         // Checks if the accept button is clicked
                WHILE(mouse.left) FRAME; END   // Waits for the mouse to be released
                accept_button=1;
            END
            totaltime=timetype*60;  // Reinitializes time
            // Selects the game mode depending on the type of player
            IF (qplayer1==1)
                IF (qplayer2==2) gamemode=0; ELSE gamemode=1; END
            ELSE
                IF (qplayer2==2) gamemode=2; ELSE gamemode=3; END
            END
            FRAME;
        END

        // Hides the graphic for the mouse cursor
        mouse.graph=0;
        IF (key(_esc))  // If 'ESC' was pressed, exits the game
            fade_off();
            credits();
            FRAME;
        END
        fade_off();
        unload_map(idbckgr);    // Unloads the background screen because of the memory

        // Loads the stadium graphic and its palette
        idstadium=load_map("heliobal\STADIUM.MAP");
        load_pal("heliobal\SHIPS.FPG");
        delete_text(all_text);  // Deletes all texts

        // Kills any remaining process
        let_me_alone();
        clear_screen();
        inifield();          // Reinitializes the game field
        fade_on();

        // Sets the score and the time to zero
        timer[0]=0; score1=0; score2=0;
        gametime=totaltime-(timer[0]/100);

        // Writes the texts for the scores
        write_int(font3,147,-2,2,&score1);
        write_int(font3,636,-2,2,&score2);
        write_int(font3,356,-2,2,&gametime);
        scores();   // Puts the backgrounds for the scores

        // Loads sound for the beginning of the game
        idsini=load_pcm("heliobal\inigame.pcm",0);
        sound(idsini,75,256);    // Plays the start game sound

        // Repeats until time is over
        WHILE (NOT key(_esc) AND gametime>=0)

            // If there is an equal score, adds 30 seconds of extra time
            IF (gametime<1 AND score1==score2)
                timer[0]=0;
                totaltime=30;
                extracount=30;
            END

            // Normilizes game time, so negative numbers are not printed
            IF (gametime<0) gametime=0; END
            IF (extracount>0) // If scores were equal, then puts the 'extra time' text
                idextratime=write(font2,320,280,4,"EXTRA TIME!");
            END

            FRAME;

            // Refreshes time left
            gametime=totaltime-(timer[0]/100);

            // Puts the bonus objects
            IF (rand(0,10)==0 AND idship1.bonus==0 AND idship2.bonus==0 AND bonusyes==0)
                objects();
            END

            // If the extra time text is there, deletes it
            IF (extracount>0)
                extracount--;
                delete_text(idextratime);
            END
        END

        // Unloads sound because of free memory
        unload_pcm(idsini);

        // For the ships' and balls' process
        signal(idship1,s_freeze);
        signal(idship2,s_freeze);
        signal(idball0,s_freeze);

        // Loads the end match sound
        idsend=load_pcm("heliobal\timeout.pcm",0);
        IF (gametime<1)
            idsend=load_pcm("heliobal\timeout.pcm",0);
            gametime=0;
            counter=0;
            write(font2,320,280,4,"END OF MATCH!");
            sound(idsend,75,256);
            // Waits for the 'space' key to be pressed, or a little while...
            WHILE (NOT key(_space) AND counter<30)
                FRAME;
                counter++;
            END
            unload_pcm(idsend);
        END
        // Fades the screen off
        fade_off();
        // Deletes all texts and process
        delete_text(all_text);
        let_me_alone();
        // Eliminates the screen movements (scrolls)
        stop_scroll(0);stop_scroll(1);
   END
END

//------------------------------------------------------------------------------
// Process ball
// Controls the ball
//------------------------------------------------------------------------------

PROCESS ball()

PRIVATE
    idship;             // Ships' identifier
    addangx,addangy;    // Used to add angles
    angx,angy;
    real_speed;         // For temporary use, saving the real speed
    lastx,lasty;        // Last coordinates of the object

BEGIN
    ctype=c_scroll;     // Introduces the process within the scroll
    graph=50;           // Chooses the graphic and its initial coordinates
    x=640;
    y=rand(400,560);
    lastx=x;lasty=y;    // Initializes the graphic
    LOOP
        // Moves the ball
        x+=get_distx(ballangle,ballspeed/200);
        y+=get_disty(ballangle,ballspeed/200);

        // Brakes the ball
        IF (ballspeed>0)
            ballspeed-=100;
        ELSE
            ballspeed=0;
        END

        // Detects if the ship has been touched
        IF (idship=collision(TYPE ship))
            sound(idsbump3,rand(5,50),256);   // Plays a sound

            // Takes the ship's speed plus an increment
            ballspeed=(idship.realspeed)+2000;

            // Looks if the ship is handled by the player
            IF (idship.which==player1 OR idship.which==player2)
                real_speed=idship.realspeed;
                IF (real_speed>400) real_speed=400; END

                // Adds the angle that has the ship with the
                // one that has the ball and the ship
                addangx=get_distx(get_angle(idship)+180000,400);
                addangy=get_disty(get_angle(idship)+180000,400);
                angx=get_distx(idship.realangle,real_speed);
                angy=get_disty(idship.realangle,real_speed);
                addangx+=angx; addangy+=angy;

                // Moves the ball and refreshes the angle
                ballangle=fget_angle(0,0,addangx,addangy);
                x+=get_distx(ballangle,ballspeed/200);
                y+=get_disty(ballangle,ballspeed/200);
            ELSE        // Or handled by the computer
                ballangle=(get_angle(idship)+180000) mod 360000;
            END
        END

        // Checks if bounces with the superior or inferior walls
        IF (y<195 OR y>758)
            ballangle=(fget_angle(0,0,(get_distx(ballangle,200)),-(get_disty(ballangle,200))));
            ballspeed+=100;
            x+=get_distx(ballangle,ballspeed/200);
            y+=get_disty(ballangle,ballspeed/200);
            IF (y<195) y=196; END
            IF (y>758) y=757; END
        END

        // Checks if it is on the right or left side of the game field
        IF (x<131 OR x>1069)
            // Checks if it was inside the goal
            IF  (lasty=>400 AND lasty<=544)
               // Checks the bounce with the edges of the goal
               IF (y<400 OR y>544)
                    ballangle=(fget_angle(0,0,(get_distx(ballangle,200)),-(get_disty(ballangle,200))));
                    ballspeed+=100;
                    x+=get_distx(ballangle,ballspeed/200);
                    y+=get_disty(ballangle,ballspeed/200);
                    IF (y<400) y=401; END
                    IF (y>544) y=543; END
               END
               // Checks if a goal score has been produced
               IF (x<75 OR x>1126)
                   IF (x<76) score2+=50; ELSE score1+=50; END
                   goalscored();    // A score has been produced
               END
        ELSE
            // Makes the bounces with the left and right sides of the game field
            ballangle=(fget_angle(0,0,-(get_distx(ballangle,200)),(get_disty(ballangle,200))));
            ballspeed+=100;
            x+=get_distx(ballangle,ballspeed/200);
            y+=get_disty(ballangle,ballspeed/200);
            IF (x<131) x=132; END
            IF (x>1069) x=1068; END
           END
        END
        FRAME(50);
        lastx=x;lasty=y;    // Stored for the checks with the goal
    END
END

//------------------------------------------------------------------------------
// Process ship
// Controls players' ships
//------------------------------------------------------------------------------

PROCESS ship(which)

PRIVATE
    _frame;             // Variable used to get the ship's angle
    idship;             // Identifier of the other ship
    tspeed0;            // Ships' speeds addition, before crashing
    tspeed1;            // Ships' speeds addition, after crashing
    shipsangle;               // Angle between ships
    add_speed_x,add_speed_y;  // x and y increments addition of the ships
    tdistance;                // Distance between the two ships
    idball;                   // Ball identifier
    inigraph;                 // Ships' initial graphic
    graphicangle;             // Angle to which ships' graphics tend
    gfinalangle;              // Ships' graphics angle
    addangx,addangy;          // Addition of ships' angles and the ones formed
    angx,angy;                // by the ball and the ship
    real_speed;               // Temporary variable to trunk speed
    lastx,lasty;              // Last ships' positions
    ballposx,ballposy;        // Position of the ships handled by the computer
BEGIN
    ctype=c_scroll;         // Introduces the process within the scroll
    shadow();               // Puts the shadow

    // Sets the position, graphics and initial angles of the ships
    IF (which==player1 OR which==computer1)
        graph=1; inigraph=1;
        x=580; y=480;
        angle=0;
    ELSE
        graph=25; inigraph=25;
        x=700; y=480;
        angle=180000;
    END
    lastx=x; lasty=y;   // Saves last ship position
    LOOP
        // Handles the control of the ship, depending on the type of player
        SWITCH (which)
            CASE 1:         // Reads the keyboard from player1
                IF (key(_right))
                    IF (speed_inc_x>=0) speed_inc_x+=acceleration; ELSE speed_inc_x+=brake; END
                END
                IF (key(_left))
                    IF (speed_inc_x<=0) speed_inc_x-=acceleration; ELSE speed_inc_x-=brake; END
                END
                IF (key(_up))
                    IF (speed_inc_y<=0) speed_inc_y-=acceleration; ELSE speed_inc_y-=brake; END
                END
                IF (key(_down))
                    IF (speed_inc_y>=0) speed_inc_y+=acceleration; ELSE speed_inc_y+=brake; END
                END
            END
            CASE 2:         // Reads the keyboard from player2
                IF (key(_t))
                    IF (speed_inc_x>=0) speed_inc_x+=acceleration; ELSE speed_inc_x+=brake; END
                END
                IF (key(_r))
                    IF (speed_inc_x<=0) speed_inc_x-=acceleration; ELSE speed_inc_x-=brake; END
                END
                IF (key(_q))
                    IF (speed_inc_y<=0) speed_inc_y-=acceleration; ELSE speed_inc_y-=brake; END
                END
                IF (key(_a))
                    IF (speed_inc_y>=0) speed_inc_y+=acceleration; ELSE speed_inc_y+=brake; END
                END
            END
            CASE 3:         // Computer1's intelligence
                ballposx=idball0.x+(get_distx(fget_angle(1130,480,idball0.x,idball0.y),25));
                ballposy=idball0.y+(get_disty(fget_angle(1130,480,idball0.x,idball0.y),25));
                realangle=near_angle(realangle,fget_angle(x,y,ballposx,ballposy),15000);
                realspeed+=100;
                speed_inc_x=get_distx(realangle,realspeed);
                speed_inc_y=get_disty(realangle,realspeed);
            END
            CASE 4:         // Computer2's intelligence
                ballposx=idball0.x+(get_distx(fget_angle(80,480,idball0.x,idball0.y),25));
                ballposy=idball0.y+(get_disty(fget_angle(80,480,idball0.x,idball0.y),25));
                realangle=near_angle(realangle, fget_angle(x,y,ballposx,ballposy),15000);
                realspeed+=100;
                speed_inc_x=get_distx(realangle,realspeed);
                speed_inc_y=get_disty(realangle,realspeed);
            END
        END

        // Moves the ship
        x+=(speed_inc_x/200);
        y+=(speed_inc_y/200);

        // And brakes it a bit
        IF (speed_inc_x>0) speed_inc_x-=40; END
        IF (speed_inc_y>0) speed_inc_y-=40; END
        IF (speed_inc_x<0) speed_inc_x+=40; END
        IF (speed_inc_y<0) speed_inc_y+=40; END

        // Truncates speed with the maximum speed
        IF (fget_dist(0,0,speed_inc_x,speed_inc_y)>maxspeed)
            // Does it in a circular way
            _frame=fget_angle(0,0,speed_inc_x,speed_inc_y);
            speed_inc_x=get_distx(_frame,maxspeed);
            speed_inc_y=get_disty(_frame,maxspeed);
        END

        // Checks the collision between ships
        IF ((idship=collision(TYPE ship)) AND id<>idship)

            // Plays a sound and puts an explosion between both ships
            sound(idsbump1,rand(15,65),256);
            explosion(x+get_distx(get_angle(idship),get_dist(idship)/2),y+get_disty(get_angle(idship),get_dist(idship)/2));

            // Refreshes ships' angle and speed variables
            realangle=fget_angle(0,0,speed_inc_x,speed_inc_y);
            realspeed=fget_dist(0,0,speed_inc_x,speed_inc_y);
            idship.realangle=fget_angle(0,0,idship.speed_inc_x,idship.speed_inc_y);
            idship.realspeed=fget_dist(0,0,idship.speed_inc_x,idship.speed_inc_y);

            // Increments speeds with crashes and additions
            realspeed+=100;idship.realspeed+=100;
            tspeed0=realspeed+idship.realspeed;

            // Calculates the angle between ships
            shipsangle=get_angle(idship);

            // Calculates vertical and horizontal increments
            incr_x=get_distx(realangle,realspeed);
            incr_y=get_disty(realangle,realspeed);
            idship.incr_x=get_distx(idship.realangle,idship.realspeed);
            idship.incr_y=get_disty(idship.realangle,idship.realspeed);

            // And adds increments (= ships' angles)
            add_speed_x=incr_x+idship.incr_x; add_speed_y=incr_y+idship.incr_y;
            tdistance=fget_dist(0,0,add_speed_x,add_speed_y);

            // A ship is moved towards a direction
            incr_x-=get_distx(shipsangle,tdistance);
            incr_y-=get_disty(shipsangle,tdistance);

            // And the other towards the opposite direction
            idship.incr_x+=get_distx(shipsangle,tdistance);
            idship.incr_y+=get_disty(shipsangle,tdistance);

            // Angle and speed variables are refreshed
            realangle=fget_angle(0,0,incr_x,incr_y);
            realspeed=fget_dist(0,0,incr_x,incr_y);
            idship.realangle=fget_angle(0,0,idship.incr_x,idship.incr_y);
            idship.realspeed=fget_dist(0,0,idship.incr_x,idship.incr_y);

            // And sets it equally to initial speeds
            tspeed1=realspeed+idship.realspeed;
            IF (tspeed1==0) tspeed1=1; END

            // Ships' speeds are refreshed
            realspeed=tspeed0*realspeed/tspeed1;
            idship.realspeed=tspeed0*idship.realspeed/tspeed1;

            // And an increment is added to the other ship if this has the strength item
            realspeed+=idship.otherstrength;
            idship.realspeed+=otherstrength;

            // Vertical and horizontal increments are refreshed
            speed_inc_x=get_distx(realangle,realspeed);
            speed_inc_y=get_disty(realangle,realspeed);
            idship.speed_inc_x=get_distx(idship.realangle,idship.realspeed);
            idship.speed_inc_y=get_disty(idship.realangle,idship.realspeed);
        END

        // Ships' angle and speed are refreshed after increments
        realangle=fget_angle(0,0,speed_inc_x,speed_inc_y);
        realspeed=fget_dist(0,0,speed_inc_x,speed_inc_y);

        // If the ship is moving, the graphic is turned to its true direction
        IF (realspeed>200)
            angle=near_angle(angle,realangle,10000);
            graphicangle=realangle-angle;
            gfinalangle=near_angle(gfinalangle,graphicangle,15000);
            WHILE (gfinalangle<0) gfinalangle+=360000; END
            WHILE (gfinalangle>=360000) gfinalangle-=360000; END
            graph=inigraph+(gfinalangle/15000);
        END

        // Checks if the ball has been touched
        IF (idball=collision(TYPE ball))

            // A sound is played
            sound(idsbump3,rand(5,50),256);

            // And ball's speed is incremented depending on the ship's one
            idball.ballspeed=realspeed+1200;

            // Checks if the player or the computer touched it
            IF (which==player1 OR which==player2)

                // If the player did, ship's direction angles are added
                // with the angle formed between both them.
                real_speed=realspeed;
                IF (real_speed>400) real_speed=400; END
                addangx=get_distx((get_angle(idball)),400);
                addangy=get_disty((get_angle(idball)),400);
                angx=get_distx(realangle,real_speed);
                angy=get_disty(realangle,real_speed);
                addangx+=angx; addangy+=angy;
                idball.ballangle=fget_angle(0,0,addangx,addangy);
            ELSE
                // If the computer did, the angle between both is taken
                idball.ballangle=get_angle(idball);
            END
        END

        // Checks collision with the superior or inferior edge
        IF (y<219 OR y>733)
            sound(idsbump2,rand(5,50),256);
            speed_inc_y=-speed_inc_y;
            IF (y<219) y=220; explosion(x,y-25); END
            IF (y>733) y=732; explosion(x,y+25); END
        END

        // Checks if the ship is on the side edges
        IF (x<154 OR x>1046)
            // Checks if the ship was inside the goal
            IF  (lasty=>425 AND lasty<=531)

                // Checks if the ship touches goal's edges
                IF (y<425 OR y>526)
                    sound(idsbump2,rand(5,50),256);
                    speed_inc_y=-speed_inc_y;
                    IF (y<425) y=426; explosion(x,y-25); END
                    IF (y>526) y=525; explosion(x,y+25); END
                END

                // Checks if the ship touches the end of the goal
                IF (x<80 OR x>1120)
                    sound(idsbump2,rand(5,50),256);
                    speed_inc_x=-speed_inc_x;
                    IF (x<80) x=81; explosion(x-25,y); END
                    IF (x>1120) x=1119; explosion(x+25,y); END
                END
            ELSE

                // The ship is touching side edges of field
                speed_inc_x=-speed_inc_x;
                sound(idsbump2,rand(5,50),256);
                IF (x<154) x=155; explosion(x-25,y); END
                IF (x>1046) x=1045; explosion(x+25,y); END
           END
        END

        FRAME(50);
        lastx=x; lasty=y;
    END
END

//------------------------------------------------------------------------------
// Process goalscored
// Handles scored goals
//------------------------------------------------------------------------------

PROCESS goalscored()

PRIVATE
    idtext;        // Text identifier for the 'GOAL!'

BEGIN
    sound(idsgoal,75,256);                    // Plays a sound
    signal(TYPE ball,s_freeze);               // For ball's process
    signal(TYPE ship,s_freeze);               // And the ships
    idtext=write(font2,320,240,4,"GOAL!");    // Puts the 'GOAL' text
    counter=0;
    WHILE (counter<10 AND NOT key(_space))    // Waits a bit for the space key to be pressed
        counter++;
        FRAME;
    END
    fade_off();
    signal(TYPE ball,s_kill);                 // Kills old process
    signal(TYPE ship,s_kill);
    signal(TYPE goals,s_kill);
    signal(TYPE objects,s_kill);
    signal(TYPE scoreobjects,s_kill);
    signal(TYPE shadow,s_kill);
    delete_text(idtext);                       // Deletes text
    inifield();                             // And creates new objects
    fade_on();                                 // Fades the screen on
END

//------------------------------------------------------------------------------
// Process explosion
// Prints explosions when there's a crash
//------------------------------------------------------------------------------

PROCESS explosion (x,y)

BEGIN
    ctype=c_scroll; // Introduces the process within the scroll
    flags=4;        // Transparent
    graph=51;       // Chooses a graphic
    z=-40;          // puts it over
    WHILE (graph<58) graph++; FRAME; END    // Plays the animation
END

//------------------------------------------------------------------------------
// Process scores
// Prints scores' backgrounds
//------------------------------------------------------------------------------

PROCESS scores()

BEGIN
    x=320;              // Selects coordinates
    y=20;
    graph=60;           // Puts background score for the time
    z=-1;
    CLONE               // Creates anther score
        graph=59;       // Puts player1's background score
        x=76;           // Changing the graphic's position
        CLONE           // Creates another score
            x=564;      // Player2's changing the position
        END
    END
    LOOP FRAME; END
END

//------------------------------------------------------------------------------
// Process inifield
// Reinitializes all process
//------------------------------------------------------------------------------

PROCESS inifield()

BEGIN
    SWITCH (gamemode)      // Initializes the game depending on the type of players

        CASE 0:            // Player1 vs Player2
            define_region(1,0,0,319,480);       // Defines two regions of screen
            define_region(2,322,0,319,480);
            start_scroll(0,0,idstadium,0,2,0);  // And two movements for them
            start_scroll(1,0,idstadium,0,1,0);
            idball0=ball();                     // Creates ball
            idship1=ship(qplayer1);             // and both ships
            idship2=ship(qplayer2);
            scroll[0].camera=idship1;           //Makes camera follow ships
            scroll[1].camera=idship2;
        END
        CASE 1:             // Player1 vs Computer
            start_scroll(0,0,idstadium,0,0,0);  // Creates screen movement
            idball0=ball();                     // Creates ball
            idship1=ship(qplayer1);             // and both ships
            idship2=ship(qplayer2);
            scroll[0].camera=idship1;           // Makes camera follow player
        END
        CASE 2:     // Computer vs Player2
            start_scroll(0,0,idstadium,0,0,0);  // Creates screen movement
            idball0=ball();                     // Creates ball
            idship1=ship(qplayer1);             // and both ships
            idship2=ship(qplayer2);
            scroll[0].camera=idship2;           // Makes camera follow player
        END
        CASE 3:     // Computer vs Computer
            start_scroll(0,0,idstadium,0,0,0);  // Creates screen movement
            idball0=ball();                     // Creates ball
            idship1=ship(qplayer1);             // and both ships
            idship2=ship(qplayer2);
            scroll[0].camera=idball0;           // Makes camera follow ball
        END
    END
    goals();            // Creates goals
    scoreobjects();      // And the scores' backgrounds

END

//------------------------------------------------------------------------------
// Process goals
// Prints the goals that overlaped on top
//------------------------------------------------------------------------------

PROCESS goals ()

BEGIN
    ctype=c_scroll; // Introduces process within scroll
    z=-50;
    x=77;           // Selects graphic's coordinates
    y=477;
    graph=61;       // Selects the graphic and creates left goal
    CLONE           // Creates right goal
        graph=62;   // Changin coordinates and graphic
        x=1122;
        y=478;
    END
    LOOP FRAME; END

END

//------------------------------------------------------------------------------
// Process shadow
// Handles ships' shadows
//------------------------------------------------------------------------------

PROCESS shadow()

BEGIN
    ctype=c_scroll; // Introduces process within scroll
    x=father.x;     // Takes father's process coordinates (the one that called this process)
    y=father.y;
    flags=4;        // Makes it transparent
    z=1;
    graph=63;       // Selects the graphic
    LOOP
        x=father.x;
        y=father.y;         // Follows the process that called him
        angle=father.angle; // Takes father's angle
        FRAME;
    END
END

//------------------------------------------------------------------------------
// Process objects
// Handles bonus objects
//------------------------------------------------------------------------------

PROCESS objects ()

PRIVATE
    bonustype;          // Bonus type: 0-> Points
                        //             1-> Best control
                        //             2-> More strength
                        //             3-> For the other ship
    initialgraphic;     // Initial graphic for the object
    idship;             // Ships' identifiers
BEGIN
    ctype=c_scroll;     // Makes process have scroll cordinates
    z=10;
    file=file2;             // Selects graphics files
    bonustype=rand(0,3);    // And a random bonus
    bonusyes=1;
    graph=(bonustype*8)+1;  // Select graphic depending on bonus type
    initialgraphic=graph;   // Initializes object's graphic
    REPEAT                  // Waits, so it doesn't overlap anything
        x=rand(142,1057);
        y=rand(206,747);
    UNTIL (NOT collision(TYPE ship) AND NOT collision (TYPE ball))
    size=0;
    timer[1]=0;                             // Sets time counter to 0
    WHILE (timer[1]<15000)                   // Leaves it on the screen for 15 secs
        IF (size<100) size+=5; END          // Makes it appear magnifying the graphic
        angle+=5000;                        // Rotates it at each step
        graph++;                            // Plays animation1
        IF (graph>initialgraphic+7) graph=initialgraphic; END
        FRAME;
        IF (idship=collision(TYPE ship))    // Checks for collision with the other ship
            sound(idsscore,100,256);
            timer[2]=0;
            explosion(x,y);
            idship.bonus=bonustype+1;       // Refreshes ships' bonus variables
            IF (idship.which==player1 OR idship.which==computer1)
                idship2.bonus=0;
            ELSE
                idship1.bonus=0;
            END
            SWITCH (bonustype)              // Looks what type of bonys it is
                CASE 0:                     // Gives points
                    IF (idship.which==player1 OR idship.which==computer1)
                        score1+=10;
                    ELSE
                        score2+=10;
                    END
                    bonustime=100;        // The effect lasts 1 second
                    break;
                END
                CASE 1:                   // Makes ship easier to handle
                    idship.maxspeed=30000; // More speed
                    idship.acceleration=8000; // More acceleration
                    idship.brake=16000;    // Best brakes
                    bonustime=50000;        // Lasts 5 secs
                    break;
                END
                CASE 2:                   // Makes bump strength greater
                    idship.otherstrength=20000;
                    bonustime=150000;       // Lasts 15 secs
                    break;
                END
                CASE 3:                   // For the other ship
                    IF (idship.which==player1 OR idship.which==computer1)
                        signal(idship2,s_freeze);
                    ELSE
                        signal(idship1,s_freeze);
                    END
                    bonustime=200;        // Lasts 2 secs
                    break;
                END
            END
        END
    END
    explosion(x,y);     // If item desappears, plays an explosion
    bonusyes=0;         // Leaves it ready for new bonuses
END

//------------------------------------------------------------------------------
// Process scoreobjects
// Controls selected objects on the score
//------------------------------------------------------------------------------

PROCESS scoreobjects()

PRIVATE
    initial_graphic;    // Initial graphic for the object
    lastobject1=0;      // Last object taken by the player on the left
    lastobject2=0;      // Last object taken by the player on the right
    idship;             // Ship's identifier
    bonustype;          // Bonus time taken

BEGIN
    z=-10; y=20;        // Selects some variables and the graphics file
    file=file2;
    LOOP
        // Checks if the player on the left took it
        IF (idship1.bonus<>0 AND idship1.bonus<>lastobject1)
            initial_graphic=((idship1.bonus-1)*8)+1;
            graph=initial_graphic;
            x=177;
            lastobject1=idship1.bonus;
            lastobject2=0;
            timer[2]=0;
        END

        // Checks if the player on the right took it
        IF (idship2.bonus<>0 AND idship2.bonus<>lastobject2)
            initial_graphic=((idship2.bonus-1)*8)+1;
            graph=initial_graphic;
            x=463;
            lastobject2=idship2.bonus;
            lastobject1=0;
            timer[2]=0;
        END

        // If any of them have it, animates the graphic
        IF (idship1.bonus<>0  OR idship2.bonus<>0)
            graph++;
            IF (graph>initial_graphic+7) graph=initial_graphic; END
        END
        FRAME;

        // Checks that the effect time has not gone yet, and that there is a bonus
        IF (timer[2]>bonustime AND bonustime<>-1)
            bonustime=-1;
            IF (idship1.bonus<>0)
                idship=idship1;
            ELSE
                idship=idship2;
            END
            bonustype=(idship.bonus)-1;
            SWITCH (bonustype)          // Quits bonus effect
                CASE 0:                 // Reinitializes variables
                    idship.bonus=0;
                    timer[2]=0;         // Reinitializes field
                    graph=0;            // Quits graphic
                END
                CASE 1:     // Sets speed, brake y acceleration like they were before
                    idship.maxspeed=2000;
                    idship.acceleration=400;
                    idship.brake=800;
                    idship.bonus=0;
                    timer[2]=0;         // Reinitiates time
                    graph=0;            // Quits graphic
                END
                CASE 2:     // Sets bump strength to zero
                    idship.otherstrength=0;
                    idship.bonus=0;
                    timer[2]=0;         // Reinitiates time
                    graph=0;            // Quits graphic
                END
                CASE 3:     // Makes the other ship to move
                    IF (idship.which==player1 OR idship.which==computer1)
                        signal(idship2,s_wakeup);
                    ELSE
                        signal(idship1,s_wakeup);
                    END
                    idship.bonus=0;
                    timer[2]=0;         // Reinitiates time
                    graph=0;            // Quits graphic
                END
            END
        END
   END
END

//------------------------------------------------------------------------------
// Process credits
// Prints program's credits and exits the game
//------------------------------------------------------------------------------

PROCESS credits()

PRIVATE
    idbckgr;    // Background graphic identifier

BEGIN
    // Eliminates any remaining process or text
    let_me_alone();
    delete_text(all_text);

    // Loads background screen with its palette and prints it on the screen
    idbckgr=load_map("heliobal\credits.map");
    load_pal("heliobal\credits.map");
    put_screen(0,idbckgr);

    // Prints credits texts
    write(font4,320,45,4,"CODE:");
    write(font4,320,90,4,"ANTONIO MARCHAL.");

    write(font4,320,145,4,"GRAPHICS:");
    write(font4,320,190,4,"JOSE FERNANDEZ");
    write(font4,320,230,4,"RAFAEL BARRASO");

    write(font4,320,290,4,"SOUNDS:");
    write(font4,320,335,4,"ANTONIO MARCHAL");
    fade_on();  // Fades the screen on

    // Waits until a key is pressed
    scan_code=0;
    WHILE (scan_code==0)
        FRAME;
    END
    fade_off(); // Fades screen off
    exit("Thanks for playing!",0);   // Exits program
END

//------------------------------------------------------------------------------
// Process menu_bar
// Prints menu's bars
// Entries: Predefined system variables
//------------------------------------------------------------------------------

PROCESS menu_bar(x,y,graph,file,flags,z)

BEGIN
    LOOP
        FRAME;
    END
END
