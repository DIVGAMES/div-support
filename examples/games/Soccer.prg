
/*-------------------------------------------------------------------
/   TITLE: SOCCER
/   AUTHOR:  Antonio Marchal
/   DATE:  DIV GAMES STUDIO (c) 2000
//-------------------------------------------------------------------*/

//
//
//    Our appologies for this program being in Spanish. Whilst we have
//    translated the other games as best as we could this one proved to
//    be just a bit too much.  To ensure we were able to meet our
//    release date we had no choice but to leave it as is.
//
//    It was either this or leave it out altogether which we didn't think
//    you would be to happy about.
//
//


PROGRAM soccer;

CONST

    pase=0;
    parado=1;
    normal=2;
    conbalon=3;
    atontado=4;
    desmarcado=5;
    esperandopase=6;
    irasaque=7;
    saquedebanda=8;
    porterotirandose=10;
    iracorner=11;
    tirandocorner=12;
    irarecibecorner=13;
    recibecorner=14;

    xicampo=176;
    yicampo=182;
    xfcampo=754;
    yfcampo=1149;

    campoagobio=4000;

    campoagobiojug=2000;


    zonaquitada=5000;

    zonarecogida=700;
    totaltestigo=5;
    zonatiro1=20000;
    zonatiro2=35000;
    vmaxima=300;
    vmaximacg=200;

    vmaxima=300;
    vmaximacg=200;

    vmaximajug=450;
    vmaximacgjug=300;


    azar=10;
    retardoatontado=3;
    conbote=2500;
    distanciacamara=180;
    alturacamara=224;
    cambiodesmarcado=100;
    incrvelocidadpelota=50;


GLOBAL

    idinicio;
    elegidosaque=0;
    conmarcadores=1;
    conintro=0;
    idnumerojugador=0;

    letras[]="Q","W","E","R","T","Y","U","I","O","P",
           "A","S","D","F","G","H","J","K","L","¥",
           "Z","X","C","V","B","N","M"," ",".";
    inicioparte=0;
    tipotiempo=0;
    totaltiempo=0;
    tiempojuego;
    idtextomensaje;
    controljugador=2;
    editando=0;

    fichero1; fichero2; fichero3; fichero4; fichero5; fichero6; fichero7; fichero8; fichero9;

    fuente1; fuente2; fuente3;

    idsonido0,idsonido1,idsonido2,idsonido3,idsonido4,idsonido5,idsonido6,idsonido7,idsonido8;
    idcanal,idcanal2;
    colorini1[3]=3,6,1,0;
    colorini2[3]=1,6,3,1;
    STRUCT nombres[23];
        letras[9];
    END
    STRUCT idnombres[23];
        idletras[9];
    END
    realopcionmenu1=-1;
    paljugador1[255];
    paljugador2[255];
    goles[1]=0,0;
    modovideo=0;
    quienmetegol=0;
    quienempieza=0;
    quiensacadebanda=0;
    quiensacacorner=0;
    porterosacando=0;
    cuenporterosacando=0;
    esquinacorner=0;
    sacando=0;
    sacandoporteria=0;
    sacandocorner=0;
    estadosaque=0;
    ultimotiro=0;
    incactual=0;
    incbote=0;
    testigo1=0;
    testigo2=0;
    testigo3=0;
    pesopelota=3;
    estadoataque=50;
    idjugadores1[9];
    idjugadores2[9];
    idporteros[1];
    idpelota;
    idcamara;
    estadoequipo=0;
    estadojuego=0;




    STRUCT tactica0[9]
        xi0,yi0;
        xi1,yi1;
        xp0,yp0;
        xp1,yp1;
        p0,p1;
        xc0,yc0;
        xc1,yc1;
    END =
          70,130, 70,120, 70,130, 40,460,15, 5, 75,465,150, 50,
         140,200,140,190,140,200,150,390,15, 5,225,465,240, 70,
         290,220,290,210,290,220,290,350,15, 5,320,410,320,100,
         450,200,450,190,450,200,460,390,15, 5,440,465,400, 70,
         510,130,510,120,510,130,540,460,15, 5,560,465,490, 50,
         170,340,170,330, 40,420, 50,660,10,10,160,190,170,170,
         290,350,290,340,290,420,290,660,10,10,320,190,320,170,
         450,340,450,330,520,420,550,660,10,10,480,190,460,170,
         290,480,320,410,130,550,150,790, 5,15,240,100,210,420,
         320,480,350,410,450,550,440,790, 5,15,400,100,410,420;

    STRUCT t ctica[9]
        xi0,yi0;
        xi1,yi1;
        xp0,yp0;
        xp1,yp1;
        p0,p1;
        xc0,yc0;
        xc1,yc1;
    END =
         510,130, 510,120, 530,210, 540,520, 15, 5, 75,465,150, 50,
         290,200, 290,190, 410,120, 420,340, 15, 5,225,465,240, 70,
         140,220, 140,210, 170,120, 120,330, 15, 5,320,410,320,100,
          70,200,  70,190,  80,210,  60,480, 15, 5,440,465,400, 70,
         450,130, 450,120, 470,320, 370,590, 10,10,560,465,490, 50,
         290,340, 290,330, 300,320, 160,590, 10,10,160,190,170,170,
         170,350, 170,340, 100,340,  90,700, 10,10,320,190,320,170,
         450,340, 450,330, 520,460, 460,770,  5,15,480,190,460,170,
         290,485, 320,410, 300,440, 290,820,  5,15,240,100,210,420,
         320,450, 350,410,  40,440, 130,800,  5,15,400,100,410,420;
    STRUCT equipototal[1]
        ataque;
        defensa;
        conbalon;
        desmarcado;
        esperandopase;
        saquedebanda;
        sacacorner;
        distanciaminima;
    END

LOCAL
        xi,yi;
        xp0,yp0;
        xp1,yp1;
        p0,p1;
        estado;
        equipo;
        pasa_a;
        tirando=0;
        contador;
        contador2;
        cuentaatontado;
        angulopelota=0;
        velocidadpelota=0;
        velocidad;
        n£mero;
        anguloportero;
        x_vieja;
        y_vieja;
        tirandose=0;
        cuentaanima;

PRIVATE
    idfondo;
    colorini[3]=3,6,1,0;
    idtextosvarios[3];
    salirjuego;
    continuajuego=0;
    iniciomensaje=0;

