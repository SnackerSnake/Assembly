.data
firstnumber: .word -8
secondnumber: .word 0x30

.text
lw $t1, firstnumber($zero)
lw $t2, secondnumber($zero)

sub $t3, $t1, $t2
subi $t0, $t3, 4

li $v0, 1
add $a0, $zero, $t0

syscall