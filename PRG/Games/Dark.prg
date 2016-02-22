COMPILER_OPTIONS _Extended_conditions;
program dark_razes;
global
    selectteam=-1;
    pasafase=0;
    fase=0;
    idfilefpg[3];
    idfilefnt[3];
    idfilemap[4];
    idsoundbestia[3];
    bancoriquezas[1]=10000,10000;
    STRUCT initfase[3]
        STRUCT equipo[1]
            inimu¤ecosx,inimu¤ecosy;
            tammu¤ecosx,tammu¤ecosy;
            iniriquezax,iniriquezay;
            xiniedificio,yiniedificio;
            STRUCT puntovigia[3];
                x,y;
            END
        END
        flagedificio;
    END=190,260,230,230, 270,385, 126,135,      // Equipo 0
        300,300, 350,150, 800,350, 400,550,

       1030,1250,230,230, 1020,1065, 1396,1361, // Equipo 1
       1200,1300, 1200,1450, 1450,1200, 1100,950,
       0,

       1080,1140,230,200, 1030,850, 1427,1077,
       1200,1000,1200,1200,1000,1000,1150,800,

       240,1330,230,200, 120,850, 175,1277,
       300,1200,300,1400,150,1100,500,1100,

       1,

       200,250,230,230, 700,90, 112,146,
       100,400,400,200,700,450,1000,100,

       800,780,230,230, 1250,470, 1006,645,
       800,800,1300,600,1300,1000,1400,200,

       0,

       930,1290,230,230, 850,480, 1283,1261,
       1300,1100,1050,1300,900,1000,1000,100,

       270,1300,230,230, 100,220, 123,1352,
       300,1450,200,1200,700,1000,400,200,

       1;

    mapasfase[]="dark\mapa1.map","dark\mapa2.map",
                "dark\mapa3.map","dark\mapa4.map";

    numeromu¤ecosgrandes[1];
    numeromu¤ecospeques[1];
    riquezaequipos[1];
    idseleccionado=0;
    enemigosmuertos=0;
    servidoresmuertos=0;
    puntuacionjugador=0;
local
    tipo;
    estado;
    x2,y2;
    x3,y3;
    energia=100;
    fuerza;
    idaatacar;
    riquezarecogida;
    aniestado;
    contador1;
    contador2;
    tiempoconstruir=0;
    cualconstruir=0;
    numerocamino=0;
    contadorcaminos=0;
    tablacaminos[41];
PRIVATE
    gameover=0;
BEGIN
    set_fps(25,2);
    max_process_time=2500;
    set_mode (m640x480);
    LOOP

        idfilefnt[1]=load_fnt("dark\dark00.fnt");
        idfilemap[0]=load_map("dark\credits.map");
        load_pal("dark\credits.map");
        put_screen(0,idfilemap[0]);
        write(idfilefnt[1],320,200,4,"Loading...");
        fade_on();
        WHILE (fading)
            FRAME;
        END
        delete_text(all_text);
        unload_map(idfilemap[0]);
        idfilefpg[0]=load_fpg("dark\animas.fpg");
        idfilefpg[1]=load_fpg("dark\orco1.fpg");
        idfilefpg[2]=load_fpg("dark\diablo1.fpg");
        idfilefnt[0]=load_fnt("dark\dark0.fnt");
        idfilefnt[2]=load_fnt("dark\dark01.fnt");
        idsoundbestia[0]=load_pcm("dark\bestia00.pcm",0);
        idsoundbestia[1]=load_pcm("dark\bestia01.pcm",0);
        idsoundbestia[2]=load_pcm("dark\bestia03.pcm",0);
        idsoundbestia[3]=load_pcm("dark\bestia02.pcm",0);
        fade_off();
        WHILE (fading)
            FRAME;
        END

        idfilemap[0]=load_map("dark\screen.map");
        load_pal("dark\screen.map");
        put_screen(0,idfilemap[0]);
        unload_map(idfilemap[0]);
        mouse.graph=0;
        fade_on();
        WHILE (scan_code==0 AND NOT mouse.left)
            FRAME;
        END
        IF (key(_esc))
            creditos();
            FRAME;
        END
        fade_off();
        clear_screen();
        delete_text(all_text);
        let_me_alone();
        idfilemap[0]=load_map("dark\select.map");
        load_pal("dark\select.map");
        put_screen(0,idfilemap[0]);
        unload_map(idfilemap[0]);
        write(idfilefnt[0],320,40,4,"Select your");
        write(idfilefnt[0],320,100,4,"Razes...");
        ponselectrazes();
        fade_on();
        WHILE (scan_code==0 AND NOT mouse.left)
            FRAME;
        END
        selectteam=-1;
        mouse.graph=43;mouse.x=320;mouse.y=240;
        WHILE (NOT key(_esc) AND selectteam==-1)
            FRAME;
        END
        mouse.graph=0;mouse.x=320;mouse.y=240;
        gameover=0;
        IF (NOT key(_esc))
            fade_off();
            clear_screen();
            delete_text(all_text);
            unload_map(idfilemap[0]);
            let_me_alone();
            iniciajuego();
            fade_on();
            WHILE (NOT key(_esc))
                FRAME;
                IF (pasafase==0)
                    IF (numeromu¤ecosgrandes[0]==0 AND
                        numeromu¤ecospeques[0]==0)
                        IF (selectteam==1)
                            pasafase=1;
                            fase++;IF (fase>3)fase=0; END
                        ELSE
                            gameover=1;
                            BREAK;
                        END
                    END
                    IF (numeromu¤ecosgrandes[1]==0 AND
                        numeromu¤ecospeques[1]==0)
                        IF (selectteam==0)
                            pasafase=1;
                            fase++;IF (fase>3)fase=0; END
                        ELSE
                            gameover=1;
                            BREAK;
                        END
                    END
                    IF (key(_t) AND key(_i) AND key(_z))
                        pasafase=1;
                        fase++;IF (fase>3)fase=0; END
                    END
                END
            END
            fade_off();
            delete_text(all_text);
            let_me_alone();
            stop_scroll(0);
            frame;
            IF (gameover==1)
                mouse.graph=0;mouse.left=0;scan_code=0;
                fade_on();
                idfilemap[3]=load_map("dark\credits.map");
                put_screen(0,idfilemap[3]);
                write(idfilefnt[2],320,40,4,"- Game Over -");
                write(idfilefnt[2],580,100,5,"Units killed:");
                write_int(idfilefnt[2],580,100,3,&servidoresmuertos);
                write(idfilefnt[2],550,160,5,"Enemies killed:");
                write_int(idfilefnt[2],550,160,3,&enemigosmuertos);
                write(idfilefnt[2],320,220,4,"Total score:");
                write_int(idfilefnt[2],320,280,4,&puntuacionjugador);
                load_pal("dark\credits.map");
                WHILE (scan_code==0 AND NOT mouse.left)
                    FRAME;
                END
                fade_off();
                delete_text(all_text);
                unload_map(idfilemap[3]);
                mouse.graph=0;mouse.left=0;scan_code=0;
                frame;
            END
        ELSE
            fade_off();
            clear_screen();
            delete_text(all_text);
            unload_map(idfilemap[0]);
            unload_map(idfilemap[1]);
            unload_map(idfilemap[4]);
            unload_pcm(idsoundbestia[0]);
            unload_pcm(idsoundbestia[1]);
            unload_pcm(idsoundbestia[2]);
            unload_pcm(idsoundbestia[3]);
            let_me_alone();
            frame;
        END
    END
