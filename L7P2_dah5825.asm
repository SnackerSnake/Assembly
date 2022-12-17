#Another note: it interrupts the 2nd input but not the rest. So at most the player can input two numbers at once.

#Note: When you enter a number in the Keyboard and Display MMIO Simulator, the bitmap will play the same number and color you press.
#Therefore, wait for the animation to finish before pressing your next input. The white X will be visible when the system is ready to receive inputs.
#Also, there's no transition for your last entry and the new sequence, so keep that in mind.
#Example: Your first sequence is 2, so it will animated 2 2 2, making your next sequence 2 2 and NOT 2 2 2. That first 2 was for your entry.

.data
        .word   0 : 40
Stack:

Colors: .word   0x000000        # background color (black)
        .word   0xffffff        # foreground color (white)

sequence: .word 0:5	#Sequence of 5 digits that will be the game's digits to flash

ColorTable:	#Used to find the HEX value of the colors used in SIMON
 .word 0xFFFF00 #[0] Yellow 0xFFFF00
 .word 0x0000FF #[1] Blue   0x0000FF
 .word 0xFF0000 #[2] Red    0xFF0000
 .word 0x00FF00 #[3] Green  0x00FF00
 .word 0xFFFFFF #[4] White  0xFFFFFF
 .word 0x000000 #[5] Black  0x000000
  
#50px Diameter circle table comprised of TWO values of importance
#First value is an X-Offset that will take the value of X given for the circle and add the offset to see..
#..where the Horizontal Line generator should begin.
#Second Valuse is the length of the Horizontal line to create. Basically, a circle is...
#..a bunch of horizontal lines of increasing then decreasing length 
CircleTable: 
 .word 0, 10, -4, 18, -6, 22, -8, 26, -9, 28, -11, 32, -12, 34, -13, 36, -14, 38, -15, 40, -15, 40, -16, 42, -17, 44
 .word -17, 44, -18, 46, -18, 46, -19, 48, -19, 48, -19, 48, -19, 48, -20, 50, -20, 50, -20, 50, -20, 50, -20, 50
 .word -20, 50, -20, 50, -20, 50, -20, 50, -20, 50, -19, 48, -19, 48, -19, 48, -19, 48, -18, 46, -18, 46, -17, 44
 .word -17, 44, -16, 42, -15, 40, -15, 40, -14, 38, -13, 36, -12, 34, -11, 32, -9, 28, -8, 26, -6, 22 -4, 18, 0, 10
 
ColorsExt:	#X, Y, Color Number, Pitch
 .word 125, 25, 0, 40	#[0] Yellow
 .word 40, 115, 1, 50	#[1] Blue
 .word 200, 120, 2, 60	#[2] Red
 .word 125, 180, 3, 70	#[3] Green
 
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
 
ColorData: .word 0:4	#(X,Y) address, color number, and MiDi stored here
newLine: .asciiz "\n"
prompt1: .asciiz "\nEnter sequence: "
playerWin: .asciiz "\nYou win!"
playerLose: .asciiz "\nYou lose" 
number1: .asciiz "1"
number2: .asciiz "2"
number3: .asciiz "3"
number4: .asciiz "4"

#########################################################################
# Exception handling
#########################################################################
# Status register bits
EXC_ENABLE_MASK:        .word   0x00000001

# Cause register bits
EXC_CODE_MASK:          .word   0x0000003c  # Exception code bits

EXC_CODE_INTERRUPT:     .word   0   # External interrupt
EXC_CODE_ADDR_LOAD:     .word   4   # Address error on load
EXC_CODE_ADDR_STORE:    .word   5   # Address error on store
EXC_CODE_IBUS:          .word   6   # Bus error instruction fetch
EXC_CODE_DBUS:          .word   7   # Bus error on load or store
EXC_CODE_SYSCALL:       .word   8   # System call
EXC_CODE_BREAKPOINT:    .word   9   # Break point
EXC_CODE_RESERVED:      .word   10  # Reserved instruction code
EXC_CODE_OVERFLOW:      .word   12  # Arithmetic overflow

