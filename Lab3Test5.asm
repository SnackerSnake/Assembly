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
thirtytTwoVariable: .asciiz "32"

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
lw $t3, firstNumber
       
#These three lines print a new line at the end.
add   $a0, $0, $0
li $v0, 4
la $a0, newLine
syscall
add   $a0, $0, $0

jal weirdConversion

weirdConversion:
la $t6, 32 #$t6 is always 32

#Keep subtracting the multiplication number by 32 until it is 32 or less than that.
bgt  $t3, $t6, subtract 

#Print the number
bgtz  $t7, printT7

#blt $t7, $zero, convertPartTwo
jal convertPartTwo

#Subtracts $t3 by 32. $t7 will keep track of how many 32s are in $t3, the multiplication answer
subtract:
sub $t3, $t3, $t6
addi $t7, $t7, 1
jal weirdConversion

printT7:
beq $t3, 32, convertPartTwo #newest line
li  $v0,1           
move $a0,$t7
syscall
jal convertPartTwo

#NEED TO CONVSIDER LARGER NUMNBERS
convertPartTwo:
ble $t3, 9, normal
beq $t3, 10, ten
beq $t3, 11, eleven
beq $t3, 12, twelve
beq $t3, 13, thirteen
beq $t3, 14, fourteen
beq $t3, 15, fifteen
beq $t3, 16, sixteen
beq $t3, 17, seventeen
beq $t3, 18, eighteen
beq $t3, 19, nineteen
beq $t3, 20, twenty
beq $t3, 21, seventeen
beq $t3, 22, twentytwo
beq $t3, 23, twentythree
beq $t3, 24, twentyfour
beq $t3, 25, twentyfive
beq $t3, 26, twentysix
beq $t3, 27, twentyseven
beq $t3, 28, twentyeight
beq $t3, 29, twentynine
beq $t3, 30, thirty
beq $t3, 31, thirtyone
beq $t3, 32, thirtytwo

normal:
li  $v0,1           
move $a0,$t3
syscall

#End the program. 
li $v0,10
syscall

ten:
la $s7, a
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

eleven:
la $s7, b
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twelve:
la $s7, c
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

thirteen:
la $s7, d
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

fourteen:
la $s7, e
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

fifteen:
la $s7, f
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

sixteen:
la $s7, g
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

seventeen:
la $s7, h
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

eighteen:
la $s7, i
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

nineteen:
la $s7, j
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twenty:
la $s7, k
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twenyone:
la $s7, l
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twentytwo:
la $s7, m
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twentythree:
la $s7, n
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twentyfour:
la $s7, o
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twentyfive:
la $s7, p
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twentysix:
la $s7, q
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall
twentyseven:
la $s7, r
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

twentyeight:
la $s7, s
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall
twentynine:
la $s7, t
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

thirty:
la $s7, u
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

thirtyone:
la $s7, v
li  $v0, 4
move $a0, $s7 
syscall

#End the program. 
li $v0,10
syscall

thirtytwo:
bgt $t7, 0, thirtytwoExtra
addi $t8, $t8, 10
li  $v0, 1         
move $a0,$t8
syscall

#End the program. 
li $v0,10
syscall

thirtytwoExtra:
subi $t7, $t7, 1
addi $t8, $t8, 10
bgt $t7, -1, thirtytwoExtra
li  $v0, 1         
move $a0,$t8
syscall

#End the program. 
li $v0,10
syscall

