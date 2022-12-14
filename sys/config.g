; Arquivo de configuração da impressora para a FLY-CDY v3
; Esse arquivo é chamado sempre na inicalização da placa
; Configurado e comentado por: Gabriel Zanetti
; Para informações mais completas sobre o que cada Gcode faz e qual é o parametro que cada um recebe, consultar a documentação: https://docs.duet3d.com/en/User_manual/Reference/Gcodes

;###########################################################################
;#                        Configuração gerais                              #    
;###########################################################################

G90                    ; Coloca a impressora em modo absoluto de movimento
M83                    ; Coloca o extrusor em modo relativo
M550 P"My Printer"     ; Configura o nome de exibição da Impressora
M669 K1                ; Configura a cinematica da impressora (K1 = core xy, K0 = cartesiana....)

;###########################################################################
;#                       Configuração de Rede                              #    
;###########################################################################

M552 S1         ; Habilita o wifi
M586 P0 S1      ; Habilita conexão HTTP
M586 P1 S0      ; Desabilita o FTP
M586 P2 S0      ; Desabilita o Telnet

;###########################################################################
;#                    Configuração de Motores                              #    
;###########################################################################

M569 P0 S1 D3 V45                          ; Configura o driver 0 (P0), Na placa é o driver na posiçao do X)* sentido de giro (S1) habilita o modo silencioso (D3) e configura o limiar para troca de modo** (V45)
M569 P1 S1 D3 V45                          ; Configura o driver 1 (Na placa é o driver na posiçao do Y)*
M569 P2 S1 D3 V45                          ; Configura o driver 2 (Na placa é o driver na posiçao do Z)*
M569 P3 S1                                 ; Configura o driver 3 (Na placa é o driver na posiçao do E)*
M569 P4 S1 D3 V45                          ; Configura o driver 4 (Na placa é o driver na posiçao do E1)*
M584 X0 Y1 Z2:4 E3                         ; Configura qual driver será usado para cada eixo (Como o Z tem dois driver configura que o eixo Z usará o driver 2 e 4)
M671 X0:283 Y150:150 S5                    ; Configura a posição dos fusos na maquina para o nivelamento do eixo Z atraves do probe e define a maxima diferença possivel entre os fusos em 5mm (S5)
M350 X64 Y64 Z16 E16 I1                    ; Configura os micropassos para o TMC e habilita função de escalar automaticamente para 256 micropassos
M92 X320.00 Y320.00 Z1600.00 E411.00       ; Configura passos por mm dos eixos
M566 X900.00 Y900.00 Z60.00 E120.00        ; set maximum instantaneous speed changes (mm/min)
M203 X6000.00 Y6000.00 Z480.00 E4200.00    ; Configura a velocidade maxima dos eixos (mm/min, dividir esse valor por 60 para ter mm/s)
M201 X3000.00 Y3000.00 Z100.00 E250.00       ; Configura a aceleração maxima dos eixos (mm/s^2)
M906 X1000 Y1000 Z800 E800 I30               ; Configura a corrente (usado somente em TMC uart/spi) em mA e a % da corrente em respouso (Parametro I). Ex I30 = 30% do valor de corrente dos eixos
M84 S30                                    ; Configura o tempo em segundos para os motores entrarem em estado de repouso

;* Caso necessite a inversão do sentido de giro do motor, mudar o parametro S do respectivo eixo.
; Ex: M569 P0 S1 Gira o motor em sentido horario  
;     M569 P0 S0 Gira o motor em sentido anti-horario

;** limiar para troca de modo de operação do TMC (sealthchop = modo silencioso, spreadCycle = modo "força")
; Quanto maior o valor de V menor é a velocidade para troca de modo

;###########################################################################
;#                 Configuração de Area de movimento                       #    
;###########################################################################

M208 X0 Y0 Z0 S1         ; Configura o valor minimo de movimento dos eixos
M208 X283 Y300 Z285 S0   ; sConfigura o valor Maximo de movimento dos eixos

;###########################################################################
;#                    Configuração de Ednstops                             #    
;###########################################################################

M574 X2 S1 P"!xstop"  ; Configura o endstop no maximo do eixo (X2), configura para o tipo SWITCH (S1) e informa qual pino vai ser usado (P"xstop")*
M574 Y1 S1 P"ystop"  ; Configura o endstop no minimo do eixo (Y1), configura para o tipo SWITCH (S1) e informa qual pino vai ser usado (P"ystop")*
M574 Z1 S2           ; Configura o endstop no maximo do eixo (X2), configura para usar o PROBE (S2)

