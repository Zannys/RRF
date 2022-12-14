;Função responsavel pelo homing do eixo Z (G28 Z ou Home Z)
G1 X{global.centroMesaProbeX} Y{global.centroMesaProbeY} F3000  ;Move o probe para o centro da mesa
M558 F300
G30             ; home Z by probing the bed
G4 P500
M558 F120
G30