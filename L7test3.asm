.data 
stack_beg:
        .word   0 : 40
stack_end:

answer_array: .word 0:10
number:	.word 0
ColorTable:
	.word 0x000000	#black
	.word 0x0000ff	#blue 
	.word 0x00ff00	#green
	.word 0xff0000	#red
	.word 0x00ffff	#blue + green (cyan)
	.word 0xffff00	#blue + red   (magenta) 
	.word 0xffff00	#green +red   (red)
	.word 0xffffff	#white
	
CircleTable:
	.word 128,20,44
	.word 127,20,44
	.word 126,20,44
	.word 125,20,44
	.word 124,21,42
	.word 123,21,42
	.word 122,21,42 ### 3 space 
	.word 121,22,40 
	.word 120,22,40	## left 2 pixels 
	.word 119,23,38
	.word 118,23,38	## left 2 pixels 
	.word 117,24,36 
	.word 116,25,34	
	.word 115,25,34 ## left 2 pixels
	.word 114,26,32 
	.word 113,28,28 ## START of drop 2 y
	.word 112,29,26
	.word 111,31,22 ## drop 2 y 
	.word 110,33,20 ## drop 2 y 
	.word 109,36,14 ## drop 3 y 
	.word 108,38,10 ## drop 2 y 
BoxTable:
	.word '1', 1, 1, 'B'
	.word '2', 17, 1, 'G'
	.word '3', 1, 17, 'R'
	.word '4', 1, 1, 'Y'
	
Colors: .word   0x000000        # background color (black)
        .word   0xffffff        # foreground color (white)
        
Queue: 
		.word 0:99
Queue_pointer:	.word 0

DigitTable:
        .byte   ' ', 0,0,0,0,0,0,0,0,0,0,0,0
        .byte   '0', 0x7e,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '1', 0x38,0x78,0xf8,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
        .byte   '2', 0x7e,0xff,0x83,0x06,0x0c,0x18,0x30,0x60,0xc0,0xc1,0xff,0x7e
        .byte   '3', 0x7e,0xff,0x83,0x03,0x03,0x1e,0x1e,0x03,0x03,0x83,0xff,0x7e
        .byte   '4', 0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '5', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0x7f,0x03,0x03,0x83,0xff,0x7f
        .byte   '6', 0xc0,0xc0,0xc0,0xc0,0xc0,0xfe,0xfe,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '7', 0x7e,0xff,0x03,0x06,0x06,0x0c,0x0c,0x18,0x18,0x30,0x30,0x60
        .byte   '8', 0x7e,0xff,0xc3,0xc3,0xc3,0x7e,0x7e,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '9', 0x7e,0xff,0xc3,0xc3,0xc3,0x7f,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '+', 0x00,0x00,0x00,0x18,0x18,0x7e,0x7e,0x18,0x18,0x00,0x00,0x00
        .byte   '-', 0x00,0x00,0x00,0x00,0x00,0x7e,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   '*', 0x00,0x00,0x00,0x66,0x3c,0x18,0x18,0x3c,0x66,0x00,0x00,0x00
        .byte   '/', 0x00,0x00,0x18,0x18,0x00,0x7e,0x7e,0x00,0x18,0x18,0x00,0x00
        .byte   '=', 0x00,0x00,0x00,0x00,0x7e,0x00,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   'A', 0x18,0x3c,0x66,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3
        .byte   'B', 0xfc,0xfe,0xc3,0xc3,0xc3,0xfe,0xfe,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'C', 0x7e,0xff,0xc1,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc1,0xff,0x7e
        .byte   'D', 0xfc,0xfe,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'E', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xff,0xff
        .byte   'F', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xc0,0xc0
# add additional characters here....
# first byte is the ascii character
# next 12 bytes are the pixels that are "on" for each of the 12 lines
        .byte    0, 0,0,0,0,0,0,0,0,0,0,0,0

