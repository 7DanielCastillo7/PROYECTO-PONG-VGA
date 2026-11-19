`default_nettype none

module teclado (
    input  wire clk_25mhz, // Reloj de 25 MHz
    input  wire ps2_clk,   // Reloj del teclado PS/2
    input  wire ps2_data,  // Datos del teclado PS/2
    output reg  J1_sube = 1'b0,
    output reg  J1_baja = 1'b0,
    output reg  J2_sube = 1'b0,
    output reg  J2_baja = 1'b0
);

    // Sincronización y detección de flanco de bajada (fall)
    reg [2:0] ps2_clk_sync = 3'b111;
    reg       bit_in       = 1'b1;

    always @(posedge clk_25mhz) begin
        ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
        bit_in       <= ps2_data;
    end

    wire fall = (ps2_clk_sync[2:1] == 2'b10);

    // Contador de bits (0 a 10)
    reg  [3:0] contador = 4'd0;
    wire       fin      = (contador == 4'd10);
    wire [3:0] next_cnt = fin ? 4'd0 : (contador + 4'd1);

    always @(posedge clk_25mhz) begin
        if (fall) begin
            contador <= next_cnt;
        end
    end

    // Pulso 'listo' de 1 ciclo
    reg listo = 1'b0;
    always @(posedge clk_25mhz) begin
        listo <= fin & fall;
    end

    // Registro de desplazamiento de 11 bits
    reg [10:0] desplazamiento = 11'd0;
    always @(posedge clk_25mhz) begin
        if (fall) begin
            desplazamiento <= {bit_in, desplazamiento[10:1]};
        end
    end

    // Registro scan_code de 8 bits
    reg [7:0] scan_code = 8'h00;
    always @(posedge clk_25mhz) begin
        if (listo) begin
            scan_code <= desplazamiento[8:1];
        end
    end

    // Detector de código Break (0xF0) y señal No_Sol
    wire es_f0 = (scan_code == 8'hF0);
    reg  reg_f0 = 1'b0;

    always @(posedge clk_25mhz) begin
        if (listo) begin
            reg_f0 <= es_f0;
        end
    end

    wire No_Sol = ~reg_f0;

    // Comparadores de teclas (W, S, Flecha Arriba, Flecha Abajo)
    wire cmp_w  = (scan_code == 8'h1D);
    wire cmp_s  = (scan_code == 8'h1B);
    wire cmp_up = (scan_code == 8'h75);
    wire cmp_dn = (scan_code == 8'h72);

    // Habilitadores de salida
    wire en_w  = cmp_w  & listo;
    wire en_s  = cmp_s  & listo;
    wire en_up = cmp_up & listo;
    wire en_dn = cmp_dn & listo;

    always @(posedge clk_25mhz) begin
        if (en_w)  J1_sube <= No_Sol;
        if (en_s)  J1_baja <= No_Sol;
        if (en_up) J2_sube <= No_Sol;
        if (en_dn) J2_baja <= No_Sol;
    end