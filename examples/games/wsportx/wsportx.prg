COMPILEr_OPTIONS _ignore_errors;
//-----------------------------------------------------------------------
//             E X T R E M E   W A T E R   S P O R T S
//
//
//-----------------------------------------------------------------------
PROGRAM wsports;
CONST
    inicio_lancha_x=4500;       // EN x DIF. DE 2000;
    inicio_lancha_y=4500;       // EN Y DIF 3100
    rayasdurezas=3;
    tama¤odureza=200;
    anchodureza=620;
    dentrodureza=0;
    retraso_pies=-5;
    retraso_camara=400;
    pos_rampa=6600;
    limite_facil=4400;
    pos_rampa_x=4500;
    limite_pasillo_der=4000;
    limite_pasillo_izq=4080;
    limite_pasillo_y=5100;
    mirar_rampa=100;
GLOBAL


    STRUCT jump_class[5];
        nombre;
        distancia;
    END=
        "TONY MARSHALL",250,
        "JAMES GROBIKER",220,
        "CHARLES DIRALL",200,
        "DANY BROWN",190,
        "BILLY KITININ",180;

    STRUCT jump_class_wom[5];
        nombre;
        distancia;
    END=
        "TANIA MARSHALL",250,
        "MIRELLE GROBIKER",220,
        "CINDY DIRALL",200,
        "SHARON GATES",190,
        "KIM KITININ",180;



    STRUCT estados_fisica[2];   // 0 - Parado
                                // 1 - Moviendose a la der.
                                // 2 - Moviendose a la izq.
        teclas[4];      // 0 - Sin tecla
                        // 1 - Pulsada tecla derecha.
                        // 2 - Pulsada tecla izquierda.
                        // 3 - Pulsada tecla derecha+control.
                        // 4 - Pulsada tecla izquierda+control.
    END=
        0,1,2,3,4,
        7,1,7,3,7,
        7,7,2,7,4;

    // Letras para usar con el nombre
    simbolos_ascii[]=
    "X","X","X","X","X","X","X","X",    // 0-7
    "X","X","X","X","X","X","X","X",    // 8-15
    "X","X","X","X","X","X","X","X",    // 16-23
    "X","X","X","X","X","X","X","X",    // 24-31
    " ","!","X","#","$","%","&","'",    // 32-39
    "(",")","*","+",",","-",".","/",    // 40-47
    "0","1","2","3","4","5","6","7",    // 48-55
    "8","9",":",";","<","=",">","?",    // 56-63
    "@","A","B","C","D","E","F","G",    // 64-71
    "H","I","J","K","L","M","N","O",    // 72-79
    "P","Q","R","S","T","U","V","W",    // 80-87
    "X","Y","Z","[","\","]","^","_",    // 88-95
    "`","a","b","c","d","e","f","g",    // 96-103
    "h","i","j","k","l","m","n","o",    // 104-111
    "p","q","r","s","t","u","v","w",    // 112-119
    "x","y","z","{","|","}","~","X",    // 120-127
    "c","u","e","a","a","a","a","c",    // 128-135
    "e","e","e","i","i","i","a","a",    // 136-143
    "e","X","C","X","o","o","u","u",    // 144-151
    "y","o","u","c","X","X","X","X",    // 152-159
    "a","i","o","u","¤","¥","¦","§",    // 160-167
    "¨","©","ª","«","¬","­","®","¯",    // 168-175
    "°","±","²","X","X","X","X","X",    // 176-183
    "X","X","X","X","X","X","X","X",    // 184-191
    "X","X","X","X","X","X","X","X",    // 192-199
    "X","X","X","X","X","X","X","X",    // 200-207
    "X","X","X","X","X","X","X","X",    // 208-215
    "X","X","X","Û","Ü","Ý","Þ","ß",    // 216-223
    "X","X","X","X","X","X","X","X",    // 224-231
    "X","X","X","X","X","X","X","X",    // 232-239
    "X","X","X","X","X","X","X","X",    // 240-247
    "X","X","X","X","X","X","X","X";    // 248-255

    STRUCT nombre;
        letras[13];
    END=
        80,108,97,121,101,
        114,45,49,45,32,
        32,32,32,32;

    longiname=10;
    tipojuego=0;
    tipoprota=0;
    tipodificultad=0;
    tipomodalidad=1;
    tiposexo=0;
    finjuego=0;
    estas_seguro=0;
    seleccionmenu;

    file1,file2,file3,file4,file5,file6,file7,file9,file10,file11,file12,file13,file14,file15;
    font1,font2,font3,font4,font5,font6,font7;
    mapa1;
    idsonido[13];

    idlancha=0;
    idcamara=0;
    idprota=0;
    idprota_c=0;
    px,py;
    cuerdasfase[]=750,720,660,600,580,540,500,480;
    nmanga;
    estado_tour;
    barca_parada;
    ultimavista=0;
    pangle=90000;
    dist_camara2=1200;

    // Parametros guardados en el archivo .DAT
    //      !!!   N O   T O C A R   !!!

    dist_boyas_en_x=286;
    dist_boyas_en_y=740;
    e_desplaz_camara=1;
    dist_camara=940;
    dist_final_cuerda=510;

    paso_aceleracion1=400;
    paso_aceleracion2=250;

    velocidad_lancha=13;
    altura_camara=112;
    max_velocidad0=2600;
    velocidad_decremento=100;

    // Fin de archivos guardados en el archivo .DAT

    max_velocidad=1200;
    max_velocidad2=1800;

    si_giro=0;
    mueve_giro=0;
    ini_mueve_g=0;

    impulso_salida=500;

    velocidad;
    aceleracion;
    ultima_velocidad;

    cambia_de_lado=0;
    salta_animacion=0;
    si_estados_nuevos=0;
    direccion_mala=0;

    setup_on=0;

    boyashechas[8];
    estabilidad=0;
    bajada_cuerda=10;
    subida_cuerda=10;
    desarrollo_manga=0;
    se_cayo=0;

    estado_truco=-1;
    paso_aceleracion3=180;
    max_velocidad3=900;
    ultimo_tiempo=0;
    giro_inicial=0;
    en_lanzamiento=0;

    tiempo_restante;
    aceleracion_salto=0;
    incr_por_salto=0;
    corta_viento=0;
    salto_obtenido=-1;
    salto_actual=0;
    numero_salto=0;
    salto_jug[2];
    media_salto=-1;
    num_man_w=0;
    acaba_salto=0;

    saliendo_agua=0;
    buen_salto=0;
    mueve_cuerda=0;
    primeravez=0;
    es_boya=0;
    acaba_mal=0;
    subida_manos=0;
    salto_real=0;
    con_estala_pri=0;

    // variables usadas en la tienda...
    // lancha de 1 a 3
    // tabla de 1 a 5


    boat_sel=1;
    board_sel=1;

LOCAL
    contador1;
    estado;
PRIVATE
    animacartel;
    animaagua=40;
    dir_agua=1;
    pausa_inicio_juego=0;
    cc1;
    valor_suelo=8;
BEGIN
    SETUP.MASTER=32000;
    SETUP.Mixer=32000;
    SET_VOLUME();

    set_mode(m640x480);
    set_fps(25,5);
    file1=load_fpg("wsportx\wsportx5.fpg");
    load_wld("wsportx\zeenws3.wld",file1);

    font1=load_fnt("wsportx\wsportx0.fnt");
    font2=load_fnt("wsportx\wsportx2.fnt");
    font3=load_fnt("..\wsportx\wsportx4.fnt");
    font4=load_fnt("wsportx\wsportx3.fnt");
    font5=load_fnt("wsportx\wsportx5.fnt");
    font6=load_fnt("wsportx\wsportxc.fnt");
    font7=load_fnt("wsportx\wsportxd.fnt");

    tipodificultad=0;
    tiposexo=0;
    finjuego=0;
    file5=load_fpg("wsportx\wsportxd.fpg");

/*
    // Sirve pa ver el mapa de durezas....
    pinta_mapa_durezas();
    start_scroll(0,file5,995,0,0,0);
    scroll.camera=cursor_durezas();
    LOOP
        IF (mouse.right)
            BREAK;
        END
        FRAME;
    END
    stop_scroll(0);
*/
            file6=load_fpg("wsportx\publi0.fpg");
            file7=load_fpg("wsportx\publi1.fpg");
            file9=load_fpg("wsportx\publi2.fpg");
            file10=load_fpg("wsportx\cuerda.fpg");
            file11=load_fpg("wsportx\estelas.fpg");
            file12=load_fpg("wsportx\rampa.fpg");
            file13=load_fpg("wsportx\stelati.fpg");
            file14=load_fpg("wsportx\stelala.fpg");
            file15=load_fpg("wsportx\ws-cosas.fpg");

            idsonido[0]=load_pcm("wsportx\musi_ini.wav",0);
            idsonido[1]=load_pcm("wsportx\ini_voz.wav",0);
            idsonido[2]=load_pcm("wsportx\publico.wav",0);
            idsonido[3]=load_pcm("wsportx\ini_fx.wav",0);
            idsonido[4]=load_pcm("wsportx\moto_ini.wav",0);


            idsonido[5]=load_pcm("wsportx\moto_med.wav",1);
            idsonido[6]=load_pcm("wsportx\loop_agu.wav",1);

            idsonido[7]=load_pcm("wsportx\publico.wav",1);

            idsonido[8]=load_pcm("wsportx\moto_fin.wav",0);
            idsonido[9]=load_pcm("wsportx\musi_fin.wav",0);

            idsonido[10]=load_pcm("wsportx\fin_mal.wav",0);
            idsonido[11]=load_pcm("wsportx\fin_ok.wav",0);

            idsonido[12]=load_pcm("wsportx\musi_cla.wav",0);

            idsonido[13]=load_pcm("wsportx\sal_jump.wav",0);

            SWITCH (tipomodalidad)
                CASE 1:
                    file3=load_fpg("wsportx\wsportx3.fpg");
                    IF (tiposexo)
                        file2=load_fpg("wsportx\saltotia.fpg");
                    ELSE
                        file2=load_fpg("wsportx\saltotio.fpg");
                    END
                END
            END

        // Ficheros del mundo para todas las modalidades






            load("wsportx\wsportx0.dat",&dist_boyas_en_x);




    LOOP
        load_pal("wsportx\wsportx0.fpg");
        IF (finjuego<>2 AND finjuego<>6 AND finjuego<>20)
            IF (finjuego<>7)
                es_boya=0;
                primeravez=0;
                num_man_w=0;
                numero_salto=0;
                nmanga=0;
                estado_tour=0;
                salto_jug[0]=0;
                salto_jug[1]=0;
                salto_jug[2]=0;
//                menu_suscripcion();
                put_screen(file1,32);
                WHILE (scan_code<>0)
                    FRAME;
                END
                WHILE (scan_code==0)
                    FRAME;
                END

                FRAME;
                clear_screen();
                let_me_alone();
                FRAME;
                delete_text(all_text);
                fade_off();
            END
                // intro


            load ("wsportx\select.dat",&boat_sel);
            SWITCH (boat_sel)
                CASE 1:
                    file4=load_fpg("wsportx\lancha1.fpg");
                END
                CASE 2:
                    file4=load_fpg("wsportx\lancha2.fpg");
                END
                CASE 3:
                    file4=load_fpg("wsportx\lancha3.fpg");
                END
            END


            FRAME;
            idprota_c=camara_travel();
            pon_textos(tipomodalidad,tipodificultad);
            clear_screen();
            FRAME;

            fade_on();
            WHILE (scan_code<>0)
                FRAME;
            END
            sound(idsonido[12],512,256);
            cc1=0;

            WHILE (scan_code==0 AND cc1<350)
                cc1++;
                set_sector_texture(0,valor_suelo,0,-1);
                set_sector_texture(9,valor_suelo,0,-1);
                set_sector_texture(14,valor_suelo,0,-1);
                set_sector_texture(15,valor_suelo,0,-1);
                valor_suelo+=1;     // Incremento del suelo
                IF (valor_suelo>17)
                    valor_suelo=8;
                END
                FRAME;
            END
            stop_mode8(0);
            delete_text(all_text);
            stop_sound(all_sound);

            FRAME;
            let_me_alone();
            FRAME;
        END

        SWITCH (tipomodalidad)
            CASE 1:
                lancha();
                pon_rampa_ydemas();
                pon_marcadores2();
            END
        END
        desarrollo_manga=0;
        animacartel=0;
        finjuego=0;
        se_cayo=0;


