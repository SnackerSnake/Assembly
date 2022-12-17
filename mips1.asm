.data
$t1: .word 4
$t2: .word 16
text: .asciiz "Final Value: "

.text
li $v0, 4
la $a0, text

add $t0, $t1, $t2
li $v0, 1
move $a0, $t0
syscall