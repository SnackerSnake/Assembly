.data
msg: .asciiz "Final Value: "

.text
li $t1, 4
li $t2, 16

add $s0, $t1, $t2, 5

li $v0, 5
la $a0, msg
syscall

li v0, 1
move $a0, $s0
syscall