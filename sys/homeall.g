;Função chamada ao executar o comando G28 (homing de todos os eixos)
if{(move.axes[2].machinePosition >= 0) && (move.axes[2].machinePosition < 10)} ;Verifica a posiçao do eixo Z, se maior que 0 e menor que 10
   G1 H2 Z5      ;Afasta a mesa do bico em 5mm para que não bata em nada durante o homing do X e Y
   
;As linhas acima são necessarias pois quando o G28 é chamado ele coloca todos os eixos em estado e posição "desconhecida", 
;e o RRF por preteção não movimenta os eixos nesse estado, então para mover o Z 10mm para que o bico não bata em nada é necessario essas linhas


M98 P"homex.g" ;Executa o arquivo responsavel pelo homing do X (G28 X)
M98 P"homey.g" ;Executa o arquivo responsavel pelo homing do Y (G28 Y)
M98 P"homez.g" ;Executa o arquivo responsavel pelo homing do Z (G28 Z)