/*
        // Sirve para ver el mapa de durezas
        define_region(1,40,40,80,80);
        start_scroll(0,file5,995,0,1,0);
        scroll.camera=cursor_durezas2();
*/

        WHILE (scan_code<>0)
            FRAME;
        END
        pausa_inicio_juego=0;
        estado=0;
        control_sonido();
        FRAME;
        estado=1;
        WHILE (estado<2)
            timer[0]=0;
            FRAME;
            set_sector_texture(0,valor_suelo,0,-1);
            set_sector_texture(9,valor_suelo,0,-1);
            set_sector_texture(14,valor_suelo,0,-1);
            set_sector_texture(15,valor_suelo,0,-1);
            valor_suelo+=1;     // Incremento del suelo
            IF (valor_suelo>17)
                valor_suelo=8;
            END

        END
        sound(idsonido[2],384,256);
        WHILE (scan_code==0 AND pausa_inicio_juego<120)
            timer[0]=0;
            set_sector_texture(0,valor_suelo,0,-1);
            set_sector_texture(9,valor_suelo,0,-1);
            set_sector_texture(14,valor_suelo,0,-1);
            set_sector_texture(15,valor_suelo,0,-1);
            valor_suelo+=1;     // Incremento del suelo
            IF (valor_suelo>17)
                valor_suelo=8;
            END
            IF (animacartel%20==0)
                sound(idsonido[3],256,256);
            END
            timer[0]=0;
            animacartel++;
            animacartel%=200;
            pausa_inicio_juego++;
            pon_item(320,160,9,file3,-1);
            pon_item(325,195,10+(pausa_inicio_juego/20),file3,-1);
            FRAME;
        END
        estado=3;
        direccion_mala=0;
        desarrollo_manga=1;
        idlancha.estado=1;
        idprota.estado=1;
        animacartel=0;
        animaagua=40;
        dir_agua=1;
        timer[0]=0;
        con_estala_pri=1;
        WHILE (finjuego==0)
            animacartel++;
            if (animacartel<100)
                pon_item(320,140,18,file3,-1);
            end
            IF (key(_esc))
                finjuego=5;
                barca_parada=1;
                let_me_alone();
                BREAK;
            END
            set_sector_texture(0,valor_suelo,0,-1);
            set_sector_texture(9,valor_suelo,0,-1);
            set_sector_texture(14,valor_suelo,0,-1);
            set_sector_texture(15,valor_suelo,0,-1);
            valor_suelo+=1;     // Incremento del suelo
            IF (valor_suelo>17)
                valor_suelo=8;
            END
            FRAME;
        END
        idlancha.estado=2;
        idprota.estado=2;
        WHILE (scan_code<>0)
            FRAME;
        END
        IF (finjuego==2 OR finjuego==3)
            IF (acaba_mal)

            ELSE
                sound(idsonido[11],512,256);
            END
        END
        IF (finjuego==4 OR finjuego==1 OR finjuego==20)
            IF (acaba_mal)
                sound(idsonido[10],512,256);
            END
        END
        IF (finjuego<>5)
            estado=7;
        END
        WHILE (estado==7)
            set_sector_texture(0,valor_suelo,0,-1);
            set_sector_texture(9,valor_suelo,0,-1);
            set_sector_texture(14,valor_suelo,0,-1);
            set_sector_texture(15,valor_suelo,0,-1);
            valor_suelo+=1;     // Incremento del suelo
            IF (valor_suelo>17)
                valor_suelo=8;
            END
            FRAME;
        END
        IF (finjuego==2 OR finjuego==1 OR finjuego==4 OR finjuego==20)
            cc1=0;
            WHILE (scan_code==0 AND cc1<100)
                cc1++;
                set_sector_texture(0,valor_suelo,0,-1);
                set_sector_texture(9,valor_suelo,0,-1);
                set_sector_texture(14,valor_suelo,0,-1);
                set_sector_texture(15,valor_suelo,0,-1);
                valor_suelo+=1;     // Incremento del suelo
                IF (valor_suelo>17)
                    valor_suelo=8;
                END
                IF (finjuego==2 OR finjuego==20)
                    pon_item(320,140,16,file3,-1);
                END
                IF (finjuego==1)
                    pon_item(320,140,19,file3,-1);
                END
                IF (finjuego==4)
                    pon_item(320,140,17,file3,-1);
                END
                FRAME;
            END
        END
        WHILE (scan_code<>0)
            FRAME;
        END
        stop_mode8(0);
        delete_text(all_text);
        con_estala_pri=0;
        FRAME;
        delete_text(all_text);
        let_me_alone();
        restore_type=complete_restore;
        FRAME;
        IF (tipomodalidad==1)
            pon_tabla2_0();
            FRAME;
            clear_screen();
            FRAME;
        END
        IF (finjuego==1 OR finjuego==4 OR
            finjuego==3 OR finjuego==5 OR
            finjuego==7)
            sound(idsonido[12],512,256);
            SWITCH (tipomodalidad)
                CASE 1:
                    comprueba_posicion2();
                    pon_tabla2_1();
                    FRAME;
                    clear_screen();
                    FRAME;
                END
            END
            estado_tour++;
        END
        FRAME;
        let_me_alone();
        FRAME;
        // ??? falta inicializar unas cuantas variables
        desarrollo_manga=0;
        se_cayo=0;
        pangle=90000;
        si_giro=0;
        giro_inicial=0;
        velocidad=0;
        aceleracion=0;
        en_lanzamiento=0;

        tiempo_restante=0;
        aceleracion_salto=0;
        estabilidad=0;
        salto_obtenido=-1;
        incr_por_salto=0;
        corta_viento=0;
        FRAME;
    end
END


PROCESS menu_suscripcion()
PRIVATE
    puntocolor;
BEGIN
    signal(father,s_freeze_tree);
    signal(id,s_wakeup);
    FRAME;
    file1=load_fpg("wsportx\wsportxm.fpg");
//    load_pal("wsportx\wsportxm.fpg");
    mouse.graph=992;
    mouse.file=file1;
    seleccionmenu=0;
    put_screen(file1,1);
    fade_on();
    LOOP
        s_write(font3,177,123,0);

        puntocolor=map_get_pixel(file1,991,mouse.x,mouse.y);
        SWITCH (puntocolor)
            CASE 1:
                IF (mouse.left) introduce_nombre(177,123); END
            END
            CASE 2:
                IF (mouse.left) tiposexo=0; END
            END
            CASE 3:
                IF (mouse.left) tiposexo=1; END
            END
            CASE 4:
                IF (mouse.left) tipomodalidad=0; END
            END
            CASE 5:
                IF (mouse.left) tipomodalidad=1; END
            END
            CASE 6:
                IF (mouse.left) tipomodalidad=2; END
            END
            CASE 7:
                IF (mouse.left) tipomodalidad=3; END
            END
            CASE 8:
                IF (mouse.left) tipodificultad=0; END
            END
            CASE 9:
                IF (mouse.left) tipodificultad=1; END
            END
            CASE 10:
                IF (mouse.left) tipodificultad=2; END
            END
            CASE 11:
                IF (mouse.left)
                    estas_seguro=0;
                    are_you_sure();
                    FRAME;
                    IF (estas_seguro)
                        seleccionmenu=1;
                        BREAK;
                    END
                END
            END
            CASE 12:
                IF (mouse.left OR key (_enter)) seleccionmenu=2; BREAK; END
            END
        END
        SWITCH (tiposexo)
            CASE 0: pon_item(212,146,993,file1,1); END
            CASE 1: pon_item(307,146,993,file1,1); END
        END
        SWITCH (tipodificultad)
            CASE 0: pon_item(220,290,993,file1,1); END
            CASE 1: pon_item(224,310,993,file1,1); END
            CASE 2: pon_item(226,330,993,file1,1); END
        END
        SWITCH (tipomodalidad)
            CASE 0: pon_item(213,190,993,file1,1); END
            CASE 1: pon_item(215,210,993,file1,1); END
            CASE 2: pon_item(217,230,993,file1,1); END
            CASE 3: pon_item(219,250,993,file1,1); END
        END
        FRAME;
        delete_text(all_text);
    END
    fade_off();
    clear_screen();
    delete_text(all_text);
    mouse.graph=0;
    unload_fpg(file1);
    IF (seleccionmenu)
        exit("",0);
    END
    clear_screen();
    signal(father,s_wakeup_tree);
    FRAME;

END

PROCESS s_write(fontelegido,x,y,tipodistx)
PRIVATE
    dist_x_l;
BEGIN
    IF (tipodistx==0)
        dist_x_l=12;
    ELSE
        dist_x_l=20;
    END
    FROM contador1=0 TO 13;
        write(fontelegido,x+(contador1*dist_x_l),y,4,simbolos_ascii[nombre.letras[contador1]]);
    END

END

PROCESS are_you_sure()
PRIVATE
    saliendo=0;
BEGIN
    signal(father,s_sleep_tree);
    signal(id,s_wakeup);
    delete_text(all_text);
    FRAME;
    x=320;
    y=240;
    graph=976;
    file=file1;
    z=-270;
    put_screen(file1,3);
    WHILE (saliendo==0)
        IF (mouse.left)
            IF (fget_dist(x-112,y,mouse.x,mouse.y)<=37)
                saliendo=1;
                estas_seguro=1;
            END
            IF (fget_dist(x+112,y,mouse.x,mouse.y)<=37)
                saliendo=1;
                estas_seguro=0;
            END
        END
        FRAME;
    END
    put_screen(file1,1);
    signal(father,s_wakeup_tree);
    FRAME;
END

PROCESS introduce_nombre(x,y)
PRIVATE
    animacursort=0;
BEGIN
    delete_text(all_text);
    mouse.graph=0;
    signal(father,s_freeze_tree);
    signal(id,s_wakeup);

    WHILE (scan_code<>_enter)
        FROM contador1=0 TO 13;
            write(font3,x+(contador1*12),y,4,simbolos_ascii[nombre.letras[contador1]]);
        END
        animacursort++;
        animacursort%=40;
        IF (animacursort<20)
            pon_item(x+(longiname*12),y,994,file1,1);
        END
        IF (ascii<>0 AND ascii<>13 AND ascii<>8)
            IF (longiname<13)
                nombre.letras[longiname]=ascii;
                longiname++;
            END
            ascii=0;
        END
        IF (scan_code==_backspace)
            IF (longiname>0)
                nombre.letras[longiname-1]=32;
                longiname--;
            END
            ascii=0;
        END
        FRAME;
        delete_text(all_text);
    END
    signal(father,s_wakeup_tree);
    mouse.graph=992;
    mouse.file=file1;
END

PROCESS pon_item(x,y,graph,file,z)
BEGIN
    FRAME;
END

PROCESS pon_item2(x,y,graph,file,z)
BEGIN
    LOOP
        FRAME;
    END
END

PROCESS pon_textos(cual,cual2)
PRIVATE
    idtexto[7];
    contadortex;

    textosmov[7]=
    "EXTREME WATER SPORTS",
    "(c) 1999 DIV GAMES STUDIOS",
    "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
    "START MODE",
    "modalidad",
    "dificultad",
    "PRESS ANY KEY";

    modalidadestext[4]="SLALOM","JUMP","WAKEBOARDING","TOURNAMENT";
    tipostext[4]="EASY","MEDIUM","HARD",;

    controlmovimientostext=0;

