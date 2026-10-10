NMOS Id-Vds Characteristics (white background)

Vdd  d  0  DC 0
Vgs  g  0  DC 0
M1   d  g  0  0  nmos1  W=5u L=16u

.model nmos1 NMOS (LEVEL=1 VTO=1 KP=50u LAMBDA=0.01)

.dc Vdd 0 5 0.02 Vgs 1 4 1

.control
  run
  set color0=white
  set color1=black
  let id_uA = -i(Vdd)*1e6
  plot id_uA ylabel 'Id (uA)' xlabel 'Vds (V)' title 'NMOS Id-Vds Characteristics'
.endc

.end