#Note: I did 2 for bottom left and 3 for top right instead of reversed
#Also time duration for the blink sequence is the same regardless of difficulty

.data
	#STACK
	stack_beg:
       				.word   0 : 40
	stack_end:
	
	#DATA
	seqArray:		.space	100		#Sequence array
	max:			.word	0		#Max of sequence
	currentStepOfMax:	.word	0	#Step in max of sequence
	genID:			.word 	0		#ID of generator
	seed:			.word	0		#Seed of generator
	randomNum:		.word	0		#Random number generated
	
	#STRINGS
	winPrompt:		.asciiz "You win!"	#Win prompt
	losePrompt:		.asciiz "You lose!"	#Lose prompt
	introPrompt:		.asciiz "Welcome to Simon Says! In the game, enter 1 for yellow, 2 for green, 3 for blue, and 4 for red. \nKeep in mind you have to type and enter one number at a time.\nMenu: Enter 1 for easy, 2 for normal, 3 for hard.. Enter 0 to quit."
	colourPrompt:		.asciiz "Yellow: 1\nGreen: 2\nBlue: 3\nRed: 4\n"
	invalidNumPrompt:	.asciiz "Invalid number entered, please try again."
	
	#COLOR TABLE
	colourTable:		.word	0x000000	#Black
				.word	0x00FFFF00	#Yellow
				.word	0x00ff00	#Green
				.word	0x0000ff	#Blue
				.word	0x00ffff	#Blue-Green
				.word	0xff0000	#Red
				.word	0xffff00	#Green-Red
				.word	0xffffff	#White
	
