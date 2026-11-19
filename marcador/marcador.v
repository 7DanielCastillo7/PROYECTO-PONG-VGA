`default_nettype none

module marcador (
    input  wire [9:0] pixel_x,
    input  wire [9:0] pixel_y,
    input  wire [9:0] box_x,
    input  wire [9:0] box_y,
    input  wire [3:0] digit,
    output wire       en_digit
);

    wire [4:0] rel_x = pixel_x - box_x;
    wire [4:0] rel_y = pixel_y - box_y;

    wire dentro_caja = (pixel_x >= box_x) && (pixel_x < box_x + 10'd16) &&
                       (pixel_y >= box_y) && (pixel_y < box_y + 10'd28);

    wire geo_a = dentro_caja && (rel_y >= 0 && rel_y <= 2)   && (rel_x >= 1 && rel_x <= 14);
    wire geo_f = dentro_caja && (rel_y >= 1 && rel_y <= 13)  && (rel_x >= 0 && rel_x <= 2);
    wire geo_b = dentro_caja && (rel_y >= 1 && rel_y <= 13)  && (rel_x >= 13 && rel_x <= 15);
    wire geo_g = dentro_caja && (rel_y >= 12 && rel_y <= 15) && (rel_x >= 1 && rel_x <= 14);
    wire geo_e = dentro_caja && (rel_y >= 14 && rel_y <= 26) && (rel_x >= 0 && rel_x <= 2);
    wire geo_c = dentro_caja && (rel_y >= 14 && rel_y <= 26) && (rel_x >= 13 && rel_x <= 15);
    wire geo_d = dentro_caja && (rel_y >= 25 && rel_y <= 27) && (rel_x >= 1 && rel_x <= 14);

    wire A = digit[3];
    wire B = digit[2];
    wire C = digit[1];
    wire D = digit[0];

    // Ecuaciones optimizadas de Karnaugh para Ánodo Común
    wire ac_seg_a = (~A & ~B & ~C & D) | (B & ~C & ~D);
    wire ac_seg_b = (B & ~C & D) | (B & C & ~D);
    wire ac_seg_c = (~B & C & ~D);
    wire ac_seg_d = (B & ~C & ~D) | (~B & ~C & D) | (B & C & D);
    wire ac_seg_e = (~A & D) | (~A & B & ~C) | (~C & D);
    wire ac_seg_f = (~A & ~B & D) | (~B & C) | (C & D);
    wire ac_seg_g = (~A & ~B & ~C) | (B & C & D);

    assign en_digit = (geo_a && !ac_seg_a) || 
                      (geo_b && !ac_seg_b) || 
                      (geo_c && !ac_seg_c) || 
                      (geo_d && !ac_seg_d) || 
                      (geo_e && !ac_seg_e) || 
                      (geo_f && !ac_seg_f) || 
                      (geo_g && !ac_seg_g);

endmodule