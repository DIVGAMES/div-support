
//------------------------------------------------------------------------------
// TITULO:      FOSTIATOR
// AUTOR:       DANIEL NAVARRO
// FECHA:       15/06/97
//------------------------------------------------------------------------------
PROGRAM fostiator;

CONST
    // Distintos estados de los mu¤ecos
    _parado=0;
    _avanzando=1;
    _retrocediendo=2;
    _agach ndose=3;
    _agachado=4;
    _levant ndose=5;
    _saltando=6;
    _golpe_bajo=7;
    _pu¤etazo=8;
    _patada_giratoria=9;
    _patada_normal=10;
    _patada_a‚rea=11;
    _tocado=12;
    _muerto=13;

    // Distintas posiciones de los mu¤ecos
    saltar=0;
    agacharse=1;
    avanzar=2;
    retroceder=3;
    golpear=4;

    // Tipo de control del mu¤eco
    control_teclado1=1;
    control_teclado2=2;
    control_ordenador=0;

    default_fps=24; // Numero de im genes por segundo

GLOBAL
    // Secuencia de animacin de cada uno de los estados de los mu¤ecos
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

    s_golpe1;        // Identificadores de sonidos
    s_golpe2;
    s_golpe3;
    s_tocado1;
    s_tocado2;
    s_tocado3;
    s_aire1;
    s_aire2;
    s_aire3;
    s_aire4;
    s_aire5;
    s_muerto;

    id_luchador1,id_luchador2;  // Identificador de ambos combatientes
    id_auxiliar;                // Identificador auxiliar

    combates1;      // Numero de combates que ha ganado el primero
    combates2;      // Numero de combates que ha ganado el segundo

    estado_juego;   // 0-parado, 1-jugando, 2-fin combate

    escenario;      // Escenario de lucha 0 / 2

    luchador1=1;    // 0-Ripley, 1-Bishop, 2-Alien, 3-Nostromo
    luchador2=2;    // 0-Ripley, 1-Bishop, 2-Alien, 3-Nostromo

    nivel=1;        // Dificultad del juego (0..2)
    modo;           // Modo de juego (ver modos[])
    sangre=1;       // Nivel de sangre (ver sangres[])

    // Textos de las opciones de combate
    nombres[]="RIPLEY","BISHOP","ALIEN","NOSTROMO";
    escenarios[]="LEVEL 1 : THE STORE ","LEVEL 2 : THE SEA","LEVEL 3: THE COLUMNS";
    niveles[]="EASY MODE","NORMAL MODE","HARD MODE";
    modos[]="COMPUTER vs COMPUTER"," CURSOR KEYS vs COMPUTER",
            "QA-RT-X KEYS vs COMPUTER","QA-RT-X KEYS vs CURSOR KEYS";
    sangres[]="BLOOD LEVEL : LOWER","BLOOD LEVEL : NORMAL","BLOOD LEVEL : HIGHER";

    struct texto[6] // Textos donde se guardan las opciones del combate
        x,y;
        codigo;
    END = 320,480,0,
          320,90,0,
          320,120,0,
          320,150,0,
          100,364,0,
          320,364,0,
          540,364,0;

    opci¢n;         // Opci¢n seleccionada del men£
    opci¢n_anterior;

    esc_pulsado;    // Indica si se ha abortado con ESC

    grises[255]=    // Tabla de conversi¢n de los colores a grises
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

    sangre_total;   // Part¡culas de sangre que se han quedado en el mapa
     ngulo_texto;   // Movimiento del texto en las opciones

    id_camara_modo8;

LOCAL
    estado;         // Indicador de la animaci¢n actual
    paso;           // Paso de la animaci¢n actual
    inc_y,inc_x;    // Desplazamientos del mu¤eco
    enemigo;        // Identificador del enemigo
    tipo_control;   // Dispositivo que controla al mu¤eco
    energ¡a;        // Energ¡a de mu¤eco

PRIVATE
    codigo_mapa;    // Pantalla de fondo cargada en ese momento
    codigo_mapa2;
    contador0;      // Contador de uso general
    idtexto;
    fileworld;