BEGIN
    max_process_time=2000;
    idinicio=id;
    set_mode(m320x200);


    idsonido8=load_pcm("soccer\musica1.pcm",1);
    idcanal2=sound(idsonido8,100,256);
    scan_code=0;


    start_fli("fli\soccer\futbol1.fli",0,0);
    WHILE (frame_fli()<>0 AND scan_code==0 AND NOT mouse.left) FRAME; END
    end_fli();
    IF (scan_code==0 AND NOT mouse.left)
        start_fli("fli\soccer\futbol2.fli",0,0);
        WHILE (frame_fli()<>0 AND scan_code==0 AND NOT mouse.left) FRAME; END
        end_fli();
    END
    IF (scan_code==0 AND NOT mouse.left)
        start_fli("fli\soccer\futbol3.fli",0,0);
        WHILE (frame_fli()<>0 AND scan_code==0 AND NOT mouse.left) FRAME; END
        end_fli();
    END
    WHILE (scan_code<>0 OR mouse.left) FRAME; END
    LOOP
        set_mode(m640x480);
        set_fps(20,1);

        idsonido0=load_pcm("soccer\silbato.pcm",0);
        idsonido1=load_pcm("soccer\aplauso.pcm",0);
        idsonido2=load_pcm("soccer\aplauso2.pcm",0);
        idsonido3=load_pcm("soccer\golpe.pcm",0);
        idsonido4=load_pcm("soccer\fondo.pcm",1);
        idsonido5=load_pcm("soccer\bote.pcm",0);
        idsonido6=load_pcm("soccer\barrida.pcm",0);
        idsonido7=load_pcm("soccer\saqueban.pcm",0);


        fuente1=load_fnt("soccer\futbol0.fnt");
        fuente2=load_fnt("soccer\futbol1.fnt");
        fuente3=load_fnt("soccer\futbol3.fnt");


        fichero1=load_fpg("soccer\menus.fpg");
        fichero2=load_fpg("soccer\traje.fpg");
        fichero3=load_fpg("soccer\traje.fpg");
        fichero4=load_fpg("soccer\intro.fpg");


        load ("dat\soccer\nombres.dat",&nombres);


        load ("dat\soccer\traje0.dat",&colorini1);
        load ("dat\soccer\traje1.dat",&colorini2);


        FOR (contador=0;contador<256;contador++)
            paljugador1[contador]=contador;
            paljugador2[contador]=contador;
        END


        FOR (contador2=0;contador2<4;contador2++)
            FOR (contador=1;contador<6;contador++)
                paljugador1[(colorini[contador2]*5)+contador]=(colorini2[contador2]*5)+contador;
                paljugador2[(colorini[contador2]*5)+contador]=(colorini1[contador2]*5)+contador;
            END
        END


        FOR (contador=1;contador<5;contador++)
            convert_palette(fichero2,contador,&paljugador2);
            convert_palette(fichero3,contador,&paljugador1);
        END
        mouse.x=320; mouse.y=240; mouse.left=0;
        IF (conintro==0)


            idfondo=load_map("soccer\intro.map");
            load_pal("soccer\intro.map");


            mouse.file=fichero4; mouse.graph=908;


            put_screen(0,idfondo);


            titulosoccer();
            titulofutbol97();
            fade_on();


            WHILE (scan_code==0 AND NOT mouse.left AND NOT mouse.right)
                scan_code=0;
                FRAME;
            END


            IF (key(_esc) OR mouse.right)
                cr‚ditos();
                FRAME;
            END
            fade_off();


            signal(TYPE titulosoccer,s_kill_tree);
            signal(TYPE titulofutbol97,s_kill_tree);
            signal(TYPE textopulsaunatecla,s_kill);
            delete_text(all_text);
            clear_screen();
            unload_map(idfondo);
        END

        mouse.graph=909; mouse.file=fichero1;

        idfondo=load_map("soccer\menu.map");
        load_pal("soccer\menu.map");


        put_screen(0,idfondo);


        pintaopciones1();
        eligeopciones1();
        fade_on();


        WHILE (realopcionmenu1==-1)
            FRAME;
        END


        signal(TYPE pintaopciones1,s_kill_tree);
        signal(TYPE eligeopciones1,s_kill_tree);
        conintro=0;
        fade_off();


        unload_map(idfondo);


        clear_screen();
        delete_text(all_text);
        salirjuego=0;


        IF (realopcionmenu1==1)


            save ("dat\soccer\traje0.dat",&colorini1,sizeof(colorini1));
            save ("dat\soccer\traje1.dat",&colorini2,sizeof(colorini2));


            idfondo=load_map("soccer\nombres.map");
            load_pal("soccer\nombres.map");
            put_screen(0,idfondo);
            realopcionmenu1=-1;
            fade_on();


            WHILE (realopcionmenu1==-1)
                opciones2();
                FRAME;
            END


            save ("dat\soccer\nombres.dat",&nombres,sizeof(nombres));
            fade_off();


            IF (editando==1)
                editando=0; signal (TYPE introduce_nombre,s_kill_tree);
            END
            realopcionmenu1=-1;
            conintro=1;
            mouse.left=0;
            WHILE (mouse.left) FRAME; END
        END


        IF (realopcionmenu1==3)
            unload_pcm(idsonido8);


            conmarcadores=1;
            goles[0]=0; goles[1]=0;
            SWITCH (tipotiempo)
                CASE 0: totaltiempo=60;END
                CASE 1: totaltiempo=120;END
                CASE 2: totaltiempo=240;END
                CASE 3: totaltiempo=480;END
            END


            unload_fpg(fichero1);
            unload_fpg(fichero2);
            unload_fpg(fichero3);
            unload_fpg(fichero4);
            unload_fnt(fuente1);
            unload_fnt(fuente2);
            unload_fnt(fuente3);


            save ("dat\soccer\traje0.dat",&colorini1,sizeof(colorini1));
            save ("dat\soccer\traje1.dat",&colorini2,sizeof(colorini2));


            delete_text(all_text);
            let_me_alone();


            salirjuego=0;
            inicioparte=0;


            WHILE (NOT key(_esc) AND inicioparte<>5 AND salirjuego==0)


                equipototal[0].ataque=0;
                equipototal[0].defensa=0;
                equipototal[0].conbalon=0;
                equipototal[0].desmarcado=0;
                equipototal[0].esperandopase=0;
                equipototal[0].saquedebanda=0;
                equipototal[0].distanciaminima=0;
                equipototal[1].ataque=0;
                equipototal[1].defensa=0;
                equipototal[1].conbalon=0;
                equipototal[1].desmarcado=0;
                equipototal[1].esperandopase=0;
                equipototal[1].saquedebanda=0;
                equipototal[1].distanciaminima=0;
                quienmetegol=0;


                IF (inicioparte==0)
                    quienempieza=0;
                ELSE
                    quienempieza=1;
                END


                quiensacadebanda=0;
                quiensacacorner=0;
                porterosacando=0;
                cuenporterosacando=0;
                esquinacorner=0;
                sacando=0;
                sacandoporteria=0;
                sacandocorner=0;
                estadosaque=0;
                ultimotiro=0;
                incactual=0;
                incbote=0;
                testigo1=0;
                testigo2=0;
                testigo3=0;
                pesopelota=3;
                estadoataque=50;
                estadoequipo=0;
                estadojuego=0;
                let_me_alone();
                FOR (contador=0;contador<10;contador++)
                    IF (idjugadores1[contador])
                        idjugadores1[contador].estado=normal;
                    END
                    IF (idjugadores2[contador])
                        idjugadores2[contador].estado=normal;
                    END
                END


                set_mode(m640x480);


                fichero1=load_fpg("soccer\traje.fpg");
                fichero2=load_fpg("soccer\traje.fpg");
                fichero3=load_fpg("soccer\menus.fpg");


                load ("dat\soccer\traje0.dat",&colorini1);
                load ("dat\soccer\traje1.dat",&colorini2);


                FOR (contador=0;contador<256;contador++)
                    paljugador1[contador]=contador;
                    paljugador2[contador]=contador;
                END


                FOR (contador2=0;contador2<4;contador2++)
                    FOR (contador=1;contador<6;contador++)
                        paljugador1[(colorini[contador2]*5)+contador]=(colorini2[contador2]*5)+contador;
                        paljugador2[(colorini[contador2]*5)+contador]=(colorini1[contador2]*5)+contador;
                    END
                END
                FOR (contador=1;contador<5;contador++)
                    convert_palette(fichero1,contador,&paljugador2);
                    convert_palette(fichero2,contador,&paljugador1);
                END


                fuente2=load_fnt("soccer\futbol3.fnt");
                fuente3=load_fnt("soccer\futbol1.fnt");


                idfondo=load_map("soccer\presenta.map");
                put_screen(0,idfondo);


                IF (inicioparte==0)
                    write(fuente2,320,10,1,"- 1st TIME -");
                ELSE
                    write(fuente2,320,10,1,"- 2nd TIME -");
                END


                SWITCH (tipotiempo)
                    CASE 0: write(fuente2,320,430,4,"TIME 2:00"); END
                    CASE 1: write(fuente2,320,430,4,"TIME 4:00"); END
                    CASE 2: write(fuente2,320,430,4,"TIME 8:00"); END
                    CASE 3: write(fuente2,320,430,4,"TIME 16:00"); END
                END


                iniciomensaje=50;
                FROM contador=9 TO 0;
                    IF (nombres[0].letras[contador]==letras[27])
                        iniciomensaje+=9;
                    ELSE
                        BREAK;
                    END
                END
                escribe_nombre(iniciomensaje,100,0,fuente3,18);
                iniciomensaje=410;
                FROM contador=9 TO 0;
                    IF (nombres[12].letras[contador]==letras[27])
                        iniciomensaje+=9;
                    ELSE
                        BREAK;
                    END
                END
                escribe_nombre(iniciomensaje,100,12,fuente3,18);


                write_int(fuente2,140,340,1,&goles[0]);
                write(fuente2,320,340,1,"-");
                write_int(fuente2,500,340,1,&goles[1]);


                traje2(141,210,1,fichero1);
                traje2(140,210,2,fichero1);
                traje2(140,270,3,fichero1);
                traje2(140,320,4,fichero1);
                traje2(501,210,1,fichero2);
                traje2(500,210,2,fichero2);
                traje2(500,270,3,fichero2);
                traje2(500,320,4,fichero2);


                mouse.graph=909;
                mouse.file=fichero3;


                WHILE(key(_space)) FRAME;  END
                WHILE(mouse.left) FRAME;  END


                idtextosvarios[3]=0;
                continuajuego=0;


                WHILE (NOT key(_space) AND continuajuego==0)


                    IF (comprueba_raton(550,395,615,455))
                        idtextosvarios[3]=write(0,580,390,4,"CONTINUE");
                    END


                    bot¢n(580,422,0,comprueba_raton(550,395,615,455),fichero3);


                    IF (comprueba_raton(550,395,615,455)==3)
                        continuajuego=1;
                    END

                    FRAME;
                    IF (idtextosvarios[3]<>0)
                        delete_text(idtextosvarios[3]);
                        idtextosvarios[3]=0;
                    END
                END


                fade_off();


                mouse.graph=0;
                signal(TYPE traje2,s_kill);


                unload_fpg(fichero1);
                unload_fpg(fichero2);
                unload_fpg(fichero3);


                clear_screen();
                delete_text(all_text);
                fade_on();
                set_fps(24,0);
                set_mode(m640x480);

                fichero1=load_fpg("soccer\futbol.fpg");
                fichero2=load_fpg("soccer\jugador0.fpg");
                fichero3=load_fpg("soccer\jugador0.fpg");
                fichero4=load_fpg("soccer\portero0.fpg");
                fichero5=load_fpg("soccer\portero1.fpg");
                fichero6=load_fpg("soccer\balon.fpg");
                fichero7=load_fpg("soccer\sombras2.fpg");
                fichero8=load_fpg("soccer\sombrap0.fpg");
                fichero9=load_fpg("soccer\sombrap1.fpg");


                fuente1=load_fnt("soccer\futbol3.fnt");
                fuente2=load_fnt("soccer\futbol1.fnt");
                fuente3=load_fnt("soccer\futbol2.fnt");


                FOR (contador=0;contador<256;contador++)
                    paljugador1[contador]=contador;
                    paljugador2[contador]=contador;
                END


                FOR (contador2=0;contador2<4;contador2++)
                    FOR (contador=1;contador<6;contador++)
                        paljugador1[(colorini[contador2]*5)+contador]=(colorini2[contador2]*5)+contador;
                        paljugador2[(colorini[contador2]*5)+contador]=(colorini1[contador2]*5)+contador;
                    END
                END


                FOR (contador=1;contador<97; contador++)
                    convert_palette(fichero3,contador,&paljugador2);
                    convert_palette(fichero2,contador,&paljugador1);
                END


                start_mode7(0,fichero1,100,0,0,0);


                m7.height=alturacamara;
                m7.focus=512;
                m7.color=158;

                valla();
                bander¡n (xicampo,yicampo);
                bander¡n (xicampo,yfcampo);
                bander¡n (xfcampo,yicampo);
                bander¡n (xfcampo,yfcampo);
                tu_porteria();
                su_porteria();
                idpelota=balon();


                idporteros[0]=porteros(0,(yfcampo-50)*100,fichero4);
                idporteros[1]=porteros(1,(yicampo+50)*100,fichero5);


                idcamara=camara();
                m7.camera=idcamara;


                equipototal[0].defensa=50;
                equipototal[0].ataque=50;
                equipototal[1].defensa=50;
                equipototal[1].ataque=50;


                FOR (contador=0;contador<10;contador++)
                    idjugadores1[contador]=ponjugador(contador,0);
                    idjugadores2[contador]=ponjugador(contador,1);
                END


                controlaequipo(0);
                controlaequipo(1);


                flecha(0);
                flecha(1);


                controlajuego ();


                tiempojuego=45-(((totaltiempo-(timer[0]/100))*45)/totaltiempo);



                IF (conmarcadores==1)
                        minicampo();
                        idtextosvarios[0]=write_int(fuente1,44,480,6,&goles[0]);
                        idtextosvarios[1]=write_int(fuente1,600,480,8,&goles[1]);
                        idtextosvarios[2]=write_int(fuente1,320,0,0,&tiempojuego);
                        ponminicamisas(20,456,65,fichero3,50);
                        ponminicamisas(620,456,65,fichero2,50);
                END

                restore_type=no_restore;
                fade_on();

                sound(idsonido2,50,256);

                idcanal=sound(idsonido4,50,256);

                WHILE (NOT key(_esc) AND inicioparte<>2 AND inicioparte<>5)

                    salirjuego=0;

                    IF (inicioparte==0 OR inicioparte==3) timer[0]=0; END

                    tiempojuego=45-(((totaltiempo-(timer[0]/100))*45)/totaltiempo);

                    IF (tiempojuego>45) tiempojuego=45; END

                    IF (tiempojuego==45 AND estadojuego==4 AND
                        idpelota.velocidadpelota==0 AND
                        equipototal[0].conbalon==0 AND
                        equipototal[1].conbalon==0 AND incbote==0)

                        IF (inicioparte==1)
                            inicioparte=2;
                            ponmensajes (6,20);
                        ELSE
                            inicioparte=5;
                            ponmensajes (7,20);
                        END

                        signal(id,s_freeze_tree);
                        signal(id,s_wakeup);
                        contador=0;

                        WHILE (NOT key (_space) AND contador<50) FRAME; contador++; END

                        signal(id,s_wakeup_tree);
                    END

                    delete_text(idtextosvarios[0]);
                    delete_text(idtextosvarios[1]);
                    delete_text(idtextosvarios[2]);

                    IF (conmarcadores==1)
                        IF (modovideo==0)
                            idtextosvarios[0]=write_int(fuente1,44,480,6,&goles[0]);
                            idtextosvarios[1]=write_int(fuente1,600,480,8,&goles[1]);
                            idtextosvarios[2]=write_int(fuente1,320,0,0,&tiempojuego);
                        ELSE
                            idtextosvarios[0]=write_int(fuente3,22,200,6,&goles[0]);
                            idtextosvarios[1]=write_int(fuente3,300,200,8,&goles[1]);
                            idtextosvarios[2]=write_int(fuente3,160,0,0,&tiempojuego);
                        END
                    END

                    estadoataque=(idpelota.y-((yicampo*100)+20))/(yfcampo-(yicampo+20));
                    IF (estadoataque<0) estadoataque=0; END
                    IF (estadoataque>100) estadoataque=100; END

                    change_sound(idcanal,(30*(100-estadoataque))/100,rand(230,280));

                    ponnombrejugador();
                    FRAME;
                    IF (key(_m))
                        IF (conmarcadores==1)
                            conmarcadores=0;
                        ELSE
                            conmarcadores=1;
                        END
                        WHILE (key(_m)) FRAME; END
                    END

                    testigo1++;IF (testigo1>(totaltestigo-1)) testigo1=0; END
                    testigo2++;IF (testigo2>(totaltestigo-1)) testigo2=0; END
                    testigo3++;IF (testigo3>1) testigo3=0; END
                END

                IF (key(_esc)) salirjuego=1; END

                IF (inicioparte==2)inicioparte=3;END
                fade_off();

                IF (inicioparte==5)

                    let_me_alone();

                    change_sound(idcanal,0,256);

                    stop_mode7(0);

                    restore_type=complete_restore;

                    set_mode(m640x480);

                    unload_fpg(fichero1);
                    unload_fpg(fichero2);
                    unload_fpg(fichero3);

                    unload_fnt(fuente1);
                    unload_fnt(fuente2);

                    fichero1=load_fpg("soccer\traje.fpg");
                    fichero2=load_fpg("soccer\traje.fpg");
                    fichero3=load_fpg("soccer\menus.fpg");

                    fuente1=load_fnt("soccer\futbol3.fnt");
                    fuente2=load_fnt("soccer\futbol1.fnt");

                    FOR (contador=0;contador<256;contador++)
                        paljugador1[contador]=contador;
                        paljugador2[contador]=contador;
                    END

                    FOR (contador2=0;contador2<4;contador2++)
                        FOR (contador=1;contador<6;contador++)
                            paljugador1[(colorini[contador2]*5)+contador]=(colorini2[contador2]*5)+contador;
                            paljugador2[(colorini[contador2]*5)+contador]=(colorini1[contador2]*5)+contador;
                        END
                    END

                    FOR (contador=1;contador<5;contador++)
                        convert_palette(fichero1,contador,&paljugador2);
                        convert_palette(fichero2,contador,&paljugador1);
                    END

                    delete_text(all_text);

                    unload_map(idfondo);

                    idfondo=load_map("soccer\presenta.map");
                    put_screen(0,idfondo);

                    iniciomensaje=50;
                    FROM contador=9 TO 0;
                        IF (nombres[0].letras[contador]==letras[27])
                            iniciomensaje+=9;
                        ELSE
                            BREAK;
                        END
                    END
                    escribe_nombre(iniciomensaje,100,0,fuente3,18);
                    iniciomensaje=410;
                    FROM contador=9 TO 0;
                        IF (nombres[12].letras[contador]==letras[27])
                            iniciomensaje+=9;
                        ELSE
                            BREAK;
                        END
                    END
                    escribe_nombre(iniciomensaje,100,12,fuente3,18);

                    traje2(141,210,1,fichero1);
                    traje2(140,210,2,fichero1);
                    traje2(140,270,3,fichero1);
                    traje2(140,320,4,fichero1);
                    traje2(501,210,1,fichero2);
                    traje2(500,210,2,fichero2);
                    traje2(500,270,3,fichero2);
                    traje2(500,320,4,fichero2);

                    write(fuente1,320,10,1,"   FINISH    ");

                    write_int(fuente1,140,340,1,&goles[0]);
                    write(fuente1,320,340,1,"-");
                    write_int(fuente1,500,340,1,&goles[1]);

                    mouse.graph=909;mouse.file=fichero3;
                    fade_on();

                    mouse.left=0; WHILE(key(_space)) FRAME;  END

                    WHILE (NOT key(_space) AND NOT mouse.left)
                        FRAME;
                    END
                    fade_off();
                    unload_map(idfondo);
                END

                restore_type=complete_restore;

                delete_text(all_text);

                unload_fpg(fichero1);
                unload_fpg(fichero2);
                unload_fpg(fichero3);
                unload_fpg(fichero4);
                unload_fpg(fichero5);
                unload_fpg(fichero6);
                unload_fpg(fichero7);
                unload_fpg(fichero8);
                unload_fpg(fichero9);

                unload_fnt(fuente1);
                unload_fnt(fuente2);
                unload_fnt(fuente3);

                stop_mode7(0);
                fade_on();

                change_sound(idcanal,0,256);
            END
            idsonido8=load_pcm("soccer\musica1.pcm",1);
            idcanal2=sound(idsonido8,100,256);
            conintro=0;
        END

        let_me_alone();
        delete_text(all_text);
        realopcionmenu1=-1;
        fade_on();
    END
END


PROCESS pintaopciones1()
BEGIN

    traje(121,210,1,fichero2);
    traje(120,210,2,fichero2);
    traje(120,270,3,fichero2);
    traje(120,320,4,fichero2);
    traje(521,210,1,fichero3);
    traje(520,210,2,fichero3);
    traje(520,270,3,fichero3);
    traje(520,320,4,fichero3);

    LOOP
        delete_text(all_text);

        escribe_nombre(90,20,0,fuente1,16);
        escribe_nombre(390,20,12,fuente1,16);

        IF (comprueba_raton(170,420,415,455))
            write(fuente2,325,430,4,"  CHANGE TEAM NAMES  ");
        ELSE
            write(fuente1,325,430,4,"  CHANGE TEAM NAMES  ");
        END

        bot¢n(52,422,1,comprueba_raton(20,395,85,455),fichero1);

        IF (comprueba_raton(20,395,85,455))
            write(0,50,390,4," BACK ");
        END

        bot¢n(580,422,0,comprueba_raton(550,395,615,455),fichero1);

        IF (comprueba_raton(550,395,615,455))
            write(0,580,390,4," START");
        END

        pontiempo(319,197,tipotiempo+1);

        poncontrol(40,40,20+(controljugador*10));
        poncontrol(600,40,40);
        FRAME;
    END
END


PROCESS eligeopciones1()

PRIVATE
    idcollisionmouse=0;

BEGIN
    LOOP

        IF (comprueba_raton(170,420,415,455)==3)
            realopcionmenu1=1;
        END

        IF (comprueba_raton(20,395,85,455)==3 OR key (_esc))
            realopcionmenu1=2;
        END

        IF (comprueba_raton(550,395,615,455)==3)
            realopcionmenu1=3;
        END

        IF (mouse.x>249 AND mouse.x<391 AND mouse.y>159 AND mouse.y<301 AND mouse.left)
            tipotiempo++;IF (tipotiempo>3) tipotiempo=0; END
            WHILE (mouse.left) FRAME; END
        END

        IF (mouse.x>0 AND mouse.x<291 AND mouse.y>0 AND mouse.y<91 AND mouse.left)
            controljugador++;IF (controljugador>2) controljugador=0; END
            WHILE (mouse.left) FRAME; END
        END
        FRAME;
    END

END






PROCESS opciones2 ()

BEGIN

    delete_text(all_text);


    escribe_nombre(78,17,0,0,10);
    escribe_nombre(458,17,12,0,10);


    escribe_nombre(78,80,1,0,10);
    escribe_nombre(458,80,13,0,10);


    FOR (contador=2;contador<12;contador++)
        escribe_nombre(78,72+(21*contador),contador,0,10);
        escribe_nombre(458,72+(21*contador),contador+12,0,10);
    END


    bot¢n(52,422,1,comprueba_raton(20,400,80,450),fichero1);


    IF (comprueba_raton(20,400,80,450))
        write(0,50,390,4," BACK ");
    END


    IF (comprueba_raton(20,400,80,450)==3)
        realopcionmenu1=2;
    END


    IF (comprueba_raton(0,12,247,29)==3)
        if (editando==0)
            introduce_nombre(0);
        ELSE
            signal (TYPE introduce_nombre,s_kill);
            introduce_nombre(0);
        END
    END
    IF (comprueba_raton(392,13,639,30)==3)
        IF (editando==0)
            introduce_nombre(12);
        ELSE
            signal (TYPE introduce_nombre,s_kill);
            introduce_nombre(12);
        END
    END


    IF (comprueba_raton(1,73,264,92)==3)
        IF (editando==0)
            introduce_nombre(1);
        ELSE
            signal (TYPE introduce_nombre,s_kill);
            introduce_nombre(1);
        END
    END
    IF (comprueba_raton(380,73,639,92)==3)
        IF (editando==0)
            introduce_nombre(13);
        ELSE
            signal (TYPE introduce_nombre,s_kill);
            introduce_nombre(13);
        END
    END


    FOR (contador=2;contador<12;contador++)
        IF (comprueba_raton(1,66+(contador*21),263,68+(contador*21)+19)==3)
            IF (editando==0)
                introduce_nombre(contador);
            ELSE
                signal (TYPE introduce_nombre,s_kill);
                introduce_nombre(contador);
            END
        END
        IF (comprueba_raton(381,66+(contador*21),639,68+(contador*21)+19)==3)
            IF (editando==0)
                introduce_nombre(contador+12);
            ELSE
                signal (TYPE introduce_nombre,s_kill);
                introduce_nombre(contador+12);
            END
        END
    END


    ponletras (358,416,-10,6);
    FRAME;
END








PROCESS ponletras (x,y,z,graph)

BEGIN
    FRAME;
END







PROCESS pontiempo (x,y,graph)

BEGIN
    FRAME;
END









PROCESS bot¢n(x,y,cual,estado,file)

BEGIN

    IF (cual==0)
        flags=1;
    ELSE
        flags=0;
    END


    IF (estado==0)
        graph=51;
    ELSE
        graph=50;
    END
    FRAME;
