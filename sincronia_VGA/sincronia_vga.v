`default_nettype none

module sincronia_vga (
    input  wire       reloj,
    input  wire       reiniciar,
    output reg        sinc_h,
    output reg        sinc_v,
    output wire       video_activo,
    output reg  [9:0] pos_x,
    output reg  [9:0] pos_y
);

    always @(posedge reloj) begin
        if (reiniciar || (pos_x == 10'd799))
            pos_x <= 10'd0;
        else
            pos_x <= pos_x + 1'b1;
    end

    always @(posedge reloj) begin
        if (reiniciar)
            pos_y <= 10'd0;
        else if (pos_x == 10'd799) begin
            if (pos_y == 10'd524)
                pos_y <= 10'd0;
            else
                pos_y <= pos_y + 1'b1;
        end
    end

    always @(posedge reloj) begin
        if (reiniciar) begin
            sinc_h <= 1'b1;
            sinc_v <= 1'b1;
        end else begin
            sinc_h <= ~((pos_x >= 10'd656) && (pos_x <= 10'd751));
            sinc_v <= ~((pos_y >= 10'd490) && (pos_y <= 10'd491));
        end
    end

    assign video_activo = (pos_x < 10'd640) && (pos_y < 10'd480);

endmodule