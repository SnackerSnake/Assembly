.data
input: .word 1
output: .word 0

.text
lw $t0, input
and $t1, $t0, 0x01
or $t1, $t1, 0x30
sw $t1, output

li $v0,10
syscall