.text
main:
	#STACK
	la		$sp, stack_end

	#Draw YELLOW SQUARE
	la		$a0, 1			#x = 1
	la		$a1, 1			#y = 1
	la		$a2, 1			#color = 1
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox
	
	#DRAW BLUE SQUARE
	la		$a0, 1			#x = 1
	la		$a1, 17			#y = 17
	la		$a2, 2			#color = 2
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox
	
	#DRAW GREEN SQUARE
	la		$a0, 17			#x = 17
	la		$a1, 1			#y = 1
	la		$a2, 3			#color = 3
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox
	
	#DRAW RED SQUARE
	la		$a0, 17			#x = 17
	la		$a1, 17			#y = 17
	la		$a2, 5			#color = 5
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox

	#LOAD ARGUMENTS
	la		$a0, seqArray		#Load address of seeqArray into $a0
	la		$a1, max		#Load address of max into $a1

	#CLEAR VALUES
	jal		initializeValues	#Jump and link to initializeValues

	#PRINT INTRO
	la		$a0, introPrompt	#Load address of intoPrompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#GET USER INPUT
	li		$v0, 5			#Load syscall for read int
	syscall		
	
	#CHECK USER INPUT
	beq		$v0, 0, exit		#Branch if $v0 is equal to 2 (QUIT)
	beq		$v0, 1, easy		#Branch if $v0 is equal to 1 (EASY)
	beq		$v0, 2, normal		#Branch if $v0 is equal to 2 (NORMAL)
	beq		$v0, 3, hard		#Branch if $v0 is equal to 3 (HARD)
	j		invalidNum		#Jump to invalidNum
	
	#EASY MODE
	easy:
	li		$t0, 5			#Load 5 into $t0
	addiu           $t9, $t9, 5
	sw		$t0, max		#Store 5 into max label	
	j		continue		#Jump to continue
	
	#NORMAL MODE
	normal:
	li		$t0, 8			#Load 8 into $t0
	addiu           $t9, $t9, 8
	sw		$t0, max		#Store 5 into max label	
	j		continue		#Jump to continue
	
	#HARD MODE
	hard:
	li		$t0, 11			#Load 11 into $t0
	addiu           $t9, $t9, 11
	sw		$t0, max		#Store 5 into max label	
	j		continue		#Jump to continue
	
	continue:
	#PRINT COLORS
	la		$a0, colourPrompt	#Load address of colourPrompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#CLEAR
	jal		clearDisplay		#Clear display
	
	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#LOOP
	li		$t6, 0			#Counter
	lw		$t5, max		#Number of sequences
	createSeqLoop:
	#LOAD ARGUMENTS
	la		$a0, genID		#Load address of genID into $a0
	la		$a1, seed		#Load address of seed into $a1

	#GET RANDOM NUM
	jal		getRandomNum		#Jump and link to getRandomNum
	sw		$v0, randomNum		#Store generated number
	
	#LOAD ARGUMENTS
	la		$a0, seqArray		#Load address of seqArray into $a0
	la		$a1, randomNum		#Load address of randomNum into $a1
	
	#CORRECT SEQUENCE ELEMENT POSITION
	move		$t7, $t6		#Copy counter into $t1
	sll		$t7, $t7, 2		#Multiply by 4
	add		$a0, $a0, $t7		#Add to array address to set correct element
	addi		$t6, $t6, 1		#Increment counter
	
	#ADD RANDOM TO SEQ AND CHECK LOOP
	jal		addToSeq		#Jump and link to addToSeq
	bne		$t6, $t5, createSeqLoop	#Loop if counter is not max
	
	#DISPLAY THE BLINKS AND CHECK USER INPUTS
	#It has no inputs because the inputs are inside for two other functions.
	jal playGame
	
	#LOSE
	lose:
	la		$a0, losePrompt		#Load address of lose prompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#PRINT NEWLINE
	li		$v0, 11			#Load print character syscall
	addi		$a0, $0, 0xA		#Load ascii character for newline into $a0
	syscall					#Execute
	
	subu $t8, $t8, $t8                      #Reset $t8 to 0
	subu $t9, $t9, $t9                      #Reset $t9 to 0
	j		main			#Loop program
	
	#WIN
	win:
	la		$a0, winPrompt		#Load address of win prompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#PRINT NEWLINE
	li		$v0, 11			#Load print character syscall
	addi		$a0, $0, 0xA		#Load ascii character for newline into $a0
	syscall					#Execute
	
	subu $t8, $t8, $t8                      #Reset $t8 to 0
	subu $t9, $t9, $t9                      #Reset $t9 to 0
	j		main			#Loop program
	
	#INVALID NUM
	invalidNum:
	la		$a0, invalidNumPrompt	#Load address of invalidNumPrompt into $a0
	li		$v0, 4			#Load print string syscall
	syscall					#Execute
	
	#PRINT NEWLINE
	li		$v0, 11			#Load print character syscall
	addi		$a0, $0, 0xA		#Load ascii character for newline into $a0
	syscall					#Execute
	j		main			#Loop program
	
	#EXIT
	exit:
	li		$v0, 17			#Load exit call
	syscall					#Execute

#Procedure: initializeValues
#Clear all values for new game
#$a0 = pointer to seqArray
#$a1 = pointer to max
initializeValues:
	#CLEAR SEQUENCE	
	li		$t0, 24			#Max words to clear
	li		$t1, 0			#Index
	initLoop:
	sw		$0, 0($a0)		#Clear index of array
	addi		$t1, $t1, 1		#Incremement counter
	addi		$a0, $a0, 4		#Incremement to next element in array
	bne 		$t1, 25, initLoop	#Loop if counter is not 100
	
	#CLEAR MAX
	sw		$0, 0($a1)		#Reset Max
	jr		$ra			#Return
	
#Procedure: getRandomNum
#Get random number for sequence
#$a0 = pointer to genID
#$a1 = pointer to seed
#$v0 = random number generated
getRandomNum:
	#CLEAR
	sw		$0, 0($a0)		#Set generator ID to 0

	#SAVE ADDRESSES
	move		$t0, $a0		#Copy address of genID in $a0 into $t0
	move		$t1, $a1		#Copy address of seed in $a1 into $t1
	
	#GET AND STORE SYSTEM TIME
	li		$v0, 30			#Load syscall for systime
	syscall					#Execute
	sw		$a0, 0($t1)		#Store systime into seed
	
	#SET AND STORE SEED
	lw		$a0, ($t0)		#Set $a0 to genID
	lw		$a1, ($t1)		#Set $a1 to seed
	li		$v0, 40			#Load syscall for seed
	syscall					#Execute
	sw		$a1, 0($t1)		#Store generated seed into seed label
	
	#PAUSE FOR RANDOMNESS
	li		$a0, 10			#Sleep for 10ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#GENERATE RANDOM RANGE 1-4
	li		$a1, 4			#Upper bound of range = 4
	li		$v0, 42			#Load syscall for random int range
	syscall					#Execute
	addi		$a0, $a0, 1		#Add 1 to make range 1-4
	move		$v0, $a0		#Copy generated random to $v0
	
	#RESET ADDRESSES
	move		$a0, $t0		#Copy address of genID in $t0 into $a0
	move		$a1, $t1		#Copy address of seed in $t1 into $a1
	
	jr		$ra			#Return
	
