#Note: I refactored a lot of the code because I felt like the logic was a lot different to me.
#Also, for the equation to show correctly, the 2nd digit in the decimal has to be entered (e.g. 2.5 has to be 2.50).
.data
#Strings for asking user to input numbers and a math operator to do math
stringInputOne: .asciiz "\nEnter 1st Number: "
stringOperator: .asciiz "Select Operator: "
stringInputTwo: .asciiz "\nEnter 2nd Number: "

#First and second number
firstNumber: .word 0:20
secondNumber: .word 0:20

#Result and remainder string
resultText: .asciiz "Result: "
remainderText: .asciiz "\nRemainder: "

#Result and remainder length I think
Result: .word 20
remainder: .word 0

#Strings for equal sign, period, decimal symbol, printing new line, and space like spacebar
equalSign: .asciiz " = "
decimalSign: .asciiz "."
newLine: .asciiz "\n"
space: .asciiz " "

errorMessage: .asciiz "Error: You either divided by 0 or put the wrong symbol for an operator."

.text
 main:
 #These get the user's first number.
 la $a0, stringInputOne
 la $a1, firstNumber
 jal GetInput
 
 #These get the operator symbol by the user.
 la $a0, stringOperator
 jal GetOperator
 
 #These get the user's second number.
 la $a0, stringInputTwo
 la $a1, secondNumber
 jal GetInput2
 
 #This will pass inputs from the user and go to the address of the operator loop.
 la $a0, firstNumber
 la $a1, secondNumber
 la $a2, Result
 la $ra, DisplayNumb
 li $s0,0
 li $t0, 0
 li $t5,0
 li $a3,0
 
 jal FirstRemoval
 
 #This function compares the user's input operator with an existing operator symbol to see what math operation to do.
 doOperation:
 beq $t9, '+', AddNumb
 beq $t9, '-', SubNumb
 beq $t9, '*', MultNumb
 beq $t9, '/', DivNumb
 
 #This function gets the first number inputted by the user.
 GetInput:
 li $v0,4
 syscall
 la $a0, firstNumber
 la $a1, 20
 li $v0, 8
 syscall
 jr $ra

 #This function gets the second number inputted by the user.
 GetInput2:
 li $v0,4
 syscall
 li $v0, 8
 la $a0, secondNumber
 la $a1, 20
 syscall
 jr $ra
 
 #This function gets the operator symbol from the user input.
 GetOperator:
 li $v0,4
 syscall

 li $v0, 12
 syscall
 move $t9, $v0
 jr $ra

#Converts the digits before the decimal (i.e. .) from ASCII to integer.
FirstConvert:
addi $t0, $t0, 0
lb $t1, 0($a0)
addiu $a0, $a0, 1
li $t2, 0x0a
beq $t1, $t2, FirstBreak
li $t2, 0x00
beq $t1, $t2, FirstBreak
li $t2, 0x2e
beq $t1, $t2, FirstBreak
subi $t3, $t1, 0x30
mul $t0, $t0, 10
add $t0, $t0, $t3
j FirstConvert

#Dollars have been parsed.
FirstBreak: 
mul $t0, $t0, 100
li $t2, 0x2e
bne $t1, $t2, SecondConvert
#We will get next character from the buffer.
lb $t1, 0($a0)
#Now load a byte from 0($a0) ? $t1.
#Now advance the pointer.
addiu $a0, $a0, 1
addiu $t3,$t1,-0x30
sltiu $t2,$t3,10
beqz $t2, SecondConvert
mul $t3, $t3, 10
add $t0, $t0, $t3
#$t0 = $t0 + (10 * $t3)
#Now we need to get next character from the buffer.
lb $t1, 0($a0)
#Again, load a byte from 0($a0) ? $t1
#Checkin if this is an ascii digit 0-9
addiu $t3,$t1,-0x30
sltiu $t2,$t3,10
beqz $t2, SecondConvert
# If it is within the range 0x30 to 0x39...
add $t0, $t0, $t3

