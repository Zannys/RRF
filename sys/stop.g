;Arquivo chamado quando se cancela uma impressão

M104 S0    ; Desliga o hotend
M140 S0    ; Desliga a mesa
M106 P0 S0 ; Desliga o FAN de camada
M117 "Impressão cancelada" ; Mostra no LCD