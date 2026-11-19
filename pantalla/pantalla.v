`default_nettype none

module pantalla (
    input  wire       video_activo,
    input  wire [9:0] pixel_x,
    input  wire [9:0] pixel_y,
    input  wire [9:0] raqueta1_y,
    input  wire [9:0] raqueta2_y,
    input  wire [9:0] pelota_x,
    input  wire [9:0] pelota_y,
    input  wire [3:0] score_j1,
    input  wire [3:0] score_j2,
    output reg  [1:0] rojo,
    output reg  [1:0] verde,
    output reg  [1:0] azul
);

    wire en_raqueta1 = (pixel_x >= 10'd20)  && (pixel_x <= 10'd29) &&
                       (pixel_y >= raqueta1_y) && (pixel_y <= raqueta1_y + 10'd59);

    wire en_raqueta2 = (pixel_x >= 10'd610) && (pixel_x <= 10'd619) &&
                       (pixel_y >= raqueta2_y) && (pixel_y <= raqueta2_y + 10'd59);

    wire en_pelota = (pixel_x >= pelota_x) && (pixel_x <= pelota_x + 10'd7) &&
                     (pixel_y >= pelota_y) && (pixel_y <= pelota_y + 10'd7);

    wire en_borde = (pixel_x < 10'd16) || (pixel_x >= 10'd624) || 
                    (pixel_y < 10'd16) || (pixel_y >= 10'd464);

    wire en_red = (pixel_x >= 10'd318) && (pixel_x <= 10'd321) && 
                  (pixel_y[3] == 1'b0) && (pixel_y >= 10'd16) && (pixel_y < 10'd464);

    wire en_score_j1;
    wire en_score_j2;

    marcador digito_j1 (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .box_x(10'd268),
        .box_y(10'd24),
        .digit(score_j1),
        .en_digit(en_score_j1)
    );

    marcador digito_j2 (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .box_x(10'd356),
        .box_y(10'd24),
        .digit(score_j2),
        .en_digit(en_score_j2)
    );

    always @(*) begin
        if (!video_activo) begin
            rojo  = 2'b00;
            verde = 2'b00;
            azul  = 2'b00;
        end else if (en_raqueta1 || en_raqueta2 || en_pelota || en_score_j1 || en_score_j2) begin
            rojo  = 2'b11;
            verde = 2'b11;
            azul  = 2'b11;
        end else if (en_borde || en_red) begin
            rojo  = 2'b10;
            verde = 2'b11;
            azul  = 2'b00;
        end else begin
            rojo  = 2'b00;
            verde = 2'b00;
            azul  = 2'b00;
        end
    end

endmodule