#Convert second user input from ascii to integer.
SecondConvert:
addi $t5, $t5, 0
lb $t2, 0($a1)
addiu $a1, $a1, 1
li $t3, 0x0a
beq $t2, $t3, SecondBreak
li $t3, 0x00
beq $t2, $t3, SecondBreak
li $t3, 0x2e
beq $t2, $t3, SecondBreak
subi $t4, $t2, 0x30
mul $t5, $t5, 10
add $t5, $t5, $t4
j SecondConvert

#This break is doing the math operation.
SecondBreak: 
mul $t5, $t5, 100
li $t3, 0x2e
bne $t2, $t3, doOperation
#We will get next character from the buffer
lb $t2, 0($a1)
#Load a byte from 0($a0) ? $t1.
#Advance the pointer.
addiu $a1, $a1, 1
addiu $t4,$t2,-0x30
sltiu $t6,$t4,10
beqz $t6, doOperation
mul $t4, $t4, 10
add $t5, $t5, $t4
#$t0 = $t0 + (10 * $t3)
#Get the next character from the buffer.
lb $t2, 0($a1)
#We will load a byte from 0($a0) ? $t1
#Check and see if this is an ASCII digit from 0-9.
addiu $t3,$t2,-0x30
sltiu $t4,$t3,10
beqz $t4, doOperation
# If it is within the range 0x30 to 0x39...
add $t5, $t5, $t3
jal doOperation

#AddNumb 0($a2) = 0($a0) + 0($a1)
#Add two data values and store the result back to memory
AddNumb:
add $t2, $t0, $t5
sw $t2, 0($a2)
jal DisplayNumb

#SubNumb 0($a2) = 0($a0) - 0($a1)
#Subtract two data values and store the result back to memory
SubNumb:
 #lw $t0, 0($a0)
#lw $t1,0($a1)
sub $t2, $t0, $t5
sw $t2, 0($a2)
jal DisplayNumb


##Procedure: MultNumb 0($a2) = 0($a0) * 0($a1)
#Multiply two data values and store the result back to memory
MultNumb:
mul $t2, $t0, $t5
sw $t2, 0($a2)
jal DisplayNumb

#DivNumb 0($a2) = 0($a0) / 0($a1) 0($a3) = 0($a0) % 0($a1)
#Divide two data values and store the result back to memory
DivNumb:
bne $t9, '/', Invalid # This will give an error if other operator is given.
beq $t5, 0, Invalid # This will give error if you try to divide by 0.
div $t0, $t5
mflo $t2 # For Quotient
mfhi $a3 # For Remainder
sw $t2, 0($a2)
sw $a3, remainder
jal DisplayNumb

#This gives an error message if the user presses the wrong input.
Invalid:
li $v0, 4
la $a0, errorMessage
syscall
jal Exit

#This will remove \n or new line at the end of string of firstNumber.
FirstRemoval:
lb $a3, firstNumber($s0) # Load character at index.
 addi $s0,$s0,1 # Increment the index.
 bnez $a3,FirstRemoval # Loop until the end of string is reached.
 beq $a1,$s0,SecondRemoval # Do not remove \n when it isn't present.
 subiu $s0,$s0,2 # Backtrack index to '\n'.
 sb $0, firstNumber($s0) # Add the terminating character in its place.
 
#This will remove \n or new line at the end of string of secondNumber.
SecondRemoval:
lb $a3, secondNumber($s0) # Load character at index.
 addi $s0,$s0,1 # Increment the index.
 bnez $a3,SecondRemoval # Loop until the end of string is reached.
 beq $a1,$s0,FirstConvert # Do not remove \n when it isn't present.
 subiu $s0,$s0,2 # Backtrack index to '\n'.
 sb $0, secondNumber($s0) # Add the terminating character in its place.
 jal FirstConvert
 
