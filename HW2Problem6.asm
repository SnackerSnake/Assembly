.data
t0variable: .word 0

.text
li	$t0, -1
lui	$t0, 0x8000

li $v0,10
syscall