; Caso necessite inversão de logica de leitura do endstop, incluir um ! na frente do pino. Ex: P"!xstop"

;###########################################################################
;#                      Configuração de probe                              #    
;###########################################################################

M950 S0 C"servo0"                ; Configura o pino para controle do BLTOUCH
M558 P9 C"^zstop" H5 F120 T3600  ; Configuração de probe*
G31 P500 X46 Y-10 Z1.15           ; Configura o offset do bico em X, Y e Z
M557 X5:237 Y8:285 P5:5          ; Configuração da area de medida para o nivelamento automatico**

;    +-- BACK ---+
;    |    [+]    |
;  L |        1  | R 
;  E |  2        | I 
;  F |[-]  N  [+]| G 
;  T |       3   | H 
;    | 4         | T 
;    |    [-]    |
;    O-- FRONT --+

;* O tipo de probe (P9 = BLTOUCH), o pino usado para o sinal do sensor (z-min), quantos mm afasta a mesa para liberar o pino (H5 = 5mm), velocidade de probe em mm/min (120 mm/min) e a velocidade (mm/min) entre as medidas (T6000)
;** Xmin:Xmax YMin:Ymax (Valor onde o BLTOUCH vai fazer a a medida, Ex: X0:200, considerando offset em X -10 o bico vai para a posição 10 no minimo e 210 no maximo, caso não seja possivel alcançar o 210 o RRF emite um alerta)
;** Xmin:Xmax YMin:Ymax (Valor onde o BLTOUCH vai fazer a a medida, Ex: X0:200, considerando offset em X 10 o bico vai para a posição 0 no minimo e 190 no maximo, caso não seja possivel alcançar o 190 o RRF emite um alerta)
;** P é quantidade de pontos P5:5 = 5 pontos no X e 5 pontos no Y

;###########################################################################
;#                    Configuração do Hotend e Mesa                        #    
;###########################################################################

M308 S0 P"bedtemp" Y"thermistor" T100000 B4092  ; Configura o sensor 0 (S0) como thermisthor (Y"thermistor"), ligado ao pino de sensor da mesa (P"bedtemp"), com o valor de resistencia de 100K (T100000) e valor beta de 4092 (B4092)*
M950 H0 C"bed" T0                               ; Configura um aquecedor o (H0), ligado no pino de controle da MESA (C"bed") e associa ao sensor de temperatura 0 (T0)
M307 H0 B0 S1.00                                ; Configura o aquecedor H0 a usar PID como controle de temperatura (B0) e configura a potencia de saida pra maxima (S1.00)
M140 H0                                         ; Mapea o aquecedor H0 como a mesa aquecida
M143 H0 S120                                    ; Configura o aquecedor H0 para o limite de temperatura maxima de 120° (S120)

M308 S1 P"e0temp" Y"thermistor" T100000 B4092   ; Configura o sensor 0 (S1) como thermisthor (Y"thermistor"), ligado ao pino de sensor da mesa (P"e0temp"), com o valor de resistencia de 100K (T100000) e valor beta de 4092 (B4092)*
M950 H1 C"e0heat" T1                            ; Configura um aquecedor o (H1), ligado no pino de controle da MESA (C"e0heat") e associa ao sensor de temperatura 1 (T1)
M307 H1 B0 S1.00                                ; Configura o aquecedor H1 a usar PID como controle de temperatura (B0) e configura a potencia de saida pra maxima (S1.00)
M143 H1 S280                                    ; Configura o aquecedor H1 para o limite de temperatura maxima de 280° (S280)

;* Valores informados pelo fabricante

;###########################################################################
;#                    Configuração de fan e fita led                       #    
;###########################################################################

