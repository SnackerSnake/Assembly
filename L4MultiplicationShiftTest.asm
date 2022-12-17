# pls multiply 32-bit nums.

.text
.globl main

main:
	li $s0, 211 # Input 1.
	li $s1, 211 # Input 2.
	li $s2, 0 # Result's going to be in s2!
	li $s3, 1 # Mask for extracting bit!
	li $t1, 0 # Counter for loop.
	
multiply:
	beq $t1, 31, exit
	and $t0, $s1, $s3
	sll $s3, $s3, 1
	
	beq $t0, 0, multiply_inc
	add $s2, $s2, $s0
	
multiply_inc:
	sll $s0, $s0, 1
	addi $t1, $t1, 1
	j multiply
	
exit:
	li $v0, 1
	add $a0, $s2, $zero
	syscall
	
	li $v0, 10
	syscall