#DisplayNumb
#Displays a message to the user followed by a numerical value
DisplayNumb:
li $t1, 100
 div $t3, $t2, $t1 # t2 = dollars ( $t0 / 100 = 123)
 rem $t4, $t2, $t1 # t3 = cents ( $t0 % 100 = 45)
 li $t1, 10
div $t5, $t4, $t1 # t4 = tens digit ( $t3 / 10 = 4)
rem $t6, $t4, $t1 # t5 = units digit ( $t3 % 10 = 5)

#Prints out "Result:"
li $v0,4
 la $a0, resultText
 syscall
 
  #Prints a space.
 la $a0, space
 li $v0, 4
 syscall
 
#Prints out the resulting number from the math operation.
move $a0, $t3
li $v0, 1
syscall
li $v0, 4
 la $a0, decimalSign
 syscall
move $a0,$t5
 li $v0, 1
syscall
move $a0, $t6
li $v0, 1
syscall 

 jal DisplayEquation
 
 #Displays the equation
DisplayEquation:

li $t1, 100
 div $t3, $t2, $t1 # t2 = dollars ( $t0 / 100 = 123)
 rem $t4, $t2, $t1 # t3 = cents ( $t0 % 100 = 45)
 li $t1, 10
div $t5, $t4, $t1 # t4 = tens digit ( $t3 / 10 = 4)
rem $t6, $t4, $t1 # t5 = units digit ( $t3 % 10 = 5)
 
 #Prints a new line.
 la $a0, newLine
 li $v0, 4
 syscall

 la $a0, firstNumber
 #sb $zero, 3($a0)
 li $v0, 4
 syscall
 
 #Prints a space.
 la $a0, space
 li $v0, 4
 syscall
 
 #Prints out the operator.
 li $v0,11
 move $a0, $t9
 syscall
 
 #Prints a space.
 la $a0, space
 li $v0, 4
 syscall

 la $a0, secondNumber
 # sb $zero, 3($a0)
 li $v0, 4
 syscall

 li $v0,4
 la $a0, equalSign
 syscall

jal DisplayNumbForEquation
 
 #DisplayNumb
#Displays a message to the user followed by a numerical value
#I did it again to jump properly.
DisplayNumbForEquation:
li $t1, 100
 div $t3, $t2, $t1 # t2 = dollars ( $t0 / 100 = 123)
 rem $t4, $t2, $t1 # t3 = cents ( $t0 % 100 = 45)
 li $t1, 10
div $t5, $t4, $t1 # t4 = tens digit ( $t3 / 10 = 4)
rem $t6, $t4, $t1 # t5 = units digit ( $t3 % 10 = 5)

#Prints out the resulting number from the math operation.
move $a0, $t3
li $v0, 1
syscall
li $v0, 4
 la $a0, decimalSign
 syscall
move $a0,$t5
 li $v0, 1
syscall
move $a0, $t6
li $v0, 1
syscall 

 jal RemainderValue
 
#Displays a message to the user followed by a numerical value
#Parses remainder value to be displayed with 2 digit implied decimal point
RemainderValue:
lw $a3, remainder
li $t3,0
move $t3,$a3
li $t1, 100
 div $t4, $t3, $t1 # t2 = dollars ( $t0 / 100 = 123)
 rem $t5, $t3, $t1 # t3 = cents ( $t0 % 100 = 45)
 li $t1, 10
div $t6, $t5, $t1 # t4 = tens digit ( $t3 / 10 = 4)
rem $t7, $t5, $t1 # t5 = units digit ( $t3 % 10 = 5)
li $v0, 4
 la $a0, remainderText
 syscall
li $v0, 1
move $a0, $t4
syscall
li $v0, 4
 la $a0, decimalSign
 syscall
 li $v0, 1
move $a0, $t6
syscall
 li $v0, 1
move $a0, $t7
syscall

 #Prints a new line.
 la $a0, newLine
 li $v0, 4
 syscall
 
 jal main

#Exits the program. This is will only run if there is an error.
Exit:
 li $v0, 10
 syscall
