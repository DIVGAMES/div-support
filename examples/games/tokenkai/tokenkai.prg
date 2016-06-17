
// -------------------------------------------------------------------------
//
//                          TOKENKAI
//
//                (C) 1999 Hammer Technologies
//              C/ Alfonso G¢mez, 42, nave 1-1-2
//          Tlf. (91) 304 06 22 - Fax. (91) 304 17 97
//                  C.P. 28037  Madrid (Spain)
//                       www.hammert.com
//
//            Esto es una demo de los dos primeros
//               niveles del programa Tokenkai.
//
//      Desarrollado en su integridad con DIV Games Studio 2.0
//
// -------------------------------------------------------------------------

program tokenkai;

// -------------------------------------------------------------------------
// Variables globales del programa
// -------------------------------------------------------------------------

global

    // Nombres de archivos para que se incluyan obligatoriamente en la instalaci¢n

    install_files[]=
        "tokenkai\nivel1.fpg","tokenkai\nivel2.fpg","tokenkai\nivel3.fpg","tokenkai\nivel4.fpg","tokenkai\nivel5.fpg",
        "tokenkai\nivel6.fpg","tokenkai\nivel7.fpg","tokenkai\nivel8.fpg","tokenkai\nivel9.fpg","tokenkai\nivel10.fpg",
        "tokenkai\nivel11.fpg","tokenkai\nivel12.fpg","tokenkai\nivel13.fpg","tokenkai\nivel14.fpg","tokenkai\nivel15.fpg",
        "map\tokenkai\inf1.pcx","map\tokenkai\inf2.pcx","map\tokenkai\inf3.pcx","map\tokenkai\inf4.pcx","map\tokenkai\inf5.pcx",
        "map\tokenkai\inf6.pcx","map\tokenkai\inf7.pcx","map\tokenkai\inf8.pcx","map\tokenkai\inf9.pcx","map\tokenkai\inf10.pcx",
        "map\tokenkai\inf11.pcx","map\tokenkai\inf12.pcx","map\tokenkai\inf13.pcx","map\tokenkai\inf14.pcx","map\tokenkai\inf15.pcx";

    config[3]=0,1,0,1;  // Opciones de configuraci¢n

    struct partida[7]   // Partidas guardadas
        nivel;          // Nivel, de 2 en adelante (0 partida no usada)
        energia;        // Energia (de 0 a 90)
        escudo;         // Escudo (de 0 a 90)
        balas;          // Munici¢n de ametralladora
        granadas;       // Granadas
        bombas;         // N£mero de explosivos
        tiros;          // Tiros a distancia para el rifle
        total[3];       // Munici¢n de cada tipo utilizada
        string texto;
    end

    struct inicio       // Datos para iniciar una partida
        nivel;          // Nivel, de 1 en adelante
        energia;        // Energia (de 0 a 90)
        escudo;         // Escudo (de 0 a 90)
        balas;          // Munici¢n de ametralladora
        granadas;       // Granadas
        bombas;         // N£mero de explosivos
        tiros;          // Tiros a distancia para el rifle
        total[3];       // Munici¢n de cada tipo utilizada
    end

    struct nivel[16]    // Dejar 16 (n£m. misiones m s 1)

        string enemigo_1;   // Datos del primer tipo de enemigo
        n£mero_1;
        m s_1;
        tiros_1;
        energia_1;

        string enemigo_2;   // Datos del segundo tipo de enemigo
        n£mero_2;
        m s_2;
        tiros_2;
        energia_2;

        salida_x0;
        salida_y0;
        salida_x1;
        salida_y1;

    end =

        "",0,0,0,0, // Nivel 0
        "",0,0,0,0,
        0,0,0,0,

        "tokenkai\enemigos.fpg",15,15,3,7, // Nivel 1
        "",0,0,0,0,
        890,0,1200,140,

        "tokenkai\enemigos.fpg",17,25,3,8, // Nivel 2
        "",0,0,0,0,
        1122,453,1279,587;

    id_jugador;

    m s_enemigo_1;
    m s_enemigo_2;

    arma_sel; // Arma seleccionada

    max_arma[]=250,20,10,10; // Munici¢n m xima para cada arma

    total_max[]=98,18,8,8; // Frecuencia de utilizaci¢n m xima de cada arma

    // Tablas de animacion

    anima[]=
        16,1,09,17,25,33,-25,-17,-09,-1,-65,-57,-49,41,49,57,65,
        16,2,10,18,26,34,-26,-18,-10,-2,-66,-58,-50,42,50,58,66,
        16,3,11,19,27,35,-27,-19,-11,-3,-67,-59,-51,43,51,59,67,
        16,4,12,20,28,36,-28,-20,-12,-4,-68,-60,-52,44,52,60,68,
        16,5,13,21,29,37,-29,-21,-13,-5,-69,-61,-53,45,53,61,69,
        16,6,14,22,30,38,-30,-22,-14,-6,-70,-62,-54,46,54,62,70,
        16,7,15,23,31,39,-31,-23,-15,-7,-71,-63,-55,47,55,63,71,
        16,8,16,24,32,40,-32,-24,-16,-8,-72,-64,-56,48,56,64,72;

    prodis[]=
        16,73,76,79,82,85,-82,-79,-76,-73,-97,-94,-91,88,91,94,97,
        16,74,77,80,83,86,-83,-80,-77,-74,-98,-95,-92,89,92,95,98,
        16,75,78,81,84,87,-84,-81,-78,-75,-99,-96,-93,90,93,96,99;

    enepas[]=
        8,17,25,33,-25,-17,-09,1,09,
        8,18,26,34,-26,-18,-10,2,10,
        8,19,27,35,-27,-19,-11,3,11,
        8,20,28,36,-28,-20,-12,4,12,
        8,21,29,37,-29,-21,-13,5,13,
        8,22,30,38,-30,-22,-14,6,14,
        8,23,31,39,-31,-23,-15,7,15,
        8,24,32,40,-32,-24,-16,8,16;

    enecor[]=
        8,59,67,75,-67,-59,-91,83,91,
        8,60,68,76,-68,-60,-92,84,92,
        8,61,69,77,-69,-61,-93,85,93,
        8,62,70,78,-70,-62,-94,86,94,
        8,63,71,79,-71,-63,-95,87,95,
        8,64,72,80,-72,-64,-96,88,96,
        8,65,73,81,-73,-65,-97,89,97,
        8,66,74,82,-74,-66,-98,90,98;

    enedis[]=
        8,41,44,47,-44,-41,-53,50,53,
        8,42,45,48,-45,-42,-54,51,54,
        8,43,46,49,-46,-43,-55,52,55;

    enemue[]=
        8,099,107,115,-107,-099,-131,123,131,
        8,100,108,116,-108,-100,-132,124,132,
        8,101,109,117,-109,-101,-133,125,133,
        8,102,110,118,-110,-102,-134,126,134,
        8,103,111,119,-111,-103,-135,127,135,
        8,104,112,120,-112,-104,-136,128,136,
        8,105,113,121,-113,-105,-137,129,137,
        8,106,114,122,-114,-106,-138,130,138;

    red=100,green=100,blue=100;
    fundido;

    e_victimas;
    e_municion;
    e_impactos;

    archivo;

    sonido[32];

// -------------------------------------------------------------------------
// Variables locales de todos los procesos
// -------------------------------------------------------------------------

local
    energia;
    escudo;
    estado;
    munici¢n;
    mensaje_matar;
    hablando;

// -------------------------------------------------------------------------
// Programa principal
// -------------------------------------------------------------------------

begin
    set_mode(m640x480);     // Seleccionamos modo de video
    inicia_menu();          // Inicializamos los menus
    archivo=fopen("dat\tokenkai\toten.cfg","r");     // Intentamos leer fichero de configuracion
    if (archivo)
        fclose(archivo);
        load("dat\tokenkai\toten.cfg",offset config);
        mouse.speed=config[3]*3;
    end
    presentacion();         // Presentacion de juego
    menu();                 // Entramos en los menus
    while (inicio.nivel>0);
        if (nivel[inicio.nivel].enemigo_1=="")
            fin_de_juego();
            menu();
        else
            finaliza_menu();
            inicia_nivel();
            jugar_nivel();
            finaliza_nivel();
            inicia_menu();
            switch(inicio.nivel)
                case -1: // Partida abortada
                    game_over();
                    menu();
                end
                case 0:  // Game over
                    game_over();
                    menu();
                end
                default:
                    estad¡sticas();
                end
            end
        end
    end
    finaliza_menu();
