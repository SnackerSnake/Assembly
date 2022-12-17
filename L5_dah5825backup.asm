#Note: I refactored a lot of the code because I felt like the logic was a lot different to me.
.data
stringInputOne: .asciiz "\nEnter 1st Number: "
stringOperator: .asciiz "Select Operator: "
stringInputTwo: .asciiz "\nEnter 2nd Number: "

firstNumber: .word 0:20
secondNumber: .word 0:20

resultText: .asciiz "Result: "
remainderText: .asciiz "\nRemainder: "

Result: .word 7
remainder: .word 0

equalSign: .asciiz " = "
decimalSign: .asciiz "."
newLine: .asciiz "\n"
space: .asciiz " "

errorMessage: .asciiz "Invalid input"

.text
 main:
 # Get the users first number
 la $a0, stringInputOne
 la $a1, firstNumber
 jal GetInput
 
 #Getting the operator inputed
 la $a0, stringOperator
 jal GetOperator
 
 # Get the users second number
 la $a0, stringInputTwo
 la $a1, secondNumber
 jal GetInput2
 
 #This will pass inputs and go to the address of the operator loop
 la $a0, firstNumber
 la $a1, secondNumber
 la $a2, Result
 la $ra, DisplayNumb
 li $s0,0
 li $t0, 0
 li $t5,0
 li $a3,0
 
 jal remove1
 
 doOperation:
 beq $t9, '+', AddNumb
 beq $t9, '-', SubNumb
 beq $t9, '*', MultNumb
 beq $t9, '/', DivNumb
 
 GetInput:
 li $v0,4
 syscall
 la $a0, firstNumber
 la $a1, 20
 li $v0, 8
 syscall
 jr $ra

 GetInput2:
 li $v0,4
 syscall
 li $v0, 8
 la $a0, secondNumber
 la $a1, 20
 syscall
#sw $v0,0($a1)
 #la $a0, firstNumber
 # la $a1, secondNumber
 jr $ra
 
 GetOperator:
 li $v0,4
 syscall

 li $v0, 12
 syscall
 move $t9, $v0
 jr $ra

convert1:
addi $t0, $t0, 0
lb $t1, 0($a0)
addiu $a0, $a0, 1
li $t2, 0x0a
beq $t1, $t2, break1
li $t2, 0x00
beq $t1, $t2, break1
li $t2, 0x2e
beq $t1, $t2, break1
subi $t3, $t1, 0x30
mul $t0, $t0, 10
add $t0, $t0, $t3
j convert1

break1: # dollars have been parsed
mul $t0, $t0, 100
li $t2, 0x2e
bne $t1, $t2, convert2
# get next character from the buffer
lb $t1, 0($a0)
#load a byte from 0($a0) ? $t1
#advance the pointer:
addiu $a0, $a0, 1
addiu $t3,$t1,-0x30
sltiu $t2,$t3,10
beqz $t2, convert2
mul $t3, $t3, 10
add $t0, $t0, $t3
#$t0 = $t0 + (10 * $t3)
# get next character from the buffer
lb $t1, 0($a0)
#load a byte from 0($a0) ? $t1
# see if this is an ascii digit 0-9
addiu $t3,$t1,-0x30
sltiu $t2,$t3,10
beqz $t2, convert2
# (it is within the range 0x30 to 0x39)
#$t3 = $t1 0x30
add $t0, $t0, $t3
#$t0 = $t0 + $t3
#sw $t0, 0($a0)
#convert second user input from ascii to integer

convert2:
addi $t5, $t5, 0
lb $t2, 0($a1)
addiu $a1, $a1, 1
li $t3, 0x0a
beq $t2, $t3, break2
li $t3, 0x00
beq $t2, $t3, break2
li $t3, 0x2e
beq $t2, $t3, break2
subi $t4, $t2, 0x30
mul $t5, $t5, 10
add $t5, $t5, $t4
j convert2

