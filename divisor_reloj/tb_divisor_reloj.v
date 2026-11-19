`timescale 1ns / 1ps

module tb_divisor_reloj;

    // 1. Señales para conectar al módulo (reg para entradas, wire para salidas)
    reg  clk_100mhz;
    wire clk_25mhz;

    // 2. Instancia del módulo bajo prueba (UUT - Unit Under Test)
    divisor_reloj uut (
        .clk_100mhz(clk_100mhz),
        .clk_25mhz(clk_25mhz)
    );

    // 3. Generación del reloj maestro de 100 MHz (Período = 10 ns -> 5 ns en alto, 5 ns en bajo)
    initial begin
        clk_100mhz = 1'b0;
        forever #5 clk_100mhz = ~clk_100mhz;
    end

    // 4. Control del tiempo de simulación
    initial begin
        // Simulamos durante 200 ns (suficiente para ver 5 ciclos completos de 25 MHz)
        #200;
        $finish;
    end

endmodule