BEGIN
    textosmov[4]=modalidadestext[cual];
    textosmov[5]=tipostext[cual2];
    FROM contadortex=0 TO 6;
        idtexto[contadortex]=write(font1,960,40+(contadortex*50),4,textosmov[contadortex]);
    END
    idtexto[0]=write(font7,960,40,4,textosmov[0]);
    idtexto[1]=write(font6,960,90,4,textosmov[1]);
    move_text(idtexto[0],320,40);
    move_text(idtexto[2],320,140);

    LOOP
        SWITCH (controlmovimientostext)

            CASE 0..639:
                move_text(idtexto[1],960-controlmovimientostext,90);
            END
            CASE 640..1279:
                move_text(idtexto[3],960-(controlmovimientostext-640),190);
            END
            CASE 1280..1919:
                move_text(idtexto[4],960-(controlmovimientostext-1280),240);
            END
            CASE 1920..2559:
                move_text(idtexto[5],960-(controlmovimientostext-1920),290);
            END
            CASE 2560..3199:
                move_text(idtexto[6],960-(controlmovimientostext-2560),340);
            END
            CASE 3200..3839:
                move_text(idtexto[1],320-(controlmovimientostext-3200),90);
            END
            CASE 3840..4479:
                move_text(idtexto[3],320-(controlmovimientostext-3840),190);
            END
            CASE 4480..5119:
                move_text(idtexto[4],320-(controlmovimientostext-4480),240);
            END
            CASE 5120..5759:
                move_text(idtexto[5],320-(controlmovimientostext-5120),290);
            END
            CASE 5760..6399:
                move_text(idtexto[6],320-(controlmovimientostext-5760),340);
            END
        END
        controlmovimientostext+=10;
        controlmovimientostext%=6400;
        FRAME;
    END
END
PROCESS camara_travel()

PRIVATE
    coord_x_v[4]=2450,13200,13200,2450,2450;
    coord_y_v[4]=4110,4110,13600,13600,4110;
    contador_v=0;
    valor_suelo=8;
    prox_x,prox_y;
    angles[4]=90000,0,270000,180000,270000;
BEGIN

    clear_screen();
    FRAME;
    start_mode8(id,0,0);
//    set_fog(0,0,0,0); ojo!
    ctype=c_m8;

    contador_v=rand(0,3);

    x=coord_x_v[contador_v];
    y=coord_y_v[contador_v];

    prox_x=coord_x_v[contador_v+1];
    prox_y=coord_y_v[contador_v+1];
    z=15;
    angle=angles[contador_v];

    LOOP
        set_sector_texture(0,valor_suelo,0,-1);
        set_sector_texture(9,valor_suelo,0,-1);
        set_sector_texture(14,valor_suelo,0,-1);
        set_sector_texture(15,valor_suelo,0,-1);
        valor_suelo+=1;     // Incremento del suelo
        IF (valor_suelo>17)
            valor_suelo=8;
        END
        IF (abs(x-prox_x)>16 OR abs(y-prox_y)>16)
            x+=get_distx(fget_angle(x,y,prox_x,prox_y),16);
            y+=get_disty(fget_angle(x,y,prox_x,prox_y),16);
        ELSE
            contador_v++;
            IF (contador_v>3)
                contador_v=0;
            END
            prox_x=coord_x_v[contador_v+1];
            prox_y=coord_y_v[contador_v+1];
            angle=angles[contador_v];
        END
        FRAME;
    END
END

PROCESS lancha()

PRIVATE

     tablagraph[]=64,
                  16,15,14,13,12,11,10, 9,
                   8, 7, 6, 5, 4, 3, 2, 1,
                  64,63,62,61,60,59,58,57,
                  56,55,54,53,52,51,50,49,
                  48,47,46,45,44,43,42,41,
                  40,39,38,37,36,35,34,33,
                  32,31,30,29,28,27,26,25,
                  24,23,22,21,20,19,18,17;


BEGIN
    salto_real=0;

    acaba_mal=0;
    acaba_salto=0;

    saliendo_agua=0;
    buen_salto=0;
    idlancha=id;
    ctype=c_m8;
    radius=128;
    xgraph=&tablagraph;
    file=file4;
    angle=0;     // Angulo verdadero


    IF (tipomodalidad==1 OR (tipomodalidad==3 AND estado_tour==1))
        x=inicio_lancha_x-200;
    else
        x=inicio_lancha_x;
    end
    IF (tipomodalidad==0 OR (tipomodalidad==3 AND estado_tour==0))
        y=inicio_lancha_y-((850-cuerdasfase[nmanga])/2);
    ELSE
        y=inicio_lancha_y;
    END

    px=x;
    py=y;

    IF (tipomodalidad==2 OR (tipomodalidad==3 AND estado_tour==2))
        dist_camara2=cuerdasfase[nmanga]+100;
    ELSE
        dist_camara2=cuerdasfase[nmanga]+retraso_camara;
    END
    IF ((tipomodalidad==0 OR (tipomodalidad==3 AND estado_tour==0))
        and primeravez==0)
        primeravez=1;
        SWITCH (tipodificultad)
            CASE 0:
                nmanga=0;
            END
            CASE 1:
                nmanga=1;
            END
            CASE 2:
                nmanga=2;
            END
        END
    END
    idcamara=camara();
    idprota_c=idcamara;
    barca_parada=0;

    SWITCH (tipomodalidad)
        CASE 1:
            nmanga=0;
            dist_final_cuerda=cuerdasfase[nmanga];
            tipo_final2();
            trozo_cuerda2(dist_final_cuerda,dist_final_cuerda);  // divida en proceso....
            pon_estela_lancha_otros();
            z=0;
            velocidad_lancha=13;
        END
    END

    FROM contador1=0 TO 8;
        boyashechas[contador1]=0;
    END

    from contador1=1 to 20;
        arboles(contador1);
    end

    LOOP
//        graph=tablagraph[((((360000-get_angle(idprota_c)+angle)%360000)*64)/360000)+1];
        IF (barca_parada==0)
            IF (estado==1)
                px=x;
                py=y;
//                advance(velocidad_lancha);    // REALMENTE ES ASI
                IF (tipomodalidad==1 OR
                    ( tipomodalidad==3 AND estado_tour==1))
                    y=y+velocidad_lancha+(aceleracion_salto/40);
                ELSE
                    y=y+velocidad_lancha;
                END

            END

            IF ((y>inicio_lancha_y+6800 and finjuego==0) OR acaba_salto==1)
                barca_parada=1;
                SWITCH (tipomodalidad)
                    CASE 1:
                        salto_jug[numero_salto]=(salto_obtenido*10)/63;
                        numero_salto++;
                        IF (numero_salto>2)
                            barca_parada=1;
                            finjuego=3;
                            media_salto=(salto_jug[0]+salto_jug[1]+salto_jug[2])/3;
                        ELSE
                            barca_parada=1;
                            IF (acaba_salto)
                                finjuego=2;
                            ELSE
                                finjuego=20;
                            END
                        END
                    END
                END
            END
        END
//            y=2000;
        px=x;
        py=y;
        FRAME;
    END
END

process trozo_cuerda(cuanta,total)
PRIVATE
    zorig;
    real_pangle=0;
BEGIN
    bajada_cuerda=10;
    x=px+get_distx(pangle,total-cuanta);
    y=py+get_disty(pangle,total-cuanta);
    z=45-(((total-cuanta)*(bajada_cuerda-25+subida_manos))/total);
    zorig=z;
    ctype=c_m8;
//    graph=980+(((cuanta-1)*5)/total);
/*
    graph=980;
    file=file3;
*/
    file=file10;
    IF (cuanta>0)
        trozo_cuerda(cuanta-10,total);
    END

    LOOP

        x=px+get_distx(pangle,total-cuanta);
        y=py+get_disty(pangle,total-cuanta);
        IF (ultimavista<>2)
            z=45-(((total-cuanta)*(bajada_cuerda-25+subida_manos))/total)+rand(-1,1);
        ELSE
            z=45-(((total-cuanta)*(-55))/total)+rand(-1,1);
        END
        IF (z<=0)
            graph=0;
        ELSe
            real_pangle=pangle;
            IF (pangle<45000)
                real_pangle=45000;
            END
            IF (pangle>135000)
                real_pangle=135000;
            END
            IF (ultimavista<>2)
                graph=((((real_pangle-45000)*8)/90000))+1;
            ELSE
                IF (cuanta<150)
                    graph=0;
                ELSE
                    graph=((((real_pangle-45000)*8)/90000))+1;
                END
            END
            FRAME;
        END
    END
END

PROCESS camara()
PRIVATE
    xi,yi;
    angle2;

BEGIN
    clear_screen();
    FRAME;
    start_mode8(id,0,0);
//    set_fog(0,0,0,0); ojo!
    ctype=c_m8;

    y=idlancha.y-dist_camara2;
    x=idlancha.x;
    z=altura_camara;
    angle=270000;
    ultimavista=0;
    WHILE (idprota==0 OR idlancha==0)
        FRAME;
    END
    SWITCH (ultimavista)
        CASE 0:
            IF (tipomodalidad==2 OR (tipomodalidad==3 AND estado_tour==2))
                dist_camara2=cuerdasfase[nmanga]+100;
            ELSE
                dist_camara2=cuerdasfase[nmanga]+retraso_camara;
            END
            y=idlancha.y-dist_camara2;
            x=idlancha.x;
            z=altura_camara;
        END
        CASE 1:
            dist_camara2=300;
            y=idprota.y-dist_camara2;
            x=idprota.x;
            z=altura_camara;
        END
        CASE 2:
            dist_camara2=0;
            y=idprota.y-dist_camara2;
            x=idprota.x;
            z=100;
        END
    END
    LOOP
        z=altura_camara;
        IF (key(_f1))
            subida_manos=0;
            ultimavista=0;
            IF (tipomodalidad==2 OR (tipomodalidad==3 AND estado_tour==2))
                dist_camara2=cuerdasfase[nmanga]+100;
            ELSE
                dist_camara2=cuerdasfase[nmanga]+retraso_camara;
            END
            y=idlancha.y-dist_camara2;
            x=idlancha.x;
            z=altura_camara;
            IF (abs(idprota.x-idlancha.x)=>e_desplaz_camara)
                y=idlancha.y-dist_camara2;
                IF (idprota.x-idlancha.x<0)
                    x=idlancha.x-(abs(idprota.x-idlancha.x)-e_desplaz_camara);
                ELSE
                    x=idlancha.x+(abs(idprota.x-idlancha.x)-e_desplaz_camara);
                END
            ELSE
                y=idlancha.y-dist_camara2;

                x=idlancha.x;
            END
        END
        IF (key(_f2))
            subida_manos=0;
            ultimavista=1;
            dist_camara2=300;
            y=idprota.y-dist_camara2;
            x=idprota.x;
            z=altura_camara;
        END
        IF (key(_f3))
            IF (tipomodalidad<>2 AND tipomodalidad<>3 AND estado_tour<>2)
                ultimavista=2;
                dist_camara2=0;
                y=idprota.y-dist_camara2;
                x=idprota.x;
            END
        END

        SWITCH (ultimavista)
            CASE 0:
//                dist_camara2=cuerdasfase[nmanga]+retraso_camara;

                IF (abs(idprota.x-idlancha.x)=>e_desplaz_camara)
                    y=idlancha.y-dist_camara2;
                    IF (idprota.x-idlancha.x<0)
                        x=idlancha.x-(abs(idprota.x-idlancha.x)-e_desplaz_camara);
                    ELSE
                        x=idlancha.x+(abs(idprota.x-idlancha.x)-e_desplaz_camara);
                    END
                ELSE
                    y=idlancha.y-dist_camara2;
                    x=idlancha.x;
                END
            END
            CASE 1,2:
                y=idprota.y-dist_camara2;
                x=idprota.x;
            END
        END
        IF (tipomodalidad==1 OR (tipomodalidad==3 AND estado_tour==1))
            IF (ultimavista==2)
                z=idprota.z+100;
            ELSE
                z=100;
            END
        END
        FRAME;
    END
END

PROCESS ponmanos(cuales)
BEGIN
    file=file3;
    SWITCH (cuales)
        CASE 0:
            graph=182;
        END
        CASE 1:
            graph=181;
        END
        CASE 2:
            graph=183;
        END
    END
    x=322;
    y=400;
    z=1;
    FRAME;