END













PROCESS comprueba_raton(x1,y1,x2,y2)

BEGIN


    IF (mouse.x>x1 AND mouse.x<x2 AND
        mouse.y>y1 AND mouse.y<y2)


        IF (mouse.left==TRUE)
            RETURN (3);
        ELSE
            RETURN (1);
        END
    END
    RETURN(0);

END











PROCESS escribe_nombre(x,y,numeror,tipoletras,ancholetras)

BEGIN


    FOR (contador=0;contador<10;contador++)

        idnombres[numeror].idletras[contador]=write(tipoletras,x+(contador*ancholetras),y,0,nombres[numeror].letras[contador]);
    END

    FRAME;
END






PROCESS titulofutbol97()

PRIVATE
    solouno=0;

BEGIN


    y=414;
    x=-140;
    graph=48;
    file=fichero4;
    LOOP


        IF (x<155)
            x+=15;
        ELSE

            IF (solouno==0)
                textopulsaunatecla();
                solouno=1;
            END
        END
        FRAME;
    END
END






PROCESS titulosoccer()

BEGIN

    y=356;
    x=-140;
    graph=10;
    file=fichero4;


    sombrasoccer();
    LOOP

        IF (x<160) x+=30; END
        FRAME;
    END
END






PROCESS sombrasoccer()

BEGIN

    graph=11;
    x=father.x+5;
    y=father.y+5;
    z=father.z+1;


    flags=4;
    file=fichero4;
    LOOP

        x=father.x+5;
        y=father.y+5;
        FRAME;
    END
END








PROCESS traje(x,y,graph,file)

PRIVATE
    oldcolorini;

BEGIN
    LOOP


        IF ((collision(TYPE mouse)) AND mouse.left)


            IF (file==fichero2)
                oldcolorini=colorini1[graph-1];
                colorini1[graph-1]++;
                IF (colorini1[graph-1]>9) colorini1[graph-1]=0; END
            ELSE
                oldcolorini=colorini2[graph-1];
                colorini2[graph-1]++;
                IF (colorini2[graph-1]>9) colorini2[graph-1]=0; END
            END


            FOR (contador=1;contador<6;contador++)
                IF (file==fichero2)
                    paljugador2[(oldcolorini*5)+contador]=(colorini1[graph-1]*5)+contador;
                ELSE
                    paljugador1[(oldcolorini*5)+contador]=(colorini2[graph-1]*5)+contador;
                END
            END


            IF (file==fichero2)
                convert_palette(file,graph,&paljugador2);
            ELSE
                convert_palette(file,graph,&paljugador1);
            END
            WHILE (mouse.left) FRAME; END
        END
    FRAME;
    END
END






PROCESS poncontrol(x,y,graph)

BEGIN
    FRAME;
END






PROCESS textopulsaunatecla()

PRIVATE
    pausatexto=0;

BEGIN

    x=452;
    y=414;
    graph=49;
    file=fichero4;
    LOOP


        pausatexto++;IF (pausatexto>9) pausatexto=0; END


        IF (pausatexto<7) graph=49; ELSE graph=0; END
        FRAME;
    END
END







PROCESS introduce_nombre(cualnombre)

PRIVATE

    posicicursor=10;
    inixcursor,iniycursor;
    parpadeocursor=0;
    tecladeraton;


    tablascan[29]=16,17,18,19,20, 21,22,23,24,25,
                  30,31,32,33,34, 35,36,37,38,39,
                  44,45,46,47,48, 49,50,57,52,14;

    contadorespacios;
BEGIN

    editando=1;

    contadorespacios=9;
    WHILE (contadorespacios>-1)
        IF (nombres[cualnombre].letras[contadorespacios]==letras[27])
            contadorespacios--;
        ELSE
            BREAK;
        END
    END
    posicicursor=contadorespacios+1;


    SWITCH (cualnombre)
        CASE 0: inixcursor=80; iniycursor=20; END
        CASE 1: inixcursor=80; iniycursor=83; END
        CASE 2..11:inixcursor=80; iniycursor=75+(cualnombre*21); END
        CASE 12: inixcursor=460; iniycursor=20; END
        CASE 13: inixcursor=460; iniycursor=83; END
        CASE 14..23:inixcursor=460; iniycursor=75+((cualnombre-12)*21); END
    END


    WHILE (NOT mouse.right AND NOT key(_enter) AND NOT key(_esc))

        IF (parpadeocursor<3)
            poncursor(inixcursor+(posicicursor*10),iniycursor,9);
        ELSE
            poncursor(inixcursor+(posicicursor*10),iniycursor,0);
        END
        parpadeocursor++;IF (parpadeocursor>5) parpadeocursor=0;END
        FRAME;


        IF (mouse.left AND
            mouse.x>152 AND mouse.x<565 AND
            mouse.y>354 AND mouse.y<477)


            tecladeraton=((mouse.x-153)/42)+(((mouse.y-355)/42)*10);


            IF (tecladeraton==29)

                posicicursor--; IF (posicicursor<0)posicicursor=0; END
                nombres[cualnombre].letras[posicicursor]=letras[27];
            ELSE

                IF (posicicursor<10)
                    nombres[cualnombre].letras[posicicursor]=letras[tecladeraton];
                END
                posicicursor++; IF (posicicursor>10)posicicursor=10; END
            END


            pontecla(tecladeraton);
            WHILE (mouse.left) FRAME; END
        END


        IF (scan_code<>0)

            FOR (contador=0;contador<30;contador++)
                IF (scan_code==tablascan[contador])

                    IF (contador==29)

                        posicicursor--; IF (posicicursor<0)posicicursor=0; END
                        nombres[cualnombre].letras[posicicursor]=letras[27];
                    ELSE

                        IF (posicicursor<10)
                            nombres[cualnombre].letras[posicicursor]=letras[contador];
                        END
                        posicicursor++; IF (posicicursor>10)posicicursor=10; END
                    END

                    pontecla(contador);

                    WHILE (key(tablascan[contador])) FRAME; END
                    BREAK;
                END
            END
        END

    END
    editando=0;
END







PROCESS pontecla (cualtecla)

BEGIN

    x=175+((cualtecla MOD 10)*41);
    y=375+((cualtecla/10)*41);
    graph=7;
    z=-5;
    FRAME(300);
END







PROCESS poncursor (x,y,graph)

BEGIN
    FRAME;
END






PROCESS c mara()

PRIVATE

    xdestc;
    ydestc;
    cincx;
    cincy;
    cangle;
    cdist;
    cvelo;

BEGIN

    ctype=2;
    x=32000;
    y=100000;
    graph=0;
    angle=90000;
    resolution=100;
    LOOP

        IF (controljugador==2)

            x=idpelota.x;
            y=idpelota.y+(distanciacamara*100);
            xdestc=x;
            ydestc=y;
        ELSE

            IF (equipototal[1].conbalon<>0)
                xdestc=equipototal[1].conbalon.x;
                ydestc=equipototal[1].conbalon.y+(distanciacamara*100);
            ELSE

                IF (equipototal[1].esperandopase<>0)
                    xdestc=equipototal[1].esperandopase.x;
                    ydestc=equipototal[1].esperandopase.y+(distanciacamara*100);
                    xdestc=(xdestc+idpelota.x*2)/3;
                ELSE

                    IF (equipototal[1].desmarcado<>0)
                        xdestc=equipototal[1].desmarcado.x;
                        ydestc=equipototal[1].desmarcado.y+(distanciacamara*100);
                        xdestc=(xdestc+idpelota.x*2)/3;
                    ELSE

                        xdestc=idpelota.x;
                        ydestc=idpelota.y+(distanciacamara*100);
                    END
                END
            END



            cangle=fget_angle(x,y,xdestc,ydestc);


            cdist=fget_dist(x,y,xdestc,ydestc);


            cvelo=cdist/totaltestigo;


            IF (cvelo>vmaxima*6) cvelo=vmaxima*6; END


            cincx=get_distx(cangle,cvelo);
            cincy=get_disty(cangle,cvelo);


            x+=cincx;
            y+=cincy;
        END


        IF (y<idpelota.y+distanciacamara*100)
            y=idpelota.y+distanciacamara*100;
        END


        IF (x<20900) x=20900; END
        IF (x>72100) x=72100; END
        IF (y<51300) y=51300; END
        IF (y>124900) y=124900; END

        FRAME;
    END
END






PROCESS valla()

BEGIN

    file=fichero1;
    graph=101;
    ctype=2;


    x=((xfcampo-xicampo)/2)+xicampo; y=0;


    size=444;
    LOOP FRAME; END

END






PROCESS tu_porteria()

BEGIN

    file=fichero1;
    ctype=2;
    graph=203;


    x=((xfcampo-xicampo)/2)+xicampo;
    y=yfcampo+2;
    flags=4;
    palo1();
    LOOP FRAME; END

END






PROCESS palo1()

BEGIN

    file=fichero1;
    graph=204;
    ctype=2;


    x=((xfcampo-xicampo)/2)+xicampo; y=yfcampo+1;
    LOOP FRAME; END
END






PROCESS su_porteria()

BEGIN

    file=fichero1;
    graph=102+(100*modovideo);
    ctype=2;


    x=((xfcampo-xicampo)/2)+xicampo;
    y=yicampo-2;


    flags=4;


    palo2();
    LOOP FRAME; END
END






PROCESS palo2()
BEGIN

    file=fichero1;
    graph=201;
    ctype=2;


    x=((xfcampo-xicampo)/2)+xicampo; y=yicampo-1;
    LOOP FRAME; END
END






PROCESS bal¢n()

PRIVATE

    incrx,incry;

BEGIN

    x=(((xfcampo-xicampo)/2)+xicampo)*100;
    y=(((yfcampo-yicampo)/2)+yicampo)*100;
    height=0;


    file=fichero6;
    graph=1;
    size=20;
    ctype=2;
    resolution=100;
    sombrabalon();

    LOOP

        IF (velocidadpelota>0)
            velocidadpelota-=incrvelocidadpelota;

            x+=get_distx(angulopelota,velocidadpelota);
            y+=get_disty(angulopelota,velocidadpelota);
        END


        IF (incbote<>0)
            height+=incactual;
            incactual-=2;
            IF (abs(incactual)>abs(incbote))
                sound(idsonido5,50,256);

                incbote=(((velocidadpelota/100)-15)/10)*2;

                IF (incbote>20) incbote=20; END
                IF (incbote<0) incbote=0; END
                incactual=incbote;
            END
        END


        IF (velocidadpelota>0 OR incbote<>0 OR
            equipototal[0].conbalon<>0 OR equipototal[1].conbalon<>0)
            IF (graph<>0)
                graph++;IF (graph>6) graph=1; END
            END
        END


        IF (x<xicampo*100 AND sacando==0 AND estadojuego==4)
            bal¢nfantasma(x,y,size,height,graph,file,velocidadpelota,angulopelota);
            graph=0;
            ponmensajes (4,20);
            velocidadpelota=0;
            estadojuego=10;
            quiensacadebanda=1-ultimotiro;
            x=(xicampo-5)*100;
        END


        IF (x>xfcampo*100 AND sacando==0 AND estadojuego==4)
            bal¢nfantasma(x,y,size,height,graph,file,velocidadpelota,angulopelota);
            graph=0;
            ponmensajes (4,20);
            estadojuego=10;
            quiensacadebanda=1-ultimotiro;
            x=(xfcampo+5)*100;
            velocidadpelota=0;
        END


        IF (y<yicampo*100 AND x>((((xfcampo-xicampo)/2)+xicampo-40)*100) AND x<((((xfcampo-xicampo)/2)+xicampo+40)*100))
            ponmensajes (3,25);
            quienmetegol=2;
            quienempieza=0;
            estadojuego=5;
            goles[0]++;
            sound(idsonido1,50,256);
        END


        IF (y>yfcampo*100 AND x>((((xfcampo-xicampo)/2)+xicampo-40)*100) AND x<((((xfcampo-xicampo)/2)+xicampo+40)*100))
            ponmensajes (3,25);
            quienmetegol=1;
            quienempieza=1;
            estadojuego=5;
            goles[1]++;
            sound(idsonido1,50,256);
        END


        IF ((y<yicampo*100 OR y>yfcampo*100) AND ((x>((((xfcampo-xicampo)/2)+xicampo-48)*100) AND x<((((xfcampo-xicampo)/2)+xicampo-40)*100)) OR
            (x>((((xfcampo-xicampo)/2)+xicampo+40)*100) AND x<((((xfcampo-xicampo)/2)+xicampo+48)*100))))
            incrx=get_distx(angulopelota,velocidadpelota);
            incry=get_disty(angulopelota,velocidadpelota);
            incry=-incry;
            angulopelota=fget_angle(0,0,incrx,incry);
        END
        IF ((y<yicampo*100 OR y>yfcampo*100) AND x>((((xfcampo-xicampo)/2)+xicampo-48)*100) AND x<((((xfcampo-xicampo)/2)+xicampo-40)*100) AND
            x>((((xfcampo-xicampo)/2)+xicampo+40)*100) AND x<((((xfcampo-xicampo)/2)+xicampo+48)*100))
            incrx=get_distx(angulopelota,velocidadpelota);
            incry=get_disty(angulopelota,velocidadpelota);
            incry=-incry;
            angulopelota=fget_angle(0,0,incrx,incry);
        END


        IF (y<=yicampo*100  AND (x<((((xfcampo-xicampo)/2)+xicampo-48)*100) OR x>((((xfcampo-xicampo)/2)+xicampo+48)*100)) AND sacandocorner==0 AND sacandoporteria==0)

            bal¢nfantasma(x,y,size,height,graph,file,velocidadpelota,angulopelota);
            graph=0;
            IF (ultimotiro==1)
                idporteros[1].velocidad=0;
                idporteros[1].estado=conbalon;
                velocidadpelota=0;
                estadojuego=15;
                porterosacando=1;
                sacandoporteria=1;
            ELSE

                ponmensajes (5,20);
                sacandocorner=0;
                estadojuego=20;
                quiensacacorner=1;

                IF (x<((((xfcampo-xicampo)/2)+xicampo-48)*100))
                    esquinacorner=0;
                    idpelota.x=xicampo*100;
                ELSE
                    esquinacorner=1;
                    idpelota.x=xfcampo*100;
                END
                idpelota.y=yicampo*100;
                idpelota.height=0;
            END
        END


        IF (y=>yfcampo*100 AND (x<((((xfcampo-xicampo)/2)+xicampo-48)*100) OR x>((((xfcampo-xicampo)/2)+xicampo+48)*100)) AND sacandocorner==0 AND sacandoporteria==0)
            bal¢nfantasma(x,y,size,height,graph,file,velocidadpelota,angulopelota);
            graph=0;
            IF (ultimotiro==0)

                idporteros[0].velocidad=0;
                idporteros[0].estado=conbalon;
                velocidadpelota=0;
                estadojuego=15;
                porterosacando=0;
                sacandoporteria=1;
            ELSE

                ponmensajes (5,20);
                sacandocorner=0;
                estadojuego=20;
                quiensacacorner=0;

                IF (x<((((xfcampo-xicampo)/2)+xicampo-48)*100))
                    esquinacorner=2;
                    idpelota.x=xicampo*100;
                ELSE
                    esquinacorner=3;
                    idpelota.x=xfcampo*100;
                END
                idpelota.y=yfcampo*100;
                idpelota.height=0;
            END
        END


        IF (height<0) height=0; END
        FRAME;
    END
END






PROCESS sombrabalon()

BEGIN

    file=fichero1;
    graph=11;
    size=50;

    ctype=2;
    resolution=100;

    flags=4;
    z=(father.z)+10;

    LOOP

        x=father.x;
        y=father.y-2;
        FRAME;
    END

END








PROCESS ponjugador(n£mero,equipo)