BEGIN
    set_mode(m640x480);     // Selecciona modo de v¡deo
    max_process_time=1500;  // Deja m s tiempo para que se ejecuten los procesos
    priority=-10;           // Pone muy poca prioridad

    intro();                // Ejecuta la intro del juego
    FRAME;                  // Necesario para parar este proceso
    LOOP // Bucle principal

        set_fps(100,0);     // Numero de im genes por segundo
        codigo_mapa=load_map("fost3D\menu.map");  // Carga la pantalla del men£
        load_pal("fost3D\menu.map");
        put_screen(0,codigo_mapa);  // Pone la pantalla del men£
        unload_map(codigo_mapa);    // Y la descarga de memoria para as¡ tener mas

        fade_on();          // Enciende la pantalla

        opcion=0;           // Inicializa la variable de opciones

        WHILE (opcion==0)   // Bucle del men£ de presentaci¢n
            IF (key(_1) OR
                key (_enter)) opcion=1; END    // Juego
            IF (key(_2) OR key (_esc)) opcion=2; END    // Salir
            FRAME;
        END

        fade_off();             // Apaga la pantalla

        IF (opcion==2)          // Opcion elegida: Salir del juego
            cr‚ditos();         // Pone los cr‚ditos
            signal(id,s_kill);  // Elimina este proceso
            FRAME;              // Y acaba.
        END

        // Carga los gr ficos de la pantalla de opciones
        codigo_mapa=load_map("fost3D\opciones.map");
        load_pal("fost3D\\opciones.map");
        put_screen(0,codigo_mapa);  // Pone el gr fico de fondo
        unload_map(codigo_mapa);    // Descarga el gr fico de memoria

        opcion=0;                   // Inicializa la variable de opciones
         ngulo_texto=0;             // Pone a cero el  ngulo de desplazamiento del texto seleccionado
        muestra_informaci¢n();      // Imprime todos los textos y gr ficos
        fade_on();                  // Enciende la pantalla

        LOOP
            // Mueve el texto que este seleccionado en ese momento
            move_text(texto[opci¢n].codigo,texto[opci¢n].x+get_disty( ngulo_texto,8),texto[opci¢n].y);
            opci¢n_anterior=opcion; // Guarda la opci¢n para no cambiar bruscamente

            // Lee las teclas
            IF (key(_right) OR key(_down))
                opcion++;
            END
            IF (key(_left) OR key(_up))
                opci¢n--;
            END

            // Se ha cambiado a otra opci¢n
            IF (opci¢n<>opci¢n_anterior)

                // Espera a que se pare
                WHILE (get_disty( ngulo_texto,8)<>0)
                     ngulo_texto+=22500;
                    move_text(texto[opci¢n_anterior].codigo,
                              texto[opci¢n_anterior].x+get_disty( ngulo_texto,8),
                              texto[opci¢n_anterior].y);
                    FRAME;
                END

                // Normaliza las opciones
                IF (opcion==7) opcion=0; END
                IF (opcion==-1) opcion=6; END

                // Espera a soltar la tecla
                WHILE (key(_right) OR key(_down) OR key(_left) OR key(_up))
                    FRAME;
                END
            ELSE
                 ngulo_texto+=22500;    // Sigue moviendo el texto
            END

            // Se ha elegido una opci¢n
            IF (key(_enter) OR key(_space) OR key (_control))
                SWITCH(opci¢n)

                    // Empieza el juego
                    CASE 0: BREAK; END

                    // Modo de juego (1/2 jugadores)
                    CASE 1:
                        modo++;
                        IF (modo==4) modo=0; END
                    END

                    // Nivel de juego (F cil/Dif¡cil)
                    CASE 2:
                        nivel++;
                        IF (nivel==3) nivel=0; END
                    END

                    // Nivel de aparici¢n de sangre
                    CASE 3:
                        sangre++;
                        IF (sangre==3) sangre=0; END
                    END

                    // Selecciona mu¤eco del jugador 1
                    CASE 4:
                        luchador1++;
                        IF (luchador1==4) luchador1=0; END
                    END

                    // Selecciona el escenario
                    CASE 5:
                        escenario++;
                        IF (escenario==3) escenario=0; END
                    END

                    // Selecciona mu¤eco del jugador 2
                    CASE 6:
                        luchador2++;
                        IF (luchador2==4) luchador2=0; END
                    END
                END
                muestra_informaci¢n();  // Actualiza la informaci¢n de pantalla
                WHILE (key(_enter) OR key(_space) OR key (_control)) // Espera a soltar la tecla
                    FRAME;
                END
            END
            IF (key(_esc))    // Se ha pulsado 'escape'
                esc_pulsado=1;// Pone variable a 1 la variable de escape pulsado
                BREAK;        // Y sale del bucle
            END
            FRAME;
        END

        IF (esc_pulsado)    // Sale del men£ de opciones si se pulso escape
            esc_pulsado=0;  // Pone a a cero la variable para la proxima vez
            fade_off();     // Apaga la pantalla
            let_me_alone(); // Deja unicamente el proceso principal(este)
            delete_text(all_text);//Borra cualquier texto que hubiera
            CONTINUE;       // Sale del siguiente bucle
        END
        // Carga los gr ficos necesarios para el escenario elegido
        SWITCH (escenario)
            CASE 0:
                codigo_mapa=load_map("fost3D\\fondo1.map");
                codigo_mapa2=load_map("fost3D\\paisaje1.map");
            END
            CASE 1:
                codigo_mapa=load_map("fost3D\\fondo2.map");
                codigo_mapa2=load_map("fost3D\\paisaje2.map");
            END
            CASE 2:
                codigo_mapa=load_map("fost3D\\fondo3.map");
                codigo_mapa2=load_map("fost3D\\paisaje1.map");
            END
        END

        // Carga los gr ficos necesarios para el jugador 1
        SWITCH(luchador1)
            CASE 0: load_fpg("fost3D\mujer.fpg"); END
            CASE 1: load_fpg("fost3D\hombre1.fpg"); END
            CASE 2: load_fpg("fost3D\esquelet.fpg"); END
            CASE 3: load_fpg("fost3D\hombre2.fpg"); END
        END

        // Carga los gr ficos necesarios para el jugador 2
        SWITCH(luchador2)
            CASE 0: load_fpg("fost3D\mujer.fpg"); END
            CASE 1: load_fpg("fost3D\hombre1.fpg"); END
            CASE 2: load_fpg("fost3D\esquelet.fpg"); END
            CASE 3: load_fpg("fost3D\hombre2.fpg"); END
        END
        fileworld=load_fpg("fost3D\texturas.fpg");
        load_wld("fost3D\zeen.wld",fileworld);
        // Si los jugadores son iguales convierte uno de ellos a grises
        IF (luchador1==luchador2)
            FROM contador0=1 TO 54;
                // Cambia los 54 primeros gr ficos del fichero
                // a la paleta de grises
                convert_palette(2,contador0,&grises);
            END
            convert_palette(2,100,&grises);// Tambi‚n convierte los gr ficos
            convert_palette(2,101,&grises);// peque¤os de las carras
        END

        combates1=0;    // Inicializa las variables del juego
        combates2=0;
        sangre_total=0;

        REPEAT          // Bucle del juego

            fade_off(); // Apaga la pantalla

            // Borra los textos, procesos  o 'scrolles' que hubiera abiertos
            let_me_alone();
            delete_text(all_text);
//            stop_scroll(0);
            stop_mode8(0);
            clear_screen();

            // Selecciona el numero de pantallas por segundo y el tipo de restauraci¢n
            set_fps(100,0);
            restore_type=complete_restore;

            // Pone la pantalla a blanco
            fade(200,200,200,8);
            WHILE (fading) FRAME; END //Espera mientras enciende la pantalla

            // Cambia el tipo de restauraci¢n de pantalla para ganar velocidad
            restore_type=no_restore;

            estado_juego=0; // Para el juego para poner todo

            // Inicializa el scroll