END



PROCESS haz_formula(cual)

BEGIN

    SWITCH (cual)
        CASE 0:
            velocidad=0;
        END
        CASE 1:
            IF (direccion_mala==0)
                IF (velocidad+paso_aceleracion1<=max_velocidad)
                    velocidad+=paso_aceleracion1;
                ELSE
                    velocidad=max_velocidad;
                END
            ELSE
                IF (velocidad+(paso_aceleracion1/8)<=(max_velocidad/8))
                    velocidad+=(paso_aceleracion1/8);
                ELSE
                    velocidad=(max_velocidad/8);
                END
            END
        END
        CASE 2:
            IF (direccion_mala==0)
                IF (abs(velocidad-paso_aceleracion1)<=max_velocidad)
                    velocidad-=paso_aceleracion1;
                ELSE
                    velocidad=-max_velocidad;
                END
            ELSE
                IF (abs(velocidad-(paso_aceleracion1/8))<=(max_velocidad/8))
                    velocidad-=(paso_aceleracion1/8);
                ELSE
                    velocidad=-(max_velocidad/8);
                END
            END
        END
        CASE 3:
            IF (direccion_mala==0)
                IF (velocidad+(paso_aceleracion1+paso_aceleracion2)<=max_velocidad2)
                    velocidad+=(paso_aceleracion1+paso_aceleracion2);
                ELSE
                    velocidad=max_velocidad2;
                END
            ELSE
                IF (velocidad+(paso_aceleracion1/8)<=(max_velocidad/8))
                    velocidad+=(paso_aceleracion1/8);
                ELSE
                    velocidad=(max_velocidad/8);
                END
            END
        END
        CASE 4:
            IF (direccion_mala==0)
                IF (abs(velocidad-(paso_aceleracion1+paso_aceleracion2))<=max_velocidad2)
                    velocidad-=(paso_aceleracion1+paso_aceleracion2);
                ELSE
                    velocidad=-max_velocidad2;
                END
            ELSE
                IF (abs(velocidad-(paso_aceleracion1/8))<=(max_velocidad/8))
                    velocidad-=(paso_aceleracion1/8);
                ELSE
                    velocidad=-(max_velocidad/8);
                END
            END
        END
        CASE 7:
            IF (velocidad-abs(velocidad_decremento)=>0)
                velocidad-=abs(velocidad_decremento);
            ELSE
                IF (velocidad+abs(velocidad_decremento)<=0)
                    velocidad+=abs(velocidad_decremento);
                ELSE
                    velocidad=0;
                END
            END
        END
        CASE 8:
            velocidad=near_angle(velocidad,0,velocidad_decremento);
        END

        CASE 9:
            IF (velocidad+paso_aceleracion3<=max_velocidad3)
                velocidad+=paso_aceleracion3;
            ELSE
                velocidad=max_velocidad3;
            END
        END
        CASE 10:
            IF (abs(velocidad-paso_aceleracion3)<=max_velocidad3)
                velocidad-=paso_aceleracion3;
            ELSE
                velocidad=-max_velocidad3;
            END
        END
        CASE 11:
            IF (velocidad+paso_aceleracion1<=max_velocidad)
                velocidad+=paso_aceleracion1;
            ELSE
                velocidad=max_velocidad;
            END
        END
        CASE 12:
            IF (abs(velocidad-paso_aceleracion1)<=max_velocidad)
                velocidad-=paso_aceleracion1;
            ELSE
                velocidad=-max_velocidad;
            END
        END

    END
END


PROCESS mira_fisica()
BEGIN
    ctype=c_m8;
    x=2500;
    y=2500;

    LOOP
        IF (se_cayo==0)
            IF (si_giro==0 AND giro_inicial==0)
                IF (velocidad==0)
                    IF (key(_right) OR key(_left)
                        OR joy.right OR joy.left)
                        cambia_estabilidad(500,1);
                        salta_animacion=1;
                        IF (key(_right) OR joy.right)
                            IF (key (_control) OR joy.button1
                                OR joy.button2)
                                haz_formula(estados_fisica[0].teclas[3]);
                                cambia_estabilidad(1500,1);
                            ELSE
                                haz_formula(estados_fisica[0].teclas[1]);
                            END
                        ELSE
                            IF (key (_control) OR joy.button1
                                OR joy.button2)
                                haz_formula(estados_fisica[0].teclas[4]);
                                cambia_estabilidad(1500,1);
                            ELSE
                                haz_formula(estados_fisica[0].teclas[2]);
                            END
                        END
                    ELSE
                        haz_formula(estados_fisica[0].teclas[0]);
                    END
                ELSE
                    IF (velocidad<0)
                        IF (key(_right) OR key(_left)
                            OR joy.right OR joy.left)
                            cambia_estabilidad(500,1);
                            IF (key(_right) OR joy.right)
                                salta_animacion=1;
                                IF (desarrollo_manga==1)
                                    se_cayo=1;
                                END
                                IF (NOT cambia_de_lado) cambia_de_lado=1; END
                                IF (key (_control) OR joy.button1
                                    OR joy.button2)
                                    haz_formula(estados_fisica[2].teclas[3]);
                                    cambia_estabilidad(1500,1);
                                ELSE
                                    haz_formula(estados_fisica[2].teclas[1]);
                                END
                            ELSE
                                IF (key (_control) OR joy.button1
                                    OR joy.button2)
                                    haz_formula(estados_fisica[2].teclas[4]);
                                    cambia_estabilidad(1500,1);
                                ELSE
                                    haz_formula(estados_fisica[2].teclas[2]);
                                END
                            END
                        ELSE
                            IF (desarrollo_manga==1)
                                se_cayo=1;
                            END
                            salta_animacion=1;
                            haz_formula(estados_fisica[2].teclas[0]);
                        END
                    ELSE
                        IF (key(_right) OR key(_left)
                            OR joy.right OR joy.left)
                            cambia_estabilidad(500,1);
                            IF (key(_right) OR joy.right)
                                IF (key (_control) OR joy.button1
                                    OR joy.button2)
                                    cambia_estabilidad(1500,1);
                                    haz_formula(estados_fisica[1].teclas[3]);
                                ELSE
                                    haz_formula(estados_fisica[1].teclas[1]);
                                END
                            ELSE
                                salta_animacion=1;
                                IF (desarrollo_manga==1)
                                    se_cayo=1;
                                END
                                IF (NOT cambia_de_lado) cambia_de_lado=1; END
                                IF (key (_control) OR joy.button1
                                    OR joy.button2)
                                    cambia_estabilidad(1500,1);
                                    haz_formula(estados_fisica[1].teclas[4]);
                                ELSE
                                    haz_formula(estados_fisica[1].teclas[2]);
                                END
                            END
                        ELSE
                            IF (desarrollo_manga==1)
                                se_cayo=1;
                            END
                            salta_animacion=1;
                            haz_formula(estados_fisica[1].teclas[0]);
                        END
                    END
                END
                IF (tipodificultad==2)
                    cambia_estabilidad(250,0);
                    IF (key(_x))
                        estabilidad-=5000;
                    END
                    IF (key(_z))
                        estabilidad+=5000;
                    END
                    IF (abs(estabilidad)>85000)
                        se_cayo=1;
                        sound(idsonido[10],512,256);
                    END
                END
            END
        ELSE
            IF (se_cayo==2)
                IF (es_boya==0)
                    IF (tipomodalidad==3)
                        barca_parada=1;
                        finjuego=7;
                    ELSE
                        barca_parada=1;
                        finjuego=4;
                    END
                ELSE
                    IF (tipomodalidad==3)
                        barca_parada=1;
                        finjuego=7;
                    ELSE
                        barca_parada=1;
                        finjuego=1;
                    END
                END
            END
        END
        FRAME;
    END
END

PROCESS pinta_mapa_durezas();
PRIVATE
    contador2;
    contador3;
    contador4;
BEGIN

    unload_fpg(file5);
    file5=load_fpg("wsportx\wsportxd.fpg");

    // pinta boyas
    // Primero la salida...
    map_put_pixel(file5,995,440,((3400+(2*dist_boyas_en_y))/10)-1,1);
    map_put_pixel(file5,995,460,((3400+(2*dist_boyas_en_y))/10)-1,1);
    FROM contador4=1 TO rayasdurezas;
        map_put_pixel(file5,995,440,(((3400+(2*dist_boyas_en_y))/10)+contador4)-1,1);
        map_put_pixel(file5,995,460,(((3400+(2*dist_boyas_en_y))/10)+contador4)-1,1);
    END
    // pinta paredes obstaculo
    FROM contador1=0 TO 439;
        map_put_pixel(file5,995,contador1,((3400+(2*dist_boyas_en_y))/10)-1,2);
        FROM contador4=1 TO rayasdurezas;
            map_put_pixel(file5,995,contador1,(((3400+(2*dist_boyas_en_y))/10)+contador4)-1,2);
        END
    END
    FROM contador1=461 TO 1699;
        map_put_pixel(file5,995,contador1,((3400+(2*dist_boyas_en_y))/10)-1,2);
        FROM contador4=1 TO rayasdurezas;
            map_put_pixel(file5,995,contador1,(((3400+(2*dist_boyas_en_y))/10)+contador4)-1,2);
        END
    END
    // pinta paredes boya
    FROM contador1=441 TO 459;
        map_put_pixel(file5,995,contador1,((3400+(2*dist_boyas_en_y))/10)-1,3);
        FROM contador4=1 TO rayasdurezas;
            map_put_pixel(file5,995,contador1,(((3400+(2*dist_boyas_en_y))/10)+contador4)-1,3);
        END
    END

    // luego las demas...

    FROM contador2=3 TO 8:
        IF (contador2%2==1)
            map_put_pixel(file5,995,(4800-(dist_boyas_en_x))/10,((3400+(contador2*dist_boyas_en_y))/10)-1,contador2+1);
            FROM contador4=1 TO rayasdurezas;
                map_put_pixel(file5,995,(4500-(dist_boyas_en_x))/10,(((3400+(contador2*dist_boyas_en_y))/10)+contador4)-1,contador2+1);
            END
            // pinta paredes obstaculo
            FOR (contador1=0;contador1<(4500-(dist_boyas_en_x));contador1+=10)
                map_put_pixel(file5,995,contador1/10,((3400+(contador2*dist_boyas_en_y))/10)-1,contador2+1);
                FROM contador4=1 TO rayasdurezas;
                    map_put_pixel(file5,995,contador1/10,(((3400+(contador2*dist_boyas_en_y))/10)+contador4)-1,contador2+1);
                END
            END
            // pinta paredes boya
            FOR (contador1=(4500-(dist_boyas_en_x))+10;contador1<17000;contador1+=10)
                map_put_pixel(file5,995,contador1/10,((3400+(contador2*dist_boyas_en_y))/10)-1,2);
                FROM contador4=1 TO rayasdurezas;
                    map_put_pixel(file5,995,contador1/10,(((3400+(contador2*dist_boyas_en_y))/10)+contador4)-1,2);
                END
            END
            // pinta cuadrado para animacion
            FOR (contador1=(3400+(contador2*dist_boyas_en_y))-tama¤odureza;contador1<(3400+(contador2*dist_boyas_en_y))-1;contador1+=10)
                FOR (contador3=(4500-(dist_boyas_en_x))-anchodureza;contador3<(4500-(dist_boyas_en_x))+dentrodureza;contador3+=10)
                    map_put_pixel(file5,995,contador3/10,(contador1/10)-1,11+(contador2-3));
                END
            END
        ELSE
            map_put_pixel(file5,995,(4500+(dist_boyas_en_x))/10,((3400+(contador2*dist_boyas_en_y))/10)-1,contador2+1);
            FROM contador4=1 TO rayasdurezas;
                map_put_pixel(file5,995,(4500+(dist_boyas_en_x))/10,(((3400+(contador2*dist_boyas_en_y))/10)+1)-1,contador2+contador4);
            END
            // pinta paredes obstaculos
            FOR (contador1=0;contador1<(4500+(dist_boyas_en_x));contador1+=10)
                map_put_pixel(file5,995,contador1/10,((3400+(contador2*dist_boyas_en_y))/10)-1,2);
                FROM contador4=1 TO rayasdurezas;
                    map_put_pixel(file5,995,contador1/10,(((3400+(contador2*dist_boyas_en_y))/10)+contador4)-1,2);
                END
            END
            // pinta paredes boyas
            FOR (contador1=(4500+(dist_boyas_en_x))+10;contador1<17000;contador1+=10)
                map_put_pixel(file5,995,contador1/10,((3400+(contador2*dist_boyas_en_y))/10)-1,contador2+1);
                FROM contador4=1 TO rayasdurezas;
                    map_put_pixel(file5,995,contador1/10,(((3400+(contador2*dist_boyas_en_y))/10)+contador4)-1,contador2+1);
                END
            END
            // pinta cuadrado para animacion
            FOR (contador1=(3400+(contador2*dist_boyas_en_y))-tama¤odureza;contador1<(3400+(contador2*dist_boyas_en_y))-1;contador1+=10)
                FOR (contador3=(4500+(dist_boyas_en_x))-dentrodureza;contador3<(4500+(dist_boyas_en_x))+anchodureza;contador3+=10)
                    map_put_pixel(file5,995,contador3/10,(contador1/10)-1,11+(contador2-3));
                END
            END
        END
    END

    // luego la meta
    map_put_pixel(file5,995,440,(390+(9*dist_boyas_en_y))-1,1);
    map_put_pixel(file5,995,460,(390+(9*dist_boyas_en_y))-1,1);
    FROM contador4=1 TO rayasdurezas;
        map_put_pixel(file5,995,440,(390+(9*dist_boyas_en_y)+contador4)-1,1);
        map_put_pixel(file5,995,460,(390+(9*dist_boyas_en_y)+contador4)-1,1);
    END
    // pinta paredes obstaculo
    FROM contador1=0 TO 439;
        map_put_pixel(file5,995,contador1,((3400+(9*dist_boyas_en_y))/10)-1,2);
        FROM contador4=1 TO rayasdurezas;
            map_put_pixel(file5,995,contador1,(((3400+(9*dist_boyas_en_y))/10)+contador4)-1,2);
        END
    END
    FROM contador1=461 TO 1699;
        map_put_pixel(file5,995,contador1,((3400+(9*dist_boyas_en_y))/10)-1,2);
        FROM contador4=1 TO rayasdurezas;
            map_put_pixel(file5,995,contador1,(((3400+(9*dist_boyas_en_y))/10)+contador4)-1,2);
        END
    END
    // pinta paredes boya
    FROM contador1=441 TO 459;
        map_put_pixel(file5,995,contador1,((3400+(9*dist_boyas_en_y))/10)-1,10);
        FROM contador4=1 TO rayasdurezas;
            map_put_pixel(file5,995,contador1,(((3400+(9*dist_boyas_en_y))/10)+contador4)-1,10);
        END
    END
    FRAME;
