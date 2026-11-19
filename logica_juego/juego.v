`default_nettype none

module juego (
    input  wire       sinc_v,
    input  wire       btn_j1_subir,
    input  wire       btn_j1_bajar,
    input  wire       btn_j2_subir,
    input  wire       btn_j2_bajar,
    output reg  [9:0] raqueta1_y = 10'd210,
    output reg  [9:0] raqueta2_y = 10'd210,
    output reg  [9:0] pelota_x   = 10'd320,
    output reg  [9:0] pelota_y   = 10'd240,
    output reg  [3:0] score_j1   = 4'd0,
    output reg  [3:0] score_j2   = 4'd0
);

    reg       dir_x        = 1'b1;
    reg       dir_y        = 1'b1;
    reg [3:0] pelota_speed = 4'd2;
    reg [3:0] hit_count    = 4'd0;

    always @(posedge sinc_v) begin
        // Movimiento Raqueta 1
        if (btn_j1_subir && (raqueta1_y > 10'd16))
            raqueta1_y <= raqueta1_y - 10'd4;
        else if (btn_j1_bajar && (raqueta1_y < 10'd404))
            raqueta1_y <= raqueta1_y + 10'd4;

        // Movimiento Raqueta 2
        if (btn_j2_subir && (raqueta2_y > 10'd16))
            raqueta2_y <= raqueta2_y - 10'd4;
        else if (btn_j2_bajar && (raqueta2_y < 10'd404))
            raqueta2_y <= raqueta2_y + 10'd4;

        // Detección de Gol
        if (pelota_x >= 10'd624) begin
            pelota_x     <= 10'd320;
            pelota_y     <= 10'd240;
            dir_x        <= 1'b0; 
            pelota_speed <= 4'd2;
            hit_count    <= 4'd0;
            if (score_j1 < 4'd9) score_j1 <= score_j1 + 1'b1;
            else begin score_j1 <= 4'd0; score_j2 <= 4'd0; end 
        end
        else if (pelota_x <= 10'd16) begin
            pelota_x     <= 10'd320;
            pelota_y     <= 10'd240;
            dir_x        <= 1'b1;
            pelota_speed <= 4'd2;
            hit_count    <= 4'd0;
            if (score_j2 < 4'd9) score_j2 <= score_j2 + 1'b1;
            else begin score_j1 <= 4'd0; score_j2 <= 4'd0; end 
        end
        else begin
            // Rebote Horizontal con Colisiones
            if (dir_x) begin 
                if ((pelota_x + 10'd7 >= 10'd610) && (pelota_x <= 10'd619) && 
                    (pelota_y + 10'd7 >= raqueta2_y) && (pelota_y <= raqueta2_y + 10'd59)) begin
                    dir_x <= 1'b0; 
                    if (hit_count == 4'd9) begin
                        hit_count    <= 4'd0;
                        if (pelota_speed < 4'd6) pelota_speed <= pelota_speed + 1'b1;
                    end else begin
                        hit_count    <= hit_count + 1'b1;
                    end
                end
                else begin
                    pelota_x <= pelota_x + {6'b0, pelota_speed};
                end
            end 
            else begin 
                if ((pelota_x <= 10'd29) && (pelota_x + 10'd7 >= 10'd20) && 
                    (pelota_y + 10'd7 >= raqueta1_y) && (pelota_y <= raqueta1_y + 10'd59)) begin
                    dir_x <= 1'b1; 
                    if (hit_count == 4'd9) begin
                        hit_count    <= 4'd0;
                        if (pelota_speed < 4'd6) pelota_speed <= pelota_speed + 1'b1;
                    end else begin
                        hit_count    <= hit_count + 1'b1;
                    end
                end
                else begin
                    pelota_x <= pelota_x - {6'b0, pelota_speed};
                end
            end

            // Rebote Vertical
            if (dir_y) begin
                if (pelota_y >= 10'd464)
                    dir_y <= 1'b0; 
                else
                    pelota_y <= pelota_y + {6'b0, pelota_speed};
            end else begin
                if (pelota_y <= 10'd16)
                    dir_y <= 1'b1; 
                else
                    pelota_y <= pelota_y - {6'b0, pelota_speed};
            end
        end
    end

endmodule