.data

stringInputOne: .asciiz "Enter 1st Number: "
stringOperator: .asciiz "Select Operator; For add press 1, For sub press 2, For div press 3, For mult press 4,For remaminder press 5: "
stringInputTwo: .asciiz "Enter 2nd Number: "

plusSign: .asciiz "+"
minusSign: .asciiz "-"
multSign: .asciiz "*"
divSign: .asciiz "/"

userOperator: .space 1
#userOperatorString: .asciiz ""

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
	la $a0, stringInputOne
	syscall
	
	li $v0,5
	syscall
	move $t0,$v0
	
	#These lines get the operator
	li $v0,4
	la $a0, stringOperator
	syscall
	
	li $v0,4
	la $a0,endLine
	syscall
	
	li $v0,5
	syscall
	move $t2,$v0
	
	#Give $v0's value to $v1; we want the operator
	li $a0, 8 #Get user text for operator
	la $v1, userOperator
	move $v1, $v0
	
	#These lines get the second number.
	li $v0,4
	la $a0, stringInputTwo
	syscall
	
	li $v0,5
	syscall
	move $t1,$v0
	
	li $v0,4
	la $a0,endLine
	syscall
	
	jal Addition
	#jal Subtraction
	#jal Dividition	
	#jal Multplication
	#jal Remainder
	jal Exit
	
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
	jr $ra
	
Subtraction:

	li $v0,4
	la $a0,subtraction
	syscall
			
	sub $t3,$t0,$t1
	move $a0,$t3
	
	li $v0,1
	syscall
	jr $ra	

Dividition:

	li $v0,4
	la $a0,dividition
	syscall
			
	div $t0,$t1
	mflo $a0	
	li $v0,1
	syscall
		
	
	jr $ra	
	
Multplication:

	li $v0,4
	la $a0,multplication
	syscall
			
	mul $t3,$t0,$t1
	move $a0,$t3
	
	li $v0,1
	syscall
	jr $ra	

Remainder:
	
	li $v0,4
	la $a0,remainder
	syscall

	
	rem $t3,$t0,$t1
	move $a0,$t3
	li $v0,1
	syscall
	jr $ra

Exit:

li $v0,10
syscall
