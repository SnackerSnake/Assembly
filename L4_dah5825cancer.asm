#Notes: Missing conventions
#Using jal for AddNumb, SubNumb, MultNumb, and DivNumb. For real, how are you supposed to call jal if they are all four conditional and you need a beq or equivalent instruction for an if statement? I spent more than 2 hours looking over the module videos trying to figure this voodoo.
#Having DisplayNumb's input in main...Not only is the function description vague (just results or ALL numbers?), but also, using $a0 like that in main would break a lot of the code because $a0 is also used as AddNumb, SubNumb, etc. input
#Again for DisplayNumb, putting the message code "li $v0,4 la $a0,result syscall" inside it entirely breaks the calculator
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
result: .asciiz "Result: "
addition: .asciiz "Addition : "
subtraction: .asciiz "subtraction : "
division: .asciiz "dividition : "
multplication: .asciiz "multplication : "
remainderString: .asciiz "Remainder is: "

input: .word 0
resultNumber: .word 0
remainder: .word 0

quotient: .asciiz "Quotient: "

.text
main:
	#These lines get the first number.
	la $a0, stringInputOne
	lw $a1, input($zero)
	jal GetInput
	
	#These lines get the operator
	la $a0, stringOperator
	jal GetOperator
	move $v1, $a0
	
	#These lines get the second number.
	la $a0, stringInputTwo
	lw $a1, input($zero)
	jal GetInput
	
	#These lines help jump to the appropriate operation.
	lb $v1, userOperator($zero)
	
	lb $s0, plusSign($zero)
        lb $s1, minusSign($zero)
        lb $s2, multSign($zero)
	lb $s3, divSign($zero)
	
	beq $v1,$s0,AddNumb
	beq $v1,$s1,SubNumb
	
	#Variables for mult
	li $a0, 0 #Resetting $a0
	li $s3, 1 # Mask for extracting bit!
	li $t1, 0 # Counter for loop.
	#Popping I think (for mult and div)
	lw $s0, 0($sp)
	add $sp, $sp, 4
	lw $s1, 0($sp)
	add $sp, $sp, 4
	beq $v1,$s2,MultNumb
	
	add $s2, $zero, $s0 # Remainder register
	#Reset $s3
	li $s3, 0
	sll $s2, $s2, 1
	beq $v1,$s3,DivNumb

#These lines get the first number.
GetInput: 
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	move $a1,$v0
	
	#Stacking by Pushing I think
	subi $sp, $sp, 4
	sw $a1, 0($sp)
	
	jr $ra

#These lines get the operator
GetOperator:
li $v0,4

syscall
	
li $v0, 8 #Get user text for operator
la $a0, userOperator
li $a1, 4
syscall

jr $ra

#This function displays the result of all four operations.
DisplayNumb:
	
li $v0,1
syscall

jr $ra
	
AddNumb:

	li $v0,4
	la $a0,result
	syscall
	
	#Popping I think
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
		
	add $a2,$a0,$a1
	
	move $a0,$a2
	jal DisplayNumb
	
	j Exit
	
SubNumb:

	li $v0,4
	la $a0,result
	syscall
	
	#Popping I think
	lw $a1, 0($sp)
	add $sp, $sp, 4
	lw $a0, 0($sp)
	add $sp, $sp, 4
			
	sub $a2,$a0,$a1
	move $a0,$a2
	
	jal DisplayNumb
	
	j Exit	


DivNumb:
	bge $s3, 16, DisplayNumbDivision
	
	srl $t0, $s2, 16
	sub $t0, $t0, $s1
	
	li $v0, 35
	add $a0, $zero, $s2
	syscall
	
	li $v0, 4
	la $a0, endLine
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
	j DivNumb
	
MultNumb:		
	beq $t1, 31, DisplayNumbMult
	and $t0, $s1, $s3
	sll $s3, $s3, 1
	
	beq $t0, 0, MultiplyIncrease
	add $s4, $s4, $s0
	
MultiplyIncrease:
	sll $s0, $s0, 1
	addi $t1, $t1, 1
	j MultNumb
	
DisplayNumbMult:
	li $v0,4
	la $a0,result
	syscall

	li $v0,1
	move $a0,$s4
	syscall

	j Exit

Exit:

li $v0,10
syscall

DisplayNumbDivision:
li $v0, 4
	la $a0, endLine
	syscall
	
	la $a0, quotient
	syscall
	
	li $v0, 36
	addu $a0, $zero, $s0
	syscall
	
	li $v0, 4
	la $a0, endLine
	syscall
	
	la $a0, remainderString
	syscall
	
	li $v0, 36
	addu $a0, $zero, $s1
	syscall
	
	j Exit