# Status and cause register bits
EXC_INT_ALL_MASK:       .word   0x0000ff00  # Interrupt level enable bits

EXC_INT0_MASK:          .word   0x00000100  # Software
EXC_INT1_MASK:          .word   0x00000200  # Software
EXC_INT2_MASK:          .word   0x00000400  # Display
EXC_INT3_MASK:          .word   0x00000800  # Keyboard
EXC_INT4_MASK:          .word   0x00001000
EXC_INT5_MASK:          .word   0x00002000  # Timer
EXC_INT6_MASK:          .word   0x00004000
EXC_INT7_MASK:          .word   0x00008000

.text
	#Initialize data
	li $s1, 0	#Max = 0
	li $s0, 0	#Iterates through sequence
	jal InitRand	#Setup random value
	jal ClearScreen	#Clear display 

main:	
	# Enable interrupts in status register
	mfc0    $t0, $12

	# Disable all interrupt levels
	lw      $t1, EXC_INT_ALL_MASK
	not     $t1, $t1
	and     $t0, $t0, $t1
	
	# Enable console interrupt levels
	lw      $t1, EXC_INT3_MASK
	or      $t0, $t0, $t1
	#lw      $t1, EXC_INT4_MASK
	#or      $t0, $t0, $t1

	# Enable exceptions globally
	lw      $t1, EXC_ENABLE_MASK
	or      $t0, $t0, $t1

	mtc0    $t0, $12
	
	# Enable keyboard interrupts
	li      $t0, 0xffff0000     # Receiver control register
	li      $t1, 0x00000002     # Interrupt enable bit
	sw      $t1, ($t0)
	
	la $a1, sequence 	#Load sequence

	jal DrawCrosshairs	#Draw crosshairs
	
	jal GetRand		#Get random number (function)
	
	la $a1, sequence
	add $a1, $a1, $s0	#Add number to sequence
	sw $a0, ($a1)		#Save random number to sequence

	addi $s0, $s0, 4	#Increment sequence pointer
	addi $s1, $s1, 1	#Increment max
	
	la $a1, sequence
	jal BlinkLights		#Blink lights (Output text)
	
	la $a1, sequence
	jal UserCheck		#User check
	beq $s1, 5, pass	#Display player win if max count has been reached
	j main			#If max not reached, iterate again

#Procedure: InitRand
#This function will initialize the GetRand function
InitRand:
	li $v0, 30	#Get system time
	syscall		#$a0 will be set to low order 32 bits of system time
	move $a1, $a0	#Move lower 32 bits of system time to $a1 for seed value
	#li $a1, 13	#Constant seed used for debugging
	li $a0, 0	#Use generator 0
	li $v0, 40	#Sets seed to value of generator $a0, seed $a1
	syscall
	jr $ra

#Procedure: GetRand
#Output - $a0 = Random number (0-3)
GetRand:
	li $a1, 4	#Random Int Range [0-$a1)
	li $v0, 42	
	syscall		#$a0 has the random integer from 0 to 3
	jr $ra	

#Procedure: Pause
#Function will "pause" MIPS so that output can be displayed for 0.5 seconds
Pause:
	li $v0, 30	#Get clock time
	syscall
	move $t9, $a0	#Save inital clock time
pauseLoop:
	syscall				#Get newer system time
	subu $t2, $a0, $t9		#$t2 = current time - intitial time
	bltu $t2, 500, pauseLoop	#Loop if time passed is less than wait time
	jr $ra

#Procedure: BlinkLights
#Input - $s1 = max
#Input - $a1 = sequence 
#This will begin the output of the colored squares
BlinkLights:
	li $v0, 4
	la $a0, newLine
	syscall			#New line
	addiu $sp, $sp, -20	#Room for 5 words
	li $s5, 0		#Counter
	sw $ra, 12($sp)		#Save $ra

