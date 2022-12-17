#Variables
.data
#These three variables will handle multiplication.
t2variable: .word 0 
t3variable: .word 0
t4variable: .word 0 

#These two numbers are the inputs by the user for multiplication.
firstNumber: .word  0 
secondNumber: .word 0

userInput: .asciiz "Enter a number: " #This variable will be responsible for prompting the user for an input.
userSecondInput: .asciiz "Enter a second number: " #This variable will be responsible for prompting the user for an input.

newLine: .asciiz "\n" #A new line variable

t7saveNumber: .word 0x10010000

textFile: .asciiz "D:/Lab3.txt" #For the name of the txt file to modify

#These are for the letters for converting to base 32.
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

#Store inputs into memory
memoryArrayOne: .word 20
memoryArrayTwo: .word 20 

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
add   $a0, $0, $0 
li $v0, 4
la $a0, newLine
syscall
add   $a0, $0, $0 

#Just in case, reset these registers
li $s6, 0
li $s7, 0

#Convert to base 32
jal weirdConversion

#To close the file and restart the program.
filesAndRestart:
#New line
li $v0, 4
la $a0, newLine
syscall
add   $a0, $0, $0 

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
li $t6, 0
li $at, 0
li $a0, 0
li $a1, 0
li $a2, 0
li $a3, 0
li $s1, 0
li $s6, 0
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

    done: #End multiplication function
    jr $ra
    
weirdConversion:
#New line
li $v0, 4
la $a0, newLine
syscall
add   $a0, $0, $0 

#===For Files===

add   $s0, $0, $0 #reset just in case

#Opening the file
li $v0, 13
la $a0, textFile
li $a1, 1 #set to 0 to not write
syscall
move $s1, $v0

#===Base 32 conversion===
la $t6, 32 #$t6 is always 32

#Keep subtracting the multiplication number by 32 until it is 32 or less than that.
bgt  $t3, $t6, subtract 

#Print the number
bgtz  $t7, printT7

#blt $t7, $zero, convertPartTwo
jal convert

#Subtracts $t3 by 32. $t7 will keep track of how many 32s are in $t3, the multiplication answer
subtract:
sub $t3, $t3, $t6
addi $t7, $t7, 1
jal weirdConversion

#Prints a one digit/ten for every 32 in a number
printT7:
beq $t3, 32, convert #newest line
li  $v0,1           
move $a0,$t7
syscall

jal convert

#Converts a digit to the appropriate 32 base equivalent
convert:
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
beq $t3, 21, twentyone
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

#Prints base 32's 1-9
normal:
li  $v0,1           
move $a0,$t3
syscall

#Idk how to make integers on .txt
#Write on the file
#li $v0, 9
#li $a0, 4
#syscall
#move $s0, $v0

#sb $s0, 0($t3)
#li $v0, 15
#move $a0, $s1
#move $a1, $s0
#la $a2, 50
#syscall
#Close the file
#li $v0, 16
#move $a0, $s1
#syscall

jal filesAndRestart

#Turns 10 into A and writes it on the file
ten:
la $s7, a
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, a
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

eleven: #Turns 11 into B and writes it on the file
la $s7, b
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, b
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

twelve: #Turns 12 into C and writes it on the file
la $s7, c
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, c
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

thirteen: #Turns 13 into D and writes it on the file
la $s7, d
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, d
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

fourteen: #Turns 14 into E and writes it on the file
la $s7, e
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, e
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

fifteen: #Turns 15 into F and writes it on the file
la $s7, f
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, f
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

sixteen: #Turns 16 into G and writes it on the file
la $s7, g
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, g
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

seventeen: #Turns 17 into H and writes it on the file
la $s7, h
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, h
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

eighteen: #Turns 18 into I and writes it on the file
la $s7, i
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, i
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

nineteen: #Turns 19 into J and writes it on the file
la $s7, j
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, j
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

twenty: #Turns 20 into K and writes it on the file
la $s7, k
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, k
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

twentyone: #Turns 21 into L and writes it on the file
la $s7, l
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, l
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall

jal filesAndRestart

twentytwo: #Turns 22 into M and writes it on the file
la $s7, m
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, m
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall

jal filesAndRestart

twentythree: #Turns 23 into N and writes it on the file
la $s7, n
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, n
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

twentyfour: #Turns 24 into O and writes it on the file
la $s7, o
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, o
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

twentyfive: #Turns 25 into P and writes it on the file
la $s7, p
li  $v0, 4
move $a0, $s7
syscall     

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, p
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall

jal filesAndRestart

twentysix: #Turns 26 into Q and writes it on the file
la $s7, q
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, q
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

twentyseven: #Turns 27 into A and writes it on the file
la $s7, r
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, r
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

twentyeight: #Turns 28 into S and writes it on the file
la $s7, s
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, s
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

twentynine: #Turns 29 into T and writes it on the file
la $s7, t
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, t
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

thirty: #Turns 30 into U and writes it on the file
la $s7, u
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, u
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

thirtyone: #Turns 31 into V and writes it on the file
la $s7, v
li  $v0, 4
move $a0, $s7 
syscall

#Write on the file
li $v0, 15
move $a0, $s1
la $a1, v
la $a2, 2
syscall
#Close the file
li $v0, 16
move $a0, $s1
syscall


jal filesAndRestart

thirtytwo: #Turns 32 into 10 and writes it on the file
bgt $t7, 0, thirtytwoExtra
addi $t8, $t8, 10
li  $v0, 1         
move $a0,$t8
syscall

jal filesAndRestart

thirtytwoExtra: #Turns numbers that consists of multiply 32s into the right base 32 number (e.g. 20 for 64, 30 for 96)
subi $t7, $t7, 1
addi $t8, $t8, 10
bgt $t7, -1, thirtytwoExtra
li  $v0, 1         
move $a0,$t8
syscall

jal filesAndRestart