end

// -------------------------------------------------------------------------
// Carga los recursos utilizados en cada nivel
// -------------------------------------------------------------------------

function inicia_nivel()

private
    angulo1;

begin

    // Sonido inicial de la explosi¢n

    sonido[17]=load_pcm("pcm\tokenkai\explos02.wav",0);
    sound(sonido[17],256,256);

    // Carga ficheros de graficos

    load_fpg("tokenkai\nivel"+itoa(inicio.nivel)+".fpg");
    load_fpg("tokenkai\marcador.fpg");
    load_fpg("tokenkai\prota.fpg");
    load_fpg(nivel[inicio.nivel].enemigo_1);
    if (nivel[inicio.nivel].enemigo_2!="")
        load_fpg(nivel[inicio.nivel].enemigo_2);
    end

    // Carga fuentes de letras

    load_fnt("tokenkai\toten0.fnt");
    load_fnt("tokenkai\toten1.fnt");

    // Carga efectos de sonido

    sonido[0]=load_pcm("pcm\tokenkai\impacto0.wav",0);  // Impacto de balas en el mapa
    sonido[1]=load_pcm("pcm\tokenkai\impacto1.wav",0);
    sonido[2]=load_pcm("pcm\tokenkai\impacto2.wav",0);
    sonido[3]=load_pcm("pcm\tokenkai\impacto3.wav",0);
    sonido[4]=load_pcm("pcm\tokenkai\impacto4.wav",0);
    sonido[5]=load_pcm("pcm\tokenkai\impacto5.wav",0);
    sonido[6]=load_pcm("pcm\tokenkai\impacto6.wav",0);
    sonido[7]=load_pcm("pcm\tokenkai\nopuedo.wav",0);   // Click de raton sobre mapa
    sonido[8]=load_pcm("pcm\tokenkai\flecha.wav",0);
    sonido[9]=load_pcm("pcm\tokenkai\cogecosa.wav",0);  // Coger Item
    sonido[10]=load_pcm("pcm\tokenkai\pistola0.wav",0);  // Disparo metralleta
    sonido[11]=load_pcm("pcm\tokenkai\giro07.wav",0);
    sonido[12]=load_pcm("pcm\tokenkai\golpe27.wav",0);
    sonido[13]=load_pcm("pcm\tokenkai\boton00.wav",0);
    sonido[14]=load_pcm("pcm\tokenkai\aspersor.wav",0);
    sonido[15]=load_pcm("pcm\tokenkai\m_primer.wav",0); // Activar / Seleccionar snipper
    sonido[16]=load_pcm("pcm\tokenkai\explo1.wav",0);   // Explosiones varias

    // Errores ignorados

    ignore_error(120);

    // Briefing del nivel

    pantalla(1);
    graph=2; y=210; mouse.file=1;

    repeat
        x=450+400+get_disty(angulo1,400);
        if (angulo1<90000) angulo1+=5000; end
        frame;
    until (scan_code!=0 or mouse.left)

    repeat
        x=450+400+get_disty(angulo1,400);
        angulo1-=5000;
        frame;
    until (angulo1<0)

    // Inicializa el juego

    fade(200,200,200,10);       // Efecto de Fade
    while (fading) frame; end

    mouse.file=1;
    graph=0;

    fade(100,100,100,5);

    // Marcador

    put(1,1,640-64,240);   // Ponemos grafico del marcador
    radar();               // inicializamos radar

    objeto(2,0,576,44,4);  // Barra energia
    objeto(3,0,576,88,5);  // Barra escudo
    objeto(4,0,600,137,6); // Barra munici¢n

    restore_type=partial_restore;

    // Inicializa scroll
    // Definimos regiones de scroll

    define_region(1,0,0,640-128,480);
    define_region(2,192,192,640-128-192*2,480-192*2);
    define_region(3,128,128,640-128-128*2,480-128*2);

    // Estad¡sticas

    timer=0;
    e_victimas=0;
    e_municion=0;
    e_impactos=0;

    // ­Preparado!

    mensaje_mision(224);

    // Munici¢n restante

    write_int(2,558,211,8,offset inicio.balas);
    write_int(2,558+44,211,8,offset inicio.granadas);
    write_int(2,558,211+44,8,offset inicio.tiros);
    write_int(2,558+44,211+44,8,offset inicio.bombas);

    objeto(17,0,541,194,0);
    objeto(18,0,539+44,196,0);
    objeto(19,0,543,195+44,0);
    objeto(20,0,541+44,196+44,0);

    arma_sel=0; // Selecciona la ametralladora por defecto
    arma();     // Icono selector de arma

end

// -------------------------------------------------------------------------
// Funci¢n principal de control de juego
// -------------------------------------------------------------------------

function jugar_nivel()

private
    ang;
    velx,vely;
    antes_left;

begin

    // Definimos parametros del scroll

    start_scroll(0,0,3,4,1,0);
    scroll.speed=2;
    scroll.region1=2;
    scroll.region2=3;
    scroll.ratio=100;
    id_jugador=prota();
    scroll.camera=id_jugador;

    // Vemos que nivel debemos de inicializar

    switch(inicio.nivel)
        case 1:
            recorte(10,654,643,0);
            recorte(11,436,278,0);
            recorte(12,205,359,0);
            recorte(13,799,411,0);
            recorte(14,928,349,0);
            recorte(15,940,626,0);
            recorte(16,127,617,-16);
            item_energia(25,104,778);
            item_energia(25,1260,790);
            item_escudo(45,820,390);
            explosivo(63,166,276);
            explosivo(65,1098,236);
            nivel1_lancha();
        end
        case 2:
            recorte(10,461,366,-32);
            recorte(10,535,409,-32);
            recorte(10,548,614,-32);
            recorte(10,905,650,-32);
            recorte(11,693,636,-16);
            recorte(12,112,641,-64);
            recorte(13,909,351,0);
            recorte(14,244,559,0);
            explosivo(63,250,319);
            explosivo(65,1200,832);
            explosivo(65,31,855);
            item_energia(15,1029,172);
        end
        // ...
    end

    for (x=0;x<nivel[inicio.nivel].n£mero_1;x++)
        enemigo(3,nivel[inicio.nivel].tiros_1,nivel[inicio.nivel].energ¡a_1,280);
    end

    for (x=0;x<nivel[inicio.nivel].n£mero_2;x++)
        enemigo(4,nivel[inicio.nivel].tiros_2,nivel[inicio.nivel].energ¡a_2,280);
    end

    m s_enemigo_1=nivel[inicio.nivel].m s_1;
    m s_enemigo_2=nivel[inicio.nivel].m s_2;

    priority=-100;

    loop
        if (fundido==0)
            if (red>=110) red-=10; end
            if (red<=90) red+=10; end
            if (green>=110) green-=10; end
            if (green<=90) green+=10; end
            if (blue>=110) blue-=10; end
            if (blue<=90) blue+=10; end
        else
            fundido--;
        end
        fade(red,green,blue,10);

        // Cambio de arma

        if (mouse_in(523,178,523+86,178+86) and mouse.left)
            arma_sel=(mouse.x-523)/44+((mouse.y-178)/44)*2;
            if (not antes_left)
                sound(sonido[13],256,256);
            end
        end

        if (key(_1) and arma_sel!=0) arma_sel=0; sound(sonido[13],256,256); end
        if (key(_2) and arma_sel!=1) arma_sel=1; sound(sonido[13],256,256); end
        if (key(_3) and arma_sel!=2) arma_sel=2; sound(sonido[13],256,256); end
        if (key(_4) and arma_sel!=3) arma_sel=3; sound(sonido[13],256,256); end

        if (inicio.energia<=0) // Game over
            inicio.nivel=0;
            break;
        end
        if (key(_esc))  // Si pulsamos escape, ventana de pausa
            graph=0;
            mouse.graph=30;
            sound(sonido[14],256,256);
            if (pausa())
                inicio.nivel=-1;
                break;
            end
        end
        if (not get_id(type enemigo))
            break;
        end

        move_scroll(0);
        scroll.x1=scroll.x0+get_distx(ang,24);
        scroll.y1=scroll.y0+get_disty(ang,12);
        ang+=1000;

        antes_left=mouse.left;

        if (arma_sel==2)

            if (mouse_in(0,0,640-128,480))
                mouse.graph=0;
                file=1; graph=28;
                region=1;
                x=mouse.x+scroll.x0;
                y=mouse.y+scroll.y0;
                if (path_line(0,6,6,id_jugador.x,id_jugador.y) and inicio.tiros>0)
                    mirilla(29);
                else
                    mirilla(27);
                end
                x=mouse.x-4; y=mouse.y;
            else
                graph=0;
                mouse.graph=30;
            end

            scroll.camera=0;
            if (mouse.x==0 and velx>-16) velx-=4; end
            if (mouse.x==639 and velx<16) velx+=4; end
            if (mouse.y==0 and vely>-16) vely-=4; end
            if (mouse.y==479 and vely<16) vely+=4; end
            scroll.x0+=velx;
            scroll.y0+=vely;
            if (velx>0) velx-=2; end
            if (vely>0) vely-=2; end
            if (velx<0) velx+=2; end
            if (vely<0) vely+=2; end
            frame;

        else

            graph=0;
            mouse.graph=30;
            scroll.camera=0;
            frame;
            scroll.camera=id_jugador;

        end

    end

    if (inicio.nivel>0)
        graph=0;
        mouse.graph=30;
        scroll.camera=id_jugador;
        mensaje_mision(223);
        mensaje_salida();
        repeat
            frame;
        until (id_jugador.x>=nivel[inicio.nivel].salida_x0 and
               id_jugador.x<=nivel[inicio.nivel].salida_x1 and
               id_jugador.y>=nivel[inicio.nivel].salida_y0 and
               id_jugador.y<=nivel[inicio.nivel].salida_y1)
        signal(get_id(type mensaje_salida),s_kill);
        signal(get_id(type mensaje_mision),s_kill);
        frame(2000);
        inicio.nivel++;
    end

