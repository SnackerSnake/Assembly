.data

buffer: .asciiz " "

.text
la $a0 buffer
while(1)
{
lb 0($a0), $t1
addiu $a0, $a0, 1

li $t2, 0xA
beq $t1, $t2, break
beq $t1, $t0, break

li $t2, 0x2e
beq $t1, $t2, break

addu
}