PRIVATE

    estado_anterior;
    xdest; ydest;
    pospelox,pospeloy;
    pasex,pasey;
    fuerzabalon;
    iniciosaque;



    tablag1[]=8,67,68,69,70,71,72,65,66;

    tablag10[]=8,17,25,33,-25,-17, -9,1, 9;
    tablag11[]=8,18,26,34,-26,-18,-10,2,10;
    tablag12[]=8,19,27,35,-27,-19,-11,3,11;
    tablag13[]=8,20,28,36,-28,-20,-12,4,12;
    tablag14[]=8,21,29,37,-29,-21,-13,5,13;
    tablag15[]=8,22,30,38,-30,-22,-14,6,14;
    tablag16[]=8,23,31,39,-31,-23,-15,7,15;
    tablag17[]=8,24,32,40,-32,-24,-16,8,16;

    tablag20[]=8,57,58,59,60,61,62,63,64;

    tablag30[]=8,51,52,53,54,55,56,49,50;
    tablag31[]=8,43,44,45,46,47,48,41,42;
    tablag32[]=8,75,76,77,78,79,80,73,74;

    tablag40[]=8,83,84,85,86,87,88,81,82;
    tablag41[]=8,91,92,93,94,95,96,89,90;
    dirconcontrol;

BEGIN

    height=-5;


    sombrajugador();

    IF (equipo==0)

        file=fichero2;
        xgraph=&tablag1;


        IF (quienempieza==0)
            xi=(t ctica[n£mero].xi0+xicampo)*100;
            yi=(t ctica[n£mero].yi0+yicampo)*100;
        ELSE
            xi=(t ctica[n£mero].xi1+xicampo)*100;
            yi=(t ctica[n£mero].yi1+yicampo)*100;
        END
        xp0=(t ctica[n£mero].xp0+rand(-20,20)+xicampo)*100;
        yp0=(t ctica[n£mero].yp0+rand(-20,20)+yicampo)*100;
        xp1=(t ctica[n£mero].xp1+rand(-20,20)+xicampo)*100;
        yp1=(t ctica[n£mero].yp1+rand(-20,20)+yicampo)*100;
    ELSE

        file=fichero3;
        xgraph=&tablag1;


        IF (quienempieza==0)
            xi=(xfcampo-tactica[n£mero].xi1)*100;
            yi=(yfcampo-tactica[n£mero].yi1)*100;
        ELSE
            xi=(xfcampo-tactica[n£mero].xi0)*100;
            yi=(yfcampo-tactica[n£mero].yi0)*100;
        END
        xp0=(xfcampo-tactica[n£mero].xp0+rand(-20,20))*100;
        yp0=(yfcampo-tactica[n£mero].yp0+rand(-20,20))*100;
        xp1=(xfcampo-tactica[n£mero].xp1+rand(-20,20))*100;
        yp1=(yfcampo-tactica[n£mero].yp1+rand(-20,20))*100;
    END


    p0=tactica[n£mero].p0;
    p1=tactica[n£mero].p1;


    estado=parado;


    x=rand(500,1500);
    y=rand(50500,52500);


    size=150;
    ctype=2;
    resolution=100;
    cuentaanima=rand(0,7);
    velocidad=1;
    LOOP

        IF (fget_dist(x,y,idpelota.x,idpelota.y)<zonarecogida AND idpelota.height>0 AND idpelota.height<100)
            idpelota.angulopelota=rand(0,360)*100;
            idpelota.x+=get_distx(idpelota.angulopelota,idpelota.velocidadpelota);
            idpelota.y+=get_disty(idpelota.angulopelota,idpelota.velocidadpelota);
            ultimotiro=equipo;
        END


        IF ((testigo1==(n£mero/(10/totaltestigo)) AND equipo==0) OR
            (testigo2==(n£mero/(10/totaltestigo)) AND equipo==1) )
            REPEAT

                estado_anterior=estado;


                SWITCH (estado)

                    CASE parado:
                        velocidad=fget_dist(x,y,xi,yi)/totaltestigo;
                        IF (velocidad>vmaxima) velocidad=vmaxima; END
                        IF (velocidad<100) velocidad=100; END
                        angle=fget_angle(x,y,xi,yi);
                        IF (fget_dist(x,y,xi,yi)<=(vmaxima+200)/2) velocidad=0; END
                        IF (velocidad==0) angle=fget_angle(x,y,idpelota.x,idpelota.y); END
                    END


                    CASE normal:


                        xdest=((xp0*p0*equipototal[equipo].defensa)+
                            (xp1*p1*equipototal[equipo].ataque)+
                            (idpelota.x*pesopelota*100))/
                            (p0*equipototal[equipo].defensa+
                             p1*equipototal[equipo].ataque+
                             pesopelota*100);

                        ydest=((yp0*p0*equipototal[equipo].defensa)+
                            (yp1*p1*equipototal[equipo].ataque)+
                            (idpelota.y*pesopelota*100))/
                            (p0*equipototal[equipo].defensa+
                             p1*equipototal[equipo].ataque+
                             pesopelota*100);


                        IF (fget_dist(x,y,xdest,ydest)>3000)
                            velocidad=fget_dist(x,y,xdest,ydest)/totaltestigo;
                            IF (velocidad>vmaxima) velocidad=vmaxima; END
                            IF (velocidad<100) velocidad=100; END
                            angle=fget_angle(x,y,xdest,ydest);
                            IF (fget_dist(x,y,xdest,ydest)<=(vmaxima+200)/2) velocidad=0; END
                        ELSE
                            velocidad=0;
                        END
                    END


                    CASE conbalon:
                        ultimotiro=equipo;


                        IF (equipototal[equipo].desmarcado<>0)
                            equipototal[equipo].desmarcado.estado=normal;
                        END
                        equipototal[equipo].desmarcado=0;


                        IF (equipototal[equipo].esperandopase<>0)
                            equipototal[equipo].esperandopase.estado=normal;
                        END
                        equipototal[equipo].esperandopase=0;

                        IF (equipo==0)

                            IF (y>(yfcampo*100)-zonatiro1)
                                sound(idsonido3,50,256);

                                estado=atontado;
                                cuentaatontado=retardoatontado;

                                idpelota.angulopelota=fget_angle(x,y,((((xfcampo-xicampo)/2)+xicampo)*100)+((rand(-azar*10,azar*10))*100),yfcampo*100);
                                idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,((((xfcampo-xicampo)/2)+xicampo)*100)+((rand(-azar*10,azar*10))*100),yfcampo*100));
                                IF (idpelota.velocidadpelota>conbote)
                                     incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                                END
                                (equipototal[0].conbalon).estado=normal;
                                equipototal[0].conbalon=0;
                                tirando=2;
                                ultimotiro=0;
                            ELSE

                                FOR (contador=0;contador<10;++contador)
                                    IF (fget_dist(x,y,idjugadores2[contador].x,idjugadores2[contador].y)<campoagobio
                                        AND idjugadores2[contador].tirandose==0)

                                        IF (y>(yfcampo*100)-zonatiro2)

                                            sound(idsonido3,50,256);


                                            idpelota.angulopelota=fget_angle(x,y,((((xfcampo-xicampo)/2)+xicampo)*100)+((rand(-azar*10,azar*10))*100),yfcampo*100);
                                            idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,((((xfcampo-xicampo)/2)+xicampo)*100)+((rand(-azar*10,azar*10))*100),yfcampo*100));
                                            IF (idpelota.velocidadpelota>conbote)
                                                incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                                            END
                                            equipototal[0].conbalon=0;


                                            estado=atontado;
                                            cuentaatontado=retardoatontado;
                                            tirando=2;
                                            ultimotiro=0;
                                        ELSE


                                            sound(idsonido3,50,256);


                                            pasa_a=daquienpasa(equipo);


                                            idpelota.angulopelota=fget_angle(x,y,idjugadores1[pasa_a].x,idjugadores1[pasa_a].y);
                                            angle=fget_angle(x,y,idjugadores1[pasa_a].x,idjugadores1[pasa_a].y);
                                            idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,idjugadores1[pasa_a].x,idjugadores1[pasa_a].y))+(rand(-azar,azar)*100);
                                            IF (idpelota.velocidadpelota>conbote)
                                                incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                                            END
                                            ultimotiro=0;


                                            idjugadores1[pasa_a].estado=esperandopase;
                                            idjugadores1[pasa_a].velocidad=0;
                                            equipototal[0].esperandopase=idjugadores1[pasa_a];
                                            equipototal[0].conbalon=0;


                                            estado=atontado;
                                            cuentaatontado=retardoatontado;
                                            tirando=2;
                                        END
                                    END
                                END

                                IF (estado==conbalon)
                                    velocidad=fget_dist(x,y,(((xfcampo-xicampo)/2)+xicampo)*100,yfcampo*100)/totaltestigo;
                                    IF (velocidad>vmaximacg) velocidad=vmaximacg; END
                                    IF (velocidad<100) velocidad=100; END
                                    angle=fget_angle(x,y,(((xfcampo-xicampo)/2)+xicampo)*100,yfcampo*100);
                                END
                            END
                        ELSE


                            IF (controljugador==2)

                                IF (y<(yicampo*100)+zonatiro1)

                                    sound(idsonido3,50,256);

                                    estado=atontado;
                                    cuentaatontado=retardoatontado;

                                    idpelota.angulopelota=fget_angle(x,y,((((xfcampo-xicampo)/2)+xicampo)*100)+((rand(-azar*10,azar*10))*100),yicampo*100);
                                    idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,((((xfcampo-xicampo)/2)+xicampo)*100)+((rand(-azar*10,azar*10))*100),yicampo*100));

                                    IF (idpelota.velocidadpelota>conbote)
                                        incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                                    END
                                    (equipototal[1].conbalon).estado=normal;
                                    equipototal[1].conbalon=0;
                                    tirando=2;
                                    ultimotiro=1;
                                ELSE


                                    FOR (contador=0;contador<10;++contador)
                                        IF (fget_dist(x,y,idjugadores1[contador].x,idjugadores1[contador].y)<campoagobio AND idjugadores1[contador].estado<>atontado)

                                            IF (y<(yicampo*100)+zonatiro2)


                                                sound(idsonido3,50,256);


                                                idpelota.angulopelota=fget_angle(x,y,((((xfcampo-xicampo)/2)+xicampo)*100)+((rand(-azar*10,azar*10))*100),yicampo*100);
                                                idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,((((xfcampo-xicampo)/2)+xicampo)*100)+((rand(-azar*10,azar*10))*100),yicampo*100));
                                                IF (idpelota.velocidadpelota>conbote)
                                                    incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                                                END
                                                equipototal[1].conbalon=0;
                                                contador=10;


                                                estado=atontado;
                                                cuentaatontado=retardoatontado;
                                                tirando=2;
                                                ultimotiro=1;
                                            ELSE

                                                sound(idsonido3,50,256);
                                                ultimotiro=1;


                                                pasa_a=daquienpasa(equipo);


                                                idpelota.angulopelota=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                                angle=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                                idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y))+(rand(-azar,azar)*100);;


                                                IF (idpelota.velocidadpelota>conbote)
                                                    incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                                                END


                                                idjugadores2[pasa_a].estado=esperandopase;
                                                idjugadores2[pasa_a].velocidad=0;
                                                equipototal[1].esperandopase=idjugadores2[pasa_a];
                                                equipototal[1].conbalon=0;
                                                contador=10;


                                                estado=atontado;
                                                cuentaatontado=retardoatontado;
                                                tirando=2;
                                            END
                                        END
                                    END

                                    IF (estado==conbalon)
                                        velocidad=fget_dist(x,y,(((xfcampo-xicampo)/2)+xicampo)*100,yicampo*100)/totaltestigo;
                                        IF (velocidad>vmaximacg) velocidad=vmaximacg; END
                                        IF (velocidad<100) velocidad=100; END
                                        angle=fget_angle(x,y,(((xfcampo-xicampo)/2)+xicampo)*100,yicampo*100);
                                    END
                                END
                            ELSE

                                FOR (contador=0;contador<10;++contador)
                                    IF (fget_dist(x,y,idjugadores1[contador].x,idjugadores1[contador].y)<campoagobiojug)


                                        sound(idsonido3,50,256);
                                        ultimotiro=1;


                                        pasa_a=daquienpasa(equipo);


                                        idpelota.angulopelota=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                        angle=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                        idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y));


                                        IF (idpelota.velocidadpelota>conbote)
                                            incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                                        END


                                        idjugadores2[pasa_a].estado=esperandopase;
                                        idjugadores2[pasa_a].velocidad=0;
                                        equipototal[1].esperandopase=idjugadores2[pasa_a];
                                        equipototal[1].conbalon=0;
                                        contador=10;


                                        estado=atontado;
                                        cuentaatontado=retardoatontado;
                                        tirando=2;
                                    END
                                END

                                dirconcontrol=0;
                                IF (controljugador==0)


                                    IF (joy.right) dirconcontrol+=1; END
                                    IF (joy.left) dirconcontrol-=1; END
                                    IF (joy.up) dirconcontrol-=10; END
                                    IF (joy.down) dirconcontrol+=10; END
                                ELSE


                                    IF (key(_right)) dirconcontrol+=1; END
                                    IF (key(_left)) dirconcontrol-=1; END
                                    IF (key(_up)) dirconcontrol-=10; END
                                    IF (key(_down)) dirconcontrol+=10; END
                                END


                                IF (dirconcontrol<>0) velocidad=400; ELSE velocidad-=300; END
                                IF (velocidad>vmaximacgjug) velocidad=vmaximacgjug; END
                                IF (velocidad<100) velocidad=0; END


                                SWITCH(dirconcontrol)
                                    CASE -11: angle=135000; END
                                    CASE -10: angle=90000; END
                                    CASE -9: angle=45000; END
                                    CASE -1: angle=180000; END
                                    CASE 1: angle=0; END
                                    CASE 9: angle=225000; END
                                    CASE 10: angle=270000; END
                                    CASE 11: angle=315000; END
                                END
                                IF (controljugador==0)
                                    IF (joy.button1 AND tirandose==0)
                                        sound(idsonido3,50,256);


                                        idpelota.angulopelota=angle;
                                        idpelota.velocidadpelota=2000;
                                        fuerza_tiro();
                                        incactual=16; incbote=16; idpelota.height=0;


                                        estado=atontado;
                                        cuentaatontado=retardoatontado;
                                        equipototal[equipo].conbalon=0;
                                        tirando=2;
                                        ultimotiro=1;
                                    END

                                    IF (joy.button2)
                                        sound(idsonido3,50,256);
                                        ultimotiro=1;


                                        pasex=x+get_distx(angle,35000);
                                        pasey=y+get_disty(angle,35000);
                                        pasa_a=0;
                                        FROM contador=0 TO 9;
                                            IF (numero<>contador)
                                                IF (fget_dist(pasex,pasey,idjugadores2[contador].x,idjugadores2[contador].y)<
                                                    fget_dist(pasex,pasey,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y))
                                                    pasa_a=contador;
                                                END
                                            END
                                        END


                                        idpelota.angulopelota=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                        angle=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                        idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y));
                                        estado=atontado;
                                        cuentaatontado=retardoatontado;
                                        tirando=2;
                                        equipototal[equipo].conbalon=0;
                                    END
                                ELSE

                                    IF (key(_control) AND tirandose==0)


                                        sound(idsonido3,50,256);


                                        idpelota.angulopelota=angle;
                                        idpelota.velocidadpelota=2000;
                                        fuerza_tiro();
                                        incactual=16; incbote=16; idpelota.height=0;


                                        estado=atontado;
                                        cuentaatontado=retardoatontado;
                                        equipototal[equipo].conbalon=0;
                                        tirando=2;
                                        ultimotiro=1;
                                    END
                                    IF (key(_alt))


                                        sound(idsonido3,50,256);
                                        ultimotiro=1;


                                        pasex=x+get_distx(angle,35000);
                                        pasey=y+get_disty(angle,35000);
                                        pasa_a=0;
                                        FROM contador=0 TO 9;
                                            IF (numero<>contador)
                                                IF (fget_dist(pasex,pasey,idjugadores2[contador].x,idjugadores2[contador].y)<
                                                    fget_dist(pasex,pasey,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y))
                                                    pasa_a=contador;
                                                END
                                            END
                                        END
                                        idpelota.angulopelota=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                        angle=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                        idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y));


                                        estado=atontado;
                                        cuentaatontado=retardoatontado;
                                        tirando=2;
                                        equipototal[equipo].conbalon=0;
                                    END
                                END
                            END
                        END
                    END

                    CASE atontado:


                            cuentaatontado--;
                            IF (cuentaatontado==0)

                                estado=normal;
                            END
                    END

                    CASE esperandopase:

                        IF (fget_dist(x,y,idpelota.x,idpelota.y)<zonarecogida AND idpelota.height==0)


                            IF (equipototal[equipo].desmarcado<>0)
                                (equipototal[equipo].desmarcado).estado=normal;
                            END
                            equipototal[equipo].desmarcado=0;


                            IF (equipototal[0].conbalon<>0)
                                (equipototal[0].conbalon).estado=atontado;
                                (equipototal[0].conbalon).cuentaatontado=retardoatontado;
                                equipototal[0].conbalon=0;
                            END
                            IF (equipototal[1].conbalon<>0)
                                (equipototal[1].conbalon).estado=atontado;
                                (equipototal[1].conbalon).cuentaatontado=retardoatontado;
                                equipototal[1].conbalon=0;
                            END


                            estado=conbalon;
                            equipototal[equipo].conbalon=id;
                            equipototal[equipo].esperandopase=0;
                        END


                        IF (idpelota.velocidadpelota<500)
                            idpelota.velocidadpelota=0;
                            velocidad=fget_dist(x,y,idpelota.x,idpelota.y)/totaltestigo;
                            IF (velocidad>vmaxima) velocidad=vmaxima; END
                            IF (velocidad<100) velocidad=100; END
                            angle=fget_angle(x,y,idpelota.x,idpelota.y);
                        ELSE
                            velocidad=0;
                        END
                    END

                    CASE desmarcado:


                        IF (equipo==0)


                            pospelox=da_pos_balon(0,equipo);
                            pospeloy=da_pos_balon(1,equipo);
                            velocidad=fget_dist(x,y,pospelox,pospeloy)/totaltestigo;
                            IF (velocidad>vmaxima) velocidad=vmaxima; END
                            IF (velocidad<100) velocidad=100; END
                            angle=fget_angle(x,y,pospelox,pospeloy);
                        ELSE


                            IF (controljugador==2)

                                pospelox=da_pos_balon(0,equipo);
                                pospeloy=da_pos_balon(1,equipo);
                                velocidad=fget_dist(x,y,pospelox,pospeloy)/totaltestigo;
                                IF (velocidad>vmaxima) velocidad=vmaxima; END
                                IF (velocidad<100) velocidad=100; END
                                angle=fget_angle(x,y,pospelox,pospeloy);
                            ELSE

                                dirconcontrol=0;
                                IF (controljugador==0)

                                    IF (joy.right) dirconcontrol+=1; END
                                    IF (joy.left) dirconcontrol-=1; END
                                    IF (joy.up) dirconcontrol-=10; END
                                    IF (joy.down) dirconcontrol+=10; END
                                    IF (joy.button1 AND fget_dist(x,y,idpelota.x,idpelota.y)<zonaquitada)
                                        sound(idsonido5,50,256);
                                        tirandose=1;
                                        angle=fget_angle(x,y,idpelota.x,idpelota.y);
                                    END
                                ELSE

                                    IF (key(_right)) dirconcontrol+=1; END
                                    IF (key(_left)) dirconcontrol-=1; END
                                    IF (key(_up)) dirconcontrol-=10; END
                                    IF (key(_down)) dirconcontrol+=10; END
                                    IF (key(_control) AND
                                        fget_dist(x,y,idpelota.x,idpelota.y)<zonaquitada)
                                        sound(idsonido5,50,256);
                                        tirandose=1;
                                        angle=fget_angle(x,y,idpelota.x,idpelota.y);
                                    END
                                END


                                IF (dirconcontrol<>0) velocidad+=400; ELSE velocidad-=300; END
                                IF (velocidad>vmaximajug) velocidad=vmaximajug; END
                                IF (velocidad<100) velocidad=0; END


                                SWITCH(dirconcontrol)
                                    CASE -11: angle=135000; END
                                    CASE -10: angle=90000; END
                                    CASE -9: angle=45000; END
                                    CASE -1: angle=180000; END
                                    CASE 1: angle=0; END
                                    CASE 9: angle=225000; END
                                    CASE 10: angle=270000; END
                                    CASE 11: angle=315000; END
                                END
                            END
                        END


                        IF (fget_dist(x,y,idpelota.x,idpelota.y)<zonarecogida*2 AND idpelota.height==0)
                            equipototal[equipo].desmarcado=0;

                            IF (equipototal[0].conbalon<>0)
                                (equipototal[0].conbalon).estado=atontado;
                                (equipototal[0].conbalon).cuentaatontado=retardoatontado;
                                equipototal[0].conbalon=0;
                            END
                            IF (equipototal[1].conbalon<>0)
                                (equipototal[1].conbalon).estado=atontado;
                                (equipototal[1].conbalon).cuentaatontado=retardoatontado;
                                equipototal[1].conbalon=0;
                            END


                            estado=conbalon;
                            equipototal[equipo].conbalon=id;


                            IF (equipototal[0].esperandopase<>0)
                                (equipototal[0].esperandopase).estado=normal;
                            END
                            IF (equipototal[1].esperandopase<>0)
                                (equipototal[1].esperandopase).estado=normal;
                            END
                            equipototal[0].esperandopase=0;
                            equipototal[1].esperandopase=0;
                        END
                        IF (fget_dist(x,y,idpelota.x,idpelota.y)<zonarecogida*3)
                            angle=fget_angle(x,y,idpelota.x,idpelota.y);
                            IF (equipo==0)
                                IF (equipototal[1].conbalon<>0)
                                    sound(idsonido6,50,256);
                                    tirandose=1;
                                END
                            ELSE
                                IF (equipototal[0].conbalon<>0)
                                    sound(idsonido5,50,256);
                                    tirandose=1;
                                END
                            END
                        END
                    END


                    CASE irasaque:

                        velocidad=fget_dist(x,y,idpelota.x,idpelota.y)/totaltestigo;
                        IF (velocidad>vmaxima) velocidad=vmaxima; END
                        IF (velocidad<100) velocidad=100; END
                        angle=fget_angle(x,y,idpelota.x,idpelota.y);

                        IF (fget_dist(x,y,idpelota.x,idpelota.y)<=(vmaxima+200)/2)
                            velocidad=0;
                            estado=saquedebanda;
                            idpelota.graph=1;
                        END
                    END


                    CASE saquedebanda:

                        SWITCH (estadosaque)
                            CASE 0:

                                xgraph=&tablag30;
                                angle=fget_angle(x,y,(((xfcampo-xicampo)/2)+xicampo)*100,(((yfcampo-yicampo)/2)+yicampo)*100);
                                IF (equipo==1 AND controljugador<2)
                                    IF (numero==0) elegidosaque=1; iniciosaque=2; ELSE elegidosaque=0; iniciosaque=1; END
                                    FOR (contador=iniciosaque;contador<10;contador++)
                                        IF (contador<>numero)
                                            IF (fget_dist(idpelota.x,idpelota.y,idjugadores2[contador].x,idjugadores2[contador].y)<
                                                fget_dist(idpelota.x,idpelota.y,idjugadores2[elegidosaque].x,idjugadores2[elegidosaque].y))
                                                elegidosaque=contador;
                                            END
                                        END
                                    END
                                    elige_saque(numero);
                                    FRAME;
                                    pasa_a=elegidosaque;
                                ELSE

                                    pasa_a=daquienpasa(equipo);
                                END
                                sound(idsonido7,50,256);

                                pesopelota=6;

                                idpelota.graph=0;
                                IF (equipo==0)
                                    angle=fget_angle(x,y,idjugadores1[pasa_a].x,idjugadores1[pasa_a].y);
                                ELSE
                                    angle=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                END
                            END
                            CASE 1:

                                IF (equipo==0)
                                    angle=fget_angle(x,y,idjugadores1[pasa_a].x,idjugadores1[pasa_a].y);
                                ELSE
                                    angle=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                END

                                xgraph=&tablag31;
                            END
                            CASE 2:

                                IF (equipo==0)
                                    idpelota.angulopelota=fget_angle(x,y,idjugadores1[pasa_a].x,idjugadores1[pasa_a].y);
                                    idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,idjugadores1[pasa_a].x,idjugadores1[pasa_a].y));
                                ELSE
                                    idpelota.angulopelota=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                    idpelota.velocidadpelota=coge_veloc(fget_dist(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y));
                                END

                                IF (equipo==0)
                                    angle=fget_angle(x,y,idjugadores1[pasa_a].x,idjugadores1[pasa_a].y);
                                ELSE
                                    angle=fget_angle(x,y,idjugadores2[pasa_a].x,idjugadores2[pasa_a].y);
                                END

                                xgraph=&tablag32;


                                idpelota.graph=10;


                                idpelota.height=90;
                                incactual=0; incbote=18;
                                IF (equipo==0)
                                    idjugadores1[pasa_a].estado=esperandopase;
                                    equipototal[0].esperandopase=idjugadores1[pasa_a];
                                ELSE
                                    idjugadores2[pasa_a].estado=esperandopase;
                                    equipototal[1].esperandopase=idjugadores2[pasa_a];

                                END

                            END
                        END
                    ++estadosaque;
                    END

                    CASE iracorner:


                        velocidad=fget_dist(x,y,idpelota.x,idpelota.y)/totaltestigo;
                        IF (velocidad>vmaxima) velocidad=vmaxima; END
                        IF (velocidad<100) velocidad=100; END
                        angle=fget_angle(x,y,idpelota.x,idpelota.y);


                        IF (fget_dist(x,y,idpelota.x,idpelota.y)<=(vmaxima+200)/2)
                            velocidad=0;
                            estado=tirandocorner;
                            idpelota.graph=1;
                        END
                    END

                    CASE tirandocorner:




                        IF (estadojuego==4 OR estadojuego>21)

                            tirando=2;

                            estado=atontado;
                            cuentaatontado=retardoatontado;
                        END


                        IF (estadojuego<>4)

                            SWITCH(esquinacorner)
                                CASE 0: x=idpelota.x-400; y=idpelota.y-400; END
                                CASE 1: x=idpelota.x+400; y=idpelota.y-400; END
                                CASE 2: x=idpelota.x-400; y=idpelota.y+400; END
                                CASE 3: x=idpelota.x+400; y=idpelota.y+400; END
                            END
                        END
                        angle=get_angle(idpelota);
                    END


                    CASE irarecibecorner:


                        IF (quiensacacorner==1)

                            IF (equipo==0)

                                xdest=(t ctica[n£mero].xc0+xicampo)*100;
                                ydest=(t ctica[n£mero].yc0+yicampo)*100;
                            ELSE
                                xdest=(t ctica[n£mero].xc1+xicampo)*100;
                                ydest=(t ctica[n£mero].yc1+yicampo)*100;
                            END
                        ELSE

                            IF (equipo==0)
                                xdest=(xfcampo-tactica[n£mero].xc1)*100;
                                ydest=(yfcampo-tactica[n£mero].yc1)*100;
                            ELSE
                                xdest=(xfcampo-tactica[n£mero].xc0)*100;
                                ydest=(yfcampo-tactica[n£mero].yc0)*100;
                            END
                        END


                        velocidad=fget_dist(x,y,xdest,ydest)/totaltestigo;
                        IF (velocidad>vmaxima) velocidad=vmaxima; END
                        IF (velocidad<100) velocidad=100; END
                        angle=fget_angle(x,y,xdest,ydest);


                        IF (fget_dist(x,y,xdest,ydest)<=(vmaxima+200)/2)
                            velocidad=0;
                            estado=recibecorner;
                        END
                    END
                END


            until (estado_anterior==estado)
        END


        IF (estado==esperandopase && fget_dist(x,y,idpelota.x,idpelota.y)<zonarecogida AND idpelota.height==0)


            IF (equipototal[equipo].desmarcado<>0)
                (equipototal[equipo].desmarcado).estado=normal;
            END
            equipototal[equipo].desmarcado=0;
            IF (equipototal[0].conbalon<>0)
                (equipototal[0].conbalon).estado=atontado;
                (equipototal[0].conbalon).cuentaatontado=retardoatontado;
                equipototal[0].conbalon=0;
            END


            IF (equipototal[1].conbalon<>0)
                (equipototal[1].conbalon).estado=atontado;
                (equipototal[1].conbalon).cuentaatontado=retardoatontado;
                equipototal[1].conbalon=0;
            END


            equipototal[equipo].conbalon=id;
            equipototal[equipo].conbalon.estado=conbalon;
            equipototal[equipo].esperandopase=0;
        END


        advance(velocidad);


        IF (estado<>saquedebanda)


            IF (estado==conbalon OR fget_dist(x,y,idpelota.x,idpelota.y)>zonaquitada)
                tirandose=0;
            END


            IF (velocidad==0 AND tirando==0)

                xgraph=&tablag1;
            ELSE

                IF (tirandose==1)
                    xgraph=&tablag20;
                ELSE

                    IF (tirando>0)
                        IF (tirando==2)
                            xgraph=&tablag40;
                        ELSE
                            xgraph=&tablag41;
                        END
                        --tirando;
                    ELSE

                        SWITCH(cuentaanima)
                            CASE 0: xgraph=&tablag10;END
                            CASE 1: xgraph=&tablag11;END
                            CASE 2: xgraph=&tablag12;END
                            CASE 3: xgraph=&tablag13;END
                            CASE 4: xgraph=&tablag14;END
                            CASE 5: xgraph=&tablag15;END
                            CASE 6: xgraph=&tablag16;END
                            CASE 7: xgraph=&tablag17;END
                        END
                        ++cuentaanima;IF (cuentaanima>7) cuentaanima=0; END
                    END
                END
            END


            IF (estado==conbalon)
                idpelota.x=x+get_distx(angle,300);
                idpelota.y=y+get_disty(angle,300);
            END
        END
        FRAME;
   END