//            start_scroll(0,0,codigo_mapa,codigo_mapa2,0,0);
//            start_scroll(0,0,0,0,0,0);
//            scroll.x0=160;

            id_camara_modo8=camara_modo8();

            // Crea los mu¤ecos  que se han seleccionado
            // y el tipo de control de los mismos
            SWITCH(modo)

                // Ordenador contra ordenador
                CASE 0:
                    id_luchador1=mu¤eco(60,400,1,1,control_ordenador,luchador1);
                    id_luchador2=mu¤eco(560,400,2,0,control_ordenador,luchador2);
                END

                // Jugador contra ordenador
                CASE 1:
                    id_luchador1=mu¤eco(60,400,1,1,control_teclado1,luchador1);
                    id_luchador2=mu¤eco(560,400,2,0,control_ordenador,luchador2);
                END

                // Ordenador contra jugador
                CASE 2:
                    id_luchador1=mu¤eco(60,400,1,1,control_teclado2,luchador1);
                    id_luchador2=mu¤eco(560,400,2,0,control_ordenador,luchador2);
                END

                // Jugador contra jugador
                CASE 3:
                    id_luchador1=mu¤eco(60,400,1,1,control_teclado2,luchador1);
                    id_luchador2=mu¤eco(560,400,2,0,control_teclado1,luchador2);
                END
            END

            // Inicializa las variables enemigo de los mu¤ecos que son
            // identificadores al proceso del enemigo
            id_luchador1.enemigo=id_luchador2;
            id_luchador2.enemigo=id_luchador1;

            objetos(0,320,49,200,0,0); // Pone los marcadores de energ¡a
            objetos(0,194,38,201,0,1);
            objetos(0,446,38,202,0,2);

            define_region(1,0,0,640,480);   // Define las regiones para el movimiento
            define_region(2,0,0,640,480);   // de pantalla

            // Escribe el nombre del escenario
            write(1,320,0,1,escenarios[escenario]);

            // Pone las fotos y los nombres de los mu¤ecos
            objetos(id_luchador1.file,44,52,100+combates2,1,0);
            write(1,45,100,1,nombres[luchador1]);
            objetos(id_luchador2.file,596,52,100+combates1,0,0);
            write(1,596,100,1,nombres[luchador2]);

            // Crea las estrellas que marcan los combates ganados
            crea_estrellas();

            // Pone el mensaje de inicio de combate
            SWITCH(combates1+combates2)
                CASE 0:
                    idtexto=write(2,320,200,4,"ROUND 1st");
                END
                CASE 1:
                    idtexto=write(2,320,200,4,"ROUND 2nd");
                END
                CASE 2:
                    idtexto=write(2,320,200,4,"ROUND 3rd");
                END
            END

            fade(100,100,100,10);       // Muestra la pantalla
            WHILE (fading) FRAME; END

            // Dependiendo del nivel el juego va mas o menos r pido
            set_fps(default_fps+nivel*2,8);
            FRAME(4800);    // Hace una peque¤a pausa

            // Borra el texto de inicio de combate
            delete_text(idtexto);

            estado_juego=1;             // Quita la pausa al juego

            REPEAT  // Bucle de cada combate

                // Coloca el scroll dependiendo de las posiciones de los luchadores
//                scroll.x0=(id_luchador1.x+id_luchador2.x)/4-80;
                SWITCH (escenario)
                    CASE 0:
                       id_camara_modo8.x=6700+(((id_luchador1.x+id_luchador2.x)/2)-320);
                    END
                    CASE 1:
                       id_camara_modo8.x=7000+(((id_luchador1.x+id_luchador2.x)/2)-320);
                    END
                    CASE 2:
                       id_camara_modo8.y=7800+(((id_luchador1.x+id_luchador2.x)/2)-320);
                    END

                END
                FRAME;

                // Actualiza los marcadores
                define_region(1,296-id_luchador1.energia,28,id_luchador1.energia+1,20);
                define_region(2,345,29,id_luchador2.energia+1,20);

                // Comprueba si se ha pulsado 'escape'
                IF (key(_esc)) esc_pulsado=1; END

            // Repite hasta que se pulse escape o gane algun luchador
            UNTIL (estado_juego==2 OR esc_pulsado)

            // Si no se ha pulsado escape es que alguno ha ganada
            IF (NOT esc_pulsado)
                IF (id_luchador1.energia==0) // Gana el jugador 2
                    combates2++;
                ELSE
                    combates1++;            // Gana el jugador 1
                END
                crea_estrellas();   // Actualiza las estrellas
                FRAME(4800);
            END

        // Repite hasta que algun jugador gane dos combates
        UNTIL (combates1==2 OR combates2==2 OR esc_pulsado)

        // Si no se ha pulsado 'escape' pon el final de la lucha
        IF (NOT esc_pulsado)

            // Pon el numero de im genes por segundo como en el men£
            set_fps(100,0);

            fade(200,200,200,10);       // Pone la pantalla a blanco
            WHILE (fading) FRAME; END   // Espera hasta que se ponga blanca

            // Pone el nombre del que ha ganado
            IF (combates1==2)
                write(2,320,160,4,nombres[luchador1]);
            ELSE
                write(2,320,160,4,nombres[luchador2]);
            END

            // Y el mensaje de gana
            write(2,320,220,4,"WINS");

            fade(100,100,100,10);       // Enciende pantalla
            WHILE (fading) FRAME; END   // Espera hasta que se encienda

            // Pone el numero de im genes por segundo como en el juego
            set_fps(default_fps+nivel*2,8);

            FRAME(9600);                // Espera un rato

        ELSE
            // Actualiza la variable que guarda la pulsaci¢n de 'escape'
            esc_pulsado=0;
        END

        fade_off(); // Apaga la pantalla

        // Inicializa todo, borra procesos, textos pendientes, scrolles, etc
//        stop_scroll(0);             // Para scroll
        stop_mode8(0);
        unload_fpg(1);              // Descarga ficheros de gr ficos
        unload_fpg(2);
        unload_fpg(fileworld);
        unload_map(codigo_mapa);    // Descarga mapas gr ficos
        unload_map(codigo_mapa2);
        let_me_alone();             // Borra procesos
        delete_text(all_text);      // Borra textos

        // Cambia la forma de restaurar la pantalla
        restore_type=complete_restore;

    END
END

//------------------------------------------------------------------------------
// Proceso muestra_informacion
// Pone los textos y los gr ficos de la pantalla de opciones
//------------------------------------------------------------------------------

PROCESS muestra_informaci¢n()

