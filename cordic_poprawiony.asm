	.data
sinmsg:	.asciiz	"sinus: "
cosmsg:	.asciiz	"\ncosinus: "

gamma:	.word	# gamma values
	0x20000000, 0x12E4051D, 0x09FB385B, 0x051111D4, 
	0x028B0D43, 0x0145D7E1, 0x00A2F61E, 0x00517C55,
	0x0028BE53, 0x00145F2E, 0x000A2F98, 0x000517CC,
	0x00028BE6, 0x000145F3, 0x0000A2F9, 0x0000517C,
	0x000028BE, 0x0000145F, 0x00000A2F, 0x00000517,
const: 	.word 0x26DD3B6A	#constant K = 0.60725293500925

	.text
main:	
	li 	$v0, 5		# load Phi argument
	syscall
	move	$s1, $v0	# Beta = Phi
	lw	$s2, const	# x = K
	and	$s3, $s3, $zero	# y = 0
	and	$s0, $s0, $zero	# i = 0
	la	$s7, gamma	# gamma[i] address
	
loop:
	lw	$t1, ($s7)	# load gamma[i]
signum:
	# changes the sign to be the same as Beta sign
	sra	$t0, $s1, 31	
	xor	$t1, $t0, $t1	# invert gamma[i] if beta < 0
	xor	$t2, $t0, $s2	# invert x if beta < 0
	xor	$t3, $t0, $s3	# invert y if beta < 0
	
	srl	$t0, $s1, 31	
	add	$t1, $t1, $t0	# add 1 to gamma[i] if beta < 0
	add	$t2, $t2, $t0	# add 1 to x if beta < 0
	add	$t3, $t3, $t0	# add 1 to y if beta < 0
pow2:
	# multiply by 2^(-i), by shifting right
	srav	$t2, $t2, $s0 	# x * 2^(-i)
	srav	$t3, $t3, $s0 	# y * 2^(-i)

	sub	$s2, $s2, $t3	# x = x - sgn(Beta)*y*2^(-i)
	add	$s3, $s3, $t2	# y = y + sgn(Beta)*x*2^(-i)
	sub   	$s1, $s1, $t1	# Beta = Beta - sgn(Beta)*gamma[i]
	
	addiu	$s0, $s0, 1	# i++
	addiu	$s7, $s7, 4	# adjusting gamma[i] address to point on the next value
	
	blt	$s0, 20, loop	# if (i >= 20) break, else jump to the beginning of the loop
	
end:
	li 	$v0, 4
	la	$a0, sinmsg	# print "sinus: "
	syscall	

	li 	$v0, 35
	move	$a0, $s3	# print sin(Phi) -- its equal to y
	syscall	
	
	li 	$v0, 4
	la	$a0, cosmsg	# print "cosinus: "
	syscall	
	
	li	$v0, 35
	move	$a0, $s2	# print cos(Phi) -- its equal to x
	syscall		

	
