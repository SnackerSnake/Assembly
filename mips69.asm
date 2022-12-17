.data 
message: .asciiz "Hello World"

.text
main:
li $v0, 4
la $a0, message
syscall

add $s0, $s0, 1