.data

string1: .asciiz "For add press 1, For sub press 2, For div press 3, For mult press 4,For remaminder press 5: "
string2: .asciiz "Enter a number: "
endLine: .asciiz "\n"
addition: .asciiz "Addition : "
subtraction: .asciiz "subtraction : "
dividition: .asciiz "dividition : "
multplication: .asciiz "multplication : "
remainder: .asciiz "Remainder is: "

.text
main:
	#These lines get the first number.
	li $v0,4
	la $a0,string2
	syscall
	
	li $v0,5
	syscall
	move $t0,$v0
	move $s0,$v0
	
	#These lines get the operator
	li $v0,4
	la $a0,string1
	syscall
	
	li $v0,4
	la $a0,endLine
	syscall
	
	li $v0,5
	syscall
	move $t2,$v0
	
	#These lines get the second number.
	li $v0,4
	la $a0,string2
	syscall
	
	li $v0,5
	syscall
	move $t1,$v0
	move $s1,$v0
	
	li $v0,4
	la $a0,endLine
	syscall
	
	beq $t2,1,Addition
	beq $t2,2,Subtraction
	beq $t2,3,Dividition	
	beq $t2,4,Multiplication
	beq $t2,5,Remainder	
	
Addition:

	li $v0,4
	la $a0,addition
	syscall
	
	li $v0,4
	la $a0,endLine
	syscall
		
	add $t3,$t0,$t1
	move $a0,$t3
	
	li $v0,1
	syscall
	
	j Exit
	
Subtraction:

	li $v0,4
	la $a0,subtraction
	syscall
			
	sub $t3,$t0,$t1
	move $a0,$t3
	
	li $v0,1
	syscall
	j Exit	

Dividition:

	li $v0,4
	la $a0,dividition
	syscall
			
	div $t0,$t1
	mflo $a0	
	li $v0,1
	syscall
		
	
	j Exit	
	
Multiplication:
        li $s3, 1 # Mask for extracting bit!
	li $t1, 0 # Counter for loop.
	
	beq $t1, 31, exit
	and $t0, $s1, $s3
	sll $s3, $s3, 1
	
	beq $t0, 0, multiply_inc
	add $s2, $s2, $s0
	
multiply_inc:
	sll $s0, $s0, 1
	addi $t1, $t1, 1
	j Multiplication

Remainder:
	
	li $v0,4
	la $a0,remainder
	syscall

	
	rem $t3,$t0,$t1
	move $a0,$t3
	li $v0,1
	syscall
	j Exit

Exit:

li $v0,10
syscall

exit:
	li $v0, 1
	add $a0, $s2, $zero
	syscall
	
	li $v0, 10
	syscall