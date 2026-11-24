# Pong VGA en FPGA (Digilent Basys 3)

Implementación modular en Verilog del juego clásico **Pong** para dos jugadores sobre una tarjeta FPGA **Digilent Basys 3** (Artix-7, reloj maestro de 100 MHz), con salida de video **VGA (640×480 @ 60 Hz)**, control por **teclado PS/2** y decodificador de marcador diseñado mediante ecuaciones booleanas simplificadas con **mapas de Karnaugh**.

- **Asignatura / Contexto:** Electrónica Digital (ELDI 2026)
- **Autores:** Daniel Castillo López y Santiago Alejandro Maldonado Barrera
- **Uso de inteligencia artificial:** Se utilizó asistencia de IA para consultas de diseño, redacción de código Verilog (`.v`), testbenches (`tb_*.v`), restricciones (`.xdc`) y simulación. Los detalles están en [DECLARACION_IA.md](DECLARACION_IA.md), y los archivos asistidos incluyen la marca correspondiente (`// [USO DE IA]`).

---

## 1. Requisitos

| Propósito | Herramienta / Hardware |
| :--- | :--- |
| Simulación funcional | **Icarus Verilog** (`iverilog` / `vvp`) y **GTKWave** (en Linux, WSL o Windows) |
| Síntesis, implementación y programación | **Xilinx Vivado** (con soporte para Digilent Basys 3, `xc7a35tcpg236-1`) |
| Hardware físico | Tarjeta **Digilent Basys 3**, monitor con entrada **VGA** y cable VGA, teclado **PS/2** (o USB compatible con protocolo PS/2) |

---

## 2. Reproducir la simulación

### Clonar el repositorio
```bash
git clone https://github.com/7DanielCastillo7/PROYECTO-PONG-VGA.git
cd PROYECTO-PONG-VGA
```

### Compilar y ejecutar testbenches
Desde la raíz del repositorio puedes compilar y ejecutar cada banco de pruebas (`tb_*.v`) con **Icarus Verilog**:

```bash
# 1. Divisor de reloj (100 MHz -> 25 MHz)
iverilog -o sim_divisor.out divisor_reloj/divisor_reloj.v divisor_reloj/tb_divisor_reloj.v
vvp sim_divisor.out

# 2. Sincronía VGA (640x480 @ 60 Hz)
iverilog -o sim_vga.out sincronia_VGA/sincronia_vga.v sincronia_VGA/tb_sincronia_vga.v
vvp sim_vga.out

# 3. Decodificador de teclado PS/2
iverilog -o sim_teclado.out teclado/teclado.v teclado/tb_teclado.v
vvp sim_teclado.out

# 4. Lógica principal del juego
iverilog -o sim_juego.out logica_juego/juego.v logica_juego/tb_juego.v
vvp sim_juego.out

# 5. Marcador (ecuaciones booleanas por mapas de Karnaugh)
iverilog -o sim_marcador.out marcador/marcador.v marcador/tb_marcador.v
vvp sim_marcador.out

# 6. Renderizado en pantalla VGA (instancia marcador.v)
iverilog -o sim_pantalla.out marcador/marcador.v pantalla/pantalla.v pantalla/tb_pantalla.v
vvp sim_pantalla.out

# 7. Sistema completo (top_project)
iverilog -o sim_project.out \
  divisor_reloj/divisor_reloj.v \
  sincronia_VGA/sincronia_vga.v \
  teclado/teclado.v \
  logica_juego/juego.v \
  marcador/marcador.v \
  pantalla/pantalla.v \
  top_project/project.v \
  top_project/tb_project.v
vvp sim_project.out
```

Si al ejecutar algún testbench generas un archivo `.vcd` con el nombre del módulo, puedes abrirlo en **GTKWave** con:
```bash
gtkwave <nombre_modulo>.vcd
```
Si al ejecutar un testbench generas un archivo `.vcd` (el nombre exacto depende de lo que indique `$dumpfile` dentro de cada `tb_*.v`, por ejemplo `sincronia_vga.vcd`), ábrelo en **GTKWave** con:
```bash
gtkwave sincronia_vga.vcd

*(Nota: si en tu repositorio el módulo superior o algún archivo `.v` / `tb_*.v` tiene otro nombre exacto, ajústalo en los comandos anteriores).*


## 3. Reproducir el bitstream en Vivado

1. Abre **Xilinx Vivado** y crea un proyecto RTL seleccionando la FPGA de la **Digilent Basys 3** (`xc7a35tcpg236-1`).
2. Agrega como **Design Sources** los módulos de diseño (`.v`):
   - `divisor_reloj.v`
   - `sincronia_vga.v`
   - `teclado.v`
   - `juego.v`
   - `marcador.v`
   - `pantalla.v`
   - `project.v`
   *(No incluyas los archivos `tb_*.v` dentro de las fuentes de síntesis).*
3. Define `project` (`proyecto_superior/project.v`) como **Top Module**.
4. Agrega el archivo de restricciones `.xdc` ubicado en `proyecto_superior/` como **Constraints**.
5. Ejecuta **Run Synthesis**, **Run Implementation** y **Generate Bitstream**.
6. Abre **Hardware Manager**, conecta la Basys 3 por USB, abre el objetivo (*Open Target* -> *Auto Connect*) y programa la FPGA con el archivo `.bit` generado.

---

## 4. Conexiones y controles (Digilent Basys 3)

| Señal en `project` | Pin / Puerto en Basys 3 | Descripción |
| :--- | :--- | :--- |
| `clk` | `W5` (`LVCMOS33`) | Reloj maestro de `100 MHz` de la placa |
| `ps2_clk` | `C17` (`LVCMOS33`, `PULLUP`) | Reloj serial del puerto USB HID / PS/2 (`J2`) |
| `ps2_data` | `B17` (`LVCMOS33`, `PULLUP`) | Línea de datos seriales del puerto USB HID / PS/2 (`J2`) |
| `vga_r[3:0]` | `N19, J19, H19, G19` (`LVCMOS33`) | Bus de color rojo VGA (4 bits) |
| `vga_g[3:0]` | `D17, G17, H17, J17` (`LVCMOS33`) | Bus de color verde VGA (4 bits) |
| `vga_b[3:0]` | `J18, K18, L18, N18` (`LVCMOS33`) | Bus de color azul VGA (4 bits) |
| `vga_hs` | `P19` (`LVCMOS33`) | Pulso de sincronismo horizontal VGA |
| `vga_vs` | `R19` (`LVCMOS33`) | Pulso de sincronismo vertical VGA |

### Controles en el teclado PS/2
- **Jugador 1:** `W` (subir) / `S` (bajar)
- **Jugador 2:** `Flecha Arriba` (subir) / `Flecha Abajo` (bajar)

---

## 5. Arquitectura del sistema

```text
clk (100 MHz) ──► divisor_reloj ──► clk_25mhz ──┬──► sincronia_vga ──► hs, vs, video_activo, pos_x, pos_y
                                                  │                                      │
