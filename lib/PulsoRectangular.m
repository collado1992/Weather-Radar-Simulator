function Pulso = PulsoRectangular(d_NR, Fc, c, fase_o)

Pulso = exp(1j*2*pi*Fc*(-2*d_NR/c + fase_o));