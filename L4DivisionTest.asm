.data
newLine: .asciiz "\n"
quotient: .asciiz "Quotient: "
remainder: .asciiz "Remainder: "

.text
.globl main

main:
	li $s0, 43 # Dividend
	li $s1, 7 # Divisor
	add $s2, $zero, $s0 # Remainder register
	li $s3, 0
	
divide:
	sll $s2, $s2, 1
	
divide_modulo:
	bge $s3, 16, exit
	
	srl $t0, $s2, 16
	sub $t0, $t0, $s1
	
	li $v0, 35
	add $a0, $zero, $s2
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	bge $t0, 0, pos_rem
	
	# If remainder not positive
	sll $s2, $s2, 1 # Shift left 1.
	
	j inc_counter
	
pos_rem:
	sll $s2, $s2, 16
	srl $s2, $s2, 16
	
	sll $t0, $t0, 16
	addu $s2, $s2, $t0 # Add upper-16 bits.
	
	# Shift left 1 and add 1.
	sll $s2, $s2, 1
	addi $s2, $s2, 1
	
inc_counter:
	addi $s3, $s3, 1
	j divide_modulo
	
exit:
	andi $s0, $s2, 0x0000FFFF # Extract lower 16 bits. (quotient)
	
	andi $s1, $s2, 0xFFFF0000 # Extract upper 16 bits.
	srl $s1, $s1, 17 # Shift upper 16 down to lower bits + 1 offset on upper-half. (remainder)
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	la $a0, quotient
	syscall
	
	li $v0, 36
	addu $a0, $zero, $s0
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	la $a0, remainder
	syscall
	
	li $v0, 36
	addu $a0, $zero, $s1
	syscall