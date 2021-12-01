	.data
sinmsg:	.asciiz	"sinus: "
cosmsg:	.asciiz	"\ncosinus: "

gamma:	.double			#constant gamma values (in radians)
	0.7853981633974483, 0.4636476090008061, 0.24497866312686414, 0.12435499454676144,
0.06241880999595735, 0.031239833430268277, 0.015623728620476831, 0.007812341060101111,
0.0039062301319669718, 0.0019531225164788188, 0.0009765621895593195, 0.0004882812111948983,
0.00024414062014936177, 0.00012207031189367021, 6.103515617420877e-05, 3.0517578115526096e-05,
1.5258789061315762e-05, 7.62939453110197e-06, 3.814697265606496e-06, 1.907348632810187e-06
const: 	.double 0.60725293500925		#constant K 

	.text
main:	
	li	$v0, 7		# load Phi argument from user (in radians), $f0 is going to store Beta, we initialize Beta as Phi
	syscall
	l.d	$f2, const	# x = K
	mtc1	$zero, $f4	# y = 0
	and	$s0, $s0, $zero	# i = 0
	la	$s7, gamma	# gamma[i] address
	lui	$s6, 0x8000	# we need this for signum
	mtc1	$zero, $f30	# we need this for signum
	
loop:
	mfc1	$t1, $f3	# take more significant part of x and save it in $t1
	mfc1	$t2, $f5	# take more significant part of y and save it in $t2
	l.d	$f10, ($s7)	# gamma[i] -> $f10
	c.lt.s	$f1, $f30
	bc1f	pow		# if (Beta>=0) call pow1
signum:
	# changes the sign to be the same as Beta sign
	xor	$t1, $t1, $s6	# change the x sign
	xor	$t2, $t2, $s6	# change the y sign
	mfc1	$t3, $f11	# take more significant part of gamma[i] and save it in $t3
	xor	$t3, $t3, $s6	# change the gamma[i] sign
	mtc1	$t3, $f11	# saves to $f11
pow:
	# multiply by 2^(-i), it is done by subtracting i from exponent
	sll	$s5, $s0, 20	
	subu	$t1, $t1, $s5	# subtracting i from x exponent
	subu	$t2, $t2, $s5	# subtracting i from y exponent 

	mtc1	$t1, $f23	
	mov.s	$f22, $f2	# sgn(Beta)*x*2^(-i) -> $f22
	mtc1	$t2, $f25	
	mov.s	$f24, $f4	# sgn(Beta)*y*2^(-i) -> $f24

	sub.d	$f2, $f2, $f24	# x = x - sgn(Beta)*y*2^(-i)
	add.d	$f4, $f4, $f22	# y = y + sgn(Beta)*x*2^(-i)
	sub.d   $f0, $f0, $f10	# Beta = Beta - sgn(Beta)*gamma[i]
	
	addiu	$s0, $s0, 1	# i++
	addiu	$s7, $s7, 8	# adjusting gamma[i] address to point on the next value
	
	blt	$s0, 20, loop	# if (i >= 20) break
	
end:
	li 	$v0, 4
	la	$a0, sinmsg	# print "sinus: "
	syscall	

	li 	$v0, 3
	mov.d	$f12, $f4	# print sin(Phi) -- its equal to y
	syscall	
	
	li 	$v0, 4
	la	$a0, cosmsg	# print "cosinus: "
	syscall	
	
	li	$v0, 3
	mov.d	$f12, $f2	# print cos(Phi) -- its equal to x
	syscall		

	