END
PROCESS creditos()
BEGIN

    fade_off();
    scan_code=0;mouse.left=0;
    clear_screen();
    delete_text(all_text);
    let_me_alone();
    unload_fnt(idfilefnt[0]);
    idfilemap[0]=load_map("dark\credits.map");
    load_pal("dark\credits.map");
    put_screen(0,idfilemap[0]);
    unload_map(idfilemap[0]);
    write(idfilefnt[2],320,40,4,"Programming:");
    write(idfilefnt[2],320,100,4,"Antonio Marchal.");

    write(idfilefnt[2],320,180,4,"Graphics:");
    write(idfilefnt[2],320,240,4,"Rafael Barraso.");

    write(idfilefnt[2],320,320,4,"Suport:");
    write(idfilefnt[2],320,380,4,"Daniel Navarro.");


    fade_on();
    WHILE (scan_code==0 AND NOT mouse.left)
        FRAME;
    END
    fade_off();
    exit("",0);

END

PROCESS ponselectrazes()
BEGIN
    ponobjetoselect(160,250,79,0);
    ponobjetoselect(120,350,1,0);
    ponobjetoselect(200,350,14,0);
    ponobjetoselect(480,250,80,1);
    ponobjetoselect(440,350,22,1);
    ponobjetoselect(520,350,31,1);
END
PROCESS ponobjetoselect(x,y,graph,tipo)
BEGIN
    LOOP
        IF (collision (TYPE mouse))
            IF (mouse.left)
                selectteam=tipo;
            END
        END
        FRAME;
    END
END

PROCESS iniciajuego()
PRIVATE
    ultimafase;