you_lose: .asciiz "You lose! :("
you_win: .asciiz "YOU WIN!!"
one_panda: .asciiz "1"
two_panda: .asciiz "2"
three_panda: .asciiz "3"
four_panda: .asciiz "4"
.text
#################################################################################################
#main loop
##################################################################################################
main:
	la $sp, stack_end
	lui 	$t0,0xFFFF			# $t0 = 0xFFFF0000;
	ori 	$a0,$0,2			# enable keyboard interrupt
	sw 	$a0,0($t0)			# write back to 0xFFFF0000;
	la 	$t0,Queue				# get address of queue 
	la 	$t1,Queue_pointer			# get address of queue pointer 
	addi	$t2,$t0,0			# put the address in a register 
	sw 	$t2,0($t1)
	li	$t0,0
	li 	$t1,0		
	li 	$t2,0
	#set the queue pointer to the beginning of queue
	jal drawdiag	
	la $a3,answer_array 	#a3 will point to the beginning of the array of correct numbers
new_level:
	#make the queue point to the beginning of the queue
	add $s0, $s0, 1
	la $a3,answer_array	#loads the address of my array into $a3 as we will/have messed with where that is pointing
	jal random0		#random number generator0, used for all random numbers
				#prints out a new line for readability
	addi $a0,$0,0xA		#char code for a hard return
	li $v0, 11		#print char
	syscall
level:
	#add $s0, $s0, 1
	la $a3,answer_array	#loads the address of my array into $a3 as we will/have messed with where that is pointing
	jal display 		#will take in two arguments, the pointer to the array and the level we are on $s0, (0-9)
	la $a2, Queue
	la $a3,answer_array	#loads the address of my array into $a3 as we will/have messed with where that is pointing
	jal user_input		#takes us to where the user inputs numbers, loops internally based off of level
	bne $s0, 5, new_level
youwin: 			#simple procedure for printing out a new line and you win
	addi $a0,$0,0xA
	li $v0, 11
	syscall
	la $a0, you_win
	addiu $v0,$0,4		      
	syscall
exit_program:			#exits the program
	li      $v0, 10
        syscall
##########################################################################
#takes in the beginning of the array where the answer is stored
#returns random number in $a0
#only random number generator in the program
#only one is needed since the random number gnerator is reseeded everytime it is called
###############################################################################
random0:
	li $a0,0
	li $a1,0
	addi $sp,$sp,-4		#moves the stack pointer -4
	sw $ra, 4($sp)		#save $ra to the stack
	jal adjust_array 	#takes in two arguements, the level we are on (0-9) $s0, and the pointer to the array $a3
	lw $ra, 4($sp)		#moves the stack pointer 4
	addi $sp,$sp,-4		#moves the stack pointer -4
	li $v0,30
	syscall
	move $a1,$a0		#seed time is now in $a1
	li $a0,0	#random number generator 0
	li $v0,40	#random number generator 0
	syscall
	li $a1,4	#top range of numbers to generate, in our case 0-3
	li $v0, 42
	syscall
	addi $a0, $a0, 1  #fixes the range of random numbers to be 1-4
	sw $a0,0($a3)	
	jr $ra		#random number is now in $a0

####################################################################
#takes in $a3(where our array is pointing)
#also takes in what was entered $a0
#checks to see if those two match, if so we continue
####################################################################
check:
	lw $t0, 0($a3)
	beq $t0,$a0 ,correct	#branches if the right number was entered
	bne $t0,$a0 ,incorrect	#branches if the righ number was entered
	
correct: 
	addiu $sp,$sp, -20
	sw $v0, 20($sp)
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	#goin to branch and play sounds based off what is in $t0
	li $a1, 250
	li $a2, 40
	li $a3, 127
	beq $t0, 1, soundone
	beq $t0, 2, soundtwo
	beq $t0, 3, soundthree
	beq $t0, 4, soundfour

soundone:
	li $a0, 67
	j soundend	
soundtwo:
	li $a0, 68
	j soundend

soundthree:
	li $a0, 69
	j soundend

soundfour:
	li $a0, 70	
soundend:
	li $v0, 31
	syscall	
	lw $v0, 20($sp)
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	addiu $sp,$sp, 20
	j endcheck	#if we are correct then jump and move on