BEGIN
    // Borra todo para luego imprimirlo actualizado
    delete_text(all_text);  // Borra cualquier texto pendiente

    signal(id_luchador1,s_kill);     // Elimina los procesos de los mu¤ecos
    signal(id_luchador2,s_kill);
    signal(id_auxiliar,s_kill);

    // Pone los textos no seleccionables
    write(2,320,0,1,"OPTIONS");
    write(2,320,156,1,"  VS  ");

    // Pone textos seleccionables
    texto[0].codigo=write(2,320,480,7,"START GAME");
    texto[1].codigo=write(1,320,90,1,modos[modo]);
    texto[2].codigo=write(1,320,120,1,niveles[nivel]);
    texto[3].codigo=write(1,320,150,1,sangres[sangre]);

    // Pone los gr ficos de los mu¤ecos y del escenario elegidos
    id_luchador1=objetos(0,100,256,310+luchador1,1,0);
    id_luchador2=objetos(0,540,256,310+luchador2,0,0);
    id_auxiliar=objetos(0,320,300,300+escenario,0,0);

    // Pone los textos de los mu¤ecos y del escenario elegido
    texto[4].codigo=write(1,100,364,1,nombres[luchador1]);
    texto[5].codigo=write(1,320,364,1,escenarios[escenario]);
    texto[6].codigo=write(1,540,364,1,nombres[luchador2]);

    // Mueve el texto que esta seleccionado
    move_text(texto[opci¢n].codigo,
              texto[opci¢n].x+get_disty( ngulo_texto,8),
              texto[opci¢n].y);
END

//------------------------------------------------------------------------------
// Proceso control
// Mueve los mu¤ecos, bien por teclado o controlados por el ordenador
// Entradas: 'acci¢n'   : Acci¢n ha comprobar si se hace
//------------------------------------------------------------------------------

PROCESS control(acci¢n)

PRIVATE
    dist;   // Distancia entre los mu¤ecos

BEGIN

    // Comprueba que el juego no este en pausa
    IF (estado_juego<>1) return(0); END

    // Lee la tecla dependiendo del tipo de control
    SWITCH(father.tipo_control)     // Mira quien maneja el mu¤eco

        CASE control_teclado1:      // Si se controla con el teclado1

            // Va mirando que acci¢n se quiere hacer
            // Y leyendo las teclas que se usan para ello
            SWITCH(acci¢n)          // Mira que acci¢n se esta comprobando
                CASE saltar:
                    RETURN(key(_up));   // Devuelve TRUE si esta pulsada la tecla
                END
                CASE agacharse:
                    RETURN(key(_down));
                END
                CASE avanzar:
                    IF (father.flags)   // Dependiendo hacia donde mire
                        RETURN(key(_right));    // Lee una tecla...
                    ELSE
                        RETURN(key(_left));     // O la otra
                    END
                END
                CASE retroceder:
                    IF (father.flags)
                        RETURN(key(_left));
                    ELSE
                        RETURN(key(_right));
                    END
                END
                CASE golpear:
                    RETURN(key(_control));
                END
            END
        END
        CASE control_teclado2:      // Se esta usando el teclado 2
            SWITCH(acci¢n)          // Se comprueba igual que antes.
                CASE saltar:
                    RETURN(key(_q));
                END
                CASE agacharse:
                    RETURN(key(_a));
                END
                CASE avanzar:
                    IF (father.flags)
                        RETURN(key(_t));
                    ELSE
                        RETURN(key(_r));
                    END
                END
                CASE retroceder:
                    IF (father.flags)
                        RETURN(key(_r));
                    ELSE
                        RETURN(key(_t));
                    END
                END
                CASE golpear:
                    RETURN(key(_x));
                END
            END
        END
        CASE control_ordenador:         // Lo maneja el ordenador
            dist=abs(id_luchador1.x-id_luchador2.x);      // Halla la distancia entre los mu¤ecos
            SWITCH(father.estado)       // Mira que se quiere comprobar

                // Va mirando que acci¢n se quiere hacer
                // Y se comprueba si es conveniente
                CASE _parado:
                    SWITCH(acci¢n)
                        CASE saltar:
                            // Si se esta a distancia correcta y...
                            // da la suerte devuelve TRUE
                            IF (dist<160 AND rand(0,35)==0)
                                RETURN(1);
                            END
                        END
                        CASE agacharse: // Igual para las dem s acciones
                            IF (dist<160 AND rand(0,25)==0)
                                RETURN(1);
                            END
                        END
                        CASE avanzar:
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
                        CASE retroceder:
                            IF (dist<180 AND rand(0,25)==0)
                                RETURN(1);
                            END
                            IF (dist<80 AND rand(0,5)==0)
                                RETURN(1);
                            END
                        END
                        CASE golpear:
                            IF (dist<180 AND dist>60 AND rand(0,5)==0)
                                RETURN(1);
                            END
                        END
                    END
                END
                CASE _avanzando:
                    SWITCH(acci¢n)
                        CASE saltar:
                            IF (dist>180 AND dist<300 AND rand(0,8)==0)
                                RETURN(1);
                            END
                        END
                        CASE golpear:
                            IF (dist<140)
                                RETURN(1);
                            END
                        END
                    END
                END
                CASE _retrocediendo:
                    SWITCH(acci¢n)
                        CASE saltar:
                            IF (dist<120 AND rand(0,6)==0)
                                RETURN(1);
                            END
                        END
                        CASE golpear:
                            IF (dist>70 AND dist<150)
                                RETURN(1);
                            END
                        END
                    END
                END
                CASE _agachado:
                    SWITCH(acci¢n)
                        CASE agacharse:
                            IF (rand(0,5)<>0)
                                RETURN(1);
                            END
                        END
                        CASE golpear:
                            IF (dist<180 AND rand(0,5)==0)
                                RETURN(1);
                            END
                        END
                    END
                END
                CASE _saltando:
                    SWITCH(acci¢n)
                        CASE golpear:
                            IF (rand(0,10)==0)
                                RETURN(1);
                            END
                        END
                    END
                END
            END
            // Si la acci¢n es correcta se devuelve 1, si no 0
            RETURN(0);  // No hace ninguna acci¢n
        END
    END
END

//------------------------------------------------------------------------------
// Proceso mu¤eco
// Maneja todos los tipo de mu¤eco
// Entradas: 'x,y'          : Coordenadas iniciales
//           'file'         : Fichero donde est n los gr ficos
//           'flags'        : Hacia donde mira el mu¤eco (izq./der.)
//           'tipo_control' : Quien maneja al mu¤eco (teclado1/teclado2/cpu)
//           'luchador'     : Cual es de los dos luchadores
//------------------------------------------------------------------------------

PROCESS mu¤eco(x,y,file,flags,tipo_control,luchador)

PRIVATE
    nuevo_estado;       // Variable temporal para el estado del mu¤eco
    nuevo_paso;         // Variable temporal para la posici¢n de la animaci¢n del mu¤eco
    golpe_x,golpe_y;    // Variables para guardar los puntos de control de los golpes
    // Fuerza de cada uno de los golpes
    fuerza_golpe[]=35,35,55,35,35;
    contador0;          // Contador de uso general
    suma_fuerza;        // Fuerza variable dependiendo del nivel y del luchador