BEGIN
    LOOP
        pasafase=0;
        IF (idseleccionado<>0)
            idseleccionado.estado=0;
            idseleccionado=0;
        END
        clear_screen();
        idfilemap[0]=load_map(mapasfase[fase]);
        load_pal(mapasfase[fase]);
        define_region(1,0,0,500,480);
        start_scroll(0,0,idfilemap[0],0,1,0);
        scroll.x0=initfase[fase].equipo[selectteam].xiniedificio;
        scroll.y0=initfase[fase].equipo[selectteam].yiniedificio;

        ponnegro(); // ??? se pone el negro encima....

        SWITCH (fase)
            CASE 0:
                IF (selectteam)

                  mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                         initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],0);
                  mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                         initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],0);

                  mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                         initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],180000);
                  mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                         initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],180000);

                  mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                         initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],180000);
                  mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                         initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],180000);
                  riquezaequipos[0]=2500;
                  riquezaequipos[1]=5000;

                ELSE
                  mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                         initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],0);
                  mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                         initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],0);
                  mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                         initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],0);
                  mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                         initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],0);

                  mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                         initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],180000);
                  mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                         initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],180000);
                  riquezaequipos[0]=5000;
                  riquezaequipos[1]=2500;
                END
            END
            CASE 1:
                mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                       initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);
                mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                       initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);

                mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                       initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],180000);

                mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                       initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                       initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                       initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],0);

                IF (selectteam)
                    riquezaequipos[0]=2000;
                    riquezaequipos[1]=4000;

                ELSE
                    riquezaequipos[0]=4000;
                    riquezaequipos[1]=2000;
                END
            END

            CASE 2:
                mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                       initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],0);
                mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                       initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],0);
                mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                       initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],0);
                mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                       initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],0);

                mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                       initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],180000);
                mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                       initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],180000);
                mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                       initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],180000);
                mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                       initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],180000);

                IF (selectteam)
                    riquezaequipos[0]=4500;
                    riquezaequipos[1]=2000;
                ELSE
                    riquezaequipos[0]=2000;
                    riquezaequipos[1]=4500;
                END
            END
            CASE 3:
                IF (selectteam)
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);

                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],180000);
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],180000);
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],180000);
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);

                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],180000);

                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],0);

                    riquezaequipos[0]=4000;
                    riquezaequipos[1]=2000;

                ELSE
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),0,idfilefpg[1],180000);

                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],180000);
                    mu¤eco(initfase[fase].equipo[0].inimu¤ecosx+(rand(0,initfase[fase].equipo[0].tammu¤ecosx)),
                           initfase[fase].equipo[0].inimu¤ecosy+(rand(0,initfase[fase].equipo[0].tammu¤ecosy)),1,idfilefpg[1],180000);

                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),2,idfilefpg[2],0);
                    mu¤eco(initfase[fase].equipo[1].inimu¤ecosx+(rand(0,initfase[fase].equipo[1].tammu¤ecosx)),
                           initfase[fase].equipo[1].inimu¤ecosy+(rand(0,initfase[fase].equipo[1].tammu¤ecosy)),3,idfilefpg[2],0);
                    riquezaequipos[0]=2000;
                    riquezaequipos[1]=4000;
                END
            END

        END
        enemigosmuertos=0;
        servidoresmuertos=0;
        IF (fase==0) puntuacionjugador=0; END
        crea_riqueza();
        crea_casas();
        ponmarcador();
        ponmousejuego();
        fade_on();
        WHILE (fase==ultimafase)
            ultimafase=fase;
            puntuacionjugador++;
            FRAME;
        END
        fade_off();
        stop_scroll(0);
        unload_map(idfilemap[0]);
        ultimafase=fase;
        signal(TYPE ponmarcador,s_kill_tree);
        signal(TYPE ponmousejuego,s_kill_tree);
        signal(TYPE ponnegro,s_kill_tree);
        numeromu¤ecosgrandes[0]=0;
        numeromu¤ecospeques[0]=0;
        numeromu¤ecosgrandes[1]=0;
        numeromu¤ecospeques[1]=0;
        If (idseleccionado<>0)
            idseleccionado.estado=0;
            idseleccionado=0;
        END
        scan_code=0; mouse.left=0;
        IF (fase==0) fase=4; END
        idfilemap[0]=load_map("dark\credits.map");
        load_pal("dark\credits.map");
        put_screen(0,idfilemap[0]);
        write(idfilefnt[1],520,40,5,"Final Level:");
        write_int(idfilefnt[1],520,40,3,&fase);

        write(idfilefnt[2],580,100,5,"Units killed:");
        write_int(idfilefnt[2],580,100,3,&servidoresmuertos);

        write(idfilefnt[2],550,160,5,"Enemies killed:");
        write_int(idfilefnt[2],550,160,3,&enemigosmuertos);

        write(idfilefnt[2],320,220,4,"Total score:");
        write_int(idfilefnt[2],320,280,4,&puntuacionjugador);

        write(idfilefnt[2],320,440,4,"Press space bar...");
        fade_on();
        WHILE (scan_code<>_space)
            frame;
        END
        fade_off();
        unload_map(idfilemap[0]);
        unload_map(idfilemap[1]);
        unload_map(idfilemap[4]);
        delete_text(all_text);
        IF (fase==4) fase=0; END
    END
END
PROCESS ponmousejuego()
PRIVATE
    idtocado;
