.data
firstnumber: .word 4
secondnumber: .word 16

.text
lw $t1, firstnumber($zero)
lw $t2, secondnumber($zero)

addi $t3, $t1, 10
add $t0, $t2, $t3

li $v0, 1
add $a0, $zero, $t0

syscall