END

PROCESS pon_marcadores1()
BEGIN

    pon_barra_modalidad();
    pon_barra_recorrido();
    pon_barra_estabilidad();
    pon_item2(320,440,1+nmanga,file3,-1);
    LOOP
        FRAME;
    END
END
PROCESS pon_barra_modalidad()
PRIVATE
    text_modalidades[]=
    "SLALOM","JUMP","WAKEBOARDING","TOURNAMENT";
    text_dificultad[]=
    "EASY","MEDIUM","HARD";
BEGIN
    file=file3;
    graph=24;
    x=320;
    y=50;
    write(font2,240,50,4,text_modalidades[tipomodalidad]);
    write(font2,400,50,4,text_dificultad[tipodificultad]);
    LOOP
        FRAME;
    END
END

PROCESS pon_barra_recorrido()
BEGIN
    file=file3;
    graph=22;
    x=580;
    y=380;
    pon_mu¤eco_recorrido();
    LOOP
        FRAME;
    END
END

PROCESS pon_mu¤eco_recorrido()
BEGIN
    file=file3;
    graph=23;
    x=580;
    y=380;
    LOOP
        x=580-(((idprota.x-4500)*65)/1200);
        y=472-(((idprota.y-4100)*183)/5700);
        IF (y>300 AND y<470)
            graph=23;
        ELSE
            graph=0;
        END
        IF (velocidad>0)
            angle=-90000;
        ELSE
            IF (velocidad<0)
                angle=90000;
            ELSE
                angle=0;
            END
        END
        FRAME;
    END
END

PROCESS pon_barra_estabilidad()
BEGIN
    file=file3;
    graph=20;
    x=80;
    y=440;
    pon_cursor_estabilidad();
    LOOP
        FRAME;
    END
END

PROCESS pon_cursor_estabilidad()
BEGIN
    estabilidad=0;
    file=file3;
    graph=21;
    x=80+get_distx(90000+estabilidad,50);
    y=460+get_disty(90000+estabilidad,50);
    LOOP
        x=80+get_distx(90000+estabilidad,42);
        y=460+get_disty(90000+estabilidad,42);
        FRAME;
    END
END

PROCESS cursor_durezas()
PRIVATE
    punto_leido;
BEGIN

    write_int(0,0,0,0,&x);
    write_int(0,0,10,0,&y);
    write_int(0,0,20,0,&punto_leido);

    mouse.graph=992;
    mouse.file=file2;

    LOOP
        punto_leido=map_get_pixel(file5,995,scroll.x0+mouse.x,scroll.y0+mouse.y);
        IF (mouse.x>635)
           x+=5;
        END
        IF (mouse.x<5)
           x-=5;
        END

        IF (mouse.y>475)
           y+=5;
        END
        IF (mouse.y<5)
           y-=5;
        END

        FRAME;
    END

END

PROCESS cursor_durezas2()
BEGIN
    ctype=c_scroll;
    graph=21;
    file=file3;
    size=50;
    LOOP
        x=idprota.x/10;
        y=idprota.y/10;
        FRAME;
    END
END


PROCESS se¤ales_facil(x,y,graph)
PRIVATE
    contaquita=0;
    guarda_graph;
BEGIN
    ctype=c_m8;
    guarda_graph=graph;
    file=file3;
    z=125;
    LOOP
        contaquita++;
        IF (contaquita<5)
            graph=guarda_graph;
        ELSE
            graph=0;
        END
        IF (contaquita>7)
            contaquita=0;
        END
        IF (y<idprota.y)
            BREAK;
        END
        FRAME;
    END
END



PROCESS cambia_estabilidad(cuanta,tipo)
BEGIN
     IF (tipodificultad==2)
        IF (tipo)
            If (estabilidad==0)
                IF (rand(0,1))
                    estabilidad+=cuanta;
                ELSE
                    estabilidad-=cuanta;
                END
            ELSE
                IF (estabilidad>0)
                    estabilidad+=cuanta;
                ELSE
                    estabilidad-=cuanta;
                END
            END
        ELSE
            IF (estabilidad<>0)
                IF (estabilidad>0)
                    estabilidad+=cuanta;
                ELSE
                    estabilidad-=cuanta;
                END
            END
        END
    END
    FRAME;
END

process trozo_cuerda2(cuanta,total)
PRIVATE
    zorig;
    real_pangle;
BEGIN
    mueve_cuerda=0;
    bajada_cuerda=40;
    x=px+get_distx(pangle,total-cuanta);
    y=py+get_disty(pangle,total-cuanta);
    z=55-(((total-cuanta)*(bajada_cuerda+mueve_cuerda+subida_manos))/total);
    zorig=z;
    ctype=c_m8;
//    graph=980+(((cuanta-1)*5)/total);
/*
    graph=980;
    file=file3;
*/
    file=file10;

    IF (cuanta>0)
        trozo_cuerda2(cuanta-10,total);
    END

    LOOP
        x=px+get_distx(pangle,total-cuanta);
        y=py+get_disty(pangle,total-cuanta);
        bajada_cuerda=-idprota.z-30;
        IF (ultimavista<>2)
            z=55-(((total-cuanta)*(bajada_cuerda+mueve_cuerda+subida_manos))/total)+(subida_cuerda/10);
        ELSE
            z=55-(((total-cuanta)*(bajada_cuerda+10))/total)+(subida_cuerda/10);
        END
        IF (z<=0)
            graph=0;
        ELSe
            real_pangle=pangle;
            IF (pangle<45000)
                real_pangle=45000;
            END
            IF (pangle>135000)
                real_pangle=135000;
            END
            IF (ultimavista<>2)
                graph=((((real_pangle-45000)*8)/90000))+1;
            ELSE
                IF (cuanta<150)
                    graph=0;
                ELSE
                    graph=((((real_pangle-45000)*8)/90000))+1;
                END
            END
            FRAME;
        END

        FRAME;
    END
END

PROCESS tipo_final2()
PRIVATE
    valorpunto;
BEGIN

    idprota=id;
    ctype=c_m8;             // cambio de modo8
    pangle=90000;
    graph=1;
    file=file2;
/*
    write_int(font1,0,0,0,&velocidad);
    write_int(font1,0,30,0,&valorpunto);
    write_int(font1,0,60,0,&graph);
    write_int(font1,0,90,0,&fps);

    write_int(font1,0,0,0,&x);
    write_int(font1,0,30,0,&y);

    write_int(font1,0,60,0,&aceleracion_salto);
    write_int(font1,0,90,0,&salto_obtenido);
*/
    mira_fisica2();
    priority=1;
    pangle=90000;
    x=px+get_distx(pangle,dist_final_cuerda);
    y=py-dist_final_cuerda;
    maneja_animaciones2();
    LOOP
        IF (estado==1)
            x=px+get_distx(pangle,dist_final_cuerda);
            y=py-dist_final_cuerda;
        END
        If (ultimavista==2)
            IF (velocidad==0)
                ponmanos(1);
            ELSE
                IF (velocidad<0)
                    ponmanos(0);
                ELSE
                    ponmanos(2);
                END
            END
        END
        FRAME;
    END
END


PROCESS pon_rampa_ydemas();

BEGIN
    ctype=c_m8;
    rampa(pos_rampa_x,pos_rampa);



    IF (tipodificultad==0)
        se¤ales_facil(pos_rampa_x,pos_rampa-50,926);
        FROM contador1=0 TO 2;
            se¤ales_facil(limite_pasillo_der,limite_pasillo_y+(contador1*200),925);
            se¤ales_facil(limite_pasillo_izq,limite_pasillo_y+(contador1*200),927);
        END
        se¤ales_facil(4300,limite_pasillo_y-100,927);
        se¤ales_facil(4040,limite_pasillo_y+500,925);
    END
    LOOP
        FRAME;
    END

END

PROCESS rampa(x,y);
PRIVATE
    tablagraf[]=64,
/*
                   524,525,526,527,528,529,529,530,
                   530,530,531,531,531,531,500,500,
                   500,500,500,501,501,501,501,502,
                   502,502,503,503,504,505,506,507,
                   508,509,510,511,512,513,514,515,
                   515,515,515,515,515,515,515,515,
                   516,516,516,516,516,516,516,516,
                   516,517,518,519,520,521,522,523,;

*/
                   16,15,14,13,12,11,10, 9,
                    8, 7, 6, 5, 4, 3, 2, 1,
                   64,63,62,61,60,59,58,57,
                   56,55,54,53,52,51,50,49,
                   48,47,46,45,44,43,42,41,
                   40,39,38,37,36,35,34,33,
                   32,31,30,29,28,27,26,25,
                   24,23,22,21,28,27,26,25,
                   24,23,22,21,20,19,18,17;



BEGIN
    ctype=c_m8;
    xgraph=&tablagraf;
    file=file12;
    angle=270000;
    LOOP
        FRAME;
    END
END


