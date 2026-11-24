`default_nettype none // Exige declarar explícitamente todos los cables

module teclado (
    input  wire clk_25mhz,        // Reloj del sistema de 25 MHz
    input  wire ps2_clk,          // Reloj serial enviado por el teclado PS/2
    input  wire ps2_data,         // Línea serial de datos del teclado PS/2
    output reg  J1_sube = 1'b0,   // 1 mientras se mantiene presionada la tecla W
    output reg  J1_baja = 1'b0,   // 1 mientras se mantiene presionada la tecla S
    output reg  J2_sube = 1'b0,   // 1 mientras se mantiene presionada Flecha Arriba
    output reg  J2_baja = 1'b0    // 1 mientras se mantiene presionada Flecha Abajo
);

    // Sincronización de 3 etapas para ps2_clk y muestreo de ps2_data
    reg [2:0] ps2_clk_sync = 3'b111; // Historial de ps2_clk para evitar metaestabilidad y detectar flanco
    reg       bit_in       = 1'b1;   // Bit de datos muestreado

    always @(posedge clk_25mhz) begin
        ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk}; // Desplaza nuevo estado de ps2_clk
        bit_in       <= ps2_data;                     // Captura dato serie
    end

    wire fall = (ps2_clk_sync[2:1] == 2'b10); // Pulso de 1 ciclo en flanco de bajada de ps2_clk

    // Contador de bits de la trama PS/2 (0: start, 1..8: datos, 9: paridad, 10: stop)
    reg  [3:0] contador = 4'd0;
    wire       fin      = (contador == 4'd10);                      // Indica último bit de la trama de 11 bits
    wire [3:0] next_cnt = fin ? 4'd0 : (contador + 4'd1);           // Reinicia a 0 tras el bit 10

    always @(posedge clk_25mhz) begin
        if (fall) begin
            contador <= next_cnt; // Avanza el contador en cada flanco de bajada válido
        end
    end

    // Pulso 'listo' de 1 ciclo de clk_25mhz cuando termina de llegar el bit 10
    reg listo = 1'b0;
    always @(posedge clk_25mhz) begin
        listo <= fin & fall;
    end

    // Registro de desplazamiento de 11 bits (entra bit_in por MSB y desplaza hacia LSB)
    reg [10:0] desplazamiento = 11'd0;
    always @(posedge clk_25mhz) begin
        if (fall) begin
            desplazamiento <= {bit_in, desplazamiento[10:1]};
        end
    end

    // Captura el byte de scan code (bits [8:1] de la trama) al completarse los 11 bits
    reg [7:0] scan_code = 8'h00;
    always @(posedge clk_25mhz) begin
        if (listo) begin
            scan_code <= desplazamiento[8:1];
        end
    end

    // Detecta código Break (0xF0 = tecla soltada) y genera No_Sol (1 = presionar, 0 = soltar)
    wire es_f0 = (scan_code == 8'hF0); // 1 cuando el byte recibido es el prefijo de liberación 0xF0
    reg  reg_f0 = 1'b0;                // Memoriza si el byte anterior fue 0xF0

    always @(posedge clk_25mhz) begin
        if (listo) begin
            reg_f0 <= es_f0;
        end
    end

    wire No_Sol = ~reg_f0; // 1 para tecla presionada (Make), 0 para tecla soltada (Break)

    // Comparadores de scan codes para controles de Jugador 1 y Jugador 2
    wire cmp_w  = (scan_code == 8'h1D); // Tecla W (Jugador 1 sube)
    wire cmp_s  = (scan_code == 8'h1B); // Tecla S (Jugador 1 baja)
    wire cmp_up = (scan_code == 8'h75); // Flecha Arriba (Jugador 2 sube)
    wire cmp_dn = (scan_code == 8'h72); // Flecha Abajo (Jugador 2 baja)

    // Habilitadores sincronizados con el pulso 'listo'
    wire en_w  = cmp_w  & listo;
    wire en_s  = cmp_s  & listo;
    wire en_up = cmp_up & listo;
    wire en_dn = cmp_dn & listo;

    // Actualiza el estado de cada dirección según No_Sol
    always @(posedge clk_25mhz) begin
        if (en_w)  J1_sube <= No_Sol; // Activa (1) o desactiva (0) subida J1
        if (en_s)  J1_baja <= No_Sol; // Activa (1) o desactiva (0) bajada J1
        if (en_up) J2_sube <= No_Sol; // Activa (1) o desactiva (0) subida J2
        if (en_dn) J2_baja <= No_Sol; // Activa (1) o desactiva (0) bajada J2
    end

endmodule