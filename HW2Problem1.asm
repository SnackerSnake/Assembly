.data
t0ariable: .word 0 #
t2variable: .word 0 #
t3variable: .word 0 #
.text
BIT_IS_ON:
lw $t2,$t0               # 
lw $t3,0x00000002       # 
AND $t2,$t2,$t3           # 
beq $t2,$t3,BIT_IS_ON       #

              #