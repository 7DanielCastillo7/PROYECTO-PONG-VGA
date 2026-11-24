# Declaración de uso de inteligencia artificial

Este documento presenta de forma transparente cómo se utilizó la asistencia de Inteligencia Artificial (IA) durante el desarrollo del proyecto **Pong VGA en FPGA (Digilent Basys 3)** para la asignatura de Electrónica Digital, indicando la herramienta empleada, su propósito, cómo se marcó el código generado y el trabajo propio del equipo.

## Herramienta y alcance
- **Herramienta:** Gemini
- **Propósito:** Apoyo técnico en consultas de diseño, redacción de código en Verilog (`.v`), bancos de pruebas (`tb_*.v`), restricciones (`.xdc`) y simulación.

## Cómo se utilizó la IA
- **Consultas de diseño:** Resolución de dudas técnicas sobre el diseño del sistema, sincronización VGA (640×480 @ 60 Hz), decodificación de teclado PS/2, lógica de juego, simulación y constraints para la tarjeta Digilent Basys 3.
- **Código en Verilog (`.v`) y testbenches (`tb_*.v`):** Redacción y estructuración de módulos y bancos de pruebas a partir de los requerimientos y decisiones del equipo.
- **Constraints (`.xdc`) y simulación:** Apoyo en la definición/revisión de restricciones de pines y reloj, así como en la preparación de estímulos y pruebas de simulación.

## Marcado del código generado
El código generado o redactado con asistencia de IA se identifica dentro de los archivos correspondientes mediante marcas explícitas (`// [USO DE IA]`).

## Trabajo propio de los autores
- El diseño y la simplificación como en **mapas de Karnaugh** del decodificador del marcador fueron realizados por el equipo.
- Todos los **esquemáticos** del proyecto y de cada módulo fueron elaborados por el equipo en `diagrams.net`.
- La revisión final, la verificación en simulación y en la FPGA Digilent Basys 3, así como la gestión del repositorio, fueron realizadas por los autores del proyecto.