BEGIN
    priority=2;
    mouse.graph=43;
    mouse.file=idfilefpg[0];
    graph=78;
    LOOP
        IF (mouse.x>635)
            scroll.x0+=8;
        END
        IF (mouse.x<5)
            scroll.x0-=8;
        END
        IF (mouse.y>475)
            scroll.y0+=8;
        END
        IF (mouse.y<5)
            scroll.y0-=8;
        END
        IF (mouse.x>=522 AND mouse.x<622 AND
            mouse.y>=32  AND mouse.y<132)
            IF (mouse.left)
                scroll.x0=(((mouse.x-522)*1536)/100);
                scroll.y0=(((mouse.y-32)*1536)/100);
            END
        END
        x=mouse.x;y=mouse.y;
        IF (mouse.x<500)
          IF (idtocado=collision (TYPE mu¤eco))
              mouse.graph=75;
              IF (mouse.left)
                  IF (idtocado.tipo/2==selectteam)
                      IF (idseleccionado==0)
                          idtocado.estado=1;
                          idseleccionado=idtocado;
                          idtocado.numerocamino=0;
                          sound(idsoundbestia[idtocado.tipo],32,256);
                      ELSE
                          idseleccionado.estado=0;
                          idseleccionado=0;
                          idtocado.estado=1;
                          idseleccionado=idtocado;
                          sound(idsoundbestia[idtocado.tipo],32,256);
                      END
                  ELSE
                      IF (idseleccionado<>0)
                          IF (idseleccionado.file<>idfilefpg[0])
                              idseleccionado.estado=3;
                              idseleccionado.idaatacar=idtocado;
                              idseleccionado.x2=idtocado.x;
                              idseleccionado.y2=idtocado.y;
                              idseleccionado=0;
                          END
                      END
                  END
              END
          ELSE
              IF (idtocado=collision (TYPE poncasa))
                  mouse.graph=76;
                  IF (mouse.left)
                      IF (idtocado.tipo/2==selectteam)
                          IF (idseleccionado==0)
                              idtocado.estado=1;
                              idseleccionado=idtocado;
                          ELSE
                              idseleccionado.estado=0;
                              idseleccionado=0;
                              idtocado.estado=1;
                              idseleccionado=idtocado;
                          END
                      END
                  END
              ELSE
                  IF ((mouse.x+scroll.x0>initfase[fase].equipo[0].iniriquezax AND
                      mouse.x+scroll.x0<initfase[fase].equipo[0].iniriquezax+200 AND
                      mouse.y+scroll.y0>initfase[fase].equipo[0].iniriquezay AND
                      mouse.y+scroll.y0<initfase[fase].equipo[0].iniriquezay+200 )OR
                     (mouse.x+scroll.x0>initfase[fase].equipo[1].iniriquezax AND
                      mouse.x+scroll.x0<initfase[fase].equipo[1].iniriquezax+200 AND
                      mouse.y+scroll.y0>initfase[fase].equipo[1].iniriquezay AND
                      mouse.y+scroll.y0<initfase[fase].equipo[1].iniriquezay+200 ))
                      mouse.graph=74;
                      IF (mouse.left)
                          IF (idseleccionado<>0)
                              IF (idseleccionado.tipo mod 2==1)
                                  sound(idsoundbestia[idseleccionado.tipo],16,512);
                                  idseleccionado.estado=5;
                                  idseleccionado.x2=mouse.x+scroll.x0;
                                  idseleccionado.y2=mouse.y+scroll.y0;
                                  idseleccionado=0;
                              END
                          END
                      END
                  ELSE
                      IF (map_get_pixel(idfilefpg[0],(fase*3)+105,(mouse.x+scroll.x0)/4,(mouse.y+scroll.y0)/4)==100 OR
                          map_get_pixel(idfilefpg[0],(fase*3)+105,(mouse.x+scroll.x0)/4,(mouse.y+scroll.y0)/4)==101)
                          mouse.graph=76;
                          IF (idseleccionado<>0)
                              IF (map_get_pixel(idfilefpg[0],(fase*3)+105,(mouse.x+scroll.x0)/4,(mouse.y+scroll.y0)/4)==100+(idseleccionado.tipo/2))
                                  IF (mouse.left)
                                      IF (idseleccionado.file<>idfilefpg[0])
                                          sound(idsoundbestia[idseleccionado.tipo],16,512);
                                          idseleccionado.estado=9;
                                          idseleccionado.x2=mouse.x+scroll.x0;
                                          idseleccionado.y2=mouse.y+scroll.y0;
                                          idseleccionado=0;
                                      END
                                  END
                              END
                          END
                      ELSE
                          IF (mouse.x<500)
                              IF (mouse.left) // Queda detectar si puede ir ???
                                  IF (idseleccionado<>0)
                                      IF (idseleccionado.file<>idfilefpg[0])
                                          sound(idsoundbestia[idseleccionado.tipo],16,512);
                                          idseleccionado.estado=2;
                                          idseleccionado.x2=mouse.x+scroll.x0;
                                          idseleccionado.y2=mouse.y+scroll.y0;
                                          ponmarcadestino(mouse.x+scroll.x0,mouse.y+scroll.y0);
                                          idseleccionado=0;
                                      END
                                  END
                              END
                          END
                          mouse.graph=43;
                          idtocado=0;
                      END
                  END
              END
          END
        END

        IF (mouse.right)
            IF (idseleccionado<>0)
                idseleccionado.estado=0;
                idseleccionado=0;
            END
        END
        FRAME;
    END
END
PROCESS ponmarcadestino(x,y)
BEGIN
    ctype=c_scroll;
    FROM graph= 51 TO 54;
        FRAME(200);
    END
END

PROCESS cogiendoenergia(x,y)
BEGIN
    file=idfilefpg[0];
    graph=rand(63,67);
    z=father.z-2;
    ctype=c_scroll;
    FRAME;
END


PROCESS mu¤eco(x,y,tipo,file,angle)
PRIVATE
    idotro;

    animadiablogrande[]=8,49,41,33,25,17,09,01,57,
                      8,50,42,34,26,18,10,02,58,
                      8,51,43,35,27,19,11,03,59,
                      8,52,44,36,28,10,12,04,60,
                      8,53,45,37,29,21,13,05,61,
                      8,54,46,38,30,22,14,06,62,
                      8,55,47,39,31,23,15,07,63,
                      8,56,48,40,32,24,16,08,64;

    animadiablograndeataca[]=8,83,80,77,74,71,68,65,86,
                           8,84,81,78,75,72,69,66,87,
                           8,85,82,79,76,73,70,67,88;


    animadiablopeque[]=8,142,134,126,118,110,102, 94,150,
                     8,143,135,127,119,111,103, 95,151,
                     8,144,136,128,120,112,104, 96,152,
                     8,145,137,129,121,113,105, 97,153,
                     8,146,138,130,122,114,106, 98,154,
                     8,147,139,131,123,115,107, 99,155,
                     8,148,140,132,124,116,108,100,156,
                     8,149,141,133,125,117,109,101,157;

    animadiablograndemuere[]=5,89,90,91,92,93;

    animadiablopequeataca[]=8,176,173,170,167,164,161,158,179,
                          8,177,174,171,168,165,162,159,180,
                          8,178,175,172,169,166,163,160,181;

    animadiablopequemuere[]=5,182,183,184,185,186;


    animaorcogrande[]=8,49,41,33,25,17,09,01,57,
                        8,50,42,34,26,18,10,02,58,
                        8,51,43,35,27,19,11,03,59,
                        8,52,44,36,28,10,12,04,60,
                        8,53,45,37,29,21,13,05,61,
                        8,54,46,38,30,22,14,06,62,
                        8,55,47,39,31,23,15,07,63,
                        8,56,48,40,32,24,16,08,63;

    animaorcograndeataca[]=8,82,79,76,73,70,67,64,85,
                             8,83,80,77,74,71,68,65,86,
                             8,84,81,78,75,72,69,66,87;


    animaorcograndemuere[]=5,88,89,90,91,92;

    animaorcopeque[]=8,141,133,125,117,109,101, 93,149,
                       8,142,134,126,118,110,102, 94,150,
                       8,143,135,127,119,111,103, 95,151,
                       8,144,136,128,120,112,104, 96,152,
                       8,145,137,129,121,113,105, 97,153,
                       8,146,138,130,122,114,106, 98,154,
                       8,147,139,131,123,115,107, 99,155,
                       8,148,140,132,124,116,108,100,156;

    animaorcopequeataca[]=8,175,172,169,166,163,160,157,178,
                            8,176,173,170,167,164,161,158,179,
                            8,177,174,171,168,165,162,159,180;

    animaorcopequemuere[]=5,181,182,183,184,185;
    ultimoestado;
    ultimox2,ultimoy2;