BEGIN
//    ctype=c_scroll;     // Lo introduce dentro del scroll
    energia=203;        // Inicializa la energ¡a
    FRAME;
    sombra();           // Crea la sombra del mu¤eco

    IF (tipo_control<>0)                        // Si el ordenador no lleva este mu¤eco
        IF (enemigo.tipo_control==0)            // Pero lleva el del enemigo
            SWITCH(nivel)                       // Dependiendo del nivel de juego (dificultad)
                CASE 1: suma_fuerza=-10; END    // Hace que los golpes quiten menos energia
                CASE 2: suma_fuerza=-18; END
            END
        ELSE
            suma_fuerza=10; // Humano vs Humano, iguala las fuerzas
        END
    END

    SWITCH(luchador)        // Dependiendo del tipo de luchador
        CASE 0: suma_fuerza-=8; END // Ripley pega menos
        CASE 1: suma_fuerza+=6; END // Bishop es el segundo que pega m s
        CASE 2: suma_fuerza+=4; END // Alien es el segundo que pega menos
        CASE 3: suma_fuerza+=8; END // Nostrodomo pega m s que nadie
    END

    // Actualiza la fuerza de los golpes seg£n los jugadores
    FROM contador0=0 TO 4; fuerza_golpe[contador0]+=suma_fuerza; END

    LOOP
        nuevo_estado=estado;    // Actualiza la variable temporal del estado del mu¤eco
        SWITCH(estado)          // Comprueba el estado del mu¤eco
            CASE _parado:
                graph=anim0[paso++];        // Anima el gr fico
                IF (paso==sizeof(anim0))    // Si no hay mas gr ficos en la animaci¢n
                    paso=0;                 // Empieza desde 0
                END
                IF (flags)                  // Hace que los mu¤ecos se miren
                    IF (enemigo.x<x) flags=0; END
                ELSE
                    IF (enemigo.x>x) flags=1; END
                END
                // Comprueba si se quiere cambiar de estado
                IF (control(golpear))       // Comprueba si se quiere golpear
                    nuevo_estado=_pu¤etazo; // Y golpea...
                END
                IF (control(saltar))        // Comprueba si se quiere saltar
                    nuevo_estado=_saltando; // Y salta...
                    inc_y=-16; inc_x=0;     // Inicializa los incrementos para el salto
                END
                IF (control(agacharse))     // Comprueba si se quiere agachar
                    nuevo_estado=_agach ndose;  // Y se agacha...
                END
                IF (control(retroceder))    // Comprueba si se quiere retroceder
                    nuevo_estado=_retrocediendo;// Y retrocede...
                END
                IF (control(avanzar))       // Comprueba si se quiere avanzar
                    nuevo_estado=_avanzando;// Y avanza...
                END
            END

            CASE _avanzando:                // Si se esta avanzando
                graph=anim1[paso++];        // Anima el gr fico
                IF (paso==sizeof(anim1))    // Comprueba que no se ha llegado al final de la animaci¢n
                    nuevo_estado=_parado;   // Y si se ha llegado cambia de estado
                END
                IF (flags)                  // Mueve el mu¤eco seg£n donde mire
                    x+=4;
                ELSE
                    x-=4;
                END
                // Comprueba si se quieren hacer otras acciones
                IF (control(golpear))             // Se quiere golpear
                    nuevo_estado=_patada_normal;
                END
                IF (control(saltar))              // Se quiere saltar
                    nuevo_estado=_saltando;
                    inc_y=-16;
                    IF (flags)
                        inc_x=12;
                    ELSE
                        inc_x=-12;
                    END
                END
            END

            CASE _retrocediendo:            // Mira si se esta retrocediendo
                graph=anim2[paso++];        // Anima el gr fico
                IF (paso==sizeof(anim2))    // Si se ha llegado al final
                    nuevo_estado=_parado;   // Cambia de estado
                END
                IF (flags)                  // Lo mueve seg£n a donde mire
                    x-=4;
                ELSE
                    x+=4;
                END
                // Se mira si se quieren hacer otras acciones posibles
                IF (control(golpear))
                    nuevo_estado=_patada_giratoria;
                    inc_y=-10;
                END
                IF (control(saltar))
                    nuevo_estado=_saltando;
                    inc_y=-16;
                    IF (flags)
                        inc_x=-8;
                    ELSE
                        inc_x=8;
                    END
                END
            END

            CASE _agach ndose:  // Comprueba si se esta agach ndose
                graph=anim3[paso++];        // Haz la animaci¢n
                IF (paso==sizeof(anim3))    // Hasta que se llegue al final
                    nuevo_estado=_agachado; // Y pasa al estado de agachado
                END
            END

            CASE _agachado:         // Comprueba si esta agachado
                graph=anim4[0];     // Pone el gr fico necesario
                IF (flags)          // Pone al gr fico mirando al otro
                    IF (enemigo.x<x)
                        flags=0;
                    END
                ELSE
                    IF (enemigo.x>x)
                        flags=1;
                    END
                END
                // Comprueba si se quiere hacer otras acciones
                IF (control(golpear))           // Comprueba si se quiere golpear
                    nuevo_estado=_golpe_bajo;
                END
                IF (NOT control(agacharse))     // Si no quiere agacharse
                    nuevo_estado=_levant ndose; // Se pone levant ndose
                END
            END

            CASE _levant ndose:     // Comprueba si esta levant ndose
                graph=anim5[paso++];        // An¡malo
                IF (paso==sizeof(anim5))    // Si se acabado
                    nuevo_estado=_parado;   // Cambia de estado a parado
                END
            END

            CASE _saltando:             // Comprueba si se esta saltando
                graph=anim6[paso++];    // Anima los gr ficos
                IF (paso>4)             // Si se ha llegado al punto de la animaci¢n
                    x+=inc_x;           // Mueve al mu¤eco
                    y+=inc_y*3;
                    inc_y+=2;           // Cambia el incremento para que bote
                    IF (y>=400)         // Comprueba si ha tocado el suelo
                        y=400;
                        polvo(x,y);     // Crea polvo cuando cae
                        // Mira si se quiere saltar otra vez
                        IF (control(saltar))
                            nuevo_estado=_parado;
                        ELSE
                            nuevo_estado=_agach ndose;
                        END
                    END
                END
                IF (control(golpear))       // Comprueba si se quiere golpear
                    nuevo_estado=_patada_a‚rea;
                    nuevo_paso=paso;
                END
            END

            // Comprueba si se esta se hace el golpe bajo
            CASE _golpe_bajo:
                graph=anim7[paso++];        // Anima el gr fico
                IF (paso==sizeof(anim7))    // Si se acaba la animaci¢n
                    nuevo_estado=_agachado; // Se pone en otro estado
                END
                IF (flags)                  // Comprueba hacia donde mira
                    x++;                    // Y se mueve un poco
                ELSE
                    x--;
                END
                // Si se ha llegado al punto de la animaci¢n correcto
                IF (paso==2)
                    sound(s_aire1,rand(50,75),256);         // Realiza sonido
                    get_real_point(1,&golpe_x,&golpe_y);    // Coge los puntos de control del pu¤o
                    golpe(golpe_x,golpe_y,fuerza_golpe[0]); // Y comprueba si se ha tocado
                    IF (fuerza_golpe[0]>2)  // Reduce la fuerza de golpe
                        fuerza_golpe[0]--;  // para la pr¢xima vez
                    END
                END
            END
            // Comprueba si se esta haciendo la acci¢n pu¤etazo
            CASE _pu¤etazo:
                graph=anim8[paso++];        // Anima el gr fico
                IF (paso==sizeof(anim8))    // Hasta que se acabe la animaci¢n
                    nuevo_estado=_parado;   // Y cambia a un nuevo estado
                END
                IF (flags)                  // Comprueba hacia donde mira
                    x++;                    // Y se mueve
                ELSE
                    x--;
                END
                IF (paso==4)    // Si se ha llegado al punto de la animaci¢n
                    // Realiza el golpe
                    sound(s_aire2,rand(50,75),256);
                    get_real_point(1,&golpe_x,&golpe_y);    // Halla el punto donde se dara el golpe
                    golpe(golpe_x,golpe_y,fuerza_golpe[1]); // Comprueba si se da el golpe
                    IF (fuerza_golpe[1]>2)                  // Quita fuerza al golpe
                        fuerza_golpe[1]--;
                    END
                END
            END

            CASE _patada_giratoria: // Comprueba la patada giratoria como los anteriores golpes
                graph=anim9[paso++];
                IF (paso==sizeof(anim9))
                    nuevo_estado=_parado;
                END
                y+=inc_y; inc_y+=2;
                IF (y>400)
                    y=400;
                END
                IF (paso==5)
                    sound(s_aire3,rand(50,75),256);
                    get_real_point(1,&golpe_x,&golpe_y);
                    golpe(golpe_x,golpe_y,fuerza_golpe[2]);
                    IF (fuerza_golpe[2]>2)
                        fuerza_golpe[2]--;
                    END
                END
            END

            CASE _patada_normal:    // Comprueba la patada normal
                graph=anim10[paso++];
                IF (paso==sizeof(anim10))
                    nuevo_estado=_parado;
                END
                IF (paso==4)
                    sound(s_aire4,rand(50,75),256);
                    get_real_point(1,&golpe_x,&golpe_y);
                    golpe(golpe_x,golpe_y,fuerza_golpe[3]);
                    IF (fuerza_golpe[3]>2)
                        fuerza_golpe[3]--;
                    END
                END
            END

            CASE _patada_a‚rea:     // Comprueba la patada a‚rea
                graph=anim11[paso++];
                IF (paso>4)
                    x+=inc_x;
                    y+=inc_y*3;
                    inc_y+=2;
                    IF (y>=400)
                        y=400;
                        polvo(x,y);
                        IF (control(saltar))
                            nuevo_estado=_parado;
                        ELSE
                            nuevo_estado=_agach ndose;
                        END
                    END
                END
                IF (paso==10 OR paso==19)
                    sound(s_aire5,rand(50,75),256);
                    get_real_point(1,&golpe_x,&golpe_y);
                    golpe(golpe_x,golpe_y,fuerza_golpe[4]);
                    IF (fuerza_golpe[4]>2)
                        fuerza_golpe[4]--;
                    END
                END
            END

            CASE _tocado:   // Comprueba si el mu¤eco ha sido tocado
                graph=anim12[paso++];       // anima el gr fico
                IF (paso==sizeof(anim12))   // Hasta que acabe
                    // Haz un sonido al azar de los que tiene
                    SWITCH(rand(0,3))
                        CASE 0:
                            sound(s_golpe1,rand(25,50),256);
                        END
                        CASE 1:
                            sound(s_golpe2,rand(25,50),256);
                        END
                        CASE 2:
                           sound(s_golpe3,rand(25,50),256);
                        END
                    END
                    nuevo_estado=_parado;   // Cambia de estado
                    y=400;                  // Cae al suelo
                END
                x+=inc_x;      // Y mueve el mu¤eco un poco
                // Si se movia el mu¤eco, lo frena
                IF (inc_x<0)   // Si se movia a la izquierda
                    inc_x++;   // Se frena
                END
                IF (inc_x>0)   // Si se movia a la derecha
                    inc_x--;   // Se frena
                END
                IF (y<400)     // Si estaba saltando
                    y+=8;      // Hace que baje
                END
                IF (y>=400)    // Si estaba por debajo del limite inferior
                    y=400;     // Lo coloca
                END
            END

            CASE _muerto:   // Comprueba si el mu¤eco ha muerto
                IF (paso==0)
                sound(s_muerto,25,256);     // Hace el sonido de cuando muere
                END
                graph=anim13[paso++];       // Anima el gr fico hacia con una secuencia
                IF (paso==sizeof(anim13))   // Y la deja parada
                    paso--;
                END
                x+=inc_x;           // Mueve las coordenadas hasta cuadrarlas
                // Como el caso anterior (tocado) frena el mu¤eco
                IF (inc_x<0)
                    inc_x++;
                END
                IF (inc_x>0)
                    inc_x--;
                END
                IF (y<400)
                    y+=8;
                END
                IF (y>=400)
                    y=400;
                END
            END

        END

        IF (estado<>nuevo_estado)   // Actualiza el estado del mu¤eco
            estado=nuevo_estado;
            paso=nuevo_paso;        // Y el paso dentro de la animaci¢n
            nuevo_paso=0;
        END

        IF (x<40)                   // Comprueba que no se ha salido de pantalla
            x=60;                   // Y coloca el gr fico si ha salido
        END
        IF (x>600)
            x=600;
        END

        FRAME;
    END
