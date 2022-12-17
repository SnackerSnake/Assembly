#.data adds variables to the program in memory so that the program remembers what they are.
.data
#The text below .data sets the variables, or registers, to be used in the program.
t0variable: .word 1 #This sets the register for $t0 to initially 1
t1variable: .word 0 #This sets the register for $t1 to initially 0

#.text deals with function-like code
.text
#The load words load the variables.
lw $t0, t0variable($zero)
lw $t1, t1variable($zero)

#These addis add numbers to $t0 like $t0+=1 in other programming languages.
#The first parameter is the variable receiving the addition. The second parameter is the first number added, and the third parameter is the second number added.
addi $t0, $t0, 2 #For example, register $t0 gets 1 from the original register $t0 and 2 from the input 2
addi $t0, $t0, 3
addi $t0, $t0, 4
addi $t0, $t0, 5
#This add gives the value of $t0 to $t1
add $t1, $t1, $t0

#These lines are reponsible for printing the result into the Run I/O
li $v0, 1
add $a0, $zero, $t1

#The line below ends the program.
syscall