#Procedure: addToSeq
#Add generated random to sequence
#$a0 pointer to seqArray
#$a1 pointer to randomNum
addToSeq:
	#ADD TO SEQUENCE ARRAY
	lw		$t0, 0($a1)		#Load word of randomNum into $t0
	sw		$t0, 0($a0)		#Store randomNum into sequence
	
	jr		$ra			#Return

#Procedure: displaySeq
#Display generated sequence to player
#$a0 pointer to seqArray
#$a1 pointer to max
displaySeq:
	#MAKE ROOM ON STACK
	addi		$sp, $sp, -4		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack	

	#BLINK EACH NUM IN SEQUENCE
	li		$s1 0			#Counter
	lw		$t1, 0($a1)		#Load word of max from $a1
	move		$t2, $a0		#Copy address of sequence to $t2
	move		$t4, $a1		#Copy pointer to max to $t4
	
	#CLEAR DISPLAY
	jal		clearDisplay		#Clear Display
	
	blinkLoop:	
	#BLINK ELEMENT
	lw		$t3, 0($t2)		#Get element from sequence
	beq		$t3, 1, blinkYellow	#If element is 1 blink blue
	beq		$t3, 2, blinkGreen	#If element is 2 blink green
	beq		$t3, 3, blinkBlue	#If element is 3 blink red
	beq		$t3, 4	blinkRed	#If element is 4 blink magenta				
	returnLoop:				#Return from blink
	
	#INCREMENT AND CHECK
	addi		$t2, $t2, 4		#Increment to next element
	addi		$s1, $s1, 1		#Increment counter by 1
	
	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	bne		$s1, $t1, blinkLoop	#Loop if counter has not reached max
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	
	jr		$ra			#Return
	
	#BLINK BLUE
	blinkYellow:
	#DRAW
	la		$a0, 1			#x = 1
	la		$a1, 1			#y = 1
	la		$a2, 1			#colour = 1
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox

	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 1			#x = 1
	la		$a1, 1			#y = 1
	la		$a2, 0			#colour = 0
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox
	j		returnLoop		#Return back to loop
	
	#BLINK GREEN
	#DRAW
	blinkGreen:
	la		$a0, 1			#x = 1
	la		$a1, 17			#y = 17
	la		$a2, 2			#colour = 2
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox

	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 1			#x = 1
	la		$a1, 17			#y = 17
	la		$a2, 0			#colour = 0
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox
	j		returnLoop		#Return back to loop
	
	#BLINK BLUE
	#DRAW
	blinkBlue:
	la		$a0, 17			#x = 17
	la		$a1, 1			#y = 1
	la		$a2, 3			#colour = 3
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox

	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 17			#x = 17
	la		$a1, 1			#y = 1
	la		$a2, 0			#colour = 0
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBoxS
	j		returnLoop		#Return back to loop
	
	#BLINK RED
	#DRAW
	blinkRed:
	la		$a0, 17			#x = 17
	la		$a1, 17			#y = 17
	la		$a2, 5			#colour = 5
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox

	#PAUSE
	li		$a0, 800		#Sleep for 800ms
	li		$v0, 32			#Load syscall for sleep
	syscall					#Execute
	
	#BLINK
	la		$a0, 17			#x = 17
	la		$a1, 17			#y = 17
	la		$a2, 0			#colour = 0
	la		$a3, 14			#square size = 14
	jal		drawBox			#Jump and link to drawBox
	j		returnLoop		#Return back to loop
	