incorrect:
	move $a0, $t0
	addiu $sp,$sp, -20
	sw $v0, 20($sp)
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	li $a0, 65
	li $a1, 250
	li $a2, 40
	li $a3, 127
	li $v0, 33
	syscall
	lw $v0, 20($sp)
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	addiu $sp,$sp, 20
	addiu $sp,$sp, -8
	sw $ra, 4($sp)
	sw $a3, 8($sp)
	jal DisplayBox
	lw $a3, 8($sp)
	lw $ra, 4($sp)
	addiu $sp,$sp, -8
	addiu $sp,$sp, -8
	sw $ra, 4($sp)
	sw $a3, 8($sp)
	jal DisplayBox
	lw $a3, 8($sp)
	lw $ra, 4($sp)
	addiu $sp,$sp, -8
	addi $a0,$0,0xA	#if we are incorrect print a new line and you lose
	li $v0, 11
	syscall
	la $a0, you_lose
	addiu $v0,$0,4	
	syscall
	j exit_program
endcheck:
	jr $ra

######################################################################################	
#pointer to the addess of the number to be printed, will later be a color
#level count is in $s0
#s1 will be local loop counter
######################################################################################
display:
	#need to make it loop in here based off what evel we are on
	li $s1,0	#reset the loop counter for each time we enter the display from main
displayloop:
	addi $sp,$sp,-4	#moves the stack pointer -4
	sw $ra, 4($sp)	#save $ra to the stack
	jal increment_array
	lw $ra, 4($sp)	#moves the stack pointer 4
	addi $sp,$sp,4	#restore $ra from the stack
	lw $a0, 0($a3)
	################################### draw a box
	addi $sp,$sp,-8	#moves the stack pointer -4
	sw $ra, 4($sp)	#save $ra to the stack
	sw $a3, 8($sp)
	sw $a0, 0($sp)
	jal DisplayBox
	lw $a0, 0($sp)
	lw $a3, 8($sp)
	lw $ra, 4($sp)	#moves the stack pointer 4
	addi $sp,$sp,8	#restore $ra from the stack
	######################################### end draw
	#li $v0, 1
	#syscall
	add $s1, $s1, 1
	bne $s1, $s0, displayloop #loop if we still have more input to cover
	addi $a0,$0,0xA		#prints a new line character to make things much more readable
	li $v0, 11
	syscall
	jr $ra


###########################################################################################
#$a3 will be the array where the correct answer is that we are comparing to
#$s0 holds the loop count from the main loop
# will branch to you lose or win from here
#########################################################################################
user_input:
	#will have to loop and check input for each number ented comparing it to each entry in the string
	li $s1, 0
	#have to load the address of queue into register
user_inputloop:
	####code below this will be phased out when interrupts are added
	#li $v0,12
	#syscall
	##################################################################
	
	li 	$t0,1000000			# loop a shit ton until user enters a value or leave 	
SirLoop:
	
	lw 	$v0,0($a2)			# get first element in que
	bne	$v0,0,EndSirLoop		# keep looping as long as there is nothing there or until count goes to zero 
	beq	$t0,0,EndSirLoop 
	add 	$t0,$t0,-1			# decrement t0 
	j 	SirLoop
EndSirLoop:
	beq	$t0,0,incorrect
	sub $a0,$v0,48 #corrects the character to integer by subtracting 48
	addi $sp,$sp,-4	#moves the stack pointer -4
	sw $ra, 4($sp)	#save $ra to the stack
	sw $a2, 0($sp)
	jal increment_array
	lw $a2, 0($sp)
	lw $ra, 4($sp) #restore $ra from the stack
	addi $sp,$sp,4	#moves the stack pointer 4
	
	#need to draw a box here
	addiu $sp,$sp, -8
	sw $a2, 0($sp)
	sw $ra, 4($sp)
	sw $a3, 8($sp)
	jal DisplayBox
	lw $a3, 8($sp)
	lw $a2, 0($sp)
	lw $ra, 4($sp)
	addiu $sp,$sp, -8
	
	addi $sp,$sp,-16	#moves the stack pointer -4
	sw $ra, 4($sp)	#save $ra to the stack
	sw $a0, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	# what ever que is put that shit here 
	#a0
	#a3
	jal check
	lw $ra, 4($sp)	#restore $ra from the stack
	lw $a0, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp,$sp,16	#moves the stack pointer 4
	
	add 	$s1, $s1, 1
	addi	$t1,$0,0			# put zero in t1
	la 	$a2, Queue_pointer
	sw 	$t1,0($a2)			# de que eret is here for some gay reason 
	addi 	$a2,$a2,+4			# increase que address by 4 to get the next element
	##########################################
	#increment the regsiter that is pointing to the queue
	bne 	$s1, $s0, user_inputloop #loops to match the level we are on as determined by the main function
	la 	$t0,Queue				# get address of que 
	la 	$t1,Queue_pointer			# get address of que pointer 
	addi	$t2,$t0,0			# put the address in a register 
	sw 	$t2,0($t1)
	li	$t0,0
	li 	$t1,0		
	li 	$t2,0
	jr $ra
