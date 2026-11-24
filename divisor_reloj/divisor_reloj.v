// [USO DE IA] Código redactado/estructurado con asistencia de IA y validado por el equipo.
`default_nettype none // Exige declarar explícitamente todos los cables

module divisor_reloj (
    input  wire clk_100mhz, // Reloj de entrada de 100 MHz (Basys 3)
    output wire clk_25mhz   // Reloj de salida dividido a 25 MHz
);

    reg [1:0] contador = 2'b00; // Contador de 2 bits inicializado en 0

    always @(posedge clk_100mhz) begin
        contador <= contador + 1'b1; // Incrementa en cada flanco de subida de 100 MHz
    end

    assign clk_25mhz = contador[1]; // Bit 1 cambia cada 20 ns -> período de 40 ns (25 MHz)

endmodule