BEGIN
    ctype=c_scroll;
    aniestado=rand(0,7);
    SWITCH (tipo)
        CASE 0:
            xgraph=offset animadiablogrande[aniestado*9];
            numeromu¤ecosgrandes[0]++;
            fuerza=4;
        END
        CASE 1:
            xgraph=offset animadiablopeque[aniestado*9];
            numeromu¤ecospeques[0]++;
            fuerza=2;
        END
        CASE 2:
            xgraph=offset animaorcogrande[aniestado*9];
            numeromu¤ecosgrandes[1]++;
            fuerza=4;
        END
        CASE 3:
            xgraph=offset animaorcopeque[aniestado*9];
            numeromu¤ecospeques[1]++;
            fuerza=2;
        END
    END
    IF (collision (TYPE mu¤eco))
        WHILE (collision (TYPE mu¤eco))
            x+=((rand(0,2)-1)*20);
            y+=((rand(0,2)-1)*20);
            FRAME;
        END
    END
    IF (tipo/2<>selectteam)
        IF (tipo MOD 2==1)
            estado=5;
            aniestado=rand(0,7);
            x2=initfase[fase].equipo[tipo/2].iniriquezax+rand(0,200);
            y2=initfase[fase].equipo[tipo/2].iniriquezay+rand(0,200);
        ELSE
            IF (numeromu¤ecosgrandes[tipo/2]<5)
                estado=13;
                aniestado=rand(0,7);
                x2=initfase[fase].equipo[tipo/2].puntovigia[numeromu¤ecosgrandes[tipo/2]-1].x;
                y2=initfase[fase].equipo[tipo/2].puntovigia[numeromu¤ecosgrandes[tipo/2]-1].y;
            ELSE
                // ??????? Ataque........
                IF (idaatacar=cogeidenemigo(id))
                    estado=3;
                    x2=idaatacar.x;
                    y2=idaatacar.y;
                    ultimoestado=3; // Ataca hasta la muerte ?????
                ELSE
                    estado=13;
                END
            END
        END
        energia-=((4-fase)*5);
    ELSE
        quitanegro(x,y); // ??? se quita el negro encima....
    END
    LOOP
        z=-(y/4);
        SWITCH (estado)
            CASE 0:         // Quieto
                aniestado=0;
            END
            CASE 1:         // Seleccionado
                aniestado=(aniestado+1) MOD 4;
                IF (aniestado<2)
                    poncursormarcador(x,y,0);
                END
            END
            CASE 2:         // ir a....
                IF (abs (x2-x)>2 OR abs (y2-y)>2)

                    superavance(4);
                    aniestado=(aniestado+1) MOD 7;
                ELSE
                    estado=0;
                    aniestado=0;
                END
            END
            CASE 3:         // ir a atacar
                IF (fget_dist(x2,y2,x,y)>24 AND get_dist(idaatacar)>24)
                    x2=idaatacar.x;
                    y2=idaatacar.y;
                    superavance(4);
                    aniestado=(aniestado+1) MOD 7;
                ELSE
                    estado++;
                    aniestado=rand(0,2);
                    x2=x;
                    y2=y;
                    numerocamino=0;
                END
            END
            CASE 4:         // atacar
                IF (idaatacar.energia>0)
                    IF (get_dist(idaatacar)<32)
                        idaatacar.energia-=fuerza;
                        angle=fget_angle(x,y,x2,y2);
                        aniestado=(aniestado+1) MOD 3;
                    ELSE
                        x2=idaatacar.x; // Ataca hasta la muerte ????
                        y2=idaatacar.y;
                        estado=3;
                    END
                ELSE
                    idaatacar=0;
                    estado=0;
                    IF (tipo/2<>selectteam) // Si hay mucho malos ataca
                        IF (numeromu¤ecosgrandes[tipo/2]>4)
                            IF (ultimoestado==3)
                                // ??????? Ataque........
                                IF (idaatacar=cogeidenemigo(id))
                                    estado=3;
                                    x2=idaatacar.x;
                                    y2=idaatacar.y;
                                    // Ataca hasta la muerte
                                    ultimoestado=3;
                                ELSE
                                    ultimoestado=14;
                                    ultimox2=x2;
                                    ultimoy2=y2;
                                END
                            END
                        END
                    END

                    IF (ultimoestado<>0)  // Comprueba ultimo estado
                        IF (ultimoestado==14) // Cambiar a modo vigia ????
                            x2=ultimox2;
                            y2=ultimoy2;
                            estado=13;
                        END
                    END
                END
            END
            CASE 5,7,9,13:
                    superavance(4);
                    aniestado=(aniestado+1) MOD 7;
                IF (x==x2 AND y==y2)
                    estado++;
                    aniestado=rand(0,2);
                END

            END
            CASE 6:
                aniestado=(aniestado+1) MOD 3;
                IF (riquezarecogida>100)
                    estado=7;
                    aniestado=rand(0,7);
                    x2=initfase[fase].equipo[tipo/2].xiniedificio;
                    y2=initfase[fase].equipo[tipo/2].yiniedificio;
                ELSE
                    bancoriquezas[tipo/2]--; // Esto puede causar error ????
                    riquezarecogida++;
                END
            END
            CASE 8:
                aniestado=(aniestado+1) MOD 3;
                IF (riquezarecogida==0)
                    estado=5;
                    aniestado=rand(0,7);
                    // Aqui puede que vuelva donde no debe ?????
                    x2=initfase[fase].equipo[tipo/2].iniriquezax+rand(0,200);
                    y2=initfase[fase].equipo[tipo/2].iniriquezay+rand(0,200);
                ELSE
                    riquezarecogida--;
                    riquezaequipos[tipo/2]++;
                END
            END
            CASE 10:
                IF (riquezaequipos[tipo/2]>500)
                    IF (energia<100)
                        energia++;
                        riquezaequipos[tipo/2]-=10;
                        cogiendoenergia(x,y);
                    ELSE
                        IF (fuerza<100)
                            fuerza++;
                            riquezaequipos[tipo/2]-=20;
                            cogiendoenergia(x,y);
                        END
                    END
                END
            END
            CASE 14:
                aniestado=0;
                WHILE (idotro=get_id(TYPE mu¤eco))
                    IF (idotro.tipo/2<>tipo/2)
                        IF (get_dist(idotro)<200)
                            ultimoestado=14;
                            ultimox2=x2;
                            ultimoy2=y2;
                            estado=3:
                            idaatacar=idotro;
                            x2=idotro.x;
                            y2=idotro.y;
                        END
                    END
                END
            END
        END

        SWITCH (estado)
            CASE 0,2,3,5,7,9,11,13,14:
                SWITCH (tipo)
                    CASE 0:
                        xgraph=offset animadiablogrande[aniestado*9];
                    END
                    CASE 1:
                        xgraph=offset animadiablopeque[aniestado*9];
                    END
                    CASE 2:
                        xgraph=offset animaorcogrande[aniestado*9];
                    END
                    CASE 3:
                        xgraph=offset animaorcopeque[aniestado*9];
                    END
                END
           END
           CASE 4,6,8,12:
                SWITCH (tipo)
                    CASE 0:
                        xgraph=offset animadiablograndeataca[aniestado*9];
                    END
                    CASE 1:
                        xgraph=offset animadiablopequeataca[aniestado*9];
                    END
                    CASE 2:
                        xgraph=offset animaorcograndeataca[aniestado*9];
                    END
                    CASE 3:
                        xgraph=offset animaorcopequeataca[aniestado*9];
                    END
                END

           END

        END
        IF (energia<1) BREAK; END

        FRAME;
    END
    angle=0;
    SWITCH (tipo)
        CASE 0:
            xgraph=offset animadiablograndemuere;
        END
        CASE 1:
            xgraph=offset animadiablopequemuere;
        END
        CASE 2:
            xgraph=offset animaorcograndemuere;
        END
        CASE 3:
            xgraph=offset animaorcopequemuere;
        END
    END
    angle=0;
    WHILE (angle<320000)
        angle+=5000;
        FRAME;
    END
    SWITCH (tipo)
        CASE 0:
            numeromu¤ecosgrandes[0]--;
        END
        CASE 1:
            numeromu¤ecospeques[0]--;
        END
        CASE 2:
            numeromu¤ecosgrandes[1]--;
        END
        CASE 3:
            numeromu¤ecospeques[1]--;
        END
    END
    IF (tipo/2==selectteam)
        servidoresmuertos++;
    ELSE
        puntuacionjugador+=500;
        enemigosmuertos++;
    END
