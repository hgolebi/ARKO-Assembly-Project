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
	addiu	$sp, $sp, 4
	la	$s7, gamma	# gamma[i] address
loop:
	bge	$s0, 20, end	# if (i >= 20) break
	addiu	$sp, $sp, 8
	
	s.d	$f2, -8($sp)	# x -> stack
	jal	signum		# call signum with x as an argument
	jal	pow2		# call pow2 with sgn(Beta)*x as an argument
	l.d	$f22, -8($sp)	# sgn(Beta)*x*2^(-i) -> $f22
	
	s.d	$f4, -8($sp)	# y -> stack
	jal	signum		# call signum with y as an argument
	jal	pow2		# call pow2 with sgn(Beta)*y as an argument
	l.d	$f24, -8($sp)	# sgn(Beta)*y*2^(-i) -> $f24
	
	sub.d	$f2, $f2, $f24	# x = x - sgn(Beta)*y*2^(-i)
	add.d	$f4, $f4, $f22	# y = y + sgn(Beta)*x*2^(-i)
	
	l.d	$f10, ($s7)	# gamma[i] -> $f10
	s.d	$f10, -8($sp)	# gamma[i] -> stack
	jal	signum		# call signum with gamma[i] as an argument
	l.d	$f10, -8($sp)	# sgn(Beta)*gamma[i] -> $f10
	sub.d   $f0, $f0, $f10	# Beta = Beta - sgn(Beta)*gamma[i]
	
	addiu	$s0, $s0, 1	# i++
	addiu	$s7, $s7, 8	# adjusting gamma[i] address to point on the next value
	
	j	loop
	
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
		
	li 	$v0, 10		# end of the main
	syscall			
	
signum:
	# changes the argument taken from the stack to be the same sign as Beta($f0)
	mtc1	$zero, $f30
	c.lt.s	$f1, $f30
	bc1t	change		# if (Beta<0) call change
	jr	$ra
change:
	lw	$t1, -4($sp)	# load argument from the stack (we only need first part)
	lui	$t2, 0x8000
	xor	$t1, $t1, $t2	# change the sign
	sw	$t1, -4($sp)	# return value
	jr	$ra
	
pow2:
	# multiplies the argument taken from the stack by 2^(-i)
	# it is done by subtracting i from exponent
	lw	$t4, -4($sp)	# load argument from the stack (we only need first part)
	sll	$t5, $s0, 20
	subu	$t4, $t4, $t5	# subtracting i from exponent
	sw	$t4, -4($sp)	# return value
	jr	$ra