blinkLoop:	
	li $v0, 1		#Load print integer
	lw $a0, ($a1)		#Load digit to print
	addi $a0, $a0, 1	#Adjust for Array notation
	syscall
	addi $a0, $a0, -1
	addi $a1, $a1, 4	#Increment which sequence digit to print
	sw $a1, 8($sp)		#Save $a1 (Sequence digit counter)
	jal GetColorData	#Get color data
	la $t0, ColorData	#Load ColorData table
	lw $a2, 8($t0)		#Load Color Number
	lw $a0, 0($t0)		#Load X
	lw $a1, 4($t0)		#Load Y
	sw $s5, 16($sp)
	
	jal DrawCircle		#Begins the process of drawing the boxes
	jal Pause		#Pause screen
	jal ClearScreen		#Make screen all black with white crosshairs
	jal NewLine		#Add new lines for text output
	
	lw $s5, 16($sp)
	addi $s5, $s5, 1	#Increment counter
	lw $a1, 8($sp)		#Load the sequence digit counter
	blt $s5, $s1, blinkLoop	#Loop until counter = max
	
	lw $ra, 12($sp)		#Restore $ra
	addiu $sp, $sp, 20	#Reset stack pointer
	jr $ra

#Procedure: GetColorData
#Input - $a0 = color to lookup
#Input - $t1 = location where data is written 
#Output - Array with Color Data (ColorData)
GetColorData:
	mul $a0, $a0, 16	#4 word difference between array elements per color
	la $t1, ColorData	#Load the location the color data will be stored
	la $t0, ColorsExt	#Load ColorsExtended table
	add $a0, $a0, $t0	#Add base
	lw $t2, ($a0)		#Load the address of the proper data to $t1
	sw $t2, ($t1) 		#Save X
	addi $a0, $a0, 4	#Move to next value in data table
	lw $t2, ($a0)		#Access the data at the table
	sw $t2, 4($t1)		#Save Y
	addi $a0, $a0, 4	
	lw $t2, ($a0)
	sw $t2, 8($t1)		#Save Color Number
	addi $a0, $a0, 4
	lw $t2, ($a0)
	sw $t2, 12($t1)		#Save MiDi pitch
	jr $ra
	
#Procedure: DrawCircle
#Input - $a0 = X 
#Input - $a1 = Y
#Input - $a2 = Color (0-5)
#Will draw a circle with given parameters15
DrawCircle:
	#Save room in stack pointer
	addiu $sp, $sp, -28 	#Make room for 7 words
	#Save $ra, $s0, $a0, $a2
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	li $s2, 0	#Counter
	
CircleLoop:
	la $t1, CircleTable
	addi $t2, $s2, 0	#Copy counter for table serach
	mul $t2, $t2, 8		#Using counter value, shift to adjust for table's 2 arguments per 1 instance
	add $t2, $t1, $t2	#Get X-Offest array index [base + counter*4]
	lw $t3, ($t2)		#Load offset into $t3
	add $a0, $a0, $t3	#Add X-Offset to Current X
	
	addi $t2, $t2, 4	#Move to HorzLine length in array
	lw $a3, ($t2)		#Load line length 
	sw $a1, 4($sp)		#Save $a1
	sw $a3, 0($sp)		#Save $a3
	sw $s2, 24($sp)		#Save counter
	jal DrawHorz
	
	#Restore $a0-3
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	lw $s2, 24($sp)
	addi $a1, $a1, 1	#Increment Y value
	addi $s2, $s2, 1	#Increment counter
	bne $s2, 50, CircleLoop	#Keep looping until counter = 50 (50 horizontal lines in 1 circle)
	
	#Draw Number
	addi $t0, $a2, 0
	addi $a1, $a1, -30
	beq $t0, 0, setNum1
	beq $t0, 1, setNum2
	beq $t0, 2, setNum3
	beq $t0, 3, setNum4
	setNum1:
		la $a2, number1
		j NumOut
	setNum2:
		la $a2, number2
		j NumOut
	setNum3:
		la $a2, number3
		j NumOut
	setNum4:
		la $a2, number4
	
	NumOut:
	     sw $a2, 8($sp)	#Save $a2
	     jal OutText
	     
	lw $a2, 8($sp)		#Reload $a2
	
	#MiDi 
	la $t0, ColorData	#Load ColorData table where MiDi pitch is available
	lw $a0, 12($t0)		#Load pitch to $a0 for Syscall
	li $a1, 500		#Beep for .5 seconds
	li $a2, 3		#Use instrument 100 (Random choice)
	li $a3, 64		#Volue set to 64 (0-127)
	li $v0, 33
	syscall
	
	#Restore $ra, $s0, $sp
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 28	#Reset $sp
	jr $ra
	