END
PROCESS crea_riqueza()
BEGIN
    ctype=c_scroll;
    FOR (contador1=1;contador1<(bancoriquezas[0]/1000)+1;++contador1)
        pintariqueza(initfase[fase].equipo[0].iniriquezax+10+(rand(0,9)*20),
                     initfase[fase].equipo[0].iniriquezay+10+(rand(0,9)*20),
                     contador1*1000,0,rand(1,3));
    END
    FOR (contador1=1;contador1<(bancoriquezas[1]/1000)+1;++contador1)
        pintariqueza(initfase[fase].equipo[1].iniriquezax+10+(rand(0,9)*20),
                     initfase[fase].equipo[1].iniriquezay+10+(rand(0,9)*20),
                     contador1*1000,1,rand(1,3));
    END

    LOOP
        FRAME:
    END
END
PROCESS pintariqueza(x,y,valor,banco,pasoinicial)
PRIVATE
    dir_anima;
    pausa_anima=0;
BEGIN
    z=-(y/8);
    ctype=c_scroll;
    graph=pasoinicial+37;
    IF (rand(0,1)==0) dir_anima=1; ELSE dir_anima=-1; END
    IF (collision (TYPE pintariqueza))
        WHILE (collision (TYPE pintariqueza))
            x+=((rand(0,2)-1)*20);
            y+=((rand(0,2)-1)*20);
            FRAME;
        END
    END
    pausa_anima=rand(0,39);
    WHILE (bancoriquezas[banco]=>valor)
        pausa_anima++;
        IF (pausa_anima>40)
            pausa_anima=0;
            graph+=dir_anima;
            IF (graph==37 OR graph==41)
                IF (dir_anima==1) dir_anima=-1; ELSE dir_anima=1; END
            END
        END
        FRAME;
    END
