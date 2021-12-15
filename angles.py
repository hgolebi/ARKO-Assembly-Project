from math import atan, tan
from converter import tobin1

angles = [atan(pow(2, -n)) for n in range (0, 20)]
tans = [tan(ang) for ang in angles]
print(angles)
bin_angles = []
for ang in angles:
    bin_angles.append(tobin1(ang))

formated = ''
i = 0
for ang in bin_angles:
    formated += ang
    # formated += ', '
    # if i % 2 == 1:
    #     formated += '\n'
    i += 1
print(formated)