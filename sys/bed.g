var X_pos_max = 0
var X_pos_min = 0
var Y_pos = {(move.axes[1].max / 2)-sensors.probes[0].offsets[1]}

if sensors.probes[0].offsets[0] > 0
  set var.X_pos_max = move.axes[0].max
  set var.X_pos_min = sensors.probes[0].offsets[0]
else
  set var.X_pos_max = move.axes[0].max + sensors.probes[0].offsets[0]
  set var.X_pos_min = move.axes[0].min - sensors.probes[0].offsets[0]


if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
  G28
 
var interacoes = {global.interacoes}
M401
while {var.interacoes} > 0
  G30 P0 X{var.X_pos_min} Y{var.Y_pos} Z-99999 ; probe near a leadscrew, half way along Y axis
  G30 P1 X{var.X_pos_max} Y{var.Y_pos} Z-99999 S2 ; probe near a leadscrew and calibrate 2 motors
  if move.calibration.initial.deviation <= {global.tolerancia} 
    break
  else
    set var.interacoes = var.interacoes - 1
  echo "Tentativa N:" ^ global.interacoes - var.interacoes ^ ", Tolerancia não atingida: " ^ move.calibration.initial.deviation ^ "mm) / "^ global.tolerancia ^ "mm"
  
M402
if var.interacoes <= 0 & move.calibration.initial.deviation >= {global.tolerancia} 
  echo "Alinhamento do Z não concluido, muitas tentativas sem alcaçar a tolerancia desejada: " ^ global.tolerancia ^ "mm"
else
  echo "Nivelamento dos motores do Z concluido, tolerancia alcançada é de: " ^ move.calibration.final.deviation ^ "mm"