END
PROCESS crea_casas()
BEGIN
    ctype=c_scroll;
    poncasa(initfase[fase].equipo[0].xiniedificio,
            initfase[fase].equipo[0].yiniedificio,
            55,initfase[fase].flagedificio,0);
    poncasa(initfase[fase].equipo[1].xiniedificio,
            initfase[fase].equipo[1].yiniedificio,
            62,initfase[fase].flagedificio,2);
    LOOP
        FRAME;
    END
END
PROCESS poncasa(x,y,graph,flags,tipo);

BEGIN
    ctype=c_scroll;
    IF (tipo/2<>selectteam)
        z=-(y/2);
    ELSE
        z=-1257;
    END
    estado=0;
    LOOP
        SWITCH (estado)
            CASE 0:
                IF (cualconstruir==0)
                    IF (tipo/2<>selectteam)
                        IF (riquezaequipos[tipo/2]>2000)
                            estado=3;
                            aniestado=0;

                        ELSE
                            IF (riquezaequipos[tipo/2]>1000 AND
                                numeromu¤ecospeques[tipo/2]<5)
                                estado=2;
                                aniestado=0;
                            END
                        END
                    END
                END
            END
            CASE 1:
                aniestado=(aniestado+1) MOD 4;
                IF (aniestado<2)
                    poncursormarcador(x,y,1);
                END
            END

            CASE 2:
                tiempoconstruir=0;
                cualconstruir=2;
                estado=0;
            END
            CASE 3:
                tiempoconstruir=0;
                cualconstruir=3;
                estado=0;
            END
        END
        IF (cualconstruir<>0)
            tiempoconstruir++;
            SWITCH (cualconstruir)
                CASE 2:
                    IF (tiempoconstruir>99)
                        mu¤eco(initfase[fase].equipo[tipo/2].inimu¤ecosx+(rand(0,initfase[fase].equipo[tipo/2].tammu¤ecosx)),
                               initfase[fase].equipo[tipo/2].inimu¤ecosy+(rand(0,initfase[fase].equipo[tipo/2].tammu¤ecosy)),
                               ((tipo/2)*2)+1,idfilefpg[(tipo/2)+1],0);
                        cualconstruir=0;
                        tiempoconstruir=0;
                    ELSE
                        riquezaequipos[tipo/2]-=10;
                    END
                END
                CASE 3:
                    IF (tiempoconstruir>199)
                        mu¤eco(initfase[fase].equipo[tipo/2].inimu¤ecosx+(rand(0,initfase[fase].equipo[tipo/2].tammu¤ecosx)),
                               initfase[fase].equipo[tipo/2].inimu¤ecosy+(rand(0,initfase[fase].equipo[tipo/2].tammu¤ecosy)),
                               ((tipo/2)*2),idfilefpg[(tipo/2)+1],0);
                        cualconstruir=0;
                        tiempoconstruir=0;
                    ELSE
                        riquezaequipos[tipo/2]-=10;
                    END
                END

            END
        END
        FRAME;
    END
END
PROCESS ponmarcador()
BEGIN
    z=-10;
    x=570;y=240;
    graph=42;
    ponminimapa(570,82,44+fase);
    LOOP
        IF (idseleccionado<>0)
            ponseleccionado(570,200);
        END
        FRAME;
    END
END
PROCESS ponminimapa(x,y,graph)
BEGIN
    z=-20;
    LOOP
        FRAME;
    END
END
PROCESS poncursormarcador(x,y,tipo)
BEGIN
    ctype=c_scroll;
    file=idfilefpg[0];
    z=idseleccionado.z-1;
    IF (tipo==0) graph=50; ELSE graph=101; END
    FRAME;
END

PROCESS ponseleccionado(x,y)

BEGIN
    z=father.z-1;
    SWITCH(idseleccionado.file)
        CASE idfilefpg[0]:
            graph=idseleccionado.graph;
            size=50;
            ponicono(x-30,y+70,59,idfilefpg[0],0);
            ponbarra(x+10,y+70,5,riquezaequipos[idseleccionado.tipo/2],25000,57,idfilefpg[0]);
            IF (idseleccionado.cualconstruir==0)
                IF (riquezaequipos[idseleccionado.tipo/2]>2000)
                    poniconokeko(x,y+230,((idseleccionado.tipo/2)*18)+1,idfilefpg[0],2);
                    IF (idseleccionado<>0)
                        IF (riquezaequipos[idseleccionado.tipo/2]>1000)
                            poniconokeko(x,y+120,((idseleccionado.tipo/2)*18)+10,idfilefpg[0],1);
                        END
                    END
                ELSE
                    IF (riquezaequipos[idseleccionado.tipo/2]>1000)
                        poniconokeko(x,y+120,((idseleccionado.tipo/2)*18)+10,idfilefpg[0],1);
                    END
                END
            ELSE
            ponicono(x,y+120,((idseleccionado.tipo/2)*18)+((1-(idseleccionado.cualconstruir-2))*9)+(idseleccionado.tiempoconstruir MOD 8)+1,idfilefpg[0],0);
            ponbarra(x,y+120,5,idseleccionado.tiempoconstruir,(idseleccionado.cualconstruir-1)*100,57,idfilefpg[0]);
            END
        END
        CASE idfilefpg[1],idfilefpg[2]:
            IF (idseleccionado.tipo)
                IF (idseleccionado.riquezarecogida>0)
                    poniconoaccion(x,y+140,77,file,0);
                END
            ELSE
                poniconoaccion(x,y+140,81,file,1);
            END
            IF (idseleccionado<>0)
                graph=(idseleccionado.tipo*9)+1;
                size=75;x-=30;
                ponicono(x,y+50,59,idfilefpg[0],0);
                ponbarra(x+35,y+50,5,idseleccionado.riquezarecogida,100,57,idfilefpg[0]);

                ponicono(x,y+70,60,idfilefpg[0],0);
                ponbarra(x+35,y+70,6,idseleccionado.energia,100,58,idfilefpg[0]);

                ponicono(x,y+90,61,idfilefpg[0],0);
                ponbarra(x+35,y+90,7,idseleccionado.fuerza,100,58,idfilefpg[0]);
                CLONE
                    size=100;
                    x+=60;
                    file=idseleccionado.file;
                    graph=idseleccionado.graph;
                END
            END
        END
    END
    FRAME;