end

// -------------------------------------------------------------------------
// Funcion que finaliza el nivel y se
// encarga de descargar todos los datos
// -------------------------------------------------------------------------

function finaliza_nivel()

begin

    if (inicio.nivel==0)
        fade(200,0,0,1);
        while (fading) frame; end
    else
        fade_off();
    end

    restore_type=complete_restore;
    frame;

    stop_scroll(0);
    clear_screen();

    signal(type radar,s_kill);
    signal(type punto_radar,s_kill);
    signal(type objeto,s_kill);
    signal(type arma,s_kill);

    delete_text(all_text);

    mouse.graph=0;
    frame;
    fade_off();

    // Descarga ficheros

    unload_fnt(2);
    unload_fnt(1);
    unload_fpg(3);
    unload_fpg(2);
    unload_fpg(1);
    unload_fpg(0);

    // Descarga sonidos

    from x=0 to 32;
        unload_pcm(sonido[x]);
    end

end

// -------------------------------------------------------------------------
// Funcion de la ventana de pausa que aparecer al
// pulsar la tecla de escape
// -------------------------------------------------------------------------

function pausa()

private
    salir;
    ang;

begin

    while (key(_esc)) frame; end
    signal(type prota,s_freeze);
    signal(type enemigo,s_freeze);
    file=1; graph=14;
    x=240; z=-128;

    from ang=90000 to 0 step -5000;
        if (fundido==0)
            if (red>=110) red-=10; end
            if (red<=90) red+=10; end
            if (green>=110) green-=10; end
            if (green<=90) green+=10; end
            if (blue>=110) blue-=10; end
            if (blue<=90) blue+=10; end
        else
            fundido--;
        end
        fade(red,green,blue,10);
        y=-80+get_distx(ang,320);
        frame;
    end

    loop
        if (mouse_in(188-40,270-12,188+40,270+12))
            ilumina2(15,188,270);
            if (mouse.left)
                salir=1;
                break;
            end
        end
        if (mouse_in(290-40,270-12,290+40,270+12))
            ilumina2(16,290,270);
            if (mouse.left)
                break;
            end
        end
        if (key(_esc))
            break;
        end
        frame;
    end

    from ang=0 to 90000 step 15000;
        y=-80+get_distx(ang,320);
        frame;
    end

    signal(type prota,s_wakeup);
    signal(type enemigo,s_wakeup);

    return(salir);
end

// -------------------------------------------------------------------------
// Control del mensaje que nos indica por donde salir del nivel
// -------------------------------------------------------------------------

process mensaje_salida()

private
    x0,y0;
    angulo1;

begin
    file=1;
    x0=(nivel[inicio.nivel].salida_x0+nivel[inicio.nivel].salida_x1)/2;
    y0=(nivel[inicio.nivel].salida_y0+nivel[inicio.nivel].salida_y1)/2;
    loop
        x=x0-scroll.x0;
        y=y0-scroll.y0;
        if (fget_dist(240,240,x,y)>220)
            angle=fget_angle(240,240,x,y);
            x=240+get_distx(angle,220);
            y=240+get_disty(angle,220);
            angle=0;
        end
        angulo1+=7500;
        if (get_distx(angulo1,100)>=0)
            graph=222;
        else
            graph=0;
        end
        frame;
    end
end

// -------------------------------------------------------------------------
// Pantalla de Game Over
// -------------------------------------------------------------------------

function game_over()

begin
    put_screen(0,28);
    fade_on();
    repeat
        frame;
    until (ascii!=0 or mouse.left)
end

// -------------------------------------------------------------------------
// Finaliza el bucle de juego
// -------------------------------------------------------------------------

function fin_de_juego()

begin
    pantalla(21);
    fade_on();
    repeat
        frame;
    until (ascii!=0 or mouse.left)
end

// -------------------------------------------------------------------------
// Proceso principal de gestion de los enemigos
// En este proceso se representa y calculan todas las rutas
// y comportamiento de los enemigos
// -------------------------------------------------------------------------

process enemigo(file,munici¢n,energia,max_dist)

private
    x_dest;
    y_dest;

    num_puntos,puntos;
    struct punto[100]
        x,y;
    end

    ipunto=-1;
    dist;
    anim=0;

              // "estado"

              // 0    - Parado, solo ve al prota si est  mir ndole y en
              //        pantalla o si es disparado por este
              // 1    - Calcular una ruta en linea recta.
              // 2..5 - Paseo entre dos puntos en linea recta (ida y vuelta)
              //        con una ligera pausa en cada extremo
              //        2 pausa en punto[0]
              //        3 hacia punto[1]
              //        4 pausa en punto[1]
              //        5 hacia punto[0]
              // 6    - Calcular una ruta compleja
              // 7    - Paseo en ruta compleja hasta punto[puntos-1]
              // 8    - Calcular una ruta hasta el prota
              // 9    - Corriendo a por el prota (hasta una distancia del
              //        mismo, la m¡nima para disparar)
              // 10   - Disparando al prota (hasta morir, quedarse sin
              //        municion, o que el prota se aleje).
              // 11   - Calcular una ruta de huida
              // 12   - Sin municion, corriendo para alejarse del prota y
              //        advirtiendo a los que tienen munici¢n

    framecount=100;

    idpunto;
    idn;