ps2_clk, ps2_data ──────────────────► teclado ────┼──► J1/J2 sube/baja ──► juego ───────┼──► pantalla ──► RGB
                                                  │                         │ (puntaje)  │
                                                  │                         └─► marcador ─┘
                                                  └──────────────────────────────────────┘
```

- **`divisor_reloj`:** Divide el reloj de `100 MHz` de la Basys 3 a `25 MHz`, frecuencia de píxel requerida para el modo VGA `640×480 @ 60 Hz` y muestreo del teclado.
- **`sincronia_vga`:** Genera los contadores horizontal y vertical, las señales de sincronismo (`sinc_h`, `sinc_v`), la ventana de `video_activo` y las coordenadas actuales de barrido (`pos_x`, `pos_y`).
- **`teclado`:** Sincroniza `ps2_clk` y `ps2_data`, detecta flancos de bajada, ensambla tramas PS/2 de 11 bits, identifica códigos *make* y *break* (`0xF0`) y genera las señales de movimiento de ambos jugadores.
- **`juego`:** Gestiona el desplazamiento de las raquetas, el movimiento y velocidad de la pelota, las colisiones con bordes y paletas, y la actualización de puntajes.
- **`marcador`:** Decodifica los puntajes mediante funciones booleanas simplificadas con **mapas de Karnaugh** para representar los dígitos en pantalla.
- **`pantalla`:** Combina las coordenadas VGA, la zona activa y los elementos del juego/marcador para generar las señales de color `rojo`, `verde` y `azul` (expandidas a 4 bits por canal en `project`).
- **`project`:** Módulo superior (*top*) que interconecta todos los bloques y expone los puertos físicos hacia el archivo `.xdc`.

---

## 6. Organización del repositorio

Cada carpeta del proyecto reúne su código RTL (`.v`), banco de pruebas (`tb_*.v`) y diagrama esquemático correspondiente (además de los constraints en `proyecto_superior/`):

| Carpeta / Archivo | Contenido principal |
| :--- | :--- |
| `divisor_reloj/` | `divisor_reloj.v`, `tb_divisor_reloj.v` y esquemático del bloque |
| `sincronia_VGA/` | `sincronia_vga.v`, `tb_sincronia_vga.v` y esquemático del bloque |
| `teclado/` | `teclado.v`, `tb_teclado.v` y esquemático del bloque |
| `lógica_juego/` | `juego.v`, `tb_juego.v` y esquemático del bloque |
| `marcador/` | `marcador.v`, `tb_marcador.v` y esquemático del bloque |
| `pantalla/` | `pantalla.v`, `tb_pantalla.v` y esquemático del bloque |
| `proyecto_superior/` | `project.v`, `tb_project.v`, restricciones `.xdc` y esquemático general del sistema |
| `DECLARACION_IA.md` | Declaración detallada del uso de IA en el proyecto |
| `README.md` | Documentación general y guía de reproducción |

---

## 7. Problemas comunes y comprobaciones

- **Sin imagen o fuera de rango en el monitor VGA:** Verifica que `clk` esté asignado a `W5`, que el divisor genere `25 MHz` y que `vga_hs`, `vga_vs` y los buses `vga_r`, `vga_g`, `vga_b` estén en `LVCMOS33`.
- **El teclado PS/2 no responde:** Revisa que `ps2_clk` (`C17`) y `ps2_data` (`B17`) tengan `PULLUP true` en el `.xdc`, que el teclado esté conectado en el puerto correcto (`J2`) y que se envíen tramas válidas en simulación.
- **Errores de compilación en simulación:** Asegúrate de pasar todos los archivos dependientes a `iverilog` (por ejemplo, incluir `marcador.v` junto con `pantalla.v`, o todos los módulos al compilar `tb_project.v`).

---

## 8. Licencia y declaración de IA

Proyecto desarrollado con fines académicos para **Electrónica Digital**. Consulta [DECLARACION_IA.md](DECLARACION_IA.md) para conocer el alcance exacto del uso de Inteligencia Artificial y el marcado del código.