########################################################################################	
#waits 500 ms...will make more sense when displaying squares, for now just a place holder
#wait function so that we can blink the boxes on the screen
#########################################################################################
wait500:
	li $t0 500
	li $v0,30
	syscall
	move $t1, $a0
	wait500loop:
		syscall
		subu $t2, $a0,$t1
		bltu $t2, $t0, wait500loop
	jr $ra

################################################################################################################
#adjusts the array so that we can load a random number in through each loop
#takes in a pointer to the array $a3
#takes a counter of how much offset from the beginning of the array that the value is going to be stored
##############################################################################################################
adjust_array:
#load counter into $s0
	beq $s0,1, end_adjust
	beq $s0,2, add4
	beq $s0,3, add8
	beq $s0,4, add12
	beq $s0,5, add16
	beq $s0,6, add20

add4:
	add $a3, $a3, 4
	j end_adjust
add8:
	add $a3, $a3, 8
	j end_adjust
add12:
	add $a3, $a3, 12
	j end_adjust
add16:
	add $a3, $a3, 16
	j end_adjust
add20:
	add $a3, $a3, 20
	j end_adjust
end_adjust:
	jr $ra
	

#######################################################
#s1 tells us whether to increment or not
#increments the pointer to the array on $a3
########################################################
increment_array:
	beq $s1,0, end_increment
	bne $s1,0, increment4
	
increment4:
	add $a3, $a3, 4
	j end_increment
end_increment:
	jr $ra
	
	
#############################################################
#Display functions will follow
#############################################################

#############################################################
DisplayBox:
	addiu $sp,$sp, -4
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	#a0 has number correlating to box that we need to draw
	add $t0, $a0, 0
	add $s7, $t0, 0
	li $a3, 60
	beq $t0, 1, one
	beq $t0, 2, two
	beq $t0, 3, three
	beq $t0, 4, four
	
one:
	li $a0, 0
	li $a1, 8
	li $a2, 6
	j printbox
two:
	li $a0, 78
	li $a1, 88
	li $a2, 1
	j printbox
three:
	li $a0, 0
	li $a1, 158
	li $a2, 2

	j printbox
four:
	li $a0, -68
	li $a1, 88
	li $a2, 3

printbox:
	addiu $sp,$sp, -20
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	jal DrawCircle
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	addiu $sp,$sp, 20
	#will need to do some bracnhes here to determine which number to display. 
	#will still use the value stored in ( somewhere i need to store it again.
	#then call panda's function.
	addiu $sp,$sp, -20
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	#save the arguements for our shapes so we can draw numbers
	beq $s7, 1, numone
	beq $s7, 2, numtwo
	beq $s7, 3, numthree
	beq $s7, 4, numfour
	#put draw number functions in here, one corresponding to each of the spots it could be in

numone:
	li      $a0, 125
        li      $a1, 45
        la      $a2, one_panda
        jal     OutText
        j shapes

numtwo:
	li      $a0, 200
        li      $a1, 125
        la      $a2, two_panda
        jal     OutText	
	j shapes

numthree:
	li      $a0, 125
        li      $a1, 195
        la      $a2, three_panda
        jal     OutText
        j shapes

numfour:
	li      $a0, 55
        li      $a1, 125
        la      $a2, four_panda
        jal     OutText	