begin
    repeat
        x=rand(0,1280);
        y=rand(0,960);
        dist=fget_dist(x,y,id_jugador.x,id_jugador.y+24);
    until (path_free(0,5,6,x,y) and dist>max_dist);

    switch(config[1]) // Dificultad
        case 0: // Alta
            energia+=2;
        end
        case 2: // Baja
            energia--;
        end
    end

    ctype=c_scroll;
    size=80;
    xgraph=offset enepas[9];

    idpunto=punto_radar();

    switch(rand(0,2))
        case 0: estado=0; angle=rand(0,36000); end
        case 1: estado=1; end
        case 2: estado=6; end
    end

    loop

        // Comprueba si ha muerto

        if (energia<=0)
            y-=18;
            z+=16;

            // Soltar munici¢n para el jugador

            if (rand(0,3-config[1]+inicio.nivel/3)==0)
                puntos=rand(0,3);
                switch(puntos)
                    case 0: dist=inicio.balas; end
                    case 1: dist=inicio.granadas; end
                    case 2: dist=inicio.tiros; end
                    case 3: dist=inicio.bombas; end
                end
                if (dist<max_arma[puntos])
                    dist=inicio.total[0]+inicio.total[1]+inicio.total[2]+inicio.total[3]+1;
                    if (inicio.total[puntos]*100/dist<=total_max[puntos])
                        item_arma(37+puntos,x,y);
                    end
                end
            end

            charco_sangre(angle);
            from anim=0 to 7*3;
                xgraph=offset enemue[(anim/3)*9];
                frame;
            end
            frame(16000);
            flags=4;
            frame(2000);
            if (file==3)
                if (m s_enemigo_1>0)
                    enemigo(3,nivel[inicio.nivel].tiros_1,nivel[inicio.nivel].energ¡a_1,480);
                    m s_enemigo_1--;
                end
            else
                if (m s_enemigo_2>0)
                    enemigo(4,nivel[inicio.nivel].tiros_2,nivel[inicio.nivel].energ¡a_2,480);
                    m s_enemigo_2--;
                end
            end
            e_victimas++;

            break;
        end

        // Acci¢n en funci¢n del estado actual

        switch(estado)

            // *** Parado, en observaci¢n

            case 0:
                framecount=400;
                xgraph=offset enepas[9];
                if (observar()) mensaje(rand(200,202)); end
                if (rand(0,200)==0) mensaje(rand(205,221)); end
            end

            // *** Paseando entre dos puntos

            case 1: // Calcular ruta lineal
                repeat
                    x_dest=rand(0,1280);
                    y_dest=rand(0,960);
                until(path_line(0,5,6,x_dest,y_dest) and fget_dist(x,y,x_dest,y_dest)>4)
                punto[0].x=x;
                punto[0].y=y;
                punto[1].x=x_dest;
                punto[1].y=y_dest;
                anim=rand(1,40);
                estado=2;
            end

            case 2: // Parado en el punto 0
                framecount=400;
                xgraph=offset enepas[9];
                if(--anim==0)
                    estado=3;
                end
                if (observar()) mensaje(rand(200,202)); end
                if (rand(0,200)==0) mensaje(rand(205,221)); end
            end

            case 3: // Hacia el punto 1
                framecount=200;
                if (fget_dist(x,y,punto[1].x,punto[1].y)>4)
                    angle=fget_angle(x,y,punto[1].x,punto[1].y);
                    if (anim++>=7*2) anim=0; end
                    xgraph=offset enepas[(anim/2)*9];
                    advance(4);
                else
                    xgraph=offset enepas[9];
                    estado=4;
                    anim=rand(1,40);
                end
                if (observar()) mensaje(rand(200,202)); end
                if (rand(0,200)==0) mensaje(rand(205,221)); end
            end

            case 4: // Parado en el punto 1
                framecount=400;
                xgraph=offset enepas[9];
                if(--anim==0)
                    estado=5;
                end
                if (observar()) mensaje(rand(200,202)); end
                if (rand(0,200)==0) mensaje(rand(205,221)); end
            end

            case 5: // Hacia el punto 0
                framecount=200;
                if (fget_dist(x,y,punto[0].x,punto[0].y)>4)
                    angle=fget_angle(x,y,punto[0].x,punto[0].y);
                    if (anim++>=7*2) anim=0; end
                    xgraph=offset enepas[(anim/2)*9];
                    advance(4);
                else
                    xgraph=offset enepas[9];
                    estado=2;
                    anim=rand(1,40);
                end
                if (observar()) mensaje(rand(200,202)); end
                if (rand(0,200)==0) mensaje(rand(205,221)); end
            end

            // *** Paseando en una ruta

            case 6: // Calcular ruta compleja
                repeat
                    x_dest=rand(0,1280);
                    y_dest=rand(0,960);
                until (path_free(0,5,6,x_dest,y_dest))
                num_puntos=path_find(0,0,5,6,x_dest,y_dest,offset punto,sizeof(punto));
                if (num_puntos>0)
                    puntos=num_puntos;
                    ipunto=0;
                    estado=7;
                else
                    xgraph=offset enepas[9];
                end
            end

            case 7: // Siguiendo la ruta
                framecount=200;
                dist=0;
                if (ipunto<puntos)
                    repeat
                        dist=fget_dist(x,y,punto[ipunto].x,punto[ipunto].y);
                        if (dist<=4)
                            ipunto++;
                            if (ipunto==puntos) break; end
                        end
                    until (dist>4);
                end
                if (dist>4)
                    angle=fget_angle(x,y,punto[ipunto].x,punto[ipunto].y);
                    if (anim++>=7*2) anim=0; end
                    xgraph=offset enepas[(anim/2)*9];
                    advance(4);
                else
                    estado=6;
                end
                if (observar()) mensaje(rand(200,202)); end
                if (rand(0,200)==0) mensaje(rand(205,221)); end
            end

            // *** Corriendo a por el prota

            case 8: // Calcular ruta hasta prota
                num_puntos=path_find(0,0,5,6,id_jugador.x,id_jugador.y+24,offset punto,sizeof(punto));
                if (num_puntos>0)
                    puntos=num_puntos;
                    ipunto=0;
                    estado=9;
                else
                    xgraph=offset enepas[9];
                end

                if (rand(0,8+config[1]*2)<=inicio.nivel/2) // Tira una granada
                    dist=fget_dist(x,y,id_jugador.x,id_jugador.y);
                    if (dist<220 and dist>80)
                        xgraph=offset enepas[9];
                        framecount=7000;
                        sound(sonido[11],128,256);
                        granada(x,y-18,id_jugador.x,id_jugador.y);
                    end
                end
            end

            case 9: // Correr hacia el prota
                framecount=100;
                dist=0;
                if (ipunto<puntos)
                    repeat
                        dist=fget_dist(x,y,punto[ipunto].x,punto[ipunto].y);
                        if (dist<=4)
                            ipunto++;
                            if (ipunto==puntos) break; end
                        end
                    until (dist>4);
                end
                if (dist>4)
                    angle=fget_angle(x,y,punto[ipunto].x,punto[ipunto].y);
                    if (anim++>=7*2) anim=0; end
                    xgraph=offset enecor[(anim/2)*9];
                    advance(4);
                    dist=fget_dist(x,y,id_jugador.x,id_jugador.y+24);
                    if (dist<40)
                        estado=10;
                    else
                        if (dist<80)
                            if (path_line(0,6,6,id_jugador.x,id_jugador.y+24))
                                estado=10;
                            end
                        end
                    end
                else
                    xgraph=offset enepas[9];
                    estado=10;
                end
            end

            // *** Disparando al protagonista

            case 10:
                framecount=600;
                dist=fget_dist(x,y,id_jugador.x,id_jugador.y+24);
                if (dist<40)
                    angle=fget_angle(x,y,id_jugador.x,id_jugador.y+24);
                    if (anim++>=2)
                        anim=0;
                        munici¢n--;
                        sound(sonido[10],256,256);
                        bala_enemigo(x,y-18,id_jugador.x,id_jugador.y);
                    end
                    xgraph=offset enedis[anim*9];
                else
                    if (dist>100)
                        xgraph=offset enepas[9];
                        estado=8;
                    else
                        if (path_line(0,6,6,id_jugador.x,id_jugador.y+24))
                            angle=fget_angle(x,y,id_jugador.x,id_jugador.y+24);
                            if (anim++>=2)
                                anim=0;
                                munici¢n--;
                                sound(sonido[10],256,256);
                                bala_enemigo(x,y-18,id_jugador.x,id_jugador.y);
                            end
                            xgraph=offset enedis[anim*9];
                        else
                            xgraph=offset enepas[9];
                            estado=8;
                        end
                    end
                end
                if (munici¢n==0)
                    estado=11;
                end
            end

            // *** Huyendo del protagonista

            case 11: // Calcular ruta de huida
                repeat
                    x_dest=rand(0,1280);
                    y_dest=rand(0,960);
                    dist=fget_dist(x_dest,y_dest,id_jugador.x,id_jugador.y+24);
                until (dist>480 and path_free(0,5,6,x_dest,y_dest))
                num_puntos=path_find(0,0,5,6,x_dest,y_dest,offset punto,sizeof(punto));
                if (num_puntos>0)
                    puntos=num_puntos;
                    ipunto=0;
                    estado=12;
                    mensaje(rand(202,204));
                else
                    xgraph=offset enepas[9];
                end
            end

            case 12:
                framecount=100;
                dist=0;
                if (ipunto<puntos)
                    repeat
                        dist=fget_dist(x,y,punto[ipunto].x,punto[ipunto].y);
                        if (dist<=4)
                            ipunto++;
                            if (ipunto==puntos) break; end
                        end
                    until (dist>4);
                end
                if (dist>4)
                    angle=fget_angle(x,y,punto[ipunto].x,punto[ipunto].y);
                    if (anim++>=7*2) anim=0; end
                    xgraph=offset enecor[(anim/2)*9];
                    advance(4);

                    // Avisa a los dem s

                    idn=get_id(type enemigo);
                    while (idn)
                        if (fget_dist(x,y,idn.x,idn.y)<100)
                            if (idn.estado<8)
                                idn.estado=8;
                            end
                        end
                        idn=get_id(type enemigo);
                    end
                else
                    xgraph=offset enepas[9];
                    munici¢n++;
                    estado=1;
                end
            end

        end

        z=-y;
        y-=18;
        frame(framecount);
        y+=18;
    end

    signal(idpunto,s_kill);