PROCESS maneja_animaciones()
PRIVATE
    estado_pp;
    struct tablaanimaciones0[12];
        ianimacion,fanimacion,  // Paso inicio,paso final
    END=
        1,16,
        17,32,
        33,48,
        49,76,
        77,112,
        49,76,
        113,128,
        129,144,
        145,160,
        161,176,
        177,192,
        193,208,
        209,259;

    struct tablaanimaciones1[9];
        ianimacion,fanimacion,  // Paso inicio,paso final
    END=

/*
        17,20,
        21,30,
        45,85,
        86,123,
        21,36,
        180,195,
        45,85,
        1,16,
        124,179,
        31,44;
*/

        16,31,          // Moviendose recto
        30,45,          // Giro hacia la izquierda
        74,101,         // Giro brusco cambiado.. inicial.. 103
        103,138,        // Recta vibrando
        30,35,          // Vuelta a postura inicial final
        156,170,        // Caida
        45,60,          // Primer giro brusco
        1,17,           // Salida del agua
        139,154,        // Entrada en el agua del fin
        60,76;          // Primera recta despues de giro

BEGIN
    ctype=c_m8;
    x=2500;
    y=2500;
    estado_pp=29;
//    write_int(font1,0,120,0,&estado_pp);
    LOOP
        SWITCH (estado_pp)
            CASE 0:
                // Prepara animacion
                father.graph=tablaanimaciones1[0].ianimacion;
                estado_pp=17;
            END
            CASE 1:
                // Prepara animacion
                father.graph=tablaanimaciones1[0].ianimacion;
                estado_pp=17;
            END
            CASE 2:
                // Prepara animacion

                father.graph=tablaanimaciones1[5].ianimacion;
                estado_pp=18;
            END
            CASE 3:
                // Prepara animacion
                father.graph=tablaanimaciones1[1].ianimacion;
                estado_pp=19;
                father.flags=1;
                giro_inicial=1;
            END
            CASE 4:
                // Prepara animacion
                father.graph=tablaanimaciones1[6].ianimacion;
                estado_pp=20;
                father.flags=1;
                velocidad=-((max_velocidad)/2); // Curva derecha
            END
            CASE 5:
                // Prepara animacion
                father.graph=tablaanimaciones1[9].ianimacion;
                estado_pp=21;
                velocidad=((max_velocidad)/2); // salida curva derecha
                father.flags=1;
            END
            CASE 6:
                // Prepara animacion
                father.graph=tablaanimaciones1[2].ianimacion;
                estado_pp=22;
            END
            CASE 7:
                // Prepara animacion
                father.graph=tablaanimaciones1[5].ianimacion;
                estado_pp=23;
            END
            CASE 8:
                // Prepara animacion
                father.graph=tablaanimaciones1[3].ianimacion;
                estado_pp=24;
                velocidad=-(max_velocidad/4);
                si_giro=0;
                si_estados_nuevos=1;
            END
            CASE 9:
                // Prepara animacion
                father.graph=tablaanimaciones1[2].ianimacion;
                estado_pp=25;
                IF (si_giro==1)
                    father.flags=1;
                ELSE
                    father.flags=0;
                END
            END
            CASE 10:
                // Prepara animacion
                father.graph=tablaanimaciones1[3].ianimacion;
                estado_pp=24;
                IF (si_giro==1)
                    velocidad=-(max_velocidad)/4;
                ELSE
                    velocidad=(max_velocidad)/4;
                END
                si_giro=0;
            END
            CASE 11:
                // Prepara animacion
                father.graph=tablaanimaciones1[4].fanimacion;
                estado_pp=26;
                si_estados_nuevos=0;
                si_giro=0;
            END
            CASE 12:
                // Prepara animacion
                father.graph=tablaanimaciones1[0].ianimacion;
                estado_pp=27;
            END
            CASE 13:
                // Prepara animacion
                father.graph=tablaanimaciones1[0].ianimacion;
                estado_pp=27;
            END
            CASE 14:
                // Prepara animacion
                father.graph=tablaanimaciones1[8].ianimacion;
                estado_pp=28;
            END
            CASE 15:
                // Prepara animacion
                father.graph=tablaanimaciones1[5].ianimacion;
                estado_pp=23;
            END

            CASE 30:
                // Prepara animacion
                father.graph=tablaanimaciones1[1].ianimacion;
                estado_pp=31;
                direccion_mala=1;
            END

            // Este es el estado que prepara el inicio
            CASE 29:
                // Prepara animacion
                father.graph=tablaanimaciones1[7].ianimacion;
                estado_pp=16;
                bajada_cuerda=15;
            END


            // ********************************************
            // A partir de aqui se realizan las animaciones
            // ********************************************

            CASE 16:
                IF (desarrollo_manga<>0)
                    father.z=rand(-1,1);
                    father.graph++;
                    IF (father.graph==tablaanimaciones1[7].fanimacion)
                        estado_pp=0;
                    END
                END
            END
            CASE 17:
                bajada_cuerda=-10;
                IF (velocidad==0)
                    father.graph++;
                    IF (father.graph==tablaanimaciones1[0].fanimacion)
                        estado_pp=1;
                    END
                    IF (se_cayo==1)
                        estado_pp=2;
                    END
                ELSE
                    If (velocidad<0)
                        // atencion a la zifra.. ke va justa ???
                        IF (abs(idprota.y-limite_facil)<20)
                            idprota.y=limite_facil;
                            estado_pp=3;
                        ELSE
                            velocidad=0;
                        END
                    else
                        estado_pp=30;
                    end
                END
            END
            CASE 18:
                // Si final de animacion, acaba juego
                bajada_cuerda=-10+(((father.graph-tablaanimaciones1[5].ianimacion)*(25))/(tablaanimaciones1[5].fanimacion-tablaanimaciones1[5].ianimacion));
                IF (father.graph<tablaanimaciones1[5].fanimacion)
                    father.graph++;
                ELSE
                    father.z=rand(-1,1);
                    se_cayo=2;
                    acaba_mal=1;
                    velocidad=0;
                END
            END
            CASE 19:
                // Realmente saltara en un momento dado... ???
//                bajada_cuerda=-10+(((father.graph-tablaanimaciones1[1].ianimacion)*20)/(tablaanimaciones1[1].fanimacion-tablaanimaciones1[1].ianimacion));
                father.graph++;
                IF (father.graph==tablaanimaciones1[1].fanimacion)
                    estado_pp=4;
                    IF (se_cayo==1)
                        estado_pp=2;
                    END
                END
            END
            CASE 20:
//                bajada_cuerda=15+(((father.graph-tablaanimaciones1[6].ianimacion)*(-5))/(tablaanimaciones1[6].fanimacion-tablaanimaciones1[6].ianimacion));
                father.graph++;
                IF (father.graph==tablaanimaciones1[6].fanimacion)
                    estado_pp=5;
                    IF (se_cayo==1)
                        estado_pp=2;
                    END
                END
            END
            CASE 21:
                IF (velocidad==0)
                    estado_pp=7;
                ELSE
//                    bajada_cuerda=15+(((father.graph-tablaanimaciones1[9].ianimacion)*(-15))/(tablaanimaciones1[9].fanimacion-tablaanimaciones1[9].ianimacion));
                    IF (father.graph<tablaanimaciones1[9].fanimacion)
                        father.graph++;
                    ELSE
                        father.graph=tablaanimaciones1[9].fanimacion-2:
                        father.z=rand(0,2);
                    END
               END
               IF (si_giro<>0)
                   estado_pp=6;
                   father.z=0;
               end
               IF (se_cayo==1)
                   estado_pp=2;
               END
            END

            CASE 22:
                // Falta comprobar caida estado_pp=7
                IF (se_cayo==1)
                    estado_pp=7;
                ELSE
//                    bajada_cuerda=10+(((father.graph-tablaanimaciones1[3].ianimacion)*(25))/(tablaanimaciones1[3].fanimacion-tablaanimaciones1[3].ianimacion));
                    father.graph++;
                    IF (father.graph<((tablaanimaciones1[2].fanimacion-tablaanimaciones1[2].ianimacion)/2)+tablaanimaciones1[2].ianimacion)
                        mueve_giro+=1000;
                    ELSE
                        mueve_giro-=1000;
                    END
                    IF (father.graph==tablaanimaciones1[2].fanimacion)
                        estado_pp=8;
                    END
                END
            END
            CASE 23:
                // Si final de animacion, acaba juego
                bajada_cuerda=-10+(((father.graph-tablaanimaciones1[5].ianimacion)*(25))/(tablaanimaciones1[5].fanimacion-tablaanimaciones1[5].ianimacion));
                IF (father.graph<tablaanimaciones1[5].fanimacion)
                    father.graph++;
                ELSE
                    se_cayo=2;
                    acaba_mal=1;
                    velocidad=0;
                    z=rand(-1,1);
                END
            END
            CASE 24:
//                bajada_cuerda=15+(((father.graph-tablaanimaciones1[4].ianimacion)*(-25))/(tablaanimaciones1[4].fanimacion-tablaanimaciones1[4].ianimacion));
                IF (desarrollo_manga==2)
                    desarrollo_manga=3;
                ELSE
                    if (desarrollo_manga==4)
                        IF (velocidad==0)
                            estado_pp=11;
                        ELSE
                            IF (father.graph<tablaanimaciones1[3].fanimacion)
                                father.graph++;
                            ELSE
                                father.graph=tablaanimaciones1[3].fanimacion-2;
                                father.z=rand(0,2);
                            END
                        END
                    ELSE
                        if (se_cayo==1)
                            IF (father.graph<tablaanimaciones1[3].fanimacion)
                                father.graph++;
                            ELSE
                                father.graph=tablaanimaciones1[3].fanimacion-2;
                                estado_pp=15;
                            end
                        ELSE
                            IF (father.graph<tablaanimaciones1[3].fanimacion)
                                father.graph++;
                            ELSE
                                father.graph=tablaanimaciones1[3].fanimacion-2;
                                father.z=rand(0,2);
                            end
                        END
                        IF (si_giro<>0)
                            estado_pp=9;
                            father.z=0;
                        end
                    end
                END

            END
            CASE 25:
//                bajada_cuerda=10+(((father.graph-tablaanimaciones1[5].ianimacion)*(25))/(tablaanimaciones1[5].fanimacion-tablaanimaciones1[5].ianimacion));
                father.graph++;
                IF (father.graph==tablaanimaciones1[2].fanimacion)
                    estado_pp=10;
                END
                IF (father.graph<((tablaanimaciones1[2].fanimacion-tablaanimaciones1[2].ianimacion)/2)+tablaanimaciones1[2].ianimacion)
                    mueve_giro+=1000;
                ELSE
                    mueve_giro-=1000;
                END
                IF (father.graph==tablaanimaciones1[2].fanimacion)
                    IF (desarrollo_manga==3)
                        desarrollo_manga=4;
                        IF (velocidad==0)
                            estado_pp=11;
                        ELSE
                            estado_pp=10;
                        END
                    ELSE
                        estado_pp=10;
                    END
                END

            END
            CASE 26:
                father.graph--;
                IF (father.graph==tablaanimaciones1[4].ianimacion)
                    estado_pp=12;
                END
            END
            CASE 27:
                bajada_cuerda=-10;
                // Falta comprobar si se tiene que hundir
                father.graph++;
                IF (father.graph==tablaanimaciones1[0].fanimacion)
                    IF (desarrollo_manga<>5)
                        estado_pp=13;
                    ELSE
                        estado_pp=14;
                    END
                END
            END
            CASE 28:
                // Realmente es final de manga y final de juego...
                bajada_cuerda=-10+(((father.graph-tablaanimaciones1[8].ianimacion)*(25))/(tablaanimaciones1[8].fanimacion-tablaanimaciones1[8].ianimacion));

                IF (father.graph<tablaanimaciones1[8].fanimacion)
                    IF (father.graph==((tablaanimaciones1[8].fanimacion-tablaanimaciones1[8].ianimacion)/4)+tablaanimaciones1[8].ianimacion)
                        velocidad=(max_velocidad*3)/2;
                    END
                    father.graph++;
                ELSE
                    acaba_salto=1;
                    father.z=rand(-1,1);
                END
            END
            CASE 31:
                IF (father.graph<tablaanimaciones1[1].fanimacion)
                    bajada_cuerda=-10+(((father.graph-tablaanimaciones1[1].ianimacion)*20)/(tablaanimaciones1[1].fanimacion-tablaanimaciones1[1].ianimacion));
                    father.graph++;
                ELSE
                    IF (se_cayo==1)
                        estado_pp=2;
                    END
                END
            END

        END
        // Controla las banderas ...
        SWITCH (estado_pp)
           CASE 26:
               father.flags=0;
           END
        END

        FRAME;
    END