#Procedure: userCheck:
#Display generated sequence to player
#$a0 pointer to seqArray
#$a1 pointer to max
userCheck:
	#BLINK EACH NUM IN SEQUENCE
	li		$t0, 0			#Counter
	lw		$t1, 0($a1)		#Load word of max from $a1
	move		$t2, $a0		#Copy address of sequence to $t2
	userCheckLoop:	
	#GET USER INPUT
	li		$v0, 5			#Load syscall for read int
	syscall					#Execute
	
	#CHECK IF CORRECT
	lw		$a0, 0($t2)		#Get element from sequence
	bne		$v0, $a0, fail		#Check if user input is correct
	
	#INCREMENT AND CHECK
	addi		$t2, $t2, 4		#Increment to next element
	addi		$t0, $t0, 1		#Increment counter by 1
	
	bne		$t0, $t1, userCheckLoop	#Loop if counter has not reached max
	
	#USER PASS
	li		$v0, 1			#Set return to 1 (WIN)
	jr		$ra			#Return
	
	#IF USER FAILS
	fail:
	li		$v0, 0			#Set return to 0 (LOSE)
	jr		$ra			#Return

#Procedure: drawDot:
#Draw a dot on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)	
#$a2 = colour number (0-7)
drawDot:
	#MAKE ROOM ON STACK
	addi		$sp, $sp, -8		#Make room on stack for 2 words
	sw		$ra, 4($sp)		#Store $ra on element 1 of stack
	sw		$a2, 0($sp)		#Store $a2 on element 0 of stack
	
	#CALCULATE ADDRESS
	jal		calculateAddress	#returns address of pixel in $v0
	lw		$a2, 0($sp)		#Restore $a2 from stack
	sw		$v0, 0($sp)		#Save $v0 on element 0 of stack
	
	#GET COLOR
	jal		getColour		#Returns colour in $v1
	lw		$v0, 0($sp)		#Restores $v0 from stack
	
	#MAKE DOT AND RESTORE $RA
	sw		$v1, 0($v0)		#Make dot
	lw		$ra, 4($sp)		#Restore $ra from stack
	addi		$sp, $sp, 8		#Readjust stack
	
	jr		$ra			#Return
	
#Procedure: calculateAddress:
#Convert x and y coordinate to address
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$v0 = memory address
calculateAddress:
	#CALCULATIONS
	sll		$a0, $a0, 2		#Multiply $a0 by 4
	sll		$a1, $a1, 5		#Multiply $a1 by 32
	sll		$a1, $a1, 2		#Multiply $a1 by 4
	add		$a0, $a0, $a1		#Add $a1 to $a0
	addi		$v0, $a0, 0x10040000	#Add base address for display + $a0 to $v0
	
	jr		$ra			#Return
	
#Procedure: getColour:
#Get the colour based on $a2
#$a2 = colour number (0-7)
getColour:
	#GET COLOUR	
	la		$t0, colourTable	#Load Base
	sll		$a2, $a2, 2		#Index x4 is offset
	add		$a2, $a2, $t0		#Address is base + offset
	lw		$v1, 0($a2)		#Get actual color from memory

	jr		$ra			#Return
	
#Procedure: drawHorzLine:
#Draw a horizontal line on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$a2 = colour number (0-7)
#$a3 = length of the line
drawHorzLine:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -16		#Make room on stack for 4 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 2 of stack
	
	#HORIZONTAL LOOP
	horzLoop:
	jal		drawDot			#Jump and Link to drawDot
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	
	#INCREMENT VALUES
	addi		$a0, $a0, 1		#Increment x by 1
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	addi		$a3, $a3, -1		#Decrement length of line
	bne		$a3, $0, horzLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 16		#Readjust stack
	
	jr		$ra			#Return

#Procedure: drawVertLine:
#Draw a vertical line on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$a2 = colour number (0-7)
#$a3 = length of the line (1-32)
drawVertLine:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -16		#Make room on stack for 4 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	sw		$a1, 4($sp)		#Store $a0 on element 0 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 2 of stack
	
	#HORIZONTAL LOOP
	vertLoop:
	jal		drawDot			#Jump and Link to drawDot
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	
	#INCREMENT VALUES
	addi		$a1, $a1, 1		#Increment y by 1
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	addi		$a3, $a3, -1		#Decrement length of line
	bne		$a3, $0, vertLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 16		#Readjust stack
	
	jr		$ra			#Return