shapes:
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	addiu $sp,$sp, 20
	addiu $sp,$sp, -20
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	jal wait500
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	addiu $sp,$sp, 20
	li $a2, 0
	addiu $sp,$sp, -20
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	jal DrawCircle
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	addiu $sp,$sp, 20
	addiu $sp,$sp, -20
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	jal wait500
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	addiu $sp,$sp, 20
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	jr $ra
	




#############################################################
#calc address
#a0 is x coordinate
#a1 is y cooridinate
#$v0 is the address in memory we want to draw our dot 
#############################################################
calcaddress:
	sll $t0, $a0, 2
	sll $t1, $a1, 10
	add $v0, $t1, $t0
	add $v0, $v0, 0x10040000
	jr $ra
#############################################################
#get color
#uses the vale stored in $a2 to get the color from the color table
#############################################################
getcolor:
	la $t0, ColorTable
	sll $a2, $a2,2
	addu $a2, $a2, $t0
	lw $v1, 0($a2)
	jr $ra
#############################################################
#draw a dot
#############################################################
drawdot:
	addiu $sp,$sp, -8
	sw $ra, 4($sp)
	sw $a2, 0($sp)
	jal calcaddress
	lw $a2, 0($sp)
	sw $v0, 0($sp)
	jal getcolor
	lw $v0, 0($sp)
	sw $v1, ($v0)
	lw $ra, 4($sp)
	addiu $sp,$sp, 8
	jr $ra


#############################################################
#draw a horizontal line
#############################################################
HorzLine:
	addiu $sp,$sp, -4
	sw $ra, 4($sp)
HorzLoop:
	addiu $sp,$sp, -12
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	jal drawdot
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $a2, 4($sp)
	addiu $sp,$sp, 12
	addiu $a0,$a0, 1
	addiu $a3,$a3, -1
	bne   $a3,$0, HorzLoop
	lw $ra, 4($sp)
	addiu $sp,$sp, 4
	jr $ra

	
#############################################################
#draw a vertical line
#############################################################
VertLine:
	addiu $sp,$sp, -4
	sw $ra, 4($sp)
VertLoop:
	addiu $sp,$sp, -12
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	jal drawdot
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $a2, 4($sp)
	addiu $sp,$sp, 12
	addiu $a1,$a1, 1
	addiu $a3,$a3, -1
	bne   $a3,$0, VertLoop
	lw $ra, 4($sp)
	addiu $sp,$sp, 4
	jr $ra
		

#############################################################
#draw a box
#############################################################
DrawBox:
	add $s2, $a3, 0
	addiu $sp,$sp, -4
	sw $ra, 4($sp)