END

//------------------------------------------------------------------------------
// Proceso sombra
// Maneja la sombra de los mu¤ecos
//------------------------------------------------------------------------------

PROCESS sombra()

BEGIN
//    ctype=c_scroll; // Lo pone dentro del scroll
    graph=1;        // Elige el gr fico
    priority=-1;    // Le da prioridad baja para que se ejecute despu‚s
    z=1;            // Lo pone por debajo del gr fico del mu¤eco
    y=400;          // Inicializa la coordenada vertical
    flags=4;        // Y hace que sea transparente
    LOOP
        x=father.x; // Hace que siga al mu¤eco
        FRAME;
    END
END

//------------------------------------------------------------------------------
// Proceso Polvo
// Pone una nube de polvo cuando el mu¤eco cae del salto
// Entradas: Coordenadas donde ira el gr fico
//------------------------------------------------------------------------------

PROCESS polvo(x,y)

BEGIN
    FRAME;
//    ctype=c_scroll; // Lo pone dentro del scroll
    flags=4;        // Lo hace transparente
    z=-1;           // Lo pone por delante del mu¤eco
    FROM graph=2 TO 12;// Anima el gr fico
        FRAME;
    END             // Acaba, eliminando este proceso
END

//------------------------------------------------------------------------------
// Proceso golpe
// Maneja los golpes que lanzan los mu¤ecos
// Entradas: Coordenadas de donde se da realmente el golpe
//           'da¤o' Energ¡a que quita al enemigo
//------------------------------------------------------------------------------