#Procedure: drawBox:
#Draw a box on the bitmap display
#$a0 = x coordinate (0-31)
#$a1 = y coordinate (0-31)
#$a2 = colour number (0-7)
#$a3 = size of box (1-32)
drawBox:
	#MAKE ROOM ON STACK AND SAVE REGISTERS
	addi		$sp, $sp, -24		#Make room on stack for 5 words
	sw		$ra, 12($sp)		#Store $ra on element 4 of stack
	sw		$a0, 0($sp)		#Store $a0 on element 0 of stack
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	sw		$a2, 8($sp)		#Store $a2 on element 2 of stack
	sw		$a3, 20($sp)		#Store $a3 on element 5 of stack
	move		$s0, $a3		#Copy $a3 to temp register
	sw		$s0, 16($sp)		#Store $s0 on element 5 of stack
	
	boxLoop:
	jal 		drawHorzLine		#Jump and link to drawHorzLine
	
	#RESTORE REGISTERS
	lw		$a0, 0($sp)		#Restore $a0 from stack
	lw		$a1, 4($sp)		#Restore $a1 from stack
	lw		$a2, 8($sp)		#Restore $a2 from stack
	lw		$a3, 20($sp)		#Restore $a3 from stack
	lw		$s0, 16($sp)		#Restore $s0 from stack
	
	#INCREMENT VALUES
	addi		$a1, $a1, 1		#Increment y by 1
	sw		$a1, 4($sp)		#Store $a1 on element 1 of stack
	addi		$s0, $s0, -1		#Decrement counter
	sw		$s0, 16($sp)		#Store $s0 on element 5 of stack
	bne		$s0, $0, boxLoop	#If length is not 0, loop
	
	#RESTORE $RA
	lw		$ra, 12($sp)		#Restore $ra from stack
	addi		$sp, $sp, 24		#Readjust stack
	addi		$s0, $s0, 0		#Reset $s0
	
	jr		$ra			#Return
	
#This function is two functions in one to play the game.
playGame:

	#LOAD ARGUMENTS
	la		$a0, seqArray		#Load address of seqArray into $a0
	addiu $t8, $t8, 1
	sw $t8, currentStepOfMax
	la		$a1, currentStepOfMax		#Load address of max into $a1
	
	#DISPLAY SEQUENCE
	jal		displaySeq		#Jump and link to displaySeq
	
	#USER CHECK
	la		$a0, seqArray		#Load address of seqArray into $a0 (THIS IS DONE TO RESET TO START OF ARRAY)
	la		$a1, currentStepOfMax		#Load address of max into $a1 (THIS IS DONE TO RESET TO START OF ARRAY)
	jal		userCheck		#Jump and link to displaySeq
	
	#If at max, go print the lose or win result. Else, loop again
	beq $v0, 0, lose
	beq $t8, $t9, printResult
	
	jal playGame
	
printResult:
	#PRINT RESULT
	beq		$v0, 0, lose		#Branch if return is equal to 0
	beq		$v0, 1, win		#Branch if return is equal to 1
	
	jr              $ra                     #Return
	
#Procedure: drawBox:
#Draw a box on the bitmap display
clearDisplay:
	#MAKE ROOM ON STACK
	addi		$sp, $sp, -4		#Make room on stack for 1 words
	sw		$ra, 0($sp)		#Store $ra on element 4 of stack
	
	#GET REGISTERS READY TO CLEAR
	la		$a0, 0			#x-coordinate = 0
	la		$a1, 0			#y-coordinate = 0
	la		$a2, 0			#colour = black
	la		$a3, 32			#size to clear = 32
	
	jal		drawBox			#Clear Screen
	
	#RESTORE $RA
	lw		$ra, 0($sp)		#Restore $ra from stack
	addi		$sp, $sp, 4		#Readjust stack
	
	jr		$ra			#Return
