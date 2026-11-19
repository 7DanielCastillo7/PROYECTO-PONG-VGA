`default_nettype none

module divisor_reloj (
    input  wire clk_100mhz,
    output wire clk_25mhz
);

    reg [1:0] contador = 2'b00;

    always @(posedge clk_100mhz) begin
        contador <= contador + 1'b1;
    end

    assign clk_25mhz = contador[1];

endmodule