PROCESS golpe(x,y,da¤o)

PRIVATE
    id_mu¤ecos; // Identificador a los mu¤ecos
    contador0;  // Contador de uso general

BEGIN
//    ctype=c_scroll;     // Introduce al proceso dentro del scroll
    z=-1;               // Lo pone por delante de los mu¤ecos
    graph=100;          // Elige el gr fico de una bola para abarcar mas
    // Comprueba si esta tocando a un mu¤eco
    id_mu¤ecos=collision(type mu¤eco);
    IF (id_mu¤ecos==father)      // Y que no sea ‚l mismo que llamo a este proceso
        id_mu¤ecos=collision(type mu¤eco);  // Si es el mismo intenta coger el otro identificador
    END

    IF (id_mu¤ecos)              // Si ha tocado
        // Hace un sonido al azar de los disponibles
        SWITCH (rand(0,2))
            CASE 0:
                sound(s_tocado1,rand(25,75),256);
            END
            CASE 1:
                sound(s_tocado2,rand(25,75),256);
            END
            CASE 2:
                sound(s_tocado3,rand(25,75),256);
            END
        END
        id_mu¤ecos.paso=0;               // Actualiza la animaci¢n del que ha sido tocado
        id_mu¤ecos.energia-=da¤o/2;      // Le quita energ¡a
        IF (id_mu¤ecos.energia<=0)       // Si no le queda energ¡a
            id_mu¤ecos.energia=0;        // Es que esta muerto
            id_mu¤ecos.estado=_muerto;
            estado_juego=2;
        ELSE
            id_mu¤ecos.estado=_tocado;   // Si no, esta simplemente tocado
        END
        IF (id_mu¤ecos.flags)            // Mueve el gr fico un poco para atr s
            id_mu¤ecos.inc_x=-8;
        ELSE
            id_mu¤ecos.inc_x=8;
        END
        SWITCH(sangre)          // Crea la sangre
            // Dependiendo del nivel elegido en las opciones
            CASE 0:     // Golpe sin sangre
                golpe_sin_sangre(x,y);
            END
            CASE 1:     // Golpe con sangre
                contador0=da¤o/3+1;
                WHILE (contador0>0)
                    particula_sangre(x,y,id_mu¤ecos.inc_x+rand(-2,2),rand(-4,0),rand(10,20));
                    contador0--;
                END
            END
            CASE 2:    // Golpe con mucha sangre
                contador0=da¤o+2;
                WHILE (contador0>0)
                    particula_sangre(x,y,id_mu¤ecos.inc_x*2+rand(-4,4),rand(-8,2),rand(15,30));
                    contador0--;
                END
            END
        END
    END
END

//------------------------------------------------------------------------------
// Proceso particula_sangre
// Maneja la sangre que sale cuando se da un golpe
// Entradas: 'x,y'        : Coordenadas desde donde sale la sangre
//           'inc_x,inc_y': Incrementos en el movimiento de la sangre (ca¡da)
//           'cont_tiempo': Contador del tiempo que aparecer  la sangre
//------------------------------------------------------------------------------

PROCESS particula_sangre(x,y,inc_x,inc_y,cont_tiempo)

BEGIN
//    ctype=c_scroll;         // Lo pone dentro del scroll
    // Si esta en el modo de mayor sanguinolencia, espera un poco para que no salga toda junta
    IF (sangre==2)
        FRAME(rand(0,400)); // Espera un tiempo al azar
    END
    graph=rand(50,53);      // Elige uno de los gr ficos disponibles al azar
    flags=4;                // La hace transparente
    z=-2;                   // Lo pone por encima de todo
    WHILE (cont_tiempo>0)   // Mueve la sangre mientras hjaya tiempo
        x+=inc_x;           // Realiza los incrementos en las coordenadas
        y+=inc_y;
        inc_y++;            // Hace que cada vez caiga m s rapido
        IF (inc_x>0)        // Pero a horizontalmente se mueva m s lento
            inc_x--;
        END
        IF (inc_x<0)
            inc_x++;
        END
        IF (y>410)          // Comprueba si ha tocado el suelo
            // Deja sangre pegada al suelo de forma aleatoria
            IF (rand(0,80)==0 AND sangre_total<50 AND y<480)
                z=256;          // La pone detr s
                sangre_total++; // Incrementa el contador de sangre
                LOOP
                    FRAME;      // La deja en un bucle para que quede en pantalla
                END
            END
        END
        cont_tiempo--;          // Incrementa el contador de tiempo
        FRAME;
    END
END

//------------------------------------------------------------------------------
// Proceso golpe_sin_sangre
// Pone un gr fico alternativo al de la sangre para los modos sin ella
//------------------------------------------------------------------------------

PROCESS golpe_sin_sangre(x,y)

BEGIN
//    ctype=c_scroll; // Lo pone dentro del scroll
    z=-2;           // Por delante de otros gr ficos
    FROM graph=60 TO 66;
        FRAME;      // Anima el gr fico
    END