BoxLoop:
	addiu $sp,$sp, -20
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a3, 4($sp)
	jal HorzLine
	lw $a0, 16($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 4($sp)
	addiu $sp,$sp, 20
	addiu $a1, $a1, 1
	addiu $s2,$s2,-1
	bne $s2,$0, BoxLoop
	lw $ra, 4($sp)
	addiu $sp,$sp, 4
	jr $ra
###############################################################
#draw lines
###############################################################
DrawLines:
	addiu $sp, $sp, -4
	sw $ra, 4($sp)
	
	li $a0, 0
	li $a1, 16
	li $a2, 7
	li $a3, 32
	jal HorzLine
	
	li $a0, 16
	li $a1, 0
	li $a2, 7
	li $a3, 32
	jal VertLine
	
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	jr $ra
	
###################################################################

DrawCircle:

	addi $t4,$a0,0		       	# put x offset in $a0 
	addi $t5, $a1,0			# put y offset in $a1
	addi $t6, $a2,0			# put color in $a2 
	
	addi $t2,$0,0
	
CircleCircle:
	
	la $t0,CircleTable		# put the address of the tbale in a register 
	add $t1,$t2,$0
	mul $t1,$t2,12
	add $t0,$t0,$t1
	
	lw $a0,0($t0)			# x 
	lw $a1,4($t0)			# y
	add $a0,$a0,$t4			# add the x offset 
	add $a1,$a1,$t5			# add the y offset 
	add $a2,$0,$t6			# look up color  
	lw $a3,8($t0)			# length
	
	addi $sp,$sp,-28
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t4,12($sp)
	sw $t5,16($sp)
	sw $t6,20($sp)
	sw $ra,24($sp)
	jal VertLine 
	lw $ra,24($sp)
	lw $t6,20($sp)
	lw $t5,16($sp)
	lw $t4,12($sp)
	lw $t2,8($sp)
	lw $t1,4($sp)
	lw $t0,0($sp)
	addi $sp,$sp,28
	
	addi $t2,$t2,1			# add one to the loop count 
	beq $t2,21,OtherHalf		# after all 21 lines have been draw leave 
	j CircleCircle 
	
OtherHalf:
	
	addi $t2,$0,0
	addi $t3,$0,0			# need this to make the next half 
	
CircleCircle2:

	la $t0,CircleTable		# put the address of the tbale in a register 
	add $t1,$t2,$0
	mul $t1,$t2,12
	add $t0,$t0,$t1
	
	lw $a0,0($t0)			# x 
	add $a0,$a0, $t3		# move the value over to its secound half position 
	lw $a1,4($t0)			# y
	add $a0,$a0,$t4			# add x offset 
	add $a1,$a1,$t5			# add y offset 
	add $a2,$0,$t6			# look up color 
	lw $a3,8($t0)			# length
	
	addi $sp,$sp,-32
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $t2,8($sp)
	sw $t3,12($sp)
	sw $t4,16($sp)
	sw $t5,20($sp)
	sw $t6,24($sp)
	sw $ra,28($sp)
	jal VertLine 
	lw $ra,28($sp)
	lw $t6,24($sp)
	lw $t5,20($sp)
	lw $t4,16($sp)
	lw $t3,12($sp)
	lw $t2,8($sp)
	lw $t1,4($sp)
	lw $t0,0($sp)
	addi $sp,$sp,32
	
	addi $t3,$t3,2			# add 2 every time 
	addi $t2,$t2,1			# add one to the loop count 
	beq $t2,21,CircleDone		# after all 21 lines have been draw leave 
	j CircleCircle2 
	
CircleDone:
	jr $ra 

################################################################
#draw a diagonal line Down
################################################################
DiagLineDown:
	addiu $sp,$sp, -4
	sw $ra, 4($sp)
DiagLoopDown:
	addiu $sp,$sp, -12
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	jal drawdot
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $a2, 4($sp)
	addiu $sp,$sp, 12
	addiu $a0,$a0, 1
	addiu $a1,$a1, 1
	addiu $a3,$a3, -1
	bne   $a3,$0, DiagLoopDown
	lw $ra, 4($sp)
	addiu $sp,$sp, 4
	jr $ra
################################################################
#draw a diagonal line Up
################################################################
DiagLineUp:
	addiu $sp,$sp, -4
	sw $ra, 4($sp)
DiagLoopUp:
	addiu $sp,$sp, -12
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	jal drawdot
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $a2, 4($sp)
	addiu $sp,$sp, 12
	addiu $a0,$a0, -1
	addiu $a1,$a1, 1
	addiu $a3,$a3, -1
	bne   $a3,$0, DiagLoopUp
	lw $ra, 4($sp)
	addiu $sp,$sp, 4
	jr $ra
	
		
	
##########################################################################################
# draws diaganal lines
##########################################################################################
drawdiag:

	addiu $sp, $sp, -4
	sw $ra, 4($sp)
	li $a0, 30
	li $a1, 30
	li $a2, 7
	li $a3, 190
	jal DiagLineDown
	
	li $a0, 215
	li $a1, 30
	li $a2, 7
	li $a3, 190
	jal DiagLineUp
	
	lw $ra, 4($sp)
	addiu $sp,$sp,4
	jr $ra
	
#########################################################################################
#font code that panda was nice enought to give us :)
#########################################################################################
OutText:
        addiu   $sp, $sp, -24
        sw      $ra, 20($sp)

        li      $t8, 1          # line number in the digit array (1-12)
_text1:
        la      $t9, 0x10040000 # get the memory start address
        sll     $t0, $a0, 2     # assumes mars was configured as 256 x 256
        addu    $t9, $t9, $t0   # and 1 pixel width, 1 pixel height
        sll     $t0, $a1, 10    # (a0 * 4) + (a1 * 4 * 256)
        addu    $t9, $t9, $t0   # t9 = memory address for this pixel

        move    $t2, $a2        # t2 = pointer to the text string
_text2:
        lb      $t0, 0($t2)     # character to be displayed
        addiu   $t2, $t2, 1     # last character is a null
        beq     $t0, $zero, _text9

        la      $t3, DigitTable # find the character in the table
_text3:
        lb      $t4, 0($t3)     # get an entry from the table
        beq     $t4, $t0, _text4
        beq     $t4, $zero, _text4
        addiu   $t3, $t3, 13    # go to the next entry in the table
        j       _text3
_text4:
        addu    $t3, $t3, $t8   # t8 is the line number
        lb      $t4, 0($t3)     # bit map to be displayed

        sw      $zero, 0($t9)   # first pixel is black
        addiu   $t9, $t9, 4

        li      $t5, 8          # 8 bits to go out
_text5:
        la      $t7, Colors
        lw      $t7, 0($t7)     # assume black
        andi    $t6, $t4, 0x80  # mask out the bit (0=black, 1=white)
        beq     $t6, $zero, _text6
        la      $t7, Colors     # else it is white
        lw      $t7, 4($t7)
_text6:
        sw      $t7, 0($t9)     # write the pixel color
        addiu   $t9, $t9, 4     # go to the next memory position
        sll     $t4, $t4, 1     # and line number
        addiu   $t5, $t5, -1    # and decrement down (8,7,...0)
        bne     $t5, $zero, _text5

        sw      $zero, 0($t9)   # last pixel is black
        addiu   $t9, $t9, 4
        j       _text2          # go get another character

_text9:
        addiu   $a1, $a1, 1     # advance to the next line
        addiu   $t8, $t8, 1     # increment the digit array offset (1-12)
        bne     $t8, 13, _text1

        lw      $ra, 20($sp)
        addiu   $sp, $sp, 24
        jr      $ra

############################################################################################################################################################################
# keyboard interupt 
# goes here when a person hits a key

.ktext 0x80000180

	addi    $sp,$sp,-16		# store everything you mess with in the stack before you jump out 
	sw 	$ra,0($sp)
	sw 	$v0,4($sp)
	sw 	$t0,8($sp)
	sw 	$t1,12($sp)
	
	mfc0 	$k0,$13			# cause register 
	mfc0 	$k1,$14			# EOC
	andi 	$k0,$k0,0x003c		# and ko and 0x003c 
	bne 	$k0,$0,NotI0		# if this is zero well then IDK what it is but leave
	
	jal 	GetChar			# get char if code is 0 

	mtc0 	$0, $13			# Clear Cause register
	mfc0 	$k0, $12			# Set Status register
	andi 	$k0, 0xfffd		# clear EXL bit
	ori  	$k0, 0x11			# Interrupts enabled
	mtc0 	$k0, $12			# write back to status

NotI0:

	lw 	$t1,12($sp)
	lw 	$t0,8($sp)
	lw 	$v0,4($sp)		# restore everything before leaveing 	
	lw 	$ra,0($sp)
	addi 	$sp,$sp,16
	
	eret 
	
	

#############################################################################################################################################
# key board polling 
# CharThere
# erutrns 
# $v0

IsCharThere: 
	
	lui 	$t0,0xffff			# status register 
	lw 	$t1,0($t0)			# get control 
	andi 	$v0,$t1,1			# mask all but read bit 
	jr 	$ra
#############################################################################################################################################
# key board polling 
# GetChar 
# rutrns 
# $v0 = ascci character 

GetChar: 

	addi 	$sp,$sp,-4
	sw 	$ra,0($sp)
	j 	GoCheck
Cloop:
	
GoCheck: 
	
	jal 	IsCharThere
	beq 	$v0,$0,Cloop		# if nothing is there 
	lui	$t0,0xffff		
	lw 	$v0,4($t0)		# char in oxffff0004
	la	$t0,Queue_pointer
	lw 	$t1,0($t0)		# put value from que pointer in t1
	sw      $v0,0($t1)		# save to que
	addi    $t1,$t1,4		# increment que address 
	sw 	$t1,0($t0)		# update que pointer 
	lw 	$ra,0($sp)
	addi 	$sp,$sp,4 
	
	jr 	$ra