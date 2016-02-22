//
//--------------------------------------------------------------------
// Program:   Tutorial 2
// Author:    Daniel Navarro Medrano
// Date:      20/10/97
//    --------------------------------------------------------------------

PROGRAM Tutorial_2;
import "dll/wpix.dll";

GLOBAL
earths=0;
s=0;
b=0;
n=0;
r=0;
t=0;
f=0;
th=15;
BEGIN
    // Loads graphics' file
    load_fpg("tutor2.fpg");//tutorial\tutor2.fpg");
    f=load_fnt("o.FNT");
    // Sets the number of frames per second
    set_mode(m320x200);
    set_fps(99,0);//99,0);
    // Puts background screen
    put_screen(0,41);
    //xput(0,41,320,240,0,200,0,0);
    // Writes an explanable message
    write(f,160,2,1,"Press space bar to create 1000 planets");
    write(f,0,th,0,"FPS:");
    write_int(f,40,th,0,&fps);
    write_int(f,0,2*th,0,&earths);
    write_int(f,0,3*th,0,&b);
    write_int(f,0,4*th,0,&s);
    write_int(f,0,5*th,0,&t);

    // Creates an endless loop, since no process has been created yet,
    // and program will end if this loop didn't exist
    LOOP
        // Each time the space key is pressed, an earth type
        // process is created
        //
      //  pixelate_screen(mouse.x);
      //  pixelate_background(mouse.y);
        if(key(_esc))
        let_me_alone();
        earths=0;
        end

        IF (key(_space) or mouse.left) //|| nouse.left) //iyse)
        //if(mouse.left)

           n=0;

        while(n<1000)
        r=earth();
        n++;
        end

        while(key(_space) or mouse.left)
        frame;



        end
        END
        if(r)
        t=r.graph;
        end
    if(key(_left) && s>0) s--; end
    if(key(_right) && s<320) s++; end
    if(key(_up) && b>0) b--; end
    if(key(_down) && b<320) b++; end

        //e//END
        pixelate_screen(s);
        pixelate_background(b);
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
    earths++;
    // Creates process on left middle side
    x=10;//mouse.x*10;//l0; y=1800;
    y=1800;//4600;//000;//mouse.y;
    resolution=10;  // Forces coordinates to use one decimal
    z=rand(-100 ,100);

   // priority=20;
    //rand(0,100);

    //  size=100;
    // Initiates horizontal increment from 1 to 8 points
    velocity_x=rand(10,80);
    // Reinitiates initial bounce length from 8 to 25 points
    initial_velocity_y=rand(-80,-250);
    // Vertical increment equals bounce length
    velocity_y=initial_velocity_y;
    // Creates an endless loop
    size=50;//+rand(0,40);
    //z=-1000;
  //priority=99;



    //flags=4;
    //while(graph==0)//LOOP
    loop
    z=rand(-512,512);

        // Creates a loop that goes over every single image
        // that composes the animation, which ranges from code numbers 0 to 40
        FROM graph=1 TO 40;
      //  angle=(640-x)*50;
       //graph=((x/10)%400)/10;
            // Moves process horizontally
            //size=5+y/50;//rand(0,40);

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
      //      if(collision(type earth))
      //      size++;
      //      end
        END



     //   if(size<10)
    //        break;
     //   end


    END
   earths--;
END