END

//------------------------------------------------------------------------------
// Proceso objetos
// Pone los gr ficos est ticos del marcador y la pantalla de opciones
// Entradas: fichero gr fico, coordenadas, gr fico, bandera (der/izq.),
//           zona de la pantalla
//------------------------------------------------------------------------------

PROCESS objetos(file,x,y,graph,flags,region)

BEGIN
    z=10;   // Lo pone por debajo de otros gr ficos
    LOOP
        FRAME;
    END
END

//------------------------------------------------------------------------------
// Proceso crea_estrellas
// Maneja las estrellas que indican los combates ganados
//------------------------------------------------------------------------------

PROCESS crea_estrellas()

BEGIN
    // Elimina cualquier estrella que hubiera antes
    signal(type estrella,s_kill);

    // Pon las estrellas del jugador 1
    SWITCH(combates1)
        // Dependiendo de los combates ganados pone  unas estrellas u otras
        CASE 0:
            estrella(111,84,203);
            estrella(143,84,203);
        END
        CASE 1:
            estrella(111,84,204);
            estrella(143,84,203);
        END
        CASE 2:
            estrella(111,84,204);
            estrella(143,84,204);
        END
    END

    // Pon las estrellas del jugador 2
    SWITCH(combates2)
        CASE 0:
            estrella(530,84,203);
            estrella(498,84,203);
        END
        CASE 1:
            estrella(530,84,204);
            estrella(498,84,203);
        END
        CASE 2:
            estrella(530,84,204);
            estrella(498,84,204);
        END
    END

END

//------------------------------------------------------------------------------
// Proceso estrella
// Imprime los gr ficos de la estrellas
// Entradas: Coordenadas y tipo de gr fico de la estrella
//------------------------------------------------------------------------------

PROCESS estrella(x,y,graph)

BEGIN
    LOOP
        FRAME;  // Lo imprime
    END
END

//------------------------------------------------------------------------------
// Proceso cr‚ditos
// Pone la pantalla de cr‚ditos
//------------------------------------------------------------------------------

PROCESS cr‚ditos()

PRIVATE
    codigo_mapa;    // Identificador al fichero de gr ficos
    // Textos de los cr‚ditos
    textos[]=
        "PROGRAMMING","DANIEL NAVARRO","",
        "GRAPHICS","JOSE FERNANDEZ","RAFAEL BARRASO","",
        "SOUNDS","ANTONIO MARCHAL","",
        "PLAYABILITY","LUIS F. FERNANDEZ","",
        "THIS VERSION (3D)","ANTONIO MARCHAL";

BEGIN
    // Carga la pantalla de fondo
    codigo_mapa=load_map("fost3D\creditos.map");
    load_pal("fost3D\creditos.map");
    // Y el tipo de letras
    load_fnt("fost3D\creditos.fnt");
    put_screen(0,codigo_mapa);          // Pone el fondo
    FROM y=0 TO 14;                     // Y escribe los textos
        write(3,320,40+y*20,4,textos[y]);
    END
    fade_on();                          // Enciende la pantalla
    scan_code=0;
    REPEAT                              // Espera hasta que se pulse una tecla
        FRAME;
    UNTIL (scan_code<>0)
END

//------------------------------------------------------------------------------
// Proceso intro
// Realiza la intro del juego
//------------------------------------------------------------------------------

PROCESS intro();

PRIVATE
    contador0;      // Contador de uso general
    codigo_mapa;    // Identificador para descargar los graficos
    s_intro;        // Identificador del sonido de la intro
BEGIN
    // Para el proceso general para poner este
    signal(father,s_sleep);
    // Hace que la pantalla cambie rapido
    set_fps(100,0);
    load_pal("fost3D\intro.map");                 // Carga la paleta de colores
    codigo_mapa=load_map("fost3D\intro.map");     // Carga la pantalla
    s_intro=load_pcm("fost3D\introhit.pcm",0);    // Carga el sonido

    fade(200,200,200,8);        // Pone la pantalla en blanco
    WHILE (fading) FRAME; END   // Espera hasta que se encienda la pantalla
    sound(s_intro,100,256);     // Hace el sonido
    put_screen(0,codigo_mapa);  // Pone el fondo de pantalla
    unload_map(codigo_mapa);    // Descarga el grafico
    fade_on();                  // Hace que se vea la pantalla (la enciende)
    WHILE (fading) FRAME; END   // Espera hasta que se encienda la pantalla

    // Carga sonidos
    s_golpe1=load_pcm("fost3D\uah00.pcm",0);
    s_golpe2=load_pcm("fost3D\whimper2.pcm",0);
    s_golpe3=load_pcm("fost3D\whimper3.pcm",0);
    s_tocado1=load_pcm("fost3D\hit00.pcm",0);
    s_tocado2=load_pcm("fost3D\hit01.pcm",0);
    s_tocado3=load_pcm("fost3D\hit02.pcm",0);
    s_aire1=load_pcm("fost3D\turn06.pcm",0);
    s_aire2=load_pcm("fost3D\turn07.pcm",0);
    s_aire3=load_pcm("fost3D\turn08.pcm",0);
    s_aire4=load_pcm("fost3D\turn05.pcm",0);
    s_aire5=load_pcm("fost3D\turn09.pcm",0);
    s_muerto=load_pcm("fost3D\aaah01.pcm",0);

    // Carga los graficos y las letras
    load_fpg("fost3D\juego.fpg");
    load_fnt("fost3D\enjuego.fnt");
    load_fnt("fost3D\enjuego2.fnt");

    // Espera a que se pulse una tecla o pase un tiempo
    WHILE (NOT key(_esc) AND NOT key (_space) AND contador0<200)
        FRAME;
        contador0++;
    END
    // Devuelve el control al proceso principal
    signal(father,s_wakeup);
END
PROCESS camara_modo8();
BEGIN
    start_mode8(id,0,0);
    ctype=c_m8;
    m8.height=64;  // Altura de los ojos
    m8.angle=0;    // Mirar hacia arriba/abajo

    SWITCH (escenario)
        CASE 0:
            angle=90000;
            x=6700;
            y=8300;
        END
        CASE 1:
            angle=90000;
            x=7000;
            y=6000;
        END
        CASE 2:
            angle=180000;
            x=3000;
            y=7800;
        END

    END
    z=1100;

    LOOP
        FRAME;
    END
END
