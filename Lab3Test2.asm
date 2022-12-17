#Variables
.data
t0firstnumber: .word 2
t1secondnumber: .word 0
t2variable: .word 0
t3variable: .word 0
#number: .word 3
number: .word 2

t7saveNumber: .word 0x10010000

textFile: .asciiz "C:/Users/Snake/HW/CMPEN351Lab3/Lab3.txt"
textOutput: .asciiz "I wanna watch Rick and Morty."

.text
.globl multiplication

multiplication:
#Variables, Again
lw $t0, t0firstnumber($zero)
lw $t1, t1secondnumber($zero)
lw $t2, t2variable($zero)
lw $t7, t7saveNumber($zero)
lw $s2, number($zero)

#Multiplication
sll $t1, $s2, 0
sll $t2, $s2, 0
add $s2, $t1, $t2

li $v0, 1
add $a0, $zero, $s2
syscall

#Multiplication
#Old code
#sll $t3, $t0, 4
#sw $t3, 0($t7)
#add $s2, $t3, $s2
#syscall

#li $a0, 1

#Writing

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

#End the program.
li $v0,10
syscall
