#Missing functionality:
#Division with Shifting: I couldn't figure out division with shifting.

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

errorOne: .asciiz "Error: Numbers cannot be divided by zero."
errorTwo: .asciiz "Error: This calculator cannot do negative numbers for multiplication and division."
errorThree: .asciiz "Error: You typed in the wrong symbol for an operator."

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
	
	#For PrintAll Function to print entire equation
	#add $s5, $a1, $zero
	
	#These lines help jump to the appropriate operation.
	lb $v1, userOperator($zero)
	
	lb $s0, plusSign($zero)
        lb $s1, minusSign($zero)
        lb $s2, multSign($zero)
	
	
	beq $v1,$s0,AddNumb
	beq $v1,$s1,SubNumb
	
	#Variables for mult
	li $a0, 0 #Resetting $a0
	li $s3, 1 # Mask for extracting bit!
	li $t1, 0 # Counter for loop.
	
	#Popping I think
	lw $s0, 0($sp)
	add $sp, $sp, 4
	lw $s1, 0($sp)
	add $sp, $sp, 4
	
	#Negative number errror if statements
	bltz $s0, ExitNegativeMultDiv
	bltz $s1, ExitNegativeMultDiv
	
	#Multiply Function Call!
	beq $v1,$s2,MultNumb
	
	#Error if divide by zero 
	beq $s0, $zero, ExitDivideByZero
	
	#Reset $s3
	lb $s3, divSign($zero)
	
	#Divide function call!
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
	
	j RestartProgram
	
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
	
	j RestartProgram	

DivNumb:

	li $v0,4
	la $a0,result
	syscall
	
	div $s1,$s0
	mflo $a0
	li $v0,1
        syscall	
	
	jal Remainder
	
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
	
#This function prints out the result for multiplication.
DisplayNumbMult:
	li $v0,4
	la $a0,result
	syscall

	li $v0,1
	move $a0,$s4
	syscall

	j RestartProgram

#This function prints out the remainder for division.
Remainder:
	li $v0,4
	la $a0,endLine
	syscall
	
	li $v0,4
	la $a0,remainderString
	syscall

	
	rem $t3,$s1,$s0
	move $a0,$t3
	li $v0,1
	syscall
	
	jal RestartProgram

Exit:

	li $v0,10
	syscall
	
ExitDivideByZero:
	li $v0, 4
	la $a0, errorOne
	syscall

	li $v0,10
	syscall
	
ExitNegativeMultDiv:
	li $v0, 4
	la $a0, errorTwo
	syscall

	li $v0,10
	syscall

#PrintAll:

#This function restarts the program entirely aftering doing one operation.
RestartProgram:

	#Reset all of the registers.
	add $a0, $zero, $zero
	add $a1, $zero, $zero
	add $a2, $zero, $zero
	add $a3, $zero, $zero
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	add $t5, $zero, $zero
	add $t6, $zero, $zero
	add $t7, $zero, $zero
	add $s0, $zero, $zero
	add $s1, $zero, $zero
	add $s2, $zero, $zero
	add $s3, $zero, $zero
	add $s4, $zero, $zero
	add $s5, $zero, $zero
	add $s6, $zero, $zero
	add $s7, $zero, $zero
	add $t8, $zero, $zero
	add $t9, $zero, $zero
	
	#New Line like \n
	li $v0,4
	la $a0,endLine
	syscall
	
	#Go back to main.
	j main
