import math

def tobin1(number):
    number = number/(math.pi)
    if number == 0:
        return '0'*32
    elif number < 0:
        new = -pow(2, 0)
        bin = '1'
        for i in range(1, 32):
            if new + pow(2, -i) <= number:
                new += pow(2, -i)
                bin += '1'
            else:
                bin += '0'
    else:
        new = 0
        bin = '0'
        for i in range(1, 32):
            if new + pow(2, -i) <= number:
                new += pow(2, -i)
                bin += '1'
            else:
                bin += '0'
    return bin

def tohex1(number):
    number = tobin1(number)
    hexa = ''
    for i in range(0, 8):
        quad = number[i*4:i*4+4]
        num = 0
        for j in range(0,4):
            num += int(quad[j]) * pow(2, 3-j)
        hexnum = hex(num)
        hexnum = hexnum[2]
        hexa += hexnum
    return hexa

def tobin2(number):
    if number == 0:
        return '0'*32
    elif number < 0:
        new = -pow(2, 1)
        bin = '1'
        for i in range(0, 31):
            if new + pow(2, -i) <= number:
                new += pow(2, -i)
                bin += '1'
            else:
                bin += '0'
    else:
        new = 0
        bin = '0'
        for i in range(0, 31):
            if new + pow(2, -i) <= number:
                new += pow(2, -i)
                bin += '1'
            else:
                bin += '0'
    return bin

def tofloat2(bin):
    number = 0
    if bin[0] == '1':
        number -= 2
    for i in range(1,32):
        num = int(bin[i])
        number += num * pow(2, -i+1)
    return number