break2: # dollars have been parsed
mul $t5, $t5, 100
li $t3, 0x2e
bne $t2, $t3, doOperation
# get next character from the buffer
lb $t2, 0($a1)
#load a byte from 0($a0) ? $t1
#advance the pointer:
addiu $a1, $a1, 1
addiu $t4,$t2,-0x30
sltiu $t6,$t4,10
beqz $t6, doOperation
mul $t4, $t4, 10
add $t5, $t5, $t4
#$t0 = $t0 + (10 * $t3)
# get next character from the buffer
lb $t2, 0($a1)
#load a byte from 0($a0) ? $t1
# see if this is an ascii digit 0-9
addiu $t3,$t2,-0x30
sltiu $t4,$t3,10
beqz $t4, doOperation
# (it is within the range 0x30 to 0x39)
#$t3 = $t1 0x30
add $t5, $t5, $t3
#sw $t1, 8($a1)
#$t0 = $t0 + $t3
#sw $t1,0($a1)
jal doOperation

#AddNumb 0($a2) = 0($a0) + 0($a1)
#Add two data values and store the result back to memory
#Input: $a0 points to a word address in .data memory for the first data value
#Input: $a1 points to a word address in .data memory for the second data value
#Input: $a2 points to a word address in .data memory, where to store the result
AddNumb:
add $t2, $t0, $t5
sw $t2, 0($a2)
jal DisplayNumb
#SubNumb 0($a2) = 0($a0) - 0($a1)
#Subtract two data values and store the result back to memory

#Input: $a0 points to a word address in .data memory for the first data value
#Input: $a1 points to a word address in .data memory for the second data value
#Input: $a2 points to a word address in .data memory, where to store the result
SubNumb:
 #lw $t0, 0($a0)
#lw $t1,0($a1)
sub $t2, $t0, $t5
sw $t2, 0($a2)
jal DisplayNumb
##Procedure: MultNumb 0($a2) = 0($a0) * 0($a1)
#Multiply two data values and store the result back to memory
#Input: $a0 points to a word address in .data memory for the first data value
#Input:jal DisplayNumb $a1 points to a word address in .data memory for the second data value
#Input: $a2 points to a word address in .data memory, where to store the result

MultNumb:
 #lw $t0, 0($a0)
#lw $t1, 0($a1)
mul $t2, $t0, $t5
sw $t2, 0($a2)
jal DisplayNumb
#DivNumb 0($a2) = 0($a0) / 0($a1) 0($a3) = 0($a0) % 0($a1)
#Divide two data values and store the result back to memory
#Input: $a0 points to a word address in .data memory for the first data value
#Input: $a1 points to a word address in .data memory for the second data value
#Input: $a2 points to a word address in .data memory, where to store the quotient
#Input: $a3 points to a word address in .data memory, where to store the remainder

DivNumb:
 #lw $t0, 0($a0)
#lw $t1, 0($a1)
 bne $t9, '/', Invalid # Will give error if other operator is given
beq $t5, 0, Invalid # Will give error if you try to divide by 0
div $t0, $t5
mflo $t2 # Quotient
mfhi $a3 # Remainder
sw $t2, 0($a2)
sw $a3, remainder
jal DisplayNumb

Invalid:
li $v0, 4
la $a0, errorMessage
syscall
jal Exit

# remove \n or new line at the end of string of firstNumber
remove1:
lb $a3, firstNumber($s0) # Load character at index
 addi $s0,$s0,1 # Increment index
 bnez $a3,remove1 # Loop until the end of string is reached
 beq $a1,$s0,remove2 # Do not remove \n when it isn't present
 subiu $s0,$s0,2 # Backtrack index to '\n'
 sb $0, firstNumber($s0) # Add the terminating character in its place
 
# remove \n or new line at the end of string of secondNumber
remove2:
lb $a3, secondNumber($s0) # Load character at index
 addi $s0,$s0,1 # Increment index
 bnez $a3,remove2 # Loop until the end of string is reached
 beq $a1,$s0,convert1 # Do not remove \n when it isn't present
 subiu $s0,$s0,2 # Backtrack index to '\n'
 sb $0, secondNumber($s0) # Add the terminating character in its place
 jal convert1
 
#DisplayNumb
#Displays a message to the user followed by a numerical value
#Input: $a0 points to the text string that will get displayed to the user
#Input: $a1 points to a word address in .data memory, where the input value is stored
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

 #Prints a new line.
 la $a0, newLine
 li $v0, 4
 syscall

 jal remaindervalue
 
 #Displays a message to the user followed by a numerical value
#Input: $a0 points to the text string that will get displayed to the user
# parses remainder value to be displayed with 2 digit implied decimal point

remaindervalue:
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
 jal main

Exit:
 li $v0, 10
 syscall