END


process trozo_cuerda3(cuanta,total)
PRIVATE
    zorig;
    real_pangle;
BEGIN
    bajada_cuerda=10;
    x=px+get_distx(pangle,total-cuanta);
    y=py+get_disty(pangle,total-cuanta);
    bajada_cuerda=-10;
    z=75-(((total-cuanta)*bajada_cuerda)/total);
    zorig=z;
    ctype=c_m8;
/*
    graph=980;
    file=file3;
*/
    file=file10;
    IF (cuanta>10)
        trozo_cuerda3(cuanta-10,total);
    END
    LOOP
        x=px+get_distx(pangle+2500,total-cuanta);
        y=py+get_disty(pangle+2500,total-cuanta);
        IF (z<=0)
            graph=0;
        ELSe
            real_pangle=pangle+2500;
            IF (pangle<48000)
                real_pangle=48000;
            END
            IF (pangle>138000)
                real_pangle=138000;
            END
            graph=((((real_pangle-48000)*8)/90000))+1;
            FRAME;
        END

        FRAME;
    END
END
PROCESS mira_fisica2()
BEGIN
    x=2500;
    y=2500;
    ctype=c_m8;
    LOOP
        IF (idprota.estado==1)
            IF (se_cayo==0)
                IF (en_lanzamiento==0)
                    IF (key(_right) OR key (_left)
                        OR joy.right OR joy.left)
                        IF (key(_right) OR joy.right)
                            haz_formula(11);
                            cambia_estabilidad(2000,1);
                        end
                        IF (key(_left) OR joy.left)
                            haz_formula(12);
                            cambia_estabilidad(2000,1);
                        end
                        IF (aceleracion_salto>0)
                            aceleracion_salto--;
                        END
                    ELSE
                        IF (father.x<=limite_pasillo_izq AND father.x=>limite_pasillo_der)
                            IF (father.y<=pos_rampa AND father.y>=limite_pasillo_y)
                                aceleracion_salto+=8;
                                cambia_estabilidad(4000,1);
                                buen_salto=1;
                            ELSE
                                IF (aceleracion_salto=>4)
                                    aceleracion_salto-=4;
                                    cambia_estabilidad(4000,1);
                                END
                            END
                        ELSE
                            // bajar solo si ha pasado rampa
                            IF (father.y>=pos_rampa)
                                IF (aceleracion_salto>0)
                                    aceleracion_salto--;
                                END
                            ELSE
                                IF (father.y<=pos_rampa-1000)
                                    IF (aceleracion_salto>0)
                                        aceleracion_salto--;
                                    END
                                END
                            END
                        END
                        haz_formula(7);
                    END
                    IF (pangle+velocidad=>45000 AND pangle+velocidad<=135000)
                        pangle+=velocidad;
                    end
                    If (pangle<=45000)
                        pangle=45000;
                    END
                    If (pangle=>135000)
                        pangle=135000;
                    END
                ELSE
                    IF (father.y>=pos_rampa)
                        IF (rand(0,4)==0)
                            IF (rand(0,1))
                                corta_viento+=rand(3,5);
                            ELSE
                                corta_viento-=rand(3,5);
                            END
                            IF (corta_viento>50)
                                corta_viento=50;
                            END
                            IF (corta_viento<-50)
                                corta_viento=-50;
                            END
                        END
                        IF (key (_up) OR joy.up)
                            corta_viento+=5;
                            IF (corta_viento>50)
                                corta_viento=50;
                            END
                        END
                        IF (key (_down) OR joy.down)
                            corta_viento-=5;
                            IF (corta_viento<-50)
                                corta_viento=-50;
                            END
                        END
                        If (buen_salto)
                            IF (corta_viento=>-10 and corta_viento<=10)
                                aceleracion_salto+=4;
                            ELSE
                                aceleracion_salto-=4;
                                IF (tipodificultad==0)
                                    IF (corta_viento<-10)
                                        pon_item(630,360,111,file3,0);
                                    ELSE
                                        pon_item(630,440,112,file3,0);
                                    END
                                END
                            END
                        ELSE
                            IF (tipodificultad==0)
                                IF (corta_viento=>-10 and corta_viento<=10)
                                    aceleracion_salto-=2;
                                ELSE
                                    aceleracion_salto-=4;
                                    IF (corta_viento<-10)
                                        pon_item(630,360,111,file3,0);
                                    ELSE
                                        pon_item(630,440,112,file3,0);
                                    END
                                END
                            END

                        end
                    END
                END
                IF (tipodificultad==2)
                    cambia_estabilidad(1000,0);
                    IF (key(_x))
                        estabilidad-=5000;
                    END
                    IF (key(_z))
                        estabilidad+=5000;
                    END
                    IF (abs(estabilidad)>85000)
                        // El mu¤eco se cae...
                        se_cayo=1;
                        sound(idsonido[10],512,256);
                    END
                END
            ELSE
                IF (se_cayo==2)
                    salto_jug[numero_salto]=0;
                    numero_salto++;
                    IF (numero_salto>2)
                        IF (tipomodalidad==3)
                            barca_parada=1;
                            finjuego=7;
                        ELSE
                            barca_parada=1;
                            finjuego=3;
                        END
                        media_salto=(salto_jug[0]+salto_jug[1]+salto_jug[2])/3;
                    ELSE
                        barca_parada=1;
                        finjuego=2;
                    END
                END
            END
        END
        FRAME;
    END
END



PROCESS maneja_animaciones2();
PRIVATE
    estado_pp;
    pausa_salto=0;
    STRUCT tabla_animacion[7];
        f_ini,f_fin;
    END =
      137, 140,
        2,  11,
        2,  11,
       31,  74,
       75,  89,
       90, 120,
       12,  30,
       121,136;

BEGIN
    x=2500;
    y=2500;
    ctype=c_m8;
//    write_int(font1,0,120,0,&estado_pp);
    estado_pp=30;
    LOOP
        SWITCH (estado_pp)
            CASE 40:
                father.graph=tabla_animacion[7].f_ini;
                IF (father.estado)
                    estado_pp=41;
                END
            END
            CASE 41:
                mueve_cuerda=((father.graph-tabla_animacion[7].f_ini)*50)/(tabla_animacion[7].f_fin-tabla_animacion[7].f_ini);
                IF (father.graph<tabla_animacion[7].f_fin)
                    father.graph++;
                ELSE
                    father.z=rand(-1,1);
                    acaba_salto=1;
                END
            END


            CASE 30:
                subida_cuerda=-30;
                father.graph=tabla_animacion[7].f_fin;
                IF (father.estado)
                    estado_pp=31;
                END
            END
            CASE 31:
                IF (father.graph>tabla_animacion[7].f_ini)
                    father.graph--;
                ELSE
                    estado_pp=0;
                END
            END
            CASE 0:
                father.graph=tabla_animacion[0].f_ini;
                estado_pp=8;
            END
            CASE 1:
                estado_pp=9;
                father.graph=tabla_animacion[1].f_ini;
                father.flags=0;
            END
            CASE 2:
                estado_pp=10;
                father.graph=tabla_animacion[2].f_ini;
                father.flags=1;
            END
            CASE 3:
                estado_pp=10;
                father.graph=tabla_animacion[2].f_ini;
                father.flags=1;
            END
            CASE 4:
                estado_pp=9;
                father.graph=tabla_animacion[1].f_ini;
                father.flags=0;
            END
            CASE 5:
                salto_real=1;
                subida_cuerda=-150;
                estado_pp=16;
                father.graph=tabla_animacion[6].f_ini;
                en_lanzamiento=1;
            END
            CASE 6:
                father.graph=tabla_animacion[4].f_ini;
                estado_pp=13;
                en_lanzamiento=0;
            END
            CASE 7:
                estado_pp=11;
                father.graph=tabla_animacion[5].f_ini;
            END
            CASE 14:
                estado_pp=12;
                pausa_salto=0;
                father.graph=tabla_animacion[3].f_ini;
            END
            CASE 15:
                estado_pp=10;
                father.graph=tabla_animacion[2].f_ini;
                father.flags=1;
            END
            CASE 25:
                estado_pp=9;
                father.graph=tabla_animacion[2].f_ini;
                father.flags=0;
            END

            CASE 22:
                estado_pp=8;
                father.graph=tabla_animacion[0].f_ini;
                father.flags=0;
            END
            CASE 23:
                estado_pp=8;
                father.graph=tabla_animacion[0].f_ini;
                father.flags=0;
            END
            CASE 17:
                estado_pp=20;
                father.graph=tabla_animacion[1].f_fin;

            END
            CASE 18:
                estado_pp=21;
                father.graph=tabla_animacion[2].f_fin;
            END


            CASE 8:
                father.z=rand(-1,1);
                If (velocidad==0)
                    IF (father.x=>pos_rampa_x-mirar_rampa AND father.x<=pos_rampa_x+mirar_rampa AND
                        father.y=>pos_rampa-1000 AND father.y<=pos_rampa )
                        estado_pp=5;
                    ELSE
                        IF (father.graph<tabla_animacion[0].f_fin)
                            father.graph++;
                        ELSE
                            estado_pp=0;
                        END
                    END
                ELSE
                    IF (velocidad<0)
                        estado_pp=1;
                    ELSE
                        estado_pp=2;
                    END
                END
                IF (se_cayo==1)
                    estado_pp=7;
                    sound(idsonido[10],512,256);
                END
                IF (father.y>pos_rampa AND salto_obtenido<0 AND
                    se_cayo==0)
                    se_cayo=1;
                    estado_pp=7;
                END
                IF (father.y>=pos_rampa+3000)
                    estado_pp=40;
                END
            END
            CASE 9:
                IF (father.graph<tabla_animacion[1].f_fin)
                    father.graph++;
                ELSE
                    IF (father.x=>pos_rampa_x-mirar_rampa AND father.x<=pos_rampa_x+mirar_rampa AND
                        father.y=>pos_rampa-1000 AND father.y<=pos_rampa )
                        estado_pp=5;
                    ELSE
                        father.z=rand(-1,1);
                        IF (velocidad=>0)
                            IF (velocidad==0)
                                estado_pp=17;
                            ELSE
                                estado_pp=3;
                            END
                        END
                    END
                END
                IF (se_cayo==1)
                    estado_pp=17;
                    sound(idsonido[10],512,256);
                END
                IF (father.y>pos_rampa AND salto_obtenido<0 AND
                    se_cayo==0)
                    se_cayo=1;
                    estado_pp=17;
                    sound(idsonido[10],512,256);
                END
                IF (father.y>=pos_rampa+3000)
                    estado_pp=40;
                END
            END
            CASE 10:
                IF (father.graph<tabla_animacion[2].f_fin)
                    father.graph++;
                ELSE
                    father.z=rand(-1,1);
                    IF (velocidad<=0)
                        IF (velocidad==0)
                            estado_pp=18;
                        ELSE
                            estado_pp=4;
                        END
                    END
                END
                IF (se_cayo==1)
                    estado_pp=18;
                    sound(idsonido[10],512,256);
                END
                IF (father.y>pos_rampa AND salto_obtenido<0 AND
                    se_cayo==0)
                    se_cayo=1;
                    estado_pp=18;
                    sound(idsonido[10],512,256);
                END
                IF (father.y>=pos_rampa+3000)
                    estado_pp=40;
                END
            END
            CASE 11:
                mueve_cuerda=((father.graph-tabla_animacion[5].f_ini)*50)/(tabla_animacion[5].f_fin-tabla_animacion[5].f_ini);
                IF (father.graph<tabla_animacion[5].f_fin)
                    father.graph++;
                ELSE
                    father.z=rand(-1,1);
                    acaba_mal=1;
                    se_cayo=2;
                    velocidad=0;
                END
            END
            CASE 20:
                father.graph--;
                IF (father.graph<tabla_animacion[1].f_ini)
                    estado_pp=23;
                END
            END
            CASE 21:
                father.graph--;
                IF (father.graph<tabla_animacion[2].f_ini)
                    estado_pp=22;
                END
            END
            CASE 16:
                IF (father.graph<tabla_animacion[6].f_fin)
                    father.graph++;
                ELSE
                    IF (father.x=>pos_rampa_x-mirar_rampa AND father.x<=pos_rampa_x+mirar_rampa AND
                        father.y=>pos_rampa-150 AND father.y<=pos_rampa)
                        salto_real=1;
                        subida_cuerda=0;
                        estado_pp=14;
                        sound(idsonido[13],256,256);
                    END
                    father.z=rand(-1,1);
                    father.graph=tabla_animacion[6].f_fin-2;
                END
                IF (se_cayo==1)
                    subida_cuerda=0;
                    estado_pp=15;
                    sound(idsonido[10],512,256);
                END
                IF (father.y>pos_rampa AND salto_obtenido<0 AND
                    se_cayo==0)
                    sound(idsonido[10],512,256);
                    se_cayo=1;
                    estado_pp=15;
                    subida_cuerda=0;
                END
            END
            CASE 12:
                IF (father.graph<tabla_animacion[3].f_fin)
                    pausa_salto++;
                    IF (pausa_salto>1)
                        father.graph++;
                        pausa_salto=0;
                        IF (father.graph<tabla_animacion[3].f_ini+((tabla_animacion[3].f_fin-tabla_animacion[3].f_ini)/2))
                            father.z+=9;
                            subida_cuerda+=30;
                        ELSE
                            father.z-=9;
                            subida_cuerda-=30;
                        END
                    END
                ELSE
                    estado_pp=6;
                    salto_obtenido=father.y-pos_rampa;
                    IF (se_cayo==1)
                        estado_pp=7;
                    END
                END
            END
            CASE 13:
                IF (father.graph<tabla_animacion[4].f_fin)
                    father.graph++;
                ELSE
                    If (velocidad==0)
                        father.z=rand(-1,1);
                        father.graph=tabla_animacion[4].f_fin-2;
                    ELSE
                        IF (velocidad<0)
                            estado_pp=1;
                        ELSE
                            estado_pp=2;
                        END
                    END
                END
                IF (father.y>=pos_rampa+3000)
                    estado_pp=40;
                END
                IF (se_cayo==1)
                    estado_pp=7;
                END
            END
        END
        FRAME;
    END
