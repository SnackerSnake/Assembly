#.data adds variables to the program in memory so that the program remembers what they are.
.data
Numbers: .word 10, 20, 30, 40, 50 #This is the variable for the list of numbers.
Total: .word 0 #This is the variable for Total

#.text deals with function-like code
.text
li $t0, 0 #$t0 is the final total number
la $t5, Numbers #$t5 changes between the numbers in the Numbers variable
li $t2, 5 #$t2 is the loop counter
jal calc #This line goes to the loop from line 20 to 26
la $t5, Total #Honestly, I have no idea what lines 12 and 13 do.
sw $t1, 0($t5)
addu $t0, $t0, $t1 #This line gives the total from $t1 to $t0
li $v0, 10 #This is part of ending the program

#The line below ends the program.
syscall

#This loop will add the numbers from Numbers to $t1 five times.
calc:
lw $t4, 0($t5)
addu $t1, $t1, $t4 #This line adds each number from Numbers to $t1.
addiu $t5, $t5, 4
addiu $t2, $t2, -1 #This line reduces the timer by one each loop.
bgtz $t2, calc #This line keeps the loop going, I think, based on the timer.
jr $ra #This line exits the loop.
