import math

gamma_values = [0.7853981633974483, 0.4636476090008061, 0.24497866312686414, 0.12435499454676144,
0.06241880999595735, 0.031239833430268277, 0.015623728620476831, 0.007812341060101111,
0.0039062301319669718, 0.0019531225164788188, 0.0009765621895593195, 0.0004882812111948983,
0.00024414062014936177, 0.00012207031189367021, 6.103515617420877e-05, 3.0517578115526096e-05,
1.5258789061315762e-05, 7.62939453110197e-06, 3.814697265606496e-06, 1.907348632810187e-06]

K = 0.60725293500925

def sin_cos(phi):
    beta = phi
    x = K
    y = 0
    for i in range(0, 20):
        new_x = x - math.copysign(1, beta) * y * pow(2,-i)
        new_y = y + math.copysign(1, beta) * x * pow(2,-i)
        x, y = new_x, new_y
        beta = beta - math.copysign(1, beta) * gamma_values[i]
        # print("\nx=",x,"\ny=",y)
    cos, sin = x, y
    return sin, cos

# x = -0.166
# x = (-0.5)*math.pi
# sinx, cosx = sin_cos(x)
# print ('\n', sinx, cosx)
# print (math.sin(x), math.cos(x), '\n')