M950 F0 C"fan0" Q500        ; Configura a saida de fan 0 da placa (C"fan0") como fan 0 (F0) e define a frequencia de 500Hz (Q500, Não precisa mexer nesse valor)
M106 P0 S0 H-1              ; Confiura o fan0 (P0) para iniciar desligado (S0)*
M950 F1 C"fan1" Q500        ; Configura a saida de fan 1 da placa (C"fan1") como fan 1 (F1) e define a frequencia de 500Hz (Q500, Não precisa mexer nesse valor)
M106 P1 S0 H1 T50           ; Confiura o fan1 (P1) para iniciar desligado (S0)* e o associa ao aquecedor 1 (H1) e configura o limiar de controle a 50° (T50)** 
M950 P2 C"e1heat" Q500      ; Configura a saida de aquecedor 2 (C"e1heat") como uma saida com controle de intensidade (P2) e define a frequencia de 500Hz (Q500) -- Será usada para o LED interno
M950 F2 C"fan2" Q500        ; Configura a saida de fan 2 da placa (C"fan2") como fan 3 (F2) e define a frequencia de 500Hz (Q500, Não precisa mexer nesse valor)
M106 P2 S1 H-1              ; Confiura o fan2 (P2) para iniciar ligado (S1)* 
;* Valor vai de 0 (totalmente desligado) á 255 (totalmente ligado)
;** Acima do valor definido em T o FAN1 será ligado, abaixo será desligado

;###########################################################################
;#                     Configuração de ferramenta                          #    
;###########################################################################

M563 P0 D0 H1 F0 S"Hotend"  ; Configura a ferramenta o (P0), associa o extusor 0 (D0) ao aquecedor 1 (H1) e o FAN 0 (F0) e nomeia como hotend (S"Hotend")*
G10 P0 X0 Y0 Z0             ; Configura o offset da ferramenta 0 (não precisa mexer)
G10 P0 R0 S0                ; Configura a ferramenta 0 (P0) com temperatura inicial 0 (S0) e temperatura de standby 0 (R0) Não precisa mexer

;###########################################################################
;#                    Configuração do acelerometro                         #    
;###########################################################################

M955 P0 C"E.7+C.2" I20 ; Configura o acelerometro o (P0) e indica os pinos de CS (chip-select) e INT (interrupção do acelerometro) (C"E.7+C.2") e informa a posição fisica do aelerometro instalado na maquina (I20)
; M593 P"zvd" F49  ; Configuração o tipo de compensação de ressonancia (P"zvd") e a frequencia que será comepensada (F49)

; Link para plugin para ajudar na configuração do input shaping 
; Material adicional para entende o input shaping https://docs.duet3d.com/User_manual/Tuning/Input_shaping_plugin

;###########################################################################
;#                    Configuração do Diversas                             #    
;###########################################################################

M671 X0:283 Y145.5:145.5 ; Configura a posição dos fusos na maquina para o ajuste individual dos fusos (Xmin:Xmax Ymin:Ymax)
M98 P"screen.g"          ; Executa o arquivo screen.g (Está na pasta sys, responsavel pela inicialiação do display)
M912 P0 S-1              ; Seleciona o sensor de temperatura do Microcontrolador da placa
T0                       ; Seleciona a ferramenta 0
M280 P0 S160             ; Envia o comando para o BLtouch reinicar de qualquer estado de erro e retrair o pino caso esteja abaixodo

;###########################################################################
;#                    Variaveis usadas nos macros                          #    
;###########################################################################


global interacoes = 5    ; Variavel para configurar a quantidade de tentativas de nivelamento dos motores do Z em relação ao X (G32, requer os motores do Z ligados em drivers independentes)
global tolerancia = 0.05 ; Variavel para configurar a diferença de altura em mm no nivelamento dos motores do Z em relação ao X
global centroMesaX = {(move.axes[0].max/2)}      ; Cria uma varialvel chamada centromesaX e diz que o valor dela é o tamanho maximo do eixo X dividio por 2
global centroMesaY = {(move.axes[1].max/2)}      ; Cria uma varialvel chamada centromesaY e diz que o valor dela é o tamanho maximo do eixo Y dividio por 2
global centroMesaProbeX = {(move.axes[0].max/2)-sensors.probes[0].offsets[0]}      ; Cria uma varialvel chamada centroMesaProbeX e diz que o valor dela é o tamanho maximo do eixo X dividio por 2 menos o offset do probe em X
global centroMesaProbeY = {(move.axes[1].max/2)-sensors.probes[0].offsets[1]}      ; Cria uma varialvel chamada centroMesaProbeY e diz que o valor dela é o tamanho maximo do eixo Y dividio por 2 menos o offset do probe em Y