END







PROCESS controlaequipo(cual)

PRIVATE

    mascerca;
    pospelox;
    pospeloy;

BEGIN
    graph=0;
    timer[1]=0;
    LOOP

        IF (estadojuego==4 AND estadoequipo==1)


            IF (testigo3==cual)


                IF (equipototal[cual].conbalon==0 )

                    IF (cual==0)
                        IF (equipototal[cual].desmarcado<>0)
                            (equipototal[cual].desmarcado).estado=normal;
                            equipototal[cual].desmarcado=0;
                        END
                    ELSE
                        IF (timer[1]>cambiodesmarcado)
                            IF (equipototal[cual].desmarcado<>0)
                                (equipototal[cual].desmarcado).estado=normal;
                                equipototal[cual].desmarcado=0;
                            END
                        END
                    END


                    IF (cual==0)


                        pospelox=da_pos_balon(0,cual);
                        pospeloy=da_pos_balon(1,cual);


                        mascerca=0;


                        FOR (contador=1;contador<10;++contador)

                            IF (idjugadores1[contador].estado<>normal)
                                contador++;
                            ELSE

                                IF(fget_dist(idjugadores1[contador].x,idjugadores1[contador].y,pospelox,pospeloy)<
                                   fget_dist(idjugadores1[mascerca].x,idjugadores1[mascerca].y,pospelox,pospeloy))

                                    mascerca=contador;
                                END
                            END
                        END


                        idjugadores1[mascerca].estado=desmarcado;
                        equipototal[0].desmarcado=idjugadores1[mascerca];
                        equipototal[0].distanciaminima=fget_dist(idjugadores1[mascerca].x,idjugadores1[mascerca].y,pospelox,pospeloy);
                    ELSE


                        pospelox=da_pos_balon(0,cual);
                        pospeloy=da_pos_balon(1,cual);
                        mascerca=0;
                        FOR (contador=1;contador<10;++contador)
                            IF (idjugadores2[contador].estado<>normal)
                                contador++;
                            ELSE
                                IF(fget_dist(idjugadores2[contador].x,idjugadores2[contador].y,pospelox,pospeloy)<
                                   fget_dist(idjugadores2[mascerca].x,idjugadores2[mascerca].y,pospelox,pospeloy))
                                    mascerca=contador;
                                END
                            END
                        END
                        IF (controljugador==2)
                            idjugadores2[mascerca].estado=desmarcado;
                            equipototal[1].desmarcado=idjugadores2[mascerca];
                            equipototal[1].distanciaminima=fget_dist(idjugadores2[mascerca].x,idjugadores2[mascerca].y,pospelox,pospeloy);
                        ELSE
                            IF (timer[1]>cambiodesmarcado)
                                idjugadores2[mascerca].estado=desmarcado;
                                equipototal[1].desmarcado=idjugadores2[mascerca];
                                equipototal[1].distanciaminima=fget_dist(idjugadores2[mascerca].x,idjugadores2[mascerca].y,pospelox,pospeloy);
                                timer[1]=0;
                            END
                        END
                    END
                END
            END


            IF (equipototal[cual].desmarcado<>0)
                (equipototal[cual].desmarcado).estado=desmarcado;
            END
            IF (equipototal[cual].conbalon<>0)
                (equipototal[cual].conbalon).estado=conbalon;
            END

        END


        equipototal[0].defensa=100-estadoataque;
        equipototal[1].defensa=estadoataque;
        equipototal[0].ataque=estadoataque;
        equipototal[1].ataque=100-estadoataque;


        IF (equipototal[0].conbalon<>0)
            (equipototal[0].ataque)+=10;
        END
        IF (equipototal[1].conbalon<>0)
            (equipototal[1].ataque)+=10;
        END

        FRAME;
    END
