;Função responsavel pelo homing do eixo X (G28 X ou Home X)
G91                    ;Muda a impressora pro modo realtivo (ex: se o comando G1 Z10 no modo absluto o Z vai pra posição 10, no modo relativo ele anda 10 a mais do ponto que esta)

if{move.axes[2].homed && {move.axes[2].machinePosition < 10}} ;Aqui verifica se o eixo Z já fez o homing e se a posição atual do eixo é menor que 10mm, caso sea positivo para ambas as condiçoes
   G1 Z5                                                     ;Move o Z 5mm para baixo

if{sensors.endstops[0].highEnd}  
   G1 H1 X{(move.axes[0].max+10)} F6000         ;E faz uma segunda sondagem do X em menor velocidade para maior precisão
else
   G1 H1 X{-(move.axes[0].max+10)} F6000         ;E faz uma segunda sondagem do X em menor velocidade para maior precisão

G4 P100                               ;Aguarda 100mS

if{sensors.endstops[0].type != "motorStallAny"} ;Caso o tipo de endstop seja diferente do sensorless
  if{sensors.endstops[0].highEnd} 
    G1 X-5 F600
    G1 H1 X{(move.axes[0].max+10)} F600         ;E faz uma segunda sondagem do X em menor velocidade para maior precisão
  else
    G1 X5 F600
    G1 H1 X{-(move.axes[0].max+10)} F600         ;E faz uma segunda sondagem do X em menor velocidade para maior precisão  
  
G90                     ;Volta para o modo absoluto de movimento
M400                    ;Comando para que aguarda até que todos os comandos na fila tenham sido executados
M913 X100 Y100          ;Retorna a corrente do motor a 100%
M400                    ;Comando para que aguarda até que todos os comandos na fila tenham sido executados
