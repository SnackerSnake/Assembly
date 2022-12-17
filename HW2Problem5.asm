#.data adds variables to the program in memory so that the program remembers what they are.
.data
#The text below .data sets the variables, or registers, to be used in the program.
t0variable: .word 8 #This sets the register for $t0 to initially 8
t1variable: .word 2 #This sets the register for $t1 to initially 2
t2variable: .word 10 #This sets the register for $t2 to initially 10
t3variable: .word 0 #This sets the register for $t3 to initially 0

#.text deals with function-like code
.text
#The load words load the variables.
lw $t0, t0variable($zero)
lw $t1, t1variable($zero)
lw $t2, t2variable($zero)
lw $t3, t3variable($zero)

#These lines handle multiplication by 10.
sll $t0, $t2, 3
sll $t1, $t2, 1
add $t3, $t0, $t1

#These two lines finish the program.
li $v0,10
syscall