END







PROCESS flecha(tipo)

BEGIN

    file=fichero1;
    graph=4;


    resolution=100;


    ctype=2;
    z=20;


    flags=4;
    LOOP

        IF (equipototal[tipo].conbalon<>0)
            x=equipototal[tipo].conbalon.x;
            y=equipototal[tipo].conbalon.y-300;
            graph=4;
        ELSE

            IF (equipototal[tipo].desmarcado<>0)
                x=equipototal[tipo].desmarcado.x;
                y=equipototal[tipo].desmarcado.y-300;
                graph=4;
            ELSE

                graph=0;
            END
        END
        FRAME;
    END
END








PROCESS coge_veloc(dist)

PRIVATE
    n=100;
    incdist=0;

BEGIN


    WHILE (incdist<dist)
        incdist+=n;
        n+=incrvelocidadpelota;
    END
    RETURN (n);
END










PROCESS da_pos_balon(cual,cualequipo)

PRIVATE
    posx;
    posy;
    velo;

BEGIN


    IF (cualequipo==0 AND equipototal[1].conbalon<>0)
        posx=(equipototal[1].conbalon).x+get_distx((equipototal[1].conbalon).angle,(equipototal[1].conbalon).velocidad*totaltestigo);
        posy=(equipototal[1].conbalon).y+get_disty((equipototal[1].conbalon).angle,(equipototal[1].conbalon).velocidad*totaltestigo);
    ELSE
        IF (cualequipo==1 AND equipototal[0].conbalon<>0)
            posx=(equipototal[0].conbalon).x+get_distx((equipototal[0].conbalon).angle,(equipototal[0].conbalon).velocidad*totaltestigo);
            posy=(equipototal[0].conbalon).y+get_disty((equipototal[0].conbalon).angle,(equipototal[0].conbalon).velocidad*totaltestigo);
        ELSE

            posx=idpelota.x;
            posy=idpelota.y;


            velo=idpelota.velocidadpelota;


            WHILE (velo==0)
                posx+=get_distx(idpelota.angulopelota,velo);
                posy+=get_disty(idpelota.angulopelota,velo);
                velo-=100;
            END
        END
    END


    IF (cual==0)
        RETURN(posx);
    ELSE
        RETURN(posy);
    END

END






PROCESS minicampo()

BEGIN


    file=fichero1;
    IF (modovideo==0)
        graph=104;
    ELSE
        graph=108;
    END


    x=572-(286*modovideo);
    y=108-(54*modovideo);
    z=-10;


    FOR (contador=0;contador<23;contador++)
        pintapunto(contador);
    END
    LOOP
        IF(conmarcadores==0)
            graph=0;
        ELSE
            IF (modovideo==0)
                graph=104;
            ELSE
                graph=108;
            END
        END
        FRAME;
    END

END







PROCESS pintapunto(cual)

BEGIN

    file=fichero1;


    z=-12;


    LOOP
        IF(conmarcadores==0)
            graph=0;
        ELSE
            SWITCH (cual)
                CASE 0..9,21:
                    IF (modovideo==0)
                        graph=106;
                    ELSE
                        graph=109;
                    END
                END
                CASE 0..19,22:
                    IF (modovideo==0)
                        graph=107;
                    ELSE
                        graph=110;
                    END
                END
                CASE 20:graph=105: END
            END
        END


        SWITCH (cual)
            CASE 0..9:
                x=((idjugadores1[cual].x-(xicampo*100))/(500+(500*modovideo)))+517-(261*modovideo);
                y=(idjugadores1[cual].y-(yicampo*100))/(500+(500*modovideo))+(10-(4*modovideo));
            END
            CASE 10..19:
                x=((idjugadores2[cual-10].x-(xicampo*100))/(500+(500*modovideo)))+517-(261*modovideo);
                y=(idjugadores2[cual-10].y-(yicampo*100))/(500+(500*modovideo))+(10-(4*modovideo));
            END
            CASE 20:
                x=((idpelota.x-(xicampo*100))/(500+(500*modovideo)))+517-(261*modovideo);
                y=(idpelota.y-(yicampo*100))/(500+(500*modovideo))+(10-(4*modovideo));
            END
            CASE 21:
                    x=((idporteros[0].x-(xicampo*100))/(500+(500*modovideo)))+517-(261*modovideo);
                    y=(idporteros[0].y-(yicampo*100))/(500+(500*modovideo))+(10-(4*modovideo));
            END
            CASE 22:
                    x=((idporteros[1].x-(xicampo*100))/(500+(500*modovideo)))+517-(261*modovideo);
                    y=(idporteros[1].y-(yicampo*100))/(500+(500*modovideo))+(10-(4*modovideo));
            END
        END
        FRAME;
    END
END






PROCESS sombrajugador()

PRIVATE



    tablag1[]=8,67,68,69,70,71,72,65,66;

    tablag10[]=8,17,25,33,113,105, 97,1, 9;
    tablag11[]=8,18,26,34,114,106, 98,2,10;
    tablag12[]=8,19,27,35,115,107, 99,3,11;
    tablag13[]=8,20,28,36,116,108,100,4,12;
    tablag14[]=8,21,29,37,117,109,101,5,13;
    tablag15[]=8,22,30,38,118,110,102,6,14;
    tablag16[]=8,23,31,39,119,111,103,7,15;
    tablag17[]=8,24,32,40,120,112,105,8,16;

    tablag20[]=8,57,58,59,60,61,62,63,64;

    tablag30[]=8,51,52,53,54,55,56,49,50;
    tablag31[]=8,43,44,45,46,47,48,41,42;
    tablag32[]=8,75,76,77,78,79,80,73,74;

    tablag40[]=8,83,84,85,86,87,88,81,82;
    tablag41[]=8,91,92,93,94,95,96,89,90;


BEGIN

    ctype=2;
    file=fichero7;


    flags=4;


    resolution=100;


    z=(father.z)+10;
    LOOP


        angle=father.angle;
        x=father.x;
        y=father.y-2;

        IF (father.estado<>saquedebanda)

            IF (father.velocidad==0 && father.tirando==0)
                xgraph=&tablag1;
            ELSE

                IF (father.tirandose==1)
                    xgraph=&tablag20;
                ELSE

                    IF (father.tirando>0)
                        IF (father.tirando==2)
                            xgraph=&tablag40;
                        ELSE
                            xgraph=&tablag41;
                        END
                    ELSE

                        SWITCH(father.cuentaanima)
                            CASE 0: xgraph=&tablag10;END
                            CASE 1: xgraph=&tablag11;END
                            CASE 2: xgraph=&tablag12;END
                            CASE 3: xgraph=&tablag13;END
                            CASE 4: xgraph=&tablag14;END
                            CASE 5: xgraph=&tablag15;END
                            CASE 6: xgraph=&tablag16;END
                            CASE 7: xgraph=&tablag17;END
                        END
                    END
                END
            END
        ELSE
            SWITCH (estadosaque)
            CASE 0: xgraph=&tablag30; END
            CASE 1: xgraph=&tablag31; END
            CASE 2: xgraph=&tablag32; END
            END
        END
        FRAME;
    END

END







PROCESS controlajuego ()

PRIVATE
    cuentaparados;
    pasaa;
    mascerca;
    xtemp,ytemp;
    iniciosaque;
