#.data adds variables to the program in memory so that the program remembers what they are.
.data
Nums: .word 10, 20, 30, 40, 50
Total: .word 0

#.text deals with function-like code
.text
la $t0, Nums
li $t4, 5
jal calc
la $t0, Total
sw $t1, 0($t0)
li $v0, 10

#The line below ends the program.
syscall

calc:
lw $t2, 0($t0)
addu $t1, $t1, $t2
addiu $t0, $t0, 4
addiu $t4, $t4, -1
bgtz $t4, calc
jr $ra