end

// -------------------------------------------------------------------------
// Comprueba si un enemigo ve al protagonista
// -------------------------------------------------------------------------

process observar()

private
    dist;

begin
    x=id_jugador.x;
    y=id_jugador.y+24;
    dist=fget_dist(father.x,father.y,x,y);
    if (dist<80)
        father.estado=10;
        return(1);
    end
    if (dist<220)
        angle=fget_angle(father.x,father.y,x,y);
        angle=near_angle(angle,father.angle,45000);
        if (angle==father.angle)
            father.estado=8;
            return(1);
        end
    end
    return(0);
end

// -------------------------------------------------------------------------
// Proceso que pinta el charco de sangre
// debajo de los enemigos una vez abatidos
// -------------------------------------------------------------------------

process charco_sangre(angle1)
begin
    if (config[0]) return; end
    file=1; graph=111; flags=4;
    ctype=c_scroll;
    x=father.x;
    y=father.y;
    xadvance(angle1,32);
    from size=0 to 100;
        frame;
    end
    frame(10100);
end

// -------------------------------------------------------------------------
// Proceso de gestion del protagonista
// -------------------------------------------------------------------------

process prota()

private
    x_dest;
    y_dest;
    antes_left;
    antes_right;

    num_puntos,puntos;
    struct punto[100]
        x,y;
    end

    ipunto=-1;
    dist;
    anim=0;
    num_frame;

    idn;

begin
    ctype=c_scroll;
    file=2;
    size=80;
    get_point(0,3,1,&x,&y);

    loop

        x_dest=mouse.x+scroll.x0;
        y_dest=mouse.y+scroll.y0;

        if (mouse_in(0,0,640-128,480) and antes_left)
            if (fget_dist(x,y,x_dest,y_dest)>16)
                num_puntos=path_find(0,0,5,6,x_dest,y_dest,offset punto,sizeof(punto));
                if (num_puntos>0)
                    if (not mouse.left)
                        posici¢n(x_dest,y_dest);
                        sound(sonido[7],256,256);
                    end
                    puntos=num_puntos;
                    ipunto=0;
                end
            end
        end

        if (mouse_in(0,0,640-128,480) and mouse.right and abs(x-x_dest)+abs(y-y_dest)>0)

            // Disparo

            angle=fget_angle(x,y,x_dest,y_dest);
            switch(arma_sel)
                case 0:
                    if (inicio.balas>0)
                        if (num_frame++==2*2)
                            inicio.balas--;
                            inicio.total[0]++;
                            e_munici¢n++;
                            sound(sonido[10],256,256);
                            bala(x,y-24,x_dest,y_dest);
                            num_frame=0;
                        end
                        xgraph=offset prodis[(num_frame/2)*17];
                    else
                        xgraph=offset prodis[0];
                    end
                end
                case 1:
                    if (inicio.granadas>0 and not antes_right)
                        inicio.granadas--;
                        inicio.total[1]++;
                        e_munici¢n++;
                        sound(sonido[11],256,256);
                        granada(x,y-24,x_dest,y_dest);
                        xgraph=offset anima[0];
                    else
                        xgraph=offset prodis[0];
                    end
                end
                case 2:
                    priority=-101; frame(0);
                    idn=get_id(type mirilla);
                    if (idn)
                        if (inicio.tiros>0 and not antes_right and idn.graph==29)
                            inicio.tiros--;
                            inicio.total[2]++;
                            e_munici¢n++;
                            sound(sonido[10],256,384);
                            tiro(x_dest,y_dest);
                        end
                    end
                    xgraph=offset prodis[0];

                end
                case 3:
                    if (inicio.bombas>0 and not antes_right)
                        inicio.bombas--;
                        inicio.total[3]++;
                        e_munici¢n++;
                        sound(sonido[15],256,256);
                        bomba(x,y);
                        xgraph=offset anima[0];
                    else
                        xgraph=offset prodis[0];
                    end
                end
            end

        else

            dist=0;
            if (ipunto>=0 and ipunto<puntos)
                repeat
                    dist=fget_dist(x,y,punto[ipunto].x,punto[ipunto].y);
                    if (dist<=4)
                        ipunto++;
                        if (ipunto==puntos) break; end
                    end
                until (dist>4);
            end

            if (dist>4)
                angle=fget_angle(x,y,punto[ipunto].x,punto[ipunto].y);
                if (anim++>=7*3) anim=0; end
                xgraph=offset anima[(anim/3)*17];
                advance(4);
            else
                xgraph=offset prodis[0];
            end

        end

        // Miramos si cogemos el botiquin (energia)

        idn=collision(type item_energia);
        if (idn)
            inicio.energia+=idn.energia;
            if (inicio.energia>90) inicio.energia=90; end
            signal(idn,s_kill);
            sound(sonido[9],256,256);
        end

        // Miramos si cogemos el escudo

        idn=collision(type item_escudo);
        if (idn)
            inicio.escudo+=idn.escudo;
            if (inicio.escudo>90) inicio.escudo=90; end
            signal(idn,s_kill);
            sound(sonido[9],256,256);
        end

        // Miramos si cogemos un arma

        idn=collision(type item_arma);
        if (idn)
            switch(idn.graph)
                case 37:
                    inicio.balas+=125;
                    if (inicio.balas>max_arma[0])
                        inicio.balas=max_arma[0];
                    end
                end
                case 38:
                    inicio.granadas+=10;
                    if (inicio.granadas>max_arma[1])
                        inicio.granadas=max_arma[1];
                    end
                end
                case 39:
                    inicio.tiros+=5;
                    if (inicio.tiros>max_arma[2])
                        inicio.tiros=max_arma[2];
                    end
                end
                case 40:
                    inicio.bombas+=5;
                    if (inicio.bombas>max_arma[3])
                        inicio.bombas=max_arma[3];
                    end
                end
            end
            signal(idn,s_kill);
            sound(sonido[9],256,256);
        end

        define_region(4,530,38,inicio.energia,13);
        define_region(5,530,82,inicio.escudo,13);

        // Control de los mensajes del protagonista
        // cuando esta quieto o desplazandose

        if (rand(0,250)==0)
            y-=6;
            mensaje(rand(350,369));
            y+=6;
        end

        // Control de los mensajes del protagonista
        // cuando ha matado un enemigo

        if (mensaje_matar)
            y-=6;
            mensaje(rand(300,319));
            y+=6;
            mensaje_matar=0;
        end

        antes_left=mouse.left;
        antes_right=mouse.right;
        z=-y;
        y-=24;
        frame;
        y+=24;
    end
end

// -------------------------------------------------------------------------
// Marcador de la posici¢n destino del protagonista
// -------------------------------------------------------------------------

process posicion(x,y)

begin
    ctype=c_scroll;
    file=1; graph=31; flags=4;
    from size=100 to 5 step -5;
        frame;
    end
end

// -------------------------------------------------------------------------
// Proceso que gestiona todos los sprites que se pintan en cada nivel
// con una prioridad mayor que la del resto de los graficos
// -------------------------------------------------------------------------

process recorte(graph,x,y,z)

begin
    ctype=c_scroll;
    z+=-y-graphic_info(0,graph,g_height)*7/16;
    loop
        frame;
    end
end

// -------------------------------------------------------------------------
// Gestion de las granadas
// parametros que entran
// x,y - coordenadas origen
// xdest, ydest - coordenadas destino
// -------------------------------------------------------------------------

process granada(x,y,x_dest,y_dest)

private
    vel_y=24;
    altura=24;
    angle1;
    avance;
    idn;

