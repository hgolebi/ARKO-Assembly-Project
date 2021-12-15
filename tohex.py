hexlist = ['0x' for i in range(0, 20)]
str = '2000000012E4051D09FB385B051111D4028B0D430145D7E100A2F61E00517C550028BE5300145F2E000A2F98000517CC00028BE6000145F30000A2F90000517C000028BE0000145F00000A2F00000517'
i = 0
for let in str:
    hexlist[i//8] += let
    i += 1
j = 1
formated = ''
for hex in hexlist:
    formated += hex
    formated += ', '
    if j%4 == 0:
        formated += '\n'
    j += 1
print(formated)