BEGIN
    graph=0;
    LOOP

        SWITCH (estadojuego)

            CASE 1:
                IF (quienempieza==1 AND controljugador<>2)
                    elegidosaque=8;
                    elige_saque(9);
                    FRAME;
                    pasaa=elegidosaque;
                ELSE
                    IF (quienempieza==1)
                        pasaa=daquienpasa(1);
                    END
                END
                ponmensajes (0,20);


                IF (inicioparte==0)
                    inicioparte=1;
                    timer[0]=0;
                END
                IF (inicioparte==3)
                    inicioparte=4;
                    timer[0]=0;
                END
                sound(idsonido3,50,256);


                IF (quienempieza==0)
                    idpelota.angulopelota=fget_angle(idpelota.x,idpelota.y,idjugadores1[9].x,idjugadores1[9].y);
                    idpelota.velocidadpelota=coge_veloc(fget_dist(idpelota.x,idpelota.y,idjugadores1[9].x,idjugadores1[9].y));
                    idjugadores1[8].tirando=2;
                ELSE
                    idpelota.angulopelota=fget_angle(idpelota.x,idpelota.y,idjugadores2[9].x,idjugadores2[9].y);
                    idpelota.velocidadpelota=coge_veloc(fget_dist(idpelota.x,idpelota.y,idjugadores2[9].x,idjugadores2[9].y));
                    idjugadores2[8].tirando=2;
                END

                estadojuego=2;
            END
            CASE 2:

                IF (quienempieza==0)

                    IF (fget_dist(idjugadores1[9].x,idjugadores1[9].y,idpelota.x,idpelota.y)<zonarecogida)
                        sound(idsonido3,50,256);

                        FOR (contador=0;contador<10;++contador)
                            idjugadores1[contador].estado=normal;
                            idjugadores2[contador].estado=normal;
                        END
                        pasaa=daquienpasa(0);


                        idpelota.angulopelota=fget_angle(idjugadores1[9].x,idjugadores1[9].y,idjugadores1[pasaa].x,idjugadores1[pasaa].y);
                        idjugadores1[9].angle=fget_angle(idjugadores1[9].x,idjugadores1[9].y,idjugadores1[pasaa].x,idjugadores1[pasaa].y);
                        idpelota.velocidadpelota=coge_veloc(fget_dist(idjugadores1[9].x,idjugadores1[9].y,idjugadores1[pasaa].x,idjugadores1[pasaa].y));


                        IF (idpelota.velocidadpelota>conbote)
                            incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                        END


                        idjugadores1[pasaa].estado=esperandopase;
                        idjugadores1[pasaa].velocidad=0;
                        equipototal[0].esperandopase=idjugadores1[pasaa];
                        estadojuego=3;
                        idjugadores1[9].tirando=2;
                    END
                ELSE

                    IF (fget_dist(idjugadores2[9].x,idjugadores2[9].y,idpelota.x,idpelota.y)<zonarecogida)
                        sound(idsonido3,50,256);
                        FOR (contador=0;contador<10;++contador)
                            idjugadores1[contador].estado=normal;
                            idjugadores2[contador].estado=normal;
                        END
                        idpelota.angulopelota=fget_angle(idjugadores2[9].x,idjugadores2[9].y,idjugadores2[pasaa].x,idjugadores2[pasaa].y);
                        idpelota.velocidadpelota=coge_veloc(fget_dist(idjugadores2[9].x,idjugadores2[9].y,idjugadores2[pasaa].x,idjugadores2[pasaa].y));
                        idjugadores2[9].angle=fget_angle(idjugadores2[9].x,idjugadores2[9].y,idjugadores2[pasaa].x,idjugadores2[pasaa].y);
                        IF (idpelota.velocidadpelota>conbote)
                            incactual=(idpelota.velocidadpelota-conbote)/50; incbote=(idpelota.velocidadpelota-conbote)/50; idpelota.height=0;
                        END

                        idjugadores2[pasaa].estado=esperandopase;
                        idjugadores2[pasaa].velocidad=0;
                        equipototal[1].esperandopase=idjugadores2[pasaa];
                        estadojuego=3;
                        idjugadores2[9].tirando=2;
                    END
                END
            END
            CASE 3:
                estadoequipo=1;
                estadojuego=4;
            END

            CASE 5:

                idpelota.x=(((xfcampo-xicampo)/2)+xicampo)*100;
                idpelota.y=(((yfcampo-yicampo)/2)+yicampo)*100;
                idpelota.velocidadpelota=0; idpelota.angulopelota=0;
                idpelota.height=0; incactual=0; incbote=0;


                FOR (contador=0;contador<10;contador++)
                    (idjugadores1[contador]).estado=parado;
                    (idjugadores2[contador]).estado=parado;
                     IF (quienempieza==0)
                        (idjugadores1[contador]).xi=(t ctica[contador].xi0+xicampo)*100;
                        (idjugadores1[contador]).yi=(t ctica[contador].yi0+yicampo)*100;
                        (idjugadores2[contador]).xi=(xfcampo-tactica[contador].xi1)*100;
                        (idjugadores2[contador]).yi=(yfcampo-tactica[contador].yi1)*100;
                     ELSE
                        (idjugadores1[contador]).xi=(t ctica[contador].xi1+xicampo)*100;
                        (idjugadores1[contador]).yi=(t ctica[contador].yi1+yicampo)*100;
                        (idjugadores2[contador]).xi=(xfcampo-tactica[contador].xi0)*100;
                        (idjugadores2[contador]).yi=(yfcampo-tactica[contador].yi0)*100;
                     END
                END


                equipototal[0].conbalon=0;
                equipototal[1].conbalon=0;
                equipototal[0].desmarcado=0;
                equipototal[1].desmarcado=0;
                equipototal[0].esperandopase=0;
                equipototal[1].esperandopase=0;


                estadojuego=0;
                estadoequipo=0;
            END

            CASE 10:
                IF (sacando==0)

                    IF (equipototal[0].desmarcado<>0 )
                        (equipototal[0].desmarcado).estado=normal;
                    END
                    IF (equipototal[1].desmarcado<>0 )
                        (equipototal[1].desmarcado).estado=normal;
                    END

                    IF (equipototal[0].conbalon<>0 )
                        (equipototal[0].conbalon).estado=normal;
                    END
                    IF (equipototal[1].conbalon<>0 )
                        (equipototal[1].conbalon).estado=normal;
                    END

                    IF (equipototal[0].esperandopase<>0 )
                        (equipototal[0].esperandopase).estado=normal;
                    END
                    IF (equipototal[1].esperandopase<>0 )
                        (equipototal[1].esperandopase).estado=normal;
                    END


                    equipototal[0].desmarcado=0;
                    equipototal[1].desmarcado=0;
                    equipototal[0].conbalon=0;
                    equipototal[1].conbalon=0;
                    equipototal[0].esperandopase=0;
                    equipototal[1].esperandopase=0;


                    FOR (contador=1;contador<10;++contador)
                        idjugadores1[mascerca].estado=normal;
                        idjugadores2[mascerca].estado=normal;
                    END


                    IF (quiensacadebanda==0)
                        mascerca=0;
                        FOR (contador=1;contador<10;++contador)
                            IF (fget_dist(idjugadores1[contador].x,idjugadores1[contador].y,idpelota.x,idpelota.y)<
                                fget_dist(idjugadores1[mascerca].x,idjugadores1[mascerca].y,idpelota.x,idpelota.y))
                                mascerca=contador;
                            END
                        END
                        equipototal[quiensacadebanda].saquedebanda=idjugadores1[mascerca];
                        idjugadores1[mascerca].estado=irasaque;
                    ELSE
                        mascerca=0;
                        FOR (contador=1;contador<10;++contador)
                            IF (fget_dist(idjugadores2[contador].x,idjugadores2[contador].y,idpelota.x,idpelota.y)<
                                fget_dist(idjugadores2[mascerca].x,idjugadores2[mascerca].y,idpelota.x,idpelota.y))
                                mascerca=contador;
                            END
                        END
                        equipototal[quiensacadebanda].saquedebanda=idjugadores2[mascerca];
                        idjugadores2[mascerca].estado=irasaque;
                    END

                    idpelota.velocidadpelota=0;
                    idpelota.angulopelota=0;
                    idpelota.height=0;

                    estadojuego=11;
                    estadosaque=0;
                    sacando=1;
                END
            END
            CASE 11:
                IF (estadosaque>2)
                    pesopelota=3;


                    IF (equipototal[0].saquedebanda<>0)
                        (equipototal[0].saquedebanda).estado=atontado;
                        (equipototal[0].saquedebanda).cuentaatontado=retardoatontado;
                         equipototal[0].saquedebanda=0;
                    END
                    IF (equipototal[1].saquedebanda<>0)
                        (equipototal[1].saquedebanda).estado=atontado;
                        (equipototal[1].saquedebanda).cuentaatontado=retardoatontado;
                         equipototal[1].saquedebanda=0;
                    END

                    estadojuego=4;
                    sacando=0;
                END
            END


            CASE 15:
                IF (sacandoporteria==1)

                    equipototal[0].desmarcado=0;
                    equipototal[1].desmarcado=0;
                    equipototal[0].conbalon=0;
                    equipototal[1].conbalon=0;
                    equipototal[0].esperandopase=0;
                    equipototal[1].esperandopase=0;
                    FROM contador=0 TO 9;
                        idjugadores1[contador].estado=parado;
                        idjugadores2[contador].estado=parado;
                    END
                    estadoequipo=0;
                    estadojuego=16;
                    sacandoporteria=2;

                    IF (porterosacando==0)
                        get_point(fichero4,idporteros[porterosacando].graph,1,&xtemp,&ytemp);
                        idpelota.y=idporteros[porterosacando].y-100;
                    ELSE
                        get_point(fichero5,idporteros[porterosacando].graph,1,&xtemp,&ytemp);
                        idpelota.y=idporteros[porterosacando].y+100;
                    END
                    idpelota.x=(idporteros[porterosacando].x+((xtemp-50)*150));
                    idpelota.height=(105-ytemp);
                END
            END
            CASE 17:
                IF (porterosacando<>1 AND controljugador<>2 AND sacandoporteria==3)
                    elegidosaque=0;
                    FROM contador=0 TO 9;
                        IF (fget_dist(idpelota.x,idpelota.y,idjugadores2[contador].x,idjugadores2[contador].y)<
                            fget_dist(idpelota.x,idpelota.y,idjugadores2[elegidosaque].x,idjugadores2[elegidosaque].y))
                            elegidosaque=contador;
                        END
                    END
                    elige_saque(10);
                    FRAME;
                    pasaa=elegidosaque;
                END
                sacandoporteria=4;
            END
            CASE 18:
                IF (sacandoporteria==4)
                    estadojuego=19;
                    sacandoporteria=5;
                END
            END

            CASE 19:
                IF (sacandoporteria==5);

                    FROM contador=0 TO 9;
                        idjugadores1[contador].estado=normal;
                        idjugadores2[contador].estado=normal;
                    END

                    IF (porterosacando==1)

                        pasaa=daquienpasa(0);

                        idpelota.angulopelota=fget_angle(idpelota.x,idpelota.y,idjugadores1[pasaa].x,idjugadores1[pasaa].y);
                        idpelota.velocidadpelota=coge_veloc(fget_dist(idpelota.x,idpelota.y,idjugadores1[pasaa].x,idjugadores1[pasaa].y));
                        idjugadores1[pasaa].estado=esperandopase;
                        equipototal[0].esperandopase=idjugadores1[pasaa];
                    ELSE
                        IF (controljugador==2)
                            pasaa=daquienpasa(1);
                        END
                        idpelota.angulopelota=fget_angle(idpelota.x,idpelota.y,idjugadores2[pasaa].x,idjugadores2[pasaa].y);
                        idpelota.velocidadpelota=coge_veloc(fget_dist(idpelota.x,idpelota.y,idjugadores2[pasaa].x,idjugadores2[pasaa].y));
                        idjugadores2[pasaa].estado=esperandopase;
                        equipototal[1].esperandopase=idjugadores2[pasaa];
                    END

                    estadojuego=4;
                    estadoequipo=1;
                    idporteros[porterosacando].estado=normal;

                    idpelota.height=60;incactual=-12; incbote=18;
                    cuenporterosacando=0;
                    sacandoporteria=0;
                    idpelota.x+=get_distx(idpelota.angulopelota,idpelota.velocidadpelota);
                    idpelota.y+=get_disty(idpelota.angulopelota,idpelota.velocidadpelota);

                END
            END


            CASE 20:
                IF (sacandocorner==0)
                    SWITCH (esquinacorner)
                        CASE 0: idpelota.x=xicampo*100;idpelota.y=yicampo*100; END
                        CASE 1: idpelota.x=xfcampo*100;idpelota.y=yicampo*100; END
                        CASE 2: idpelota.x=xicampo*100;idpelota.y=yfcampo*100; END
                        CASE 3: idpelota.x=xfcampo*100;idpelota.y=yfcampo*100; END
                    END


                    IF (equipototal[0].desmarcado<>0 )
                        (equipototal[0].desmarcado).estado=normal;
                    END
                    IF (equipototal[1].desmarcado<>0 )
                        (equipototal[1].desmarcado).estado=normal;
                    END
                    IF (equipototal[0].conbalon<>0 )
                        (equipototal[0].conbalon).estado=normal;
                    END
                    IF (equipototal[1].conbalon<>0 )
                        (equipototal[1].conbalon).estado=normal;
                    END
                    IF (equipototal[0].esperandopase<>0 )
                        (equipototal[0].esperandopase).estado=normal;
                    END
                    IF (equipototal[1].esperandopase<>0 )
                        (equipototal[1].esperandopase).estado=normal;
                    END


                    equipototal[0].desmarcado=0;
                    equipototal[1].desmarcado=0;
                    equipototal[0].conbalon=0;
                    equipototal[1].conbalon=0;
                    equipototal[0].esperandopase=0;
                    equipototal[1].esperandopase=0;


                    idporteros[0].estado=recibecorner;
                    idporteros[1].estado=recibecorner;


                    idpelota.velocidadpelota=0;
                    idpelota.angulopelota=0;
                    idpelota.height=0;


                    IF (quiensacacorner==0)

                        mascerca=0;
                        FOR (contador=1;contador<10;++contador)
                            IF (fget_dist(idjugadores1[contador].x,idjugadores1[contador].y,idpelota.x,idpelota.y)<
                                fget_dist(idjugadores1[mascerca].x,idjugadores1[mascerca].y,idpelota.x,idpelota.y))
                                mascerca=contador;
                            END
                        END
                        idjugadores1[mascerca].estado=iracorner;
                        equipototal[0].sacacorner=idjugadores1[mascerca];

                        FOR (contador=0;contador<10;++contador)
                            IF (idjugadores1[contador].estado<>iracorner)
                                idjugadores1[contador].estado=irarecibecorner;
                            END
                            idjugadores2[contador].estado=irarecibecorner;
                        END
                    ELSE
                        mascerca=0;
                        FOR (contador=1;contador<10;++contador)
                            IF (fget_dist(idjugadores1[contador].x,idjugadores2[contador].y,idpelota.x,idpelota.y)<
                                fget_dist(idjugadores1[mascerca].x,idjugadores2[mascerca].y,idpelota.x,idpelota.y))
                                mascerca=contador;
                            END
                        END
                        idjugadores2[mascerca].estado=iracorner;
                        equipototal[1].sacacorner=idjugadores2[mascerca];
                        FOR (contador=0;contador<10;++contador)
                            IF (idjugadores2[contador].estado<>iracorner)
                                idjugadores2[contador].estado=irarecibecorner;
                            END
                            idjugadores1[contador].estado=irarecibecorner;
                       END
                    END

                    estadojuego=21;
                    sacandocorner=1;
                END
            END
            CASE 21:
                IF (sacandocorner==1)

                    cuentaparados=0;
                    FOR (contador=0;contador<10;contador++)
                        IF (idjugadores1[contador].estado==recibecorner)
                            cuentaparados++;
                        END
                        IF (idjugadores1[contador].estado==tirandocorner)
                            cuentaparados++;
                        END

                        IF (idjugadores2[contador].estado==recibecorner)
                            cuentaparados++;
                        END
                        IF (idjugadores2[contador].estado==tirandocorner)
                            cuentaparados++;
                        END
                    END

                    IF (cuentaparados==20) sacandocorner=2; estadojuego=22; END
                END
            END
            CASE 22:
                IF (sacandocorner==2)
                    sound(idsonido3,50,256);
                    IF (quiensacacorner==1 AND controljugador<2)
                        IF (equipototal[1].sacacorner.numero==0)
                            iniciosaque=2;
                            elegidosaque=1;
                        ELSE
                            iniciosaque=1;
                            elegidosaque=0;
                        END
                        FOR (contador=iniciosaque;contador<10;contador++)
                            IF (contador<>equipototal[1].sacacorner.numero)
                                IF (fget_dist(idpelota.x,idpelota.y,idjugadores2[contador].x,idjugadores2[contador].y)<
                                    fget_dist(idpelota.x,idpelota.y,idjugadores2[elegidosaque].x,idjugadores2[elegidosaque].y))
                                    elegidosaque=contador;
                                END
                            END
                        END
                        elige_saque((equipototal[1].sacacorner).numero);
                        FRAME;
                        idpelota.angulopelota=fget_angle(idpelota.x,idpelota.y,idjugadores2[elegidosaque].x,idjugadores2[elegidosaque].y);
                        idpelota.velocidadpelota=coge_veloc(fget_dist(idpelota.x,idpelota.y,idjugadores2[elegidosaque].x,idjugadores2[elegidosaque].y));
                    ELSE

                        SWITCH (esquinacorner)
                            CASE 0: idpelota.angulopelota=rand (280000,350000); END
                            CASE 1: idpelota.angulopelota=rand (190000,260000); END
                            CASE 2: idpelota.angulopelota=rand ( 10000, 80000); END
                            CASE 3: idpelota.angulopelota=rand (100000,170000); END
                        END

                        idpelota.velocidadpelota= coge_veloc(rand(12000,44000));

                    END
                    FOR (contador=0;contador<10;contador++)
                        IF (idjugadores1[contador].estado==recibecorner)
                            idjugadores1[contador].estado=normal;
                        END
                        IF (idjugadores2[contador].estado==recibecorner)
                            idjugadores2[contador].estado=normal;
                        END
                    END
                    idporteros[0].estado=normal;
                    idporteros[1].estado=normal;

                    estadojuego=23;
                    sacandocorner=3;
                END
            END
            CASE 23:
                IF (sacandocorner==3)

                    IF (equipototal[0].sacacorner<>0)
                        equipototal[0].sacacorner=0;
                    END
                    IF (equipototal[1].sacacorner<>0)
                        equipototal[1].sacacorner=0;
                    END

                    sacandocorner=0;
                    estadojuego=4;
                END
            END
        END


        cuentaparados=0;
        IF (estadoequipo==0 AND estadojuego==0)
            FROM contador=0 TO 9;
                IF (idjugadores1[contador].estado==parado AND
                    idjugadores1[contador].velocidad==0   AND
                    idjugadores2[contador].estado==parado AND
                    idjugadores2[contador].velocidad==0   )
                    cuentaparados++;
                END
            END
            IF (cuentaparados==10)
                estadojuego=1;
            END
        END
        cuentaparados=0;
        IF (estadojuego==16 AND estadoequipo==0 AND sacandoporteria==2)
            FROM contador=0 TO 9;
                IF (idjugadores1[contador].estado==parado AND
                    idjugadores1[contador].velocidad==0   AND
                    idjugadores2[contador].estado==parado AND
                    idjugadores2[contador].velocidad==0   )
                    cuentaparados++;
                END
            END
            IF (cuentaparados==10)
                estadojuego=17;
                cuentaparados=0;
                sacandoporteria=3;
            END
        END

        FRAME;

    END
END








PROCESS daquienpasa(equipo)

PRIVATE

    distanciasmin[10]= 11 DUP (0);

    mascerca;
    masadelantado;

BEGIN


    FOR (contador=0;contador<10;contador++)

        IF (equipo==0)

            IF (idjugadores1[contador].estado<>normal)

                distanciasmin[contador]=0;
            ELSE

                mascerca=0;

                FOR (contador2=1;contador2<10;contador2++)

                    IF (fget_dist(idjugadores1[contador].x,idjugadores1[contador].y,idjugadores2[contador2].x,idjugadores2[contador2].y)<
                        fget_dist(idjugadores1[contador].x,idjugadores1[contador].y,idjugadores2[mascerca].x,idjugadores2[mascerca].y))
                        mascerca=contador2;
                    END
                END
                masadelantado=fget_dist(idjugadores1[contador].x,idjugadores1[contador].y,(((xfcampo*100)-(xicampo*100))/2)+(xicampo*100),yfcampo*100)/((xfcampo-xicampo)*100);

                distanciasmin[contador]=fget_dist(idjugadores1[contador].x,idjugadores1[contador].y,idjugadores2[mascerca].x,idjugadores2[mascerca].y)-(masadelantado*5000);
           END
        ELSE

            IF (idjugadores2[contador].estado<>normal)
                distanciasmin[contador]=0;
            ELSE
                mascerca=0;
                FOR (contador2=1;contador2<10;contador2++)
                    IF (fget_dist(idjugadores2[contador].x,idjugadores2[contador].y,idjugadores1[contador2].x,idjugadores1[contador2].y)<
                        fget_dist(idjugadores2[contador].x,idjugadores2[contador].y,idjugadores1[mascerca].x,idjugadores1[mascerca].y))
                        mascerca=contador2;
                    END
                END
                masadelantado=fget_dist(idjugadores2[contador].x,idjugadores2[contador].y,(((xfcampo*100)-(xicampo*100))/2)+(xicampo*100),yicampo*100)/((xfcampo-xicampo)*100);
                distanciasmin[contador]=fget_dist(idjugadores2[contador].x,idjugadores2[contador].y,idjugadores1[mascerca].x,idjugadores1[mascerca].y)-(masadelantado*5000);
            END
        END
    END


    mascerca=0;
    FOR (contador=1;contador<10;contador++)

        IF (distanciasmin[contador]>distanciasmin[mascerca])

            mascerca=contador;
        END
    END

    RETURN(mascerca);
END









PROCESS porteros(cual, yiportero, file)

PRIVATE

    pesopelota2;
    distbalon;
    destx,desty;
    xtemp2,ytemp2;
    cuentatirada=0;

