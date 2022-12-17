.data

stringInputOne: .asciiz "Enter 1st Number: "
stringOperator: .asciiz "Operator: "
stringInputTwo: .asciiz "Enter 2nd Number: "

plusSign: .asciiz "+"
minusSign: .asciiz "-"
multSign: .asciiz "*"
divSign: .asciiz "/"

userOperator: .space 4
#userOperator: .asciiz "-"

endLine: .asciiz "\n"
addition: .asciiz "Addition : "
subtraction: .asciiz "subtraction : "
division: .asciiz "dividition : "
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
	
	#Stacking by Pushing I think
	sub $sp, $sp, 4
	sw $v0, 0($sp)
	
	#These lines get the operator
	li $v0,4
	la $a0, stringOperator
	syscall
	
	li $v0, 8 #Get user text for operator
	la $a0, userOperator
	li $a1, 4
	syscall
	move $v1, $a0
	
	#These lines get the second number.
	li $v0,4
	la $a0, stringInputTwo
	syscall
	
	li $v0,5
	syscall
	move $t1,$v0
	
	#Stacking by Pushing I think
	sub $sp, $sp, 4
	sw $v0, 0($sp)
	
	li $v0,4
	la $a0,endLine
	syscall
	
	#These lines help jump to the appropriate operation.
	lb $v1, userOperator($zero)
	
	lb $s0, plusSign($zero)
        lb $s1, minusSign($zero)
        lb $s2, multSign($zero)
	lb $s3, divSign($zero)
	
	beq $v1,$s0,AddNumb
	beq $v1,$s1,SubNumb
	beq $v1,$s2,MultNumb
	beq $v1,$s3,DivNumb
	
AddNumb:

	li $v0,4
	la $a0,addition
	syscall
	
	li $v0,4
	la $a0,endLine
	syscall
	
	#Popping I think
	lw $t0, 0($sp)
	add $sp, $sp, 4
	lw $t1, 0($sp)
	add $sp, $sp, 4
		
	add $t3,$t0,$t1
	move $a0,$t3
	
	li $v0,1
	syscall
	j Exit
	
SubNumb:

	li $v0,4
	la $a0,subtraction
	syscall
	
	#Popping I think
	lw $t0, 0($sp)
	add $sp, $sp, 4
	lw $t1, 0($sp)
	add $sp, $sp, 4
			
	sub $t3,$t1,$t0
	move $a0,$t3
	
	li $v0,1
	syscall
	j Exit	

DivNumb:

	li $v0,4
	la $a0,division
	syscall
			
	div $t0,$t1
	mflo $a0	
	li $v0,1
	syscall
		
	
	j Exit	
	
MultNumb:

	li $v0,4
	la $a0,multplication
	syscall
			
	mul $t3,$t0,$t1
	move $a0,$t3
	
	li $v0,1
	syscall
	j Exit	

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