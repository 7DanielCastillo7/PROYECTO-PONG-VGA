`default_nettype none // Exige declarar explícitamente todos los cables

module sincronia_vga (
    input  wire       reloj,        // Reloj de píxel de 25 MHz
    input  wire       reiniciar,    // Reinicio síncrono de contadores y sincronismos
    output reg        sinc_h,       // Sincronismo horizontal VGA (activo en bajo)
    output reg        sinc_v,       // Sincronismo vertical VGA (activo en bajo)
    output wire       video_activo, // 1 dentro del área visible 640x480
    output reg  [9:0] pos_x,        // Contador horizontal (0..799 píxeles/línea)
    output reg  [9:0] pos_y         // Contador vertical (0..524 líneas/cuadro)
);

    // Contador horizontal de 800 píxeles por línea (640 visibles + porches + pulso)
    always @(posedge reloj) begin
        if (reiniciar || (pos_x == 10'd799))
            pos_x <= 10'd0;
        else
            pos_x <= pos_x + 1'b1;
    end

    // Contador vertical de 525 líneas por cuadro (480 visibles + porches + pulso)
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

    // Generación registrada de pulsos de sincronía horizontal y vertical (negativos)
    always @(posedge reloj) begin
        if (reiniciar) begin
            sinc_h <= 1'b1;
            sinc_v <= 1'b1;
        end else begin
            sinc_h <= ~((pos_x >= 10'd656) && (pos_x <= 10'd751)); // Pulso H-sync (96 ciclos)
            sinc_v <= ~((pos_y >= 10'd490) && (pos_y <= 10'd491)); // Pulso V-sync (2 líneas)
        end
    end

    // Habilita el dibujo solo dentro de la región visible 640x480
    assign video_activo = (pos_x < 10'd640) && (pos_y < 10'd480);

endmodule