END
PROCESS pon_marcadores2()
BEGIN
    pon_barra_modalidad2();
    pon_barra_estabilidad2();
    pon_barra_estabilidad2_0();
    LOOP
        FRAME;
    END
end

PROCESS pon_barra_modalidad2()
PRIVATE
    text_modalidades[]=
    "SLALOM","JUMP","WAKE","TOUR";
    text_dificultad[]=
    "EASY","MEDIUM","HARD";
    idtexto_s1,idtexto_s2;
    dist_pulg;
BEGIN
    file=file3;
    graph=1;
    x=320;
    y=50;
    write(font2,230,40,4,text_modalidades[tipomodalidad]);
    write(font2,410,40,4,text_dificultad[tipodificultad]);
    LOOP
        salto_actual=(idprota.y-pos_rampa);
        IF (salto_actual>0 AND salto_obtenido<0 AND salto_real==1)
            dist_pulg=(salto_actual*10)/63;
            idtexto_s1=write_int(font5,340,40,5,&dist_pulg);
            idtexto_s2=write(font5,345,40,4,"'");
        ELSE
            IF (salto_obtenido>0)
                salto_actual=salto_obtenido;
                dist_pulg=(salto_actual*10)/63;
                idtexto_s1=write_int(font5,340,40,5,&dist_pulg);
                idtexto_s2=write(font5,345,40,4,"'");
            ELSE
                idtexto_s1=-1;
            END
        END
        FRAME;
        IF (idtexto_s1<>-1)
            delete_text(idtexto_s1);
            delete_text(idtexto_s2);
        END
    END
END
PROCESS pon_barra_estabilidad2()
BEGIN
    file=file3;
    graph=105;
    x=580;
    y=400;
    flags=4;
    LOOP
        graph=105+(corta_viento/10);
        FRAME;
    END
END



PROCESS pon_barra_estabilidad2_0()
BEGIN
    file=file3;
    graph=20;
    x=80;
    y=440;
    pon_cursor_estabilidad2_0();
    LOOP
        FRAME;
    END
END

PROCESS pon_cursor_estabilidad2_0()
BEGIN
    estabilidad=0;
    file=file3;
    graph=21;
    x=80+get_distx(90000+estabilidad,50);
    y=460+get_disty(90000+estabilidad,50);
    LOOP

        x=80+get_distx(90000+estabilidad,42);
        y=460+get_disty(90000+estabilidad,42);

        FRAME;
    END
END
PROCESS pon_tabla2_0()
PRIVATE
    idmapa;
    valor_bisel;
    cc1;
BEGIN
    signal(father,s_sleep_tree);
    signal(id,s_wakeup);
    FRAME;
    WHILE (scan_code<>0)
        FRAME;
    END
    unload_fnt(font4);
    font4=load_fnt("wsportx\wsportx9.fnt");
    idmapa=load_map("wsportx\jump0.map");
    load_pal("wsportx\jump0.map");
    put_screen(0,idmapa);
    unload_map(idmapa);
    scan_code=0;
    FOR (cc1=0;cc1<numero_salto;cc1++)
        write_int(font4,490,195+(cc1*53),5,&salto_jug[cc1]);
        write(font4,500,195+(cc1*53),4,"'");
    END
    IF (numero_salto==3)
        write_int(font4,475,395,5,&media_salto);
        write(font4,485,395,4,"'");
    END
    WHILE (scan_code<>0)
        FRAME;
    END
    WHILE (scan_code==0)
        FRAME;
    END
    WHILE (scan_code<>0)
        FRAME;
    END
    unload_fnt(font4);
    font4=load_fnt("wsportx\wsportx3.fnt");
    load_pal("wsportx\wsportx0.fpg");
    signal(father,s_wakeup_tree);
    delete_text(all_text);
    clear_screen();
    FRAME;
END

PROCESS pon_tabla2_1()
PRIVATE
    idmapa;
    valor_bisel;
BEGIN
    signal(father,s_sleep_tree);
    signal(id,s_wakeup);
    WHILE (scan_code<>0)
        FRAME;
    END
    unload_fnt(font4);
    font4=load_fnt("wsportx\wsportx6.fnt");
    idmapa=load_map("wsportx\jump1.map");
    load_pal("wsportx\jump1.map");
    put_screen(0,idmapa);
    unload_map(idmapa);
    IF (tiposexo)
        FROM contador1=0 TO 4;
            valor_bisel=((4-contador1)*20)/4;
            IF (jump_class_wom[contador1].nombre<>-999)
                write(font4,150+valor_bisel,165+(contador1*50),3,jump_class_wom[contador1].nombre);
            ELSE
                s_write(font4,150+valor_bisel,165+(contador1*50),1);
            END
            write_int(font4,460+valor_bisel,165+(contador1*50),3,&jump_class_wom[contador1].distancia);

        END
    ELSE
        FROM contador1=0 TO 4;
            valor_bisel=((4-contador1)*20)/4;
            IF (jump_class[contador1].nombre<>-999)
                write(font4,150+valor_bisel,165+(contador1*50),3,jump_class[contador1].nombre);
            ELSE
                s_write(font4,150+valor_bisel,165+(contador1*50),1);
            END
            write_int(font4,460+valor_bisel,165+(contador1*50),3,&jump_class[contador1].distancia);
        END
    END
    WHILE (scan_code<>0)
        FRAME;
    END
    WHILE (scan_code==0)
        FRAME;
    END
    WHILE (scan_code<>0)
        FRAME;
    END
    unload_fnt(font4);
    font4=load_fnt("wsportx\wsportx3.fnt");
    signal(father,s_wakeup_tree);
    delete_text(all_text);
    clear_screen();
    FRAME;
END

PROCESS comprueba_posicion2()
PRIVATE
    posiciontabla=5;
BEGIN
    posiciontabla=5;
    FROM contador1=4 to 0;
        IF (tiposexo)
            IF (media_salto=>jump_class_wom[contador1].distancia)
                posiciontabla=contador1;
            END
        ELSE
            IF (media_salto=>jump_class[contador1].distancia)
                posiciontabla=contador1;
            END
        END
    END
    IF (posiciontabla<5)
        FOR (contador1=3;contador1=>posiciontabla;contador1--)
            IF (tiposexo)
                jump_class_wom[contador1+1].nombre=jump_class_wom[contador1].nombre;
                jump_class_wom[contador1+1].distancia=jump_class_wom[contador1].distancia;
            ELSE
                jump_class[contador1+1].nombre=jump_class[contador1].nombre;
                jump_class[contador1+1].distancia=jump_class[contador1].distancia;
            END
        END
        IF (tiposexo)
            jump_class_wom[posiciontabla].nombre=-999;
            jump_class_wom[posiciontabla].distancia=media_salto;
        ELSE
            jump_class[posiciontabla].nombre=-999;
            jump_class[posiciontabla].distancia=media_salto;
        END
    END
END

PROCESS pon_estela_lancha_otros();
PRIVATE
    cc1;
BEGIN
    file=file11;
    ctype=c_m8;
    graph=49;
    priority=0;
    flags=4;
    FROM cc1=1 TO 13;
        trozo_Estela_otros(cc1);
    END
    LOOP
        x=px;
        y=py;
        z=rand(1,3);
        flags=4+rand(0,3);
        IF (barca_parada==1 OR con_estala_pri==0)
            graph=0;
        ELSE
            graph=49;
        END
        FRAME;
    END
END
PROCESS trozo_Estela_otros(cual)
BEGIN
    file=file11;
    ctype=c_m8;
    graph=49-(cual/4);
    priority=-cual;
    flags=4;
    LOOP
        x=px;
        y=(py)-(cual*24);
        z=rand(1,3);
        flags=4+rand(0,3);
        IF (barca_parada==1 OR con_estala_pri==0)
            graph=0;
        ELSE
            graph=49-(cual/4);
        END
        FRAME;
    END
END

PROCESS control_sonido();
PRIVATE
    cc1;
    acabose=0;
BEGIN
//    write_int(font1,0,0,0,&cc1);

    ctype=c_m8;
    graph=0;
    x=2500;y=2500;
    WHILE (father.estado==0)
        FRAME;
    END
    LOOP
        SWITCH (cc1)
            CASE 50:
                sound(idsonido[0],512,256);
            END
            CASE 100:
                sound(idsonido[1],256,256);
            END
            CASE 150:
                father.estado=2;
            END
            CASE 350;
                sound(idsonido[4],512,256);
            END
            CASE 400;
                sound(idsonido[5],512,256);
                sound(idsonido[6],512,256);
                sound(idsonido[7],256,256);
            END
            CASE 1600:
                father.estado=6;
            END
            CASE 1700:
                father.estado=8;
            END

        END
        IF (father.estado<>3)
            cc1++;
        ELSE
            cc1=349;
            father.estado=4;
        END
        IF (barca_parada==1 AND acabose==0)
            stop_sound(all_sound);
            sound(idsonido[8],256,256);
            sound(idsonido[9],128,256);
            acabose=1;
            father.estado=5;
            cc1=1500;
        END
        FRAME;
    END
END
PROCESS arboles(cual)

begin
    ctype=c_m8;
    graph=(cual%3)+2;
    go_to_flag(cual);
    file=file15;
    loop
        frame;

    end

end