BEGIN
    height=-5;
    ctype=2;
    resolution=100;
    size=150;
    graph=17;


    x=(((xfcampo-xicampo)/2)+xicampo)*100;
    y=yiportero;


    estado=normal;
    LOOP

        IF (cual==testigo3)

            SWITCH (estado)

                CASE normal:

                    destx=((381+((((idpelota.x/100))*165)/926))*100);

                    distbalon=fget_dist(x,y,idpelota.x,idpelota.y);

                    IF (distbalon>30000)
                        pesopelota2=0;
                    ELSE
                        pesopelota2=(30000-distbalon)/600;
                    END

                    desty=(((100*yiportero)+(pesopelota2*idpelota.y))/(100+pesopelota2));

                    velocidad=fget_dist(x,y,destx,desty)/4;
                    IF (velocidad>vmaxima) velocidad=vmaxima; END
                    IF (velocidad<100) velocidad=100; END
                    anguloportero=fget_angle(x,y,destx,desty);

                    IF (fget_dist(x,y,idpelota.x,idpelota.y)<=(vmaxima)/2) velocidad=0; END


                    IF (fget_dist(x,y,idpelota.x,idpelota.y)<equipototal[0].distanciaminima AND
                        fget_dist(x,y,idpelota.x,idpelota.y)<equipototal[1].distanciaminima AND
                        fget_dist(x,y,idpelota.x,idpelota.y)<22000)
                        velocidad=fget_dist(x,y,idpelota.x,idpelota.y)/4;
                        IF (velocidad>vmaxima) velocidad=vmaxima; END
                        IF (velocidad<100) velocidad=100; END
                        anguloportero=fget_angle(x,y,idpelota.x,idpelota.y);
                        IF (fget_dist(x,y,idpelota.x,idpelota.y)<=(vmaxima+200)/2) velocidad=0; END
                    ELSE
                        velocidad=fget_dist(x,y,destx,desty)/4;
                        IF (velocidad>vmaxima) velocidad=vmaxima; END
                        IF (velocidad<100) velocidad=100; END
                        anguloportero=fget_angle(x,y,destx,desty);
                        IF (fget_dist(x,y,destx,desty)<=(vmaxima+200)/2) velocidad=0; END
                    END


                    IF (velocidad>0)
                        x+=get_distx(anguloportero,velocidad);
                        y+=get_disty(anguloportero,velocidad);
                    END


                    IF (fget_dist(x,y,idpelota.x,idpelota.y)<zonarecogida*3 AND height<180 AND sacandoporteria==0)
                        velocidad=0;
                        estado=conbalon;
                        idpelota.velocidadpelota=0;
                        estadojuego=15;
                        porterosacando=cual;
                        sacandoporteria=1;

                    END


                    IF (idpelota.y-y<500 AND abs(idpelota.x-x)<zonarecogida*5 AND
                        fget_dist(x,y,idpelota.x,idpelota.y)>zonarecogida*3 AND idpelota.velocidadpelota>0)
                        estado=porterotirandose;
                        cuentatirada=0;
                        pesopelota=1;
                    END


                    IF (x_vieja<>x)
                        IF (x_vieja<x)
                            graph++;IF (graph>23)graph=17; END
                        ELSE
                            graph--;IF (graph<17)graph=23; END
                        END
                    ELSE
                        IF (y_vieja<>y)
                            IF (y_vieja<y)
                                graph++;IF (graph>23)graph=17; END
                            ELSE
                                graph--;IF (graph<17)graph=23; END
                            END
                        END
                    END
                END


                CASE conbalon:
                    graph=9;

                    IF (porterosacando==0)
                        get_point(fichero4,graph,1,&xtemp2,&ytemp2);
                        idpelota.y=idporteros[porterosacando].y-100;
                    ELSE
                        get_point(fichero5,graph,1,&xtemp2,&ytemp2);
                        idpelota.y=idporteros[porterosacando].y+100;
                    END
                    idpelota.x=(idporteros[porterosacando].x+((xtemp2-50)*150));
                    idpelota.height=(105-ytemp2);

                    idpelota.graph=1;
                    IF (estadojuego>16)

                        SWITCH(cuenporterosacando)

                            CASE 0:
                                graph=9;
                            END
                            CASE 1..7:
                                graph++;
                            END

                            CASE 8:
                                estadojuego=18;
                                pesopelota=3;
                                graph=17;
                            END
                        END

                        IF (porterosacando==0)
                            get_point(fichero4,graph,1,&xtemp2,&ytemp2);
                            idpelota.y=y-100;
                        ELSE
                            get_point(fichero5,graph,1,&xtemp2,&ytemp2);
                            idpelota.y=y+100;
                        END

                        idpelota.x=x+((xtemp2-50)*150);
                        idpelota.height=(105-ytemp2);
                        ++cuenporterosacando;
                    END
                END


                CASE porterotirandose:

                    SWITCH(cuentatirada)
                        CASE 0:

                            IF (x>idpelota.x)
                                IF (cual)
                                    flags=1;
                                ELSE
                                    flags=0;
                                END
                            ELSE
                                IF (cual)
                                    flags=0;
                                ELSE
                                    flags=1;
                                END
                            END
                            graph=1;
                        END

                        CASE 1..7:
                            graph++;
                        END

                        CASE 8:
                            estado=normal;
                            graph=17;
                            flags=0;
                        END
                    END

                    FOR (contador=1;contador<6;contador++)
                        IF (porterosacando==0)
                            get_point(fichero4,graph,contador,&xtemp2,&ytemp2);
                        ELSE
                            get_point(fichero5,graph,contador,&xtemp2,&ytemp2);
                        END
                        IF ((abs(idpelota.x-(x+(xtemp2*150)-5000))<2000 AND abs(idpelota.height-ytemp2)<2000 AND abs(idpelota.y-y)<200))
                            estado=normal;
                            graph=17;
                            flags=0;
                            angulopelota=fget_angle(0,0,get_distx(angulopelota,velocidadpelota),-get_disty(angulopelota,velocidadpelota));
                            velocidadpelota+=4;
                        END
                    END
                    cuentatirada++;
                END
            END
        END


        ponsombraportero(cual);
        FRAME;


        x_vieja=x;y_vieja=y;
    END

END







PROCESS ponsombraportero(cualportero)

BEGIN

    IF (cualportero==0)
        file=fichero8;
    ELSE
        file=fichero9;
    END


    if (father.estado==tirandose)

        IF (father.x>idpelota.x)
            IF (cualportero)
                flags=1;
            ELSE
                flags=0;
            END
        ELSE
            IF (cualportero)
                flags=0;
            ELSE
                flags=1;
            END
        END
    END
    height=15;
    resolution=100;
    ctype=2;
    flags=4;


    x=father.x;
    y=father.y-2;
    graph=father.graph;
    FRAME;
END







PROCESS bander¡n (x,y)

BEGIN


    file=fichero1;
    graph=1;
    ctype=2;
    LOOP
        FRAME;
    END
END








PROCESS ponmensajes (cualmensaje, tiempopuesto)

PRIVATE


    mensaje[]="FIRST SHOOT","1st TIME","2nd TIME","GOAL!!","OUT","CORNER","END FIRST TIME","  FINISH  ";
    contatexto;

BEGIN


    sound(idsonido0,50,256);


    contatexto=tiempopuesto;


    IF (modovideo==0)
        idtextomensaje=write(fuente1,320-(160*modovideo),240-(140*modovideo),4,mensaje[cualmensaje]);
    ELSE
        idtextomensaje=write(fuente2,320-(160*modovideo),240-(140*modovideo),4,mensaje[cualmensaje]);
    END


    WHILE (contatexto>0)
        contatexto--;
        FRAME;
    END


    IF (idtextomensaje<>0)
        delete_text(idtextomensaje);
        idtextomensaje=0;
    END

END






PROCESS ponnombrejugador()

PRIVATE
    numerojugador;

BEGIN


    FOR (contador=0;contador<240;++contador);
        IF (idnombres[contador/10].idletras[contador MOD 10]<>-1)
            delete_text(idnombres[contador/10].idletras[contador MOD 10]);
            idnombres[contador/10].idletras[contador MOD 10]=-1;
        END
    END


    IF (idnumerojugador<>0)
        delete_text(idnumerojugador);
        idnumerojugador=0;
    END

    IF (conmarcadores==0) RETURN; END


    IF (idporteros[1].estado==conbalon)
        IF (modovideo==0)
            escribe_nombre(260-(140*modovideo),460-(270*modovideo),13,fuente2,20);
            idnumerojugador=write_int(fuente2,240-(140*modovideo),460-(270*modovideo),1,"1");
        ELSE
            escribe_nombre(260-(140*modovideo),460-(270*modovideo),13,0,10);
            idnumerojugador=write_int(0,240-(140*modovideo),460-(270*modovideo),1,"1");
        END
    ELSE
        IF (idporteros[0].estado==conbalon)
            IF (modovideo==0)
                escribe_nombre(260-(140*modovideo),460-(270*modovideo),1,fuente2,20);
                idnumerojugador=write_int(fuente2,240-(140*modovideo),460-(270*modovideo),1,"1");
            ELSE
                escribe_nombre(260-(140*modovideo),460-(270*modovideo),1,0,10);
                idnumerojugador=write_int(0,240-(140*modovideo),460-(270*modovideo),1,"1");
            END
        ELSE

            IF (equipototal[0].conbalon<>0)

                IF (modovideo==0)

                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[0].conbalon.n£mero)+14,fuente2,20);
                ELSE
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[0].conbalon.n£mero)+14,0,10);
                END

                numerojugador=(equipototal[0].conbalon.n£mero)+2;

                IF (modovideo==0)
                    idnumerojugador=write_int(fuente2,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                ELSE
                    idnumerojugador=write_int(0,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                END
            END


            IF (equipototal[1].conbalon<>0)
                IF (modovideo==0)
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[1].conbalon.n£mero)+2,fuente2,20);
                ELSE
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[1].conbalon.n£mero)+2,0,10);
                END
                numerojugador=(equipototal[1].conbalon.n£mero)+2;
                IF (modovideo==0)
                    idnumerojugador=write_int(fuente2,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                ELSE
                    idnumerojugador=write_int(0,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                END
            END


            IF (equipototal[0].sacacorner<>0)
                IF (modovideo==0)
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[0].sacacorner.n£mero)+14,fuente2,20);
                ELSE
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[0].sacacorner.n£mero)+14,0,10);
                END
                numerojugador=(equipototal[0].sacacorner.n£mero)+2;
                IF (modovideo==0)
                    idnumerojugador=write_int(fuente2,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                ELSE
                    idnumerojugador=write_int(0,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                END
            END
            IF (equipototal[1].sacacorner<>0)
                IF (modovideo==0)
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[1].sacacorner.n£mero)+2,fuente2,20);
                ELSE
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[1].sacacorner.n£mero)+2,0,10);
                END
                numerojugador=(equipototal[1].sacacorner.n£mero)+2;
                IF (modovideo==0)
                    idnumerojugador=write_int(fuente2,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                ELSE
                    idnumerojugador=write_int(0,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                END
            END


            IF (equipototal[0].saquedebanda<>0)
                IF (modovideo==0)
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[0].saquedebanda.n£mero)+14,fuente2,20);
                ELSE
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[0].saquedebanda.n£mero)+14,0,10);
                END
                numerojugador=(equipototal[0].saquedebanda.n£mero)+2;
                IF (modovideo==0)
                    idnumerojugador=write_int(fuente2,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                ELSE
                    idnumerojugador=write_int(0,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                END
            END
            IF (equipototal[1].saquedebanda<>0)
                IF (modovideo==0)
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[1].saquedebanda.n£mero)+2,fuente2,20);
                ELSE
                    escribe_nombre(260-(140*modovideo),460-(270*modovideo),(equipototal[1].saquedebanda.n£mero)+2,0,10);
                END
                numerojugador=(equipototal[1].saquedebanda.n£mero)+2;
                IF (modovideo==0)
                    idnumerojugador=write_int(fuente2,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                ELSE
                    idnumerojugador=write_int(0,240-(140*modovideo),460-(270*modovideo),1,&numerojugador);
                END
            END
        END
    END
    FRAME;
END







PROCESS traje2(x,y,graph,file)

BEGIN
    LOOP FRAME; END
END







PROCESS ponminicamisas(x,y,graph,file,size)

PRIVATE
    guardagrafico;

BEGIN
    guardagrafico=graph;
    LOOP
        IF (conmarcadores==0) graph=0; ELSE graph=guardagrafico; END
        FRAME;
    END
END






PROCESS cr‚ditos()

PRIVATE
    idfondopant;

BEGIN


    fade_off();
    let_me_alone();
    delete_text(all_text);


    mouse.file=fichero1; mouse.graph=909;
    idfondopant=load_map("soccer\presenta.map");
    load_pal("soccer\presenta.map");


    put_screen(0,idfondopant);


    unload_fnt(fuente1);


    fuente1=load_fnt("soccer\futbol4.fnt");


    write(fuente1,320,0,1,"- CREDITS -");
    write(fuente1,320,50,1,"CODER:");
    write(fuente1,320,80,1,"ANTONIO MARCHAL.");
    write(fuente1,320,130,1,"GRAPHICS:");
    write(fuente1,320,160,1,"RAFAEL BARRASO.");
    write(fuente1,320,190,1,"JOSE FERNANDEZ.");
    write(fuente1,320,240,1,"ARTWORK:");
    write(fuente1,320,270,1,"CESAR VALENCIA.");
    write(fuente1,320,320,1,"MUSIC:");
    write(fuente1,320,350,1,"MOISES DIAZ TOLEDANO");

    write(fuente1,320,400,1,"-COPYRIGHT 1997-");

    fade_on();


    scan_code=0;
    WHILE (scan_code==0 AND NOT mouse.left AND NOT mouse.right)
        FRAME;
    END


    save ("dat\soccer\traje0.dat",&colorini1,sizeof(colorini1));
    save ("dat\soccer\traje1.dat",&colorini2,sizeof(colorini2));


    fade_off();
    exit("Thanks for playing!",0);
END









PROCESS bal¢nfantasma(x,y,size,height,graph,file,velocidadpelota,angulopelota)

BEGIN
    resolution=100;
    ctype=2;
    REPEAT


        IF (velocidadpelota>0)
            velocidadpelota-=incrvelocidadpelota;

            x+=get_distx(angulopelota,velocidadpelota);
            y+=get_disty(angulopelota,velocidadpelota);
        END


        IF (velocidadpelota>0)
            IF (graph<>0)
                graph++;IF (graph>6) graph=1; END
            END
        END
        FRAME;
    UNTIL (x<(xicampo-180)*100 OR x>(xfcampo+180)*100 OR
           y<(yicampo-180)*100 OR y>(yfcampo+180)*100 OR
           velocidadpelota<incrvelocidadpelota)
END







PROCESS elige_saque(numerojugador)

PRIVATE
    paratimer;
    canglec,cveloc,cdistc;
    cincrx,cincry;
BEGIN


    ctype=2;
    file=fichero1;
    graph=4;
    flags=4;
    resolution=100;


    paratimer=timer[0];
    signal(idinicio,s_freeze_tree);
    signal(id,s_wakeup);


    WHILE (NOT key(_control) AND NOT key(_alt) AND NOT joy.button1 AND NOT joy.button2)


        IF (key(_right) OR key (_up) OR joy.right OR joy.up)
            elegidosaque++;
            IF (elegidosaque>9) elegidosaque=0; END
            IF (elegidosaque==numerojugador) elegidosaque++; END
            IF (elegidosaque>9) elegidosaque=0; END
            WHILE (key(_right) OR key (_up) OR joy.right OR joy.up) FRAME; END
        END
        IF (key(_left) OR key (_down) OR joy.left OR joy.down)
            elegidosaque--;
            IF (elegidosaque<0) elegidosaque=9; END
            IF (elegidosaque==numerojugador) elegidosaque--; END
            IF (elegidosaque<0) elegidosaque=9; END
            WHILE (key(_left) OR key (_down) OR joy.left OR joy.down) FRAME; END
        END
        x=idjugadores2[elegidosaque].x;
        y=idjugadores2[elegidosaque].y;


        canglec=fget_angle(idcamara.x,idcamara.y,idjugadores2[elegidosaque].x,idjugadores2[elegidosaque].y+(distanciacamara*100));


        cdistc=fget_dist(idcamara.x,idcamara.y,idjugadores2[elegidosaque].x,idjugadores2[elegidosaque].y+(distanciacamara*100));


        cveloc=cdistc/totaltestigo;


        IF (cveloc>vmaxima*6) cveloc=vmaxima*6; END


        cincrx=get_distx(canglec,cveloc);
        cincry=get_disty(canglec,cveloc);


        idcamara.x+=cincrx;
        idcamara.y+=cincry;
        FRAME;
        timer[0]=paratimer;
    END


    signal(idinicio,s_wakeup_tree);
END





PROCESS fuerza_tiro()

PRIVATE
    tiempomaximo;

BEGIN

    WHILE ((key (_control) OR joy.button1) AND tiempomaximo<10)

        idpelota.velocidadpelota=2000;
        tiempomaximo++;
        FRAME;
    END

END