#Procedure: DrawBox
#Input - $a0 = X 
#Input - $a1 = Y
#Input - $a2 = Color (0-5)
#Input - $a3 = Box Width
#Will draw a box with the given parameters
DrawBox:
	addiu $sp, $sp, -24 	#Make room for 6 words
	#Save $ra, $s0, $a0, $a2
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	move $s0, $a3		#Copy $a3 -> $s0
	
BoxLoop:
	sw $a1, 4($sp)	#Save $a1
	sw $a3, 0($sp)	#Save $a3
	jal DrawHorz
	
	#Restore $a0-3
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	addi $a1, $a1, 1	#Increment Y value
	addi $s0, $s0, -1	#Decrement the width/length (since box)
	bne $zero, $s0, BoxLoop	#Keep looping until counter=0
	
	#Restore $ra, $s0, $sp
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 24	#Reset $sp
	jr $ra
	
#Procedure: DrawHorz
#Input - $a0 = X 
#Input - $a1 = Y
#Input - $a2 = Color (0-5)
#Input - $a3 = Line length
#Uses the DrawDot procedure to draw dots in a horizontal fashion
DrawHorz:
	addiu $sp, $sp, -20
	#Save $ra, $a1, $a2
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	
HorzLoop:
	#Save $a0, $a3 (changes with next procedure call)
	sw $a0, 4($sp)
	sw $a3, 0($sp)
	jal DrawDot
	#Restore all but $ra
	lw $a0, 4($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1		#Decrement the width
	addi $a0, $a0, 1		#Increase X value
	bnez $a3, HorzLoop		#If width > 0, keep looping	
	lw $ra, 16($sp)			#Restore $ra
	addiu $sp, $sp, 20		#Restore $sp
	jr $ra
	
#Procedure: DrawDot
#Input - $a0 = X
#Input - $a1 = Y
#Input - $a2 = Color (0-5)
#Draws a dot on the Bitmap by saving a color's hex value to the memrory address associated with the bitmap
DrawDot:
	addiu $sp, $sp, -8
	#Save $ra, $a2
	sw $ra, 4($sp)
	sw $a2, 0($sp)
	jal CalcAddress		#Calculate memory address to write to
	lw $a2, 0($sp)		#Load $a2
	sw $v0, 0($sp)		#Save $v0
	jal GetColor		#Retreive Hex vale of color
	lw $v0, 0($sp)		#Restore $v0
	sw $v1, ($v0)		#Write the color value to the proper memory address
	lw $ra, 4($sp)		#Restore $ra
	addiu $sp, $sp, 8	#Reset $sp
	jr $ra

#Procedure: CalcAddress
#Input - $a0 = X
#Input - $a1 = Y
#Output - $v0 = actual memory address to draw dot
CalcAddress:
	sll $a0, $a0, 2
	sll $a1, $a1, 10
	add $v0, $a0, $a1		#Add 
	addi $v0, $v0, 0x10040000	#Add base (heap value)
	jr $ra

#Procedure: GetColor
#Input - $a2 = Color Value (0-5)
#Output - $v1 = Hex color value
#Returns the hex value of requested color
GetColor:
	la $t0, ColorTable	#Load color table
	sll $a2, $a2, 2		#Shift left by 2 (x4)
	add $a2, $a2, $t0	#Add base
	lw $v1, ($a2)		#Load color value to $v1
	jr $ra
	
#Procedure: ClearScreen
#This will make the whole display black with white crosshairs
ClearScreen:
	addiu $sp, $sp, -4
	sw $ra, ($sp)	#Save $ra
	li $a0, 0	#X=0
	li $a1, 0	#Y=0
	li $a2, 5	#Color = Black
	li $a3, 256	#Size = all pixels
	jal DrawBox
	jal DrawCrosshairs
	#Restore $ra and $sp
	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra
	
#Procedure: DrawCrosshairs
#Will draw white crosshairs
DrawCrosshairs:
	addiu $sp, $sp, -8	#Saving room for $ra, $s0
	sw $ra, 4($sp)		#Save $ra
	
	#Backslash
	li $t0, 0	#Counter
	loopA:
	li $a0, 25 	#X=0
	add $a0, $a0, $t0
	li $a1, 30	#Y=30
	add $a1, $a1, $t0
	li $a2, 4	#Color=White
	li $a3, 3	#Width=Full Screen
	sw $t0, 0($sp)
	jal DrawHorz
	lw $t0, 0($sp)
	addi $t0, $t0, 1
	bne $t0, 200, loopA
	
	#Forwardslash
	li $t0, 0		#Counter
	loopB:
	li $a0, 25 		#X=25
	add $a0, $a0, $t0
	li $a1, 226		#Y=226
	sub $a1, $a1, $t0
	li $a2, 4		#Color=White
	li $a3, 3		#Width=Full Screen
	sw $t0, 0($sp)
	jal DrawHorz
	lw $t0, 0($sp)
	addi $t0, $t0, 1
	bne $t0, 200, loopB

	lw $ra, 4($sp) #restore $ra
	addiu $sp, $sp, 8 #restore stack
	jr $ra
	
#Procedure: GetChar
#Input - $s5 = counter to see what circle player "fell asleep" on
#Output - $v0 = ascii character
GetChar:
	#Store $ra
	addiu $sp, $sp, -8
	sw $ra, 0($sp)
	li $s3, 0	#Counter
	j check2
cloop:
	#Pauses then after 5 sec if no response player loses
	sw $s3, 4($sp)
	jal Pause
	lw $s3, 4($sp)
	addi $s3, $s3, 1
	beq $s3, 10, TOFail
check2:
	jal IsCharThere
	beqz $v0, cloop		#If no key, try again
	lui $t0, 0xFFFF		#Char exisits
	lw $v0, 4($t0)		#Place char in $v0
	
	#restore $ra
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	jr $ra

#Procedure: IsCharThere
#Output - #$v0 = 0 if no data or 1 if char there
#Checks to see if cahracter is present in memory
IsCharThere:
	lui $t0, 0xFFFF		#Control Reg is 0xFFFF0000
	lw $t1, ($t0)		#Go get control data
	andi $v0, $t1, 1	#Mask off LSB
	jr $ra
	
#Procedure: TOFail (Timeout Fail)
#If called, means user took too long to answer
TOFail:
	la $t0, sequence
	mul $t2, $s5, 4		#Multiply by 4 for .word navigation
	add $t0, $t0, $t2
	lb $t1, ($t0)		#Load where player fell asleep at
	addi $a0, $t1, 0	
	j fail
	
#Procedure: NewLine
#Will print a new line
NewLine:
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra
	
#Procedure: UserCheck
#Input - $a1 = seqeunce
#Input - $s1 = max
#This will take user input check integer by integer with sequence
UserCheck:
	li $s5, 0	#Counter
	li $v0, 4
	la $a0, prompt1	#Request user input
	syscall
	addiu $sp, $sp, -12
	sw $ra, 0($sp)
check:	
	#li $v0, 12		#Get user entry
	#syscall
	sw $a1, 4($sp)
	jal GetChar		#Poll Keyboard for user input
	lw $a1, 4($sp)
	subu $v0, $v0, 49	#Convert from ASCII to decimal and subtract and extra one for array notation
	lb $t1, ($a1)		#Load sequence digit to compare
	bne $v0, $t1, fail	#If there is a mismatch, fail (exit loop)
	move $a0, $t1		#Move digit to $a0
	sw $a1, 4($sp)
	sw $s5, 8($sp)
	jal GetColorData	#Get color data
	la $t0, ColorData	#Load ColorData table
	lw $a2, 8($t0)		#Load Color Number
	lw $a0, 0($t0)		#Load X
	lw $a1, 4($t0)		#Load Y
	jal DrawCircle
	jal ClearScreen
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $s5, 8($sp)
	addi $a1, $a1, 4	#Increment digit to compare
	addi $s5, $s5, 1	#Increment counter
	bne $s5, $s1, check	#Loop while max value isnt reached
	addiu $sp, $sp, 12
	jr $ra			#If loop completes, pass user check

fail:
	#MiDi 
	li $a0, 120		#Load fail pitch 
	li $a1, 500		#Beep for .5 seconds
	li $a2, 50		#Use fail instrument 50 (Random choice)
	li $a3, 100		#Volue set to 100 (0-127)
	li $v0, 33
	syscall
	
	#Draw correct circle twice (redundant code)
	move $a0, $t1
	addiu $sp, $sp, -8
	sw $a0, 4($sp)
	jal GetColorData	#Get color data
	la $t0, ColorData	#Load ColorData table
	lw $a2, 8($t0)		#Load Color Number
	lw $a0, 0($t0)		#Load X
	lw $a1, 4($t0)		#Load Y
	jal DrawCircle
	jal ClearScreen
	lw $a0, 4($sp)
	jal GetColorData	#Get color data
	lw $ra, ($sp)
	la $t0, ColorData	#Load ColorData table
	lw $a2, 8($t0)		#Load Color Number
	lw $a0, 0($t0)		#Load X
	lw $a1, 4($t0)		#Load Y
	jal DrawCircle
	jal ClearScreen
	addiu $sp, $sp, 8

	la $a0, playerLose	#Load player lose prompt
	li $v0, 4	
	syscall	
	li $v0, 10		#Exit program
	syscall
	
pass:
	la $a0, playerWin	#Load player win prompt
	li $v0, 4	
	syscall	
	li $v0, 10		#Exit program
	syscall
	
	
# OutText: display ascii characters on the bit mapped display
# $a0 = horizontal pixel co-ordinate (0-255)
# $a1 = vertical pixel co-ordinate (0-255)
# $a2 = pointer to asciiz text (to be displayed)
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
        
########################################################################
	#   Description:
	#       Example SPIM exception handler
	#       Derived from the default exception handler in the SPIM S20
	#       distribution.
	#
	#   History:
	#       Dec 2009    J Bacon
	
	########################################################################
	# Exception handling code.  This must go first!
	
			.kdata
	__start_msg_:   .asciiz "  Exception "
	__end_msg_:     .asciiz " occurred and ignored\n"
	
	# Messages for each of the 5-bit exception codes
	__exc0_msg:     .asciiz "  [Interrupt] "
	__exc1_msg:     .asciiz "  [TLB]"
	__exc2_msg:     .asciiz "  [TLB]"
	__exc3_msg:     .asciiz "  [TLB]"
	__exc4_msg:     .asciiz "  [Address error in inst/data fetch] "
	__exc5_msg:     .asciiz "  [Address error in store] "
	__exc6_msg:     .asciiz "  [Bad instruction address] "
	__exc7_msg:     .asciiz "  [Bad data address] "
	__exc8_msg:     .asciiz "  [Error in syscall] "
	__exc9_msg:     .asciiz "  [Breakpoint] "
	__exc10_msg:    .asciiz "  [Reserved instruction] "
	__exc11_msg:    .asciiz ""
	__exc12_msg:    .asciiz "  [Arithmetic overflow] "
	__exc13_msg:    .asciiz "  [Trap] "
	__exc14_msg:    .asciiz ""
	__exc15_msg:    .asciiz "  [Floating point] "
	__exc16_msg:    .asciiz ""
	__exc17_msg:    .asciiz ""
	__exc18_msg:    .asciiz "  [Coproc 2]"
	__exc19_msg:    .asciiz ""
	__exc20_msg:    .asciiz ""
	__exc21_msg:    .asciiz ""
	__exc22_msg:    .asciiz "  [MDMX]"
	__exc23_msg:    .asciiz "  [Watch]"
	__exc24_msg:    .asciiz "  [Machine check]"
	__exc25_msg:    .asciiz ""
	__exc26_msg:    .asciiz ""
	__exc27_msg:    .asciiz ""
	__exc28_msg:    .asciiz ""
	__exc29_msg:    .asciiz ""
	__exc30_msg:    .asciiz "  [Cache]"
	__exc31_msg:    .asciiz ""
	
	__level_msg:    .asciiz "Interrupt mask: "
	
	
	#########################################################################
	# Lookup table of exception messages
	__exc_msg_table:
		.word   __exc0_msg, __exc1_msg, __exc2_msg, __exc3_msg, __exc4_msg
		.word   __exc5_msg, __exc6_msg, __exc7_msg, __exc8_msg, __exc9_msg
		.word   __exc10_msg, __exc11_msg, __exc12_msg, __exc13_msg, __exc14_msg
		.word   __exc15_msg, __exc16_msg, __exc17_msg, __exc18_msg, __exc19_msg
		.word   __exc20_msg, __exc21_msg, __exc22_msg, __exc23_msg, __exc24_msg
		.word   __exc25_msg, __exc26_msg, __exc27_msg, __exc28_msg, __exc29_msg
		.word   __exc30_msg, __exc31_msg
	
	# Variables for save/restore of registers used in the handler
	save_v0:    .word   0
	save_a0:    .word   0
	save_at:    .word   0
	
	
	#########################################################################
	# This is the exception handler code that the processor runs when
	# an exception occurs. It only prints some information about the
	# exception, but can serve as a model of how to write a handler.
	#
	# Because this code is part of the kernel, it can use $k0 and $k1 without
	# saving and restoring their values.  By convention, they are treated
	# as temporary registers for kernel use.
	#
	# On the MIPS-1 (R2000), the exception handler must be at 0x80000080
	# This address is loaded into the program counter whenever an exception
	# occurs.  For the MIPS32, the address is 0x80000180.
	# Select the appropriate one for the mode in which SPIM is compiled.
	
		.ktext  0x80000180
	
		# Save ALL registers modified in this handler, except $k0 and $k1
		# This includes $t* since the user code does not explicitly
		# call this handler.  $sp cannot be trusted, so saving them to
		# the stack is not an option.  This routine is not reentrant (can't
		# be called again while it is running), so we can save registers
		# to static variables.
		sw      $v0, save_v0
		sw      $a0, save_a0
	
		# $at is the temporary register reserved for the assembler.
		# It may be modified by pseudo-instructions in this handler.
		# Since an interrupt could have occurred during a pseudo
		# instruction in user code, $at must be restored to ensure
		# that that pseudo instruction completes correctly.
		.set    noat
		sw      $at, save_at
		.set    at
	
		# Determine cause of the exception
		mfc0    $k0, $13        # Get cause register from coprocessor 0
		srl     $a0, $k0, 2     # Extract exception code field (bits 2-6)
		andi    $a0, $a0, 0x1f
		
		# Check for program counter issues (exception 6)
		bne     $a0, 6, ok_pc
		nop
	
		mfc0    $a0, $14        # EPC holds PC at moment exception occurred
		andi    $a0, $a0, 0x3   # Is EPC word-aligned (multiple of 4)?
		beqz    $a0, ok_pc
		nop
	
		# Bail out if PC is unaligned
		# Normally you don't want to do syscalls in an exception handler,
		# but this is MARS and not a real computer
		li      $v0, 4
		la      $a0, __exc3_msg
		syscall
		li      $v0, 10
		syscall
	
	ok_pc:
		mfc0    $k0, $13
		srl     $a0, $k0, 2     # Extract exception code from $k0 again
		andi    $a0, $a0, 0x1f
		bnez    $a0, non_interrupt  # Code 0 means exception was an interrupt
		nop
	
		# External interrupt handler
		# Don't skip instruction at EPC since it has not executed.
		# Interrupts occur BEFORE the instruction at PC executes.
		# Other exceptions occur during the execution of the instruction,
		# hence for those increment the return address to avoid
		# re-executing the instruction that caused the exception.
	
	     # check if we are in here because of a character on the keyboard simulator
		 # go to nochar if some other interrupt happened
		 
		 # get the character from memory
		 # store it to a queue somewhere to be dealt with later by normal code

		j	return
	
nochar:
		# not a character
		# Print interrupt level
		# Normally you don't want to do syscalls in an exception handler,
		# but this is MARS and not a real computer
		li      $v0, 4          # print_str
		la      $a0, __level_msg
		syscall
		
		li      $v0, 1          # print_int
		mfc0    $k0, $13        # Cause register
		srl     $a0, $k0, 11    # Right-justify interrupt level bits
		syscall
		
		li      $v0, 11         # print_char
		li      $a0, 10         # Line feed
		syscall
		
		j       return
	
	non_interrupt:
		# Print information about exception.
		# Normally you don't want to do syscalls in an exception handler,
		# but this is MARS and not a real computer
		li      $v0, 4          # print_str
		la      $a0, __start_msg_
		syscall
	
		li      $v0, 1          # print_int
		mfc0    $k0, $13        # Extract exception code again
		srl     $a0, $k0, 2
		andi    $a0, $a0, 0x1f
		syscall
	
		# Print message corresponding to exception code
		# Exception code is already shifted 2 bits from the far right
		# of the cause register, so it conveniently extracts out as
		# a multiple of 4, which is perfect for an array of 4-byte
		# string addresses.
		# Normally you don't want to do syscalls in an exception handler,
		# but this is MARS and not a real computer
		li      $v0, 4          # print_str
		mfc0    $k0, $13        # Extract exception code without shifting
		andi    $a0, $k0, 0x7c
		lw      $a0, __exc_msg_table($a0)
		nop
		syscall
	
		li      $v0, 4          # print_str
		la      $a0, __end_msg_
		syscall
	
		# Return from (non-interrupt) exception. Skip offending instruction
		# at EPC to avoid infinite loop.
		mfc0    $k0, $14
		addiu   $k0, $k0, 4
		mtc0    $k0, $14
	
	return:
		# Restore registers and reset processor state
		lw      $v0, save_v0    # Restore other registers
		lw      $a0, save_a0
	
		.set    noat            # Prevent assembler from modifying $at
		lw      $at, save_at
		.set    at
	
		mtc0    $zero, $13      # Clear Cause register
	
		# Re-enable interrupts, which were automatically disabled
		# when the exception occurred, using read-modify-write cycle.
		mfc0    $k0, $12        # Read status register
		andi    $k0, 0xfffd     # Clear exception level bit
		ori     $k0, 0x0001     # Set interrupt enable bit
		mtc0    $k0, $12        # Write back
	
		# Return from exception on MIPS32:
		eret
	
	
	#########################################################################
	# Standard startup code.  Invoke the routine "main" with arguments:
	# main(argc, argv, envp)
	
		.text
		.globl __start
	__start:
		lw      $a0, 0($sp)     # argc = *$sp
		addiu   $a1, $sp, 4     # argv = $sp + 4
		addiu   $a2, $sp, 8     # envp = $sp + 8
		sll     $v0, $a0, 2     # envp += size of argv array
		addu    $a2, $a2, $v0
		jal     main
		nop
	
		li      $v0, 10         # exit
		syscall
	
		.globl __eoth
	__eoth: