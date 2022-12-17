.data
firstnumber: .word 4
secondnumber: .word 16

.text
lw $t1, firstnumber($zero)
lw $t2, secondnumber($zero)

add $t3, $t1, $t2
addi $t0, $t3, 5

li $v0, 1
add $a0, $zero, $t0

syscall