begin
    ctype=c_scroll;
    file=1; graph=33;
    size=33;

    resolution=10;
    x*=10; x_dest*=10;
    y*=10; y_dest*=10;

    angle1=fget_angle(x,y,x_dest,y_dest);
    avance=fget_dist(x,y,x_dest,y_dest)/50;
    sombra_granada(x,y,angle1,avance);

    angle=rand(0,360000);

    repeat
        vel_y--;
        altura+=vel_y/3;
        xadvance(angle1,avance);

        angle+=5000;

        z=-y/10;
        y-=altura*10;
        frame;
        y+=altura*10;
    until (altura<=0)

    signal(son,s_kill);
    sound(sonido[16],256,256);
    sound(sonido[16],256,256);

    size=100;
    z-=32;

    from graph=43 to 62;
        size=125;
        idn=collision(type enemigo);
        while (idn)
            sangre(idn.x,idn.y-18);
            idn.energia=0;
            idn=collision(type enemigo);
        end
        idn=collision(type explosivo);
        if (idn)
            if (idn.estado==0)
                idn.estado=1;
            end
        end
        size=100;
        idn=collision(type prota);
        if (idn)
            if (inicio.escudo>0)
                inicio.escudo-=2;
                if (rand(0,1)) inicio.energia--; end
            else
                inicio.energia-=2;
            end
            red=200; green=80; blue=80;
            fundido=2;
        end
        frame(200);
    end

end

// -------------------------------------------------------------------------
// Pinta la sombra de la granada durante el lanzamiento
// -------------------------------------------------------------------------

process sombra_granada(x,y,angle1,avance)

begin
    ctype=c_scroll;
    file=1; graph=34;
    resolution=10;
    flags=4;
    loop
        xadvance(angle1,avance);
        z=-y/10;
        frame;
    end
end

// -------------------------------------------------------------------------
// Proceso que gestiona las bombas que ponemos
// Parametros de entrada
// x,y - coordenadas que indican la posicion en la que se deja la bomba
// -------------------------------------------------------------------------

process bomba(x,y)

private
    idn;

begin
    ctype=c_scroll;
    file=1; graph=20;

    z=-y-8;
    cartucho_bomba(x,y,z);
    y-=12;

    from graph=99 to 90;
        frame(1000);
    end

    signal(son,s_kill);

    sound(sonido[17],256,256);
    explosi¢n(x,y);

    frame(600);

    red=200; green=180; blue=180;
    fundido=16;

    from angle=0 to 360000 step 20000;
        explosi¢n(x+get_distx(angle,96+16),y+get_disty(angle,64));
    end

    priority=-101;

    sound(sonido[17],256,256);
    from x=0 to 19;
        scroll.x0+=rand(-8,8);
        scroll.y0+=rand(-8,8);
        frame;
    end

end

// -------------------------------------------------------------------------
// Gesti¢n de la explosi¢n
// -------------------------------------------------------------------------

process explosi¢n(x,y)

private
    idn;

begin
    ctype=c_scroll;
    file=1; z=-y-32;
    flags=rand(0,3);
    from graph=43 to 62;
        idn=collision(type enemigo);
        while (idn)
            sangre(idn.x,idn.y-18);
            idn.energia=0;
            idn=collision(type enemigo);
        end
        idn=collision(type explosivo);
        if (idn)
            if (idn.estado==0)
                idn.estado=1;
            end
        end
        idn=collision(type prota);
        if (idn)
            if (inicio.escudo>0)
                inicio.escudo-=2;
                if (rand(0,1)) inicio.energia--; end
            else
                inicio.energia-=2;
            end
            red=200; green=80; blue=80;
            fundido=2;
        end
        frame(200);
    end

end

// -------------------------------------------------------------------------
// Gesti¢n de cada uno de los cartuchos explosivos
// -------------------------------------------------------------------------

process cartucho_bomba(x,y,z)

begin
    ctype=c_scroll;
    file=1; graph=20;
    size=50;
    loop
        frame;
    end
end

// -------------------------------------------------------------------------
// Gesti¢n de las balas del protagonista
// -------------------------------------------------------------------------

process bala(x,y,x_dest,y_dest)

private
    angle1;
    idn;

begin
    ctype=c_scroll;
    file=1; graph=32;
    angle1=fget_angle(x,y,x_dest,y_dest);
    xadvance(angle1,24);
    while (not out_region(id,0) and (map_get_pixel(0,6,x/6,y/6)==0 or rand(0,1)))
        xadvance(angle1,16);
        idn=collision(type enemigo);
        if (idn)
            sangre(x,y);
            if (idn.energia--==1)
                father.mensaje_matar=1;
            end
            if (idn.estado<8)
                idn.estado=8;
            end
            if (idn.energia>0)
                return;
            end
        end
        idn=collision(type explosivo);
        if (idn)
            if (idn.estado==0)
                idn.estado=1;
            end
        end
        frame(0);
    end
    if (map_get_pixel(0,6,x/6,y/6)<>0)
        x+=rand(-8,8);
        y+=rand(-8,8);
        if (rand(0,1)==0) pedazo(x,y); end
        flags=4; size=rand(25,100);
        sound(sonido[rand(0,6)],256,256);
        from graph=100 to 104;
            frame(200);
        end
    end
    return;
end

// -------------------------------------------------------------------------
// Gesti¢n de tiro en snipper mode (rifle)
// -------------------------------------------------------------------------

process tiro(x,y)

private
    idn;

begin
    ctype=c_scroll;
    file=1; graph=32;
    idn=collision(type enemigo);
    if (idn)
        sangre(x,y);
        idn.energia=0;
        father.mensaje_matar=1;
    end

    // Muestra el gr fico

    flags=4;
    size=rand(25,100);
    angle=rand(0,360000);
    from graph=100 to 104;
        frame(200);
    end
end

// -------------------------------------------------------------------------
// Gestiona cada uno de los disparos de los enemigos
// -------------------------------------------------------------------------

process bala_enemigo(x,y,x_dest,y_dest)

private
    angle1;
    idn;

begin
    ctype=c_scroll;
    file=1; graph=32;
    angle1=fget_angle(x,y,x_dest,y_dest);
    xadvance(angle1,24);
    while (not out_region(id,0) and (map_get_pixel(0,6,x/6,y/6)==0 or rand(0,1)))
        xadvance(angle1,16);
        idn=collision(type prota);
        if (idn)
            e_impactos++;
            sangre(x,y);
            if (inicio.escudo>0)
                inicio.escudo-=5;
                inicio.energia--;
            else
                inicio.energia-=5;
            end
            red=200;
            green=80;
            blue=80;
            fundido=1;
            return;
        end
        frame(0);
    end
end

// -------------------------------------------------------------------------
// Sangre que salpican los enemigos cuando una
// bala les impacta
// parametros de entrada
// x,y - coordenadas de la posicion origen de la sangre
// -------------------------------------------------------------------------

process sangre(x,y)

begin
    file=1;
    ctype=c_scroll;
    x+=rand(-4,4);
    y+=rand(-4,4);
    flags=4; size=rand(25,100);
    sound(sonido[12],256,256);
    if (config[0])
        from graph=100 to 104;
            y+=2;
            z=-y-24;
            frame(200);
        end
    else
        from graph=106 to 110;
            y+=2;
            z=-y-24;
            frame(200);
        end
    end
end

// -------------------------------------------------------------------------
// Proceso que gestiona los pedazos que salen al impactar
// sobre el escenario
// parametros de entrada
// x,y - coordenadas origen del que sale el pedazo
// -------------------------------------------------------------------------

process pedazo(x,y)

private
    velmax;
    vely;
    speed;

begin
    define_region(10,x-scroll.x0-8,y-scroll.y0-8,16,16);
    screen_copy(10,1,105,0,0,16,16);
    ctype=c_scroll;
    file=1; graph=105;
    size=rand(25,75);
    angle=rand(0,360000);
    velmax=rand(8,16);
    vely=rand(-4,-12);
    speed=rand(2,6);
    repeat
        advance(speed);
        y+=vely;
        frame;
        vely+=2;
    until (vely>velmax);
end

// -------------------------------------------------------------------------
// Proceso de gestion del sistema de menus
// -------------------------------------------------------------------------

function menu()

private
    opcion;

begin

    loop
        graph=44; flags=4;
        x=3180; y=960;
        resolution=10;

        pantalla(26);

        repeat

            opcion=0;
            if (mouse_in(140,188,500,188+54*5))
                opcion=(mouse.y-188)/54+1;
                switch(opcion)
                    case 1: ilumina(35,319,213); end
                    case 2: ilumina(36,318,265); end
                    case 3: ilumina(37,317,319); end
                    case 4: ilumina(38,317,373); end
                    case 5: ilumina(39,319,428); end
                end
            end

            if (key(_esc))
                opcion=6;
                break;
            end

            if (rand(0,50)==0) x+=rand(-32,32)*5; end
            if (x>3180) x-=5; end
            if (x<3180) x+=5; end

            frame;
        until (opcion!=0 && mouse.left);

        graph=0;
        resolution=0;

        switch (opcion)

            case 1: // Comenzar partida
                inicio.nivel=1;
                inicio.energia=90;
                inicio.escudo=0;
                inicio.balas=200;
                inicio.granadas=8;
                inicio.bombas=2;
                inicio.tiros=5;
                inicio.total[0]=0;
                inicio.total[1]=0;
                inicio.total[2]=0;
                inicio.total[3]=0;
                break;
            end

            case 2: // Informes
                informes();
            end

            case 3:
                configuraci¢n();
            end

            case 4: // creditos
                creditos();
            end

            case 5: // Cargar partida
                if (cargar_partida())
                    break;
                end
            end

            case 6: // exit
                inicio.nivel=0;
                pantalla(2);
                while (fading or (scan_code==0 and not mouse.left))
                    frame;
                end
                break;
            end
        end

    end
end

// -------------------------------------------------------------------------
// Dentro de los menus, opcion de informes
// (briefings de las misiones)
// -------------------------------------------------------------------------

function informes()

private
    num_nivel;
    antes;

begin
    num_nivel=1;
    informe(num_nivel);
    loop
        if (key(_esc)) break; end
        graph=0;
        if (fget_dist(mouse.x,mouse.y,316,398)<32)
            graph=32; x=316; y=398;
            if (mouse.left and not antes)
                if (num_nivel<15)
                    informe(++num_nivel);
                else
                    num_nivel=1;
                    informe(num_nivel);
                end
            end
        end
        if (fget_dist(mouse.x,mouse.y,98,399)<32)
            graph=31; x=98; y=399;
            if (mouse.left and not antes)
                if (num_nivel>1)
                    informe(--num_nivel);
                else
                    break;
                end
            end
        end
        if (fget_dist(mouse.x,mouse.y,103,443)<32)
            graph=48; x=103; y=443;
            if (mouse.left and not antes)
                break;
            end
        end
        antes=mouse.left;
        frame;
    end
end

// -------------------------------------------------------------------------
// Gesti¢n de la opci¢n de informes
// -------------------------------------------------------------------------

function informe(n£mero)

begin
    fade(180,0,0,10);
    while (fading) frame; end
    delete_text(all_text);
    load_screen("map\tokenkai\inf"+itoa(n£mero)+".pcx");
    fade(100,100,100,5);
    while (ascii!=0 or mouse.left) frame; end
end

// -------------------------------------------------------------------------
// Carga los ficheros gr ficos y fuentes utilizados en los men£s
// -------------------------------------------------------------------------

function inicia_menu()

begin
    set_fps(35,4);
    load_fpg("tokenkai\menusdf.fpg");
    load_fnt("tokenkai\toten2.fnt");
    load_fnt("tokenkai\toten3.fnt");
    load_song("mod\tokenkai\token.s3m",1);
    song(0);
    mouse.file=0;
    mouse.graph=30;
    fade_on();
end

// -------------------------------------------------------------------------
// Descarga los fuentes y ficheros graficos utilizados en los men£s
// -------------------------------------------------------------------------

function finaliza_menu()

begin
    stop_song();
    unload_song(0);
    unload_fnt(2);
    unload_fnt(1);
    unload_fpg(0);
end

// -------------------------------------------------------------------------
// Pantallas de presentaci¢n
// -------------------------------------------------------------------------

function presentaci¢n()

begin
    put_screen(0,27);
    repeat
        frame;
    until (ascii!=0 or mouse.left)

    fade_off();
    put_screen(0,25);
    fade_on();

    graph=25; flags=4;
    x=3200; y=2400;
    resolution=10;

    // Pantalla de presentaci¢n
    while (ascii!=0 or mouse.left) frame; end

    repeat
        if (rand(0,35)==0) x+=rand(-32,32)*5; end
        if (x>3200) x-=5; end
        if (x<3200) x+=5; end
        frame;
    until (ascii!=0 or mouse.left)
end

// -------------------------------------------------------------------------
// Pantalla de configuraci¢n
// -------------------------------------------------------------------------

function configuraci¢n()

private
    opcion;

begin
    pantalla(22);

    repeat
        opcion=0;
        if (mouse_in(538-50,436-12,538+50,436+12))
            opcion=1;
            ilumina(42,538,436);
        end
        if (key(_esc))
            opcion=2;
            break;
        end
        for (y=0;y<4;y++)
            ilumina(45,350+config[y]*67,169+68*y);
            for (x=0;x<3 and mouse.left;x++)
                if (fget_dist(mouse.x,mouse.y,350+x*67,169+68*y)<32)
                    if ((y!=0 and y!=2) or x!=2 ) config[y]=x; end
                end
            end
        end
        mouse.speed=config[3]*3;
        frame;
    until (opcion!=0 and mouse.left and not fading);
    save("dat\tokenkai\toten.cfg",offset config,sizeof(config)+sizeof(partida));
end

// -------------------------------------------------------------------------
// Gesti¢n de la cargar de partidas grabadas
// -------------------------------------------------------------------------

function cargar_partida()

private
    opcion;
    slot;

begin
    pantalla(23);
    slot=0;

    from x=0 to 7;
        if (partida[x].nivel>0)
            partida[x].texto="Nivel "+itoa(partida[x].nivel)+": Energia "+
                itoa((partida[x].energia*100)/90)+"%, Escudo "+
                itoa((partida[x].escudo*100)/90)+"%";
            write(1,141,81+x*40,0,partida[x].texto);
        else
            partida[x].texto="--- Vac¡o ---";
            write(1,141,81+x*40,0,partida[x].texto);
        end
    end
    repeat
        opcion=0;
        if (mouse_in(177,420,288,454))
            opcion=1;
            ilumina(33,233,438);
        end
        if (mouse_in(354,419,479,451))
            opcion=2;
            ilumina(34,416,434);
        end
        if (key(_esc))
            opcion=2;
            break;
        end
        if (mouse_in(129,75,587,74+40*8))
            if (mouse.left)
                slot=(mouse.y-75)/40;
            end
        end
        ilumina(43,359,95+slot*40);
        frame;
    until (opcion!=0 and mouse.left and not fading);

    if (opcion==1 and partida[slot].nivel>0)
        inicio.nivel=partida[slot].nivel;
        inicio.energia=partida[slot].energia;
        inicio.escudo=partida[slot].escudo;
        inicio.balas=partida[slot].balas;
        inicio.granadas=partida[slot].granadas;
        inicio.bombas=partida[slot].bombas;
        inicio.tiros=partida[slot].tiros;
        inicio.total[0]=partida[slot].total[0];
        inicio.total[1]=partida[slot].total[1];
        inicio.total[2]=partida[slot].total[2];
        inicio.total[3]=partida[slot].total[3];
        return(true);
    else
        return(false);
    end
end

// -------------------------------------------------------------------------
// Gesti¢n de la grabaci¢n de partidas
// -------------------------------------------------------------------------

function salvar_partida()

private
    opcion;
    slot;

begin
    pantalla(24);
    slot=0;

    from x=0 to 7;
        if (partida[x].nivel>0)
            partida[x].texto="Nivel "+itoa(partida[x].nivel)+": Energia "+
                itoa((partida[x].energia*100)/90)+"%, Escudo "+
                itoa((partida[x].escudo*100)/90)+"%";
            write(1,141,81+x*40,0,partida[x].texto);
        else
            partida[x].texto="--- Vac¡o ---";
            write(1,141,81+x*40,0,partida[x].texto);
        end
    end
    repeat
        opcion=0;
        if (mouse_in(177,420,288,454))
            opcion=1;
            ilumina(33,233,438);
        end
        if (mouse_in(354,419,479,451))
            opcion=2;
            ilumina(34,416,434);
        end
        if (key(_esc))
            opcion=2;
            break;
        end
        if (mouse_in(129,75,587,74+40*8))
            if (mouse.left)
                slot=(mouse.y-75)/40;
            end
        end
        ilumina(43,359,95+slot*40);
        frame;
    until (opcion!=0 and mouse.left and not fading);

    if (opcion==1)
        partida[slot].nivel=inicio.nivel;
        partida[slot].energia=inicio.energia;
        partida[slot].escudo=inicio.escudo;
        partida[slot].balas=inicio.balas;
        partida[slot].granadas=inicio.granadas;
        partida[slot].bombas=inicio.bombas;
        partida[slot].tiros=inicio.tiros;
        partida[slot].total[0]=inicio.total[0];
        partida[slot].total[1]=inicio.total[1];
        partida[slot].total[2]=inicio.total[2];
        partida[slot].total[3]=inicio.total[3];
        save("dat\tokenkai\toten.cfg",offset config,sizeof(config)+sizeof(partida));
    end
