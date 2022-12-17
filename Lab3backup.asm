#Variables
.data
#These three variables will handle multiplication.
t2variable: .word 0 
t3variable: .word 0
t4variable: .word 0 

#These two numbers are the inputs by the user for multiplication.
firstNumber: .word    0 #This variable will store the input.
secondNumber: .word 0

userInput: .asciiz "Enter a number: " #This variable will be responsible for prompting the user for an input.
userSecondInput: .asciiz "Enter a second number: " #This variable will be responsible for prompting the user for an input.

newLine: .asciiz "\n" #A new line variable

t7saveNumber: .word 0x10010000

textFile: .asciiz "C:/Users/Snake/HW/CMPEN351Lab3/Lab3.txt"
textOutput: .asciiz "I wanna watch Rick and Morty."

a: .asciiz "A"
b: .asciiz "B"
c: .asciiz "C"
d: .asciiz "D"
e: .asciiz "E"
f: .asciiz "F"
g: .asciiz "G"
h: .asciiz "H"
i: .asciiz "I"
j: .asciiz "J"
k: .asciiz "K"
l: .asciiz "L"
m: .asciiz "M"
n: .asciiz "N"
o: .asciiz "O"
p: .asciiz "P"
q: .asciiz "Q"
r: .asciiz "R"
s: .asciiz "S"
t: .asciiz "T"
u: .asciiz "U"
v: .asciiz "V"

.text
.globl main

main:

#===First Input Prompt===
#These three lines prints the userInput's "Enter a number: "
li $v0,4
la $a0,userInput
syscall
      
#These two lines read the user input stored in $v0.
li $v0, 5
syscall

#This line stores the user input at address stored in $t0.
sw $v0, firstNumber #I think this part does indeed save the decimal number to data memory.      
#This line loads the address of number in $t0.
lw $t0, firstNumber
       
#These three lines print a new line at the end.
add   $a0, $0, $0
li $v0, 4
la $a0, newLine
syscall

#===Second Input Prompt===
#These three lines prints the userInput's "Enter a number: "
add   $a0, $0, $0
li $v0,4
la $a0,userSecondInput
syscall
      
#These two lines read the user input stored in $v0.
li $v0, 5
syscall

#This line stores the user input at address stored in $t0.
sw $v0, secondNumber #I think this part does indeed save the decimal number to data memory.       
#This line loads the address of number in $t0.
lw $t1,secondNumber


#These three lines print a new line at the end.
add   $a0, $0, $0
li $v0, 4
la $a0, newLine
syscall
add   $a0, $0, $0

#===Variables, Again===
lw $t2, t2variable($zero)
lw $t3, t3variable($zero)
lw $t4, t4variable($zero)

#===Multiplication===
jal multiplication

#These lines print out the multiplication result.
li  $v0,1           
move    $a0,$t3     
syscall

#New line
li $v0, 4
la $a0, newLine
syscall
add   $a0, $0, $0             

#Opening the file
li $v0, 13
la $a0, textFile
li $a1, 1 #set to 0 to not write
syscall
move $s1, $v0

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, textOutput
la $a2, 50
syscall

#Close the file
li $v0, 16
move $a0, $s1
syscall

#===Restart===
#All lis here will reset the registers.
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
li $t5, 0
li $at, 0
li $a0, 0
li $a1, 0
li $a2, 0
li $a3, 0
li $s1, 0
li $s7, 0

#New line
li $v0, 4
la $a0, newLine
syscall
add   $a0, $0, $0 

#Restart the program.
beq $0, $0, main

#End the program. This should never happen.
li $v0,10
syscall

#Multiplication function
multiplication:
    move $t3, $0        # lw product
    move $t4, $0        # hw product

    beq $t1, $0, done #This line ends the function.
    beq $t0, $0, done #This line also ends the function.

    move $t2, $0        # extend multiplicand to 64 bits

     loop:
    andi $t5, $t0, 1    # LSB(multiplier)
    beq $t5, $0, next   # This skips the loop if zero.
    addu $t3, $t3, $t1  # lw(product) += lw(multiplicand)
    sltu $t5, $t3, $t1  # catch carry-out(0 or 1)
    addu $t4, $t4, $t5  # hw(product) += carry
    addu $t4, $t4, $t2  # hw(product) += hw(multiplicand)
    next:
    # shift multiplicand left
    srl $t5, $t1, 31    # copy bit from lw to hw
    sll $t1, $t1, 1
    sll $t2, $t2, 1
    addu $t2, $t2, $t5

    srl $t0, $t0, 1     # shift multiplier right
    bne $t0, $0, loop

    done:
    jr $ra
