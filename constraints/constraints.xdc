# [USO DE IA] Restricciones revisadas/estructuradas con asistencia de IA; pines verificados por el equipo.

## =================================================
## RELOJ PRINCIPAL - 100 MHz
## =================================================
# Pin físico del oscilador de 100 MHz en la tarjeta Basys 3
set_property PACKAGE_PIN W5 [get_ports clk]
# Estándar lógico de 3.3 V para el reloj de entrada
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Restricción de temporización: período de 10 ns (100 MHz), flanco de subida en 0 ns y bajada en 5 ns
create_clock -add -name sys_clk_pin -period 10.000 \
-waveform {0 5} [get_ports clk]

## =================================================
## PUERTO PS/2 (USB HOST J2 - TECLADO)
## =================================================
# Reloj serial PS/2 con pull-up interno habilitado en modo open-drain/reposo
set_property PACKAGE_PIN C17 [get_ports ps2_clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_clk]
set_property PULLUP true [get_ports ps2_clk]

# Datos seriales PS/2 con pull-up interno habilitado
set_property PACKAGE_PIN B17 [get_ports ps2_data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_data]
set_property PULLUP true [get_ports ps2_data]

## =================================================
## VGA - ROJO (4 bits, del LSB vga_r[0] al MSB vga_r[3])
## =================================================
set_property PACKAGE_PIN G19 [get_ports {vga_r[0]}]
set_property PACKAGE_PIN H19 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN J19 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN N19 [get_ports {vga_r[3]}]

## =================================================
## VGA - VERDE (4 bits, del LSB vga_g[0] al MSB vga_g[3])
## =================================================
set_property PACKAGE_PIN J17 [get_ports {vga_g[0]}]
set_property PACKAGE_PIN H17 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN G17 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN D17 [get_ports {vga_g[3]}]

## =================================================
## VGA - AZUL (4 bits, del LSB vga_b[0] al MSB vga_b[3])
## =================================================
set_property PACKAGE_PIN N18 [get_ports {vga_b[0]}]
set_property PACKAGE_PIN L18 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN K18 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN J18 [get_ports {vga_b[3]}]

## =================================================
## VGA - SINCRONIZACION
## =================================================
# Sincronismo horizontal (HSync) y sincronismo vertical (VSync)
set_property PACKAGE_PIN P19 [get_ports vga_hs]
set_property PACKAGE_PIN R19 [get_ports vga_vs]

## =================================================
## ESTANDAR DE VOLTAJE - VGA
## =================================================
# Estándar LVCMOS33 para todos los buses de color y señales de sincronía VGA
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[*]}]

set_property IOSTANDARD LVCMOS33 [get_ports vga_hs]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vs]