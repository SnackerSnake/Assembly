.data
	Array:	.space 80
	limit:	.word 5
	zero:	.float 0.0
	msg1: .asciiz "Enter 5 floating point numbers:\n"  
	msg2: .asciiz "Content of array before sorting:\n"  
	msg3: .asciiz "Content of array after sorting:\n"  
	msg4: .asciiz "Average= "
	.globl main
.text
main:

#Print a message "Enter 5 floating point numbers:"
	li $v0, 4       	 # load 4 into $v0 (for printing a string)        
	la $a0,msg1     	 # load address of string to register $a0     
	syscall         	 # print the corresponding string to console
	
# Read 5 number of floating point number to Array	
	lw $t1,limit		# $t1=limit
 	la $s0,Array  		# $a0= Array base address 
 L1:
  	beq $t1,$zero,DONE	# if $t1==0,then goto DONE 
 	li $v0,6		# read a floating point number using system service 6
  	syscall
  	s.s $f0,0($s0)		# store the floating point number to array
  	addi $s0,$s0,4		# $s0=S0+4
 	addi $t1,$t1,-1		# decrement $t1
 	j L1

DONE:
#print message "Content of array before sorting:"	 

	li $v0, 4       	 # load 4 into $v0 (for printing a string)        
	la $a0,msg2     	 # load address of string to register $a0     
	syscall         	 # print the corresponding string to console
# print the Array using procedure PRINT_ARRAY
	la $a1,Array
 	lw $a2,limit 
 	jal Print_Array
# sort the Array using procedure sort 	
 	la $a0,Array
 	lw $a1,limit 
 	jal sort
#print message "Content of array after sorting:"	 

	li $v0, 4       	 # load 4 into $v0 (for printing a string)        
	la $a0,msg3     	 # load address of string to register $a0     
	syscall         	 # print the corresponding string to console 	
# print the Array using procedure PRINT_ARRAY
 	la $a1,Array
 	lw $a2,limit 
 	jal Print_Array
 # find the average using procedure Average
 	la $a1,Array
 	lw $a2,limit 
 	jal Average
# print message "Average= "	 

	li $v0, 4       	 # load 4 into $v0 (for printing a string)        
	la $a0,msg4     	 # load address of string to register $a0     
	syscall         	 # print the corresponding string to console 
# print the average in $f0
	mov.s  $f12,$f0		# load $f12 with floating point number in $f0
  	li $v0,2		# print floating point number in $f12
	syscall

	
 #follwing lines used to exit OS		
	
	li $v0, 10
	syscall	
	
# Procedure Print_Array  definition 
Print_Array:
  	
  L2:
   	beq $a2,$zero,Ret	# if $a2==0,then goto Ret				
  	l.s  $f12,0($a1)	# load a floating point number from array
  	li $v0,2		# print floating point number in $f12
	syscall
	
 	li $v0,11		# print a new line
 	li $a0,'\n'
   	syscall
   	addi $a1,$a1,4		# $a1=$a1+4 (for getting next array element)
   	addi $a2,$a2,-1		# decrement $a2
   	j L2

 Ret:
        jr $ra
        
#Procedure sort definition
#argument: $a0=address of array,$a1=number of elements

sort:
 	add $sp,$sp,4			# adjust stack pointer
	sw $ra,0($sp)			# store return address $ra to stack
 	move $t2,$a1			# $t2=a1 ,$t2 is used as i
	move $s0,$a0 			# $s0=$a0			
	addi $t2,$t2,-1 		# i=i-1
NEXT1:	
	move $s0,$a0  			
	move $t3,$t2			# $t3=$t2, $t3 is used as j
NEXT2:	
	l.s $f4,0($s0)			# $t4=Array[j]		
	l.s $f5,4($s0)			# $t5=Array[j+1]		
	c.le.s $f4,$f5			# if(Array[j]<Array[j+1] ) then goto Skip
	bc1t Skip
        jal swap			# else swap Array[j] and Array[j+1]
Skip:
        add $s0,$s0,4			# $s0=$s0+4 ,for processing successing element
        addi $t3,$t3,-1			# j=j-1
        bnez $t3,NEXT2                  # if j!=0 goto NEXT2
       addi $t2,$t2,-1 			# i=i-1
	bnez $t2,NEXT1                  # if i!=0 goto NEXT1
	lw $ra,0($sp)			# restore return address from stack
	add $sp,$sp,-4			# adjust stack pointer
	jr $ra
#function swap: it will swap elements Array[j] and Array[j+1]
swap:
	add $sp,$sp,4			# adjust stack pointer
	sw $ra,0($sp)			# store return address $ra to stack		
	l.s $f1,0($s0)			# $s1=Array[j]					
	l.s $f2,4($s0)			# $s2=Array[j+1]		
	s.s $f1,4($s0)			# Array[j+1]=$s1		
	s.s $f2,0($s0)			# Array[j]=$s2					
	lw $ra,0($sp)			# restore return address from stack
	add $sp,$sp,-4			# adjust stack pointer
	jr $ra					
	
# procedure Average definition 
Average:
  	l.s $f0,zero
  	move $t1,$a2
  L3:
   	beq $a2,$zero,Ret1	# if $a2==0,then goto Ret				
  	l.s  $f12,0($a1)	# load a floating point number from array
  	add.s $f0,$f0,$f12	# $f0=$f0+$f12
	
   	addi $a1,$a1,4		# $a1=$a1+4 (for getting next array element)
   	addi $a2,$a2,-1		# decrement $a2
   	j L3

 Ret1:	mtc1 $t1, $f26		# copy integer in $t3  to floating-point processor
	cvt.s.w $f26, $f26	# Convert integer in $f24 to floa
 	div.s $f0,$f0,$f26
    jr $ra