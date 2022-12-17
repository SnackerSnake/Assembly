#.data adds variables to the program in memory so that the program remembers what they are.
.data
#The text below .data sets the variables, or registers, to be used in the program.
t2variable: .word 2 #This sets the register for $t0 to initially 2
t3variable: .word 0 #This sets the register for $t1 to initially 0

#.text deals with function-like code
.text
#The load words load the variables.
lw $t2, t2variable($zero)
lw $t3, t3variable($zero)

#This line multiplies 2 by 8. It takes the 2 from $t2 and puts it into $t3.
sll $t3, $t2, 3

#These two lines finish the program.
li $v0,10
syscall