END

PROCESS poniconoaccion(x,y,graph,file,tipo)
BEGIN
    z=father.z-1;
    IF (collision (TYPE mouse))
        IF (mouse.left)
            IF (tipo)
                idseleccionado.estado=13;
                idseleccionado.x2=idseleccionado.x;
                idseleccionado.y2=idseleccionado.y;
                idseleccionado=0;
            ELSE
                idseleccionado.x2=initfase[fase].equipo[idseleccionado.tipo/2].xiniedificio;
                idseleccionado.y2=initfase[fase].equipo[idseleccionado.tipo/2].yiniedificio;
                idseleccionado.estado=7;
                idseleccionado=0;
            END
        END
    END
    FRAME;
END

PROCESS ponicono(x,y,graph,file,flags)
BEGIN
    z=father.z-1;
    FRAME;
END
PROCESS ponbarra(x,y,tipo,valor,totalescala,graph,file)
BEGIN
    z=father.z-1;
    ponicono(x,y,56,idfilefpg[0],4);
    IF ((50*valor)/totalescala>0)
        define_region(tipo,x-25,y-5,(50*valor)/totalescala,10);
        region=tipo;
    ELSE
        graph=0;
    END
    FRAME;
END

PROCESS poniconokeko(x,y,graph,file,tipo)
BEGIN
    z=father.z-1;
    IF (collision (TYPE mouse))
        IF (mouse.left)
            idseleccionado.estado=tipo+1;
            idseleccionado=0;
        END
    END
    FRAME;
END
PROCESS ponnegro()

BEGIN
    idfilemap[1]=load_map("dark\negro.map");
    idfilemap[4]=load_map("dark\negromin.map");
    ctype=c_scroll;
    x=768;
    y=768;
    graph=idfilemap[1];
    z=-1256;
    CLONE   // Se clona para el peque¤ito
        ctype=c_screen;
        x=570;
        y=82;
        graph=idfilemap[4];
        z=-25;
    END
    LOOP
        FRAME;
    END
END
PROCESS quitanegro(x,y)

BEGIN
    IF (map_get_pixel(0,idfilemap[1],x,y)<>0)
        FOR (contador1=x-75;contador1<x+75;contador1++)
            FOR (contador2=y-75;contador2<y+75;contador2++)
                IF (fget_dist(x,y,contador1,contador2)<80)
                    map_put_pixel(0,idfilemap[1],contador1,contador2,0);
                END
            END
        END
        FOR (contador1=-5;contador1<5;contador1++)
            FOR (contador2=-5;contador2<5;contador2++)
                IF (fget_dist(0,0,contador1,contador2)<6)
                    map_put_pixel(0,idfilemap[4],(x*100/1536)+contador1,(y*100/1536)+contador2,0);
                END
            END
        END

    END
END

PROCESS superavance(distancia)
BEGIN


    IF ((father.tipo/2)==selectteam)   // ??? se quita el negro encima....
        quitanegro(father.x,father.y);
    END
      x=father.x;
      y=father.y;

      IF (father.x<>father.x2 AND father.y<>father.x2 AND father.numerocamino==0)
        IF (path_free(idfilefpg[0],200+fase,12,father.x2,father.y2))
            father.numerocamino=path_find(1,idfilefpg[0],200+fase,12,father.x2,father.y2,offset(father.tablacaminos),42);
            father.contadorcaminos=0;
          END
        END
        IF (father.numerocamino>0)
          IF (fget_dist(father.x,father.y,father.tablacaminos[contadorcaminos*2],father.tablacaminos[(contadorcaminos*2)+1])=>8)
              father.angle=fget_angle(father.x,father.y,father.tablacaminos[contadorcaminos*2],father.tablacaminos[(contadorcaminos*2)+1]);
              father.x+=get_distx(father.angle,distancia);
              father.y+=get_disty(father.angle,distancia);
          ELSE
            father.x=father.tablacaminos[contadorcaminos*2];
            father.y=father.tablacaminos[(contadorcaminos*2)+1];
            ++(father.contadorcaminos);--(father.numerocamino);
          END
        ELSE
            father.x2=father.x;
            father.y2=father.y;
        END
    FRAME;
END
PROCESS cogeidenemigo(cualmu¤eco)

PRIVATE
    idotro;
BEGIN
    WHILE (idotro=get_id(type mu¤eco))
        IF (cualmu¤eco.tipo/2<>idotro.tipo/2)
            return(idotro);
        END
    END
    return(0);
END