end

// -------------------------------------------------------------------------
// Funci¢n que comprueba si el cursor del rat¢n est  dentro de una zona
// -------------------------------------------------------------------------

function mouse_in(x,y,xfin,yfin)

begin
    if (mouse.x>=x and mouse.x<xfin and mouse.y>=y and mouse.y<yfin)
        return(1);
    else
        return(0);
    end
end

// -------------------------------------------------------------------------
// Funcion que se encarga de pintar un grafico como fondo de
// pantalla
// -------------------------------------------------------------------------

function pantalla(numero)

begin
    fade(180,0,0,10);
    while (fading) frame; end
    delete_text(all_text);
    put_screen(0,numero);
    fade(100,100,100,5);
    while (ascii!=0 or mouse.left) frame; end
end

// -------------------------------------------------------------------------
// Gesti¢n del radar en el marcador
// -------------------------------------------------------------------------

process radar()

begin
    file=1;
    graph=6;
    flags=4;
    z=-1;
    x=640-128+66;
    y=379;
    objeto(5,4,640-128+66,379,0);
    loop
        angle-=1111;
        frame;
    end
end

// -------------------------------------------------------------------------
// Objetos gr ficos que se sit£an en pantalla
// -------------------------------------------------------------------------

process objeto(graph,flags,x,y,region)

begin
    file=1;
    z=-2;
    loop
        frame;
    end
end

// -------------------------------------------------------------------------
// Snipper mode (mira telesc¢pica)
// -------------------------------------------------------------------------

process mirilla(graph)

begin
    file=1;
    flags=4; region=1;
    x=mouse.x;
    y=mouse.y;
    frame;
end

// -------------------------------------------------------------------------
// Gesti¢n del arma seleccionada
// -------------------------------------------------------------------------

process arma()

begin
    file=1; graph=13;
    z=-1;
    write_int(1,600,117,4,offset munici¢n);
    loop
        x=542+(arma_sel%2)*44;
        y=197+(arma_sel/2)*44;
        switch(arma_sel)
            case 0: munici¢n=inicio.balas; end
            case 1: munici¢n=inicio.granadas; end
            case 2: munici¢n=inicio.tiros; end
            case 3: munici¢n=inicio.bombas; end
        end
        define_region(6,579,131,(munici¢n*42)/max_arma[arma_sel],13);
        ilumina2(37+arma_sel,542,126);
        frame;
    end
end

// -------------------------------------------------------------------------
// Enciende una opci¢n
// -------------------------------------------------------------------------

process ilumina(graph,x,y)

begin
    file=0;
    frame;
end

// -------------------------------------------------------------------------
// Enciende una opci¢n
// -------------------------------------------------------------------------

process ilumina2(graph,x,y)

begin
    file=1;
    z=-130;
    frame;
end

// -------------------------------------------------------------------------
// Representaci¢n de cada enemigo como punto en el radar
// -------------------------------------------------------------------------

process punto_radar()

private
    angulo1;
    angulo2;
    dist;

begin
    angulo1=rand(0,360000);
    file=1;
    z=-3; flags=4;
    loop
        dist=fget_dist(father.x,father.y,id_jugador.x,id_jugador.y+24);
        if (dist<600)
            graph=10+get_distx(angulo1,3);
            angulo1+=15000;
            angulo2=fget_angle(id_jugador.x,id_jugador.y+24,father.x,father.y);
            dist/=12;
            x=640-128+66+get_distx(angulo2,dist);
            y=379+get_disty(angulo2,dist);
        else
            graph=0;
        end
        frame(200);
    end
end

// -------------------------------------------------------------------------
// proceso que controla el item del arma
// -------------------------------------------------------------------------

process item_arma(graph,x,y);

begin
    file=1;
    ctype=c_scroll;
    z=-y-8;
    loop
        frame;
    end
end

// -------------------------------------------------------------------------
// proceso que controla el item de la energia
// -------------------------------------------------------------------------

process item_energia(energia,x,y);

begin
    file=1; graph=35;
    ctype=c_scroll;
    z=-y;
    loop
        frame;
    end
end

// -------------------------------------------------------------------------
// proceso que controla el item del escudo
// -------------------------------------------------------------------------

process item_escudo(escudo,x,y);

begin
    file=1; graph=36;
    ctype=c_scroll;
    z=-y;
    loop
        frame;
    end
end

// -------------------------------------------------------------------------
// Control de los mensajes hablados
// -------------------------------------------------------------------------

process mensaje(graph)

private
    n;

begin

    if (father.hablando or rand(0,1) or config[2]) return; end
    father.hablando=1;
    ctype=c_scroll;
    file=1;
    priority=-1;
    z=father.z;
    x=father.x;
    y=father.y-40-18;
    frame;
    from n=1 TO 24;
        x=father.x;
        y=father.y-40;
        frame;
    end
    father.hablando=0;
end

// -------------------------------------------------------------------------
// Letrero que baja desde arriba
// -------------------------------------------------------------------------

process mensaje_mision(graph)

private
    ang;

begin
    file=1;
    x=240; y=240;
    from ang=90000 to 0 step -5000;
        y=-80+get_distx(ang,320);
        frame;
    end
    frame(4000);
    from ang=0 to 90000 step 15000;
        y=-80+get_distx(ang,320);
        frame;
    end
end

// -------------------------------------------------------------------------
// Pantalla de estadisticas
// -------------------------------------------------------------------------

function estad¡sticas()

private
    opcion;
    min,sec;
    string ttotal;
    string tenerg¡a;
    string tescudo;

begin
    fade_on();
    put_screen(0,29);
    loop
        min=timer/6000; sec=(timer%6000)/100;
        ttotal=itoa(min/10)+itoa(min%10)+":"+itoa(sec/10)+itoa(sec%10);
        tenerg¡a=itoa((inicio.energ¡a*100)/90)+"%";
        tescudo=itoa((inicio.escudo*100)/90)+"%";
        write(2,512,122,0,ttotal);
        write_int(2,512,122+34,0,offset e_victimas);
        write_int(2,512,122+34*2,0,offset e_munici¢n);
        write_int(2,512,122+34*3,0,offset e_impactos);
        write(2,512,122+34*4,0,tenergia);
        write(2,512,122+34*5,0,tescudo);
        write_int(2,512,122+34*6,0,offset inicio.balas);
        write_int(2,512,122+34*7,0,offset inicio.nivel);

        while (ascii!=0 or mouse.left)
            frame;
        end
        repeat
            opcion=0;
            if (mouse_in(338-50,436-12,338+50,436+12))
                opcion=1;
                ilumina(40,338,436);
            end
            if (mouse_in(443-50,436-12,443+50,436+12))
                opcion=2;
                ilumina(41,443,436);
            end
            if (mouse_in(553-50,436-12,553+50,436+12))
                opcion=3;
                ilumina(42,553,436);
            end
            frame;

        until (opcion!=0 and mouse.left and not fading);
        delete_text(all_text);

        switch(opcion)
            case 1:
                if (cargar_partida())
                    break;
                end
            end
            case 2:
                salvar_partida();
            end
            case 3:
                break;
            end
        end

        pantalla(29);

    end

end

// -------------------------------------------------------------------------
// Pantalla de creditos
// -------------------------------------------------------------------------

function creditos()

begin
    pantalla(1);
    loop
        if (mouse_in(559-50,451-12,559+50,451+12))
            ilumina(49,559,451);
            if (mouse.left) break; end
        end
        if (key(_esc)) break; end
        frame;
    end
end

// -------------------------------------------------------------------------
// Items que explotan cuando se les dispara (barriles y bidones)
// -------------------------------------------------------------------------

process explosivo(graph,x,y)

private
    conta;

begin
    ctype=c_scroll;
    file=1;
    z=-y-18;
    loop
        if (estado==1)
            from conta=0 to 6;
                explosi¢n(x+rand(-32,32),y+rand(-32,32));
                sound(sonido[17],256,256);
            end
            estado=2;
            graph++;
        end
        frame;
    end
end

// -------------------------------------------------------------------------
// Lancha que aparece flotando en el punto de salida
// -------------------------------------------------------------------------

process nivel1_lancha()

private
    ang;

begin
    ctype=c_scroll;
    graph=20;
    x=920;
    loop
        ang+=5000;
        y=900+get_disty(ang,6);
        frame;
    end
end


// -------------------------------------------------------------------------
