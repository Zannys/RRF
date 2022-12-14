; ST7567 Init for FYSETC Mini12864 Panel V2.1
; Turn off backlight
M150 X2 R0 U0 B0 S3 F0
; Configure reset pin
M950 P1 C"PE.15"
; hardware reset of LCD
M42 P1 S0
G4 P500
M42 P1 S1
; Turn display on
M918 P2 C30 F1000000 E4
; Fade in backlight
while iterations < 256
 M150 X2 R255 U255 B255 P{iterations} S3 F0
 G4 P10
; flash Button 3 times

; Display "ready" button state
M150 X2 R128 U255 B0 P255 S3
M150 X2 R255 U0 B0 P255 S2
