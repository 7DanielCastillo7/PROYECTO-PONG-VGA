// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`default_nettype none // Exige declarar explícitamente todos los cables

module marcador (
    input  wire [9:0] pixel_x,  // Coordenada X del píxel en pantalla
    input  wire [9:0] pixel_y,  // Coordenada Y del píxel en pantalla
    input  wire [9:0] box_x,    // Posición X inicial de la caja del dígito
    input  wire [9:0] box_y,    // Posición Y inicial de la caja del dígito
    input  wire [3:0] digit,    // Dígito BCD de entrada (0..9)
    output wire       en_digit  // 1 si el píxel cae en un segmento activo
);

    wire [4:0] rel_x = pixel_x - box_x; // Desplazamiento X dentro de la caja
    wire [4:0] rel_y = pixel_y - box_y; // Desplazamiento Y dentro de la caja

    // Ventana de 16x28 píxeles asignada al dígito
    wire dentro_caja = (pixel_x >= box_x) && (pixel_x < box_x + 10'd16) &&
                       (pixel_y >= box_y) && (pixel_y < box_y + 10'd28);

    // Geometría de cada segmento (a..g) dentro de la caja de 16x28
    wire geo_a = dentro_caja && (rel_y >= 0 && rel_y <= 2)   && (rel_x >= 1 && rel_x <= 14);
    wire geo_f = dentro_caja && (rel_y >= 1 && rel_y <= 13)  && (rel_x >= 0 && rel_x <= 2);
    wire geo_b = dentro_caja && (rel_y >= 1 && rel_y <= 13)  && (rel_x >= 13 && rel_x <= 15);
    wire geo_g = dentro_caja && (rel_y >= 12 && rel_y <= 15) && (rel_x >= 1 && rel_x <= 14);
    wire geo_e = dentro_caja && (rel_y >= 14 && rel_y <= 26) && (rel_x >= 0 && rel_x <= 2);
    wire geo_c = dentro_caja && (rel_y >= 14 && rel_y <= 26) && (rel_x >= 13 && rel_x <= 15);
    wire geo_d = dentro_caja && (rel_y >= 25 && rel_y <= 27) && (rel_x >= 1 && rel_x <= 14);

    // Bits de entrada del dígito (A = MSB, D = LSB)
    wire A = digit[3];
    wire B = digit[2];
    wire C = digit[1];
    wire D = digit[0];

    // Lógica booleana simplificada mediante mapas de Karnaugh (ánodo común: 1 = apagado, 0 = encendido)
    wire ac_seg_a = (~A & ~B & ~C & D) | (B & ~C & ~D); // Karnaugh segmento a
    wire ac_seg_b = (B & ~C & D) | (B & C & ~D); // Karnaugh segmento b
    wire ac_seg_c = (~B & C & ~D); // Karnaugh segmento c
    wire ac_seg_d = (B & ~C & ~D) | (~B & ~C & D) | (B & C & D); // Karnaugh segmento d
    wire ac_seg_e = (~A & D) | (~A & B & ~C) | (~C & D); // Karnaugh segmento e
    wire ac_seg_f = (~A & ~B & D) | (~B & C) | (C & D); // Karnaugh segmento f
    wire ac_seg_g = (~A & ~B & ~C) | (B & C & D); // Karnaugh segmento g

    // Activa el píxel si está en el área del segmento y este se encuentra encendido (!ac_seg_*)
    assign en_digit = (geo_a && !ac_seg_a) || 
                      (geo_b && !ac_seg_b) || 
                      (geo_c && !ac_seg_c) || 
                      (geo_d && !ac_seg_d) || 
                      (geo_e && !ac_seg_e) || 
                      (geo_f && !ac_seg_f) || 
                      (geo_g && !ac_seg_g);

endmodule