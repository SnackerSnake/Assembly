#Special notes:
#100 for the monster value registers (e.g. in hand) is considered to be our "blank".
.data 
ColorTable:
.word 0xFFFF00 #[0] Yellow 0xFFFF00

newLine: .asciiz "\n"
spacebarComma: .asciiz ", "
 
MonsterOne: .asciiz  "Gene-Warped Warwolf"
MonsterOneAttack: .word  2000
MonsterOneDefense: .word  0

MonsterTwo: .asciiz "Hunter Dragon"
MonsterTwoAttack: .word  1700
MonsterTwoDefense: .word  100

MonsterThree: .asciiz  "7 Colored Fish"
MonsterThreeAttack: .word 1800
MonsterThreeDefense: .word  800
 
MonsterFour: .asciiz  "Dunames Dark Witch"
MonsterFourAttack: .word  1800
MonsterFourDefense: .word  1050

MonsterFive: .asciiz  "Giant Soldier of Stone"
MonsterFiveAttack: .word 1300
MonsterFiveDefense: .word 2000

PlayerOneLifePointsText: .asciiz "Player One's Life Points: "
PlayerOneLifePoints: .word 4000
PlayerTwoLifePointsText: .asciiz "Player Two's Life Points: "
PlayerTwoLifePoints: .word 4000

HandText: .asciiz "Hand: "

userInput: .space 20

SummonText: .asciiz "Choose a monster to summon by inputting their number."
SummonModeText: .asciiz "Summon in 1. Attack Mode or 2. Defense Mode?"
InvalidBP: .asciiz "Not a valid input. Please choose again."
AttackPointsText: .asciiz "Attack Points: "
DefensePointsText: .asciiz "Defense Points: "

HelpText: .asciiz "Enter a number to do a command: 1.Summon 2.Attack 3.Switch Battle Position 4. End Test"
ErrorText: .asciiz "Error: You typed in improper input. You need to type a number for the corresponding word command. Enter a number to do a command:"
AttackText: .asciiz "Your monster attacks!"
DrawingNewCardText: "Drawing New Card: "

HandOne: .asciiz "1."
HandTwo:.asciiz " 2."
HandThree:.asciiz " 3."

PlayingFieldTextOne: .asciiz "\nPLAYING FIELD: \n"
PlayingFieldTextTwo: .asciiz "Player 1's Monster (You): "
PlayingFieldTextThree: .asciiz "Player 2's Monster (Opponent): "

############ EXCEPTION STUFF ###########
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
 main:
 # Enable exceptions globally
	lw      $t1, EXC_ENABLE_MASK
	or      $t0, $t0, $t1

	mtc0    $t0, $12
	
#Initliaze initial life point amounts.
addi $s1, $s1, 4000
addi $s2, $s2, 4000

#Tells player what monsters are in their hand
li $v0, 4
la $a0, HandText
syscall
#Print hand number
li $v0, 4
la $a0, HandOne
syscall

#First player draws three cards when the duel starts.
jal DrawFirst

#Print hand number
li $v0, 4
la $a0, HandTwo
syscall

jal DrawSecond

#Print hand number
li $v0, 4
la $a0, HandThree
syscall

jal DrawThird

#New line
li $v0, 4
la $a0, newLine
syscall

#######Actualy Game Commands############
NextTurn:
jal StartTurn
jal Command
jal RefillHand
jal ShowHandFirst
jal ShowHandSecond
jal ShowHandThird


#New line
li $v0, 4
la $a0, newLine
syscall

jal BeginNextTurn
 
#Automatically draw the player's first card from the deck to the hand before the turn starts.
DrawFirst:
li $a1, 5  #Here you set $a1 to the max bound.
li $v0, 42  #Generates the random number.
syscall

move $s4, $a0 #$a0 has the randomly generated number $v0, 42 generates

#######TEST CODE############
#li $v0, 1   #print random number generated
#syscall
###########################

beq $s4, 0, DisplayMonsterOne
beq $s4, 1, DisplayMonsterTwo
beq $s4, 2, DisplayMonsterThree
beq $s4, 3, DisplayMonsterFour
beq $s4, 4, DisplayMonsterFive

#Ends the draw function.
#FinishDraw:
#jr $ra

#Automatically draw the player's second card from the deck to the hand before the turn starts.
DrawSecond:
li $a1, 5  #Here you set $a1 to the max bound.
li $v0, 42  #Generates the random number.
syscall

move $s5, $a0 #$a0 has the randomly generated number $v0, 42 generates

beq $s5, 0, DisplayMonsterOne
beq $s5, 1, DisplayMonsterTwo
beq $s5, 2, DisplayMonsterThree
beq $s5, 3, DisplayMonsterFour
beq $s5, 4, DisplayMonsterFive

#Ends the draw function.
#FinishDraw:
#jr $ra

#Automatically draw the player's second card from the deck to the hand before the turn starts.
DrawThird:
li $a1, 5  #Here you set $a1 to the max bound.
li $v0, 42  #Generates the random number.
syscall

move $s6, $a0 #$a0 has the randomly generated number $v0, 42 generates

beq $s6, 0, DisplayMonsterOne
beq $s6, 1, DisplayMonsterTwo
beq $s6, 2, DisplayMonsterThree
beq $s6, 3, DisplayMonsterFour
beq $s6, 4, DisplayMonsterFive

#This function checks every card in the hand to see which one is missing a card.
RefillHand:
beq $s4, 100, RefillHandFirst
beq $s5, 100, RefillHandSecond
beq $s6, 100, RefillHandThird

jr $ra

#This fucntion replaces the first part of the hand with a monster card if it's empty.
RefillHandFirst:

#New line
li $v0, 4
la $a0, newLine
syscall

#Displays a new card being drawn and then draws that card.
li $v0, 4
la $a0, DrawingNewCardText
syscall
beq $s4, 100, DrawFirst

jr $ra

#This fucntion replaces the second part of the hand with a monster card if it's empty.
RefillHandSecond:

#New line
li $v0, 4
la $a0, newLine
syscall

#Displays a new card being drawn and then draws that card.
li $v0, 4
la $a0, DrawingNewCardText
syscall
beq $s5, 100, DrawSecond
  
jr $ra

#This fucntion replaces the third part of the hand with a monster card if it's empty.
RefillHandThird:

#New line
li $v0, 4
la $a0, newLine
syscall

#Displays a new card being drawn and then draws that card.
li $v0, 4
la $a0, DrawingNewCardText
syscall
beq $s6, 100, DrawThird

jr $ra

#Writes on the console the stats on the beginning of the turn.
StartTurn:
#Display life points
li $v0, 4
la $a0, PlayerOneLifePointsText
syscall

li $v0, 1
lw $a0, PlayerOneLifePoints
syscall

li $v0, 4
la $a0, newLine
syscall

li $v0, 4
la $a0, PlayerTwoLifePointsText
syscall

li $v0, 1
#lw $a0, PlayerTwoLifePoints
move $a0, $s2
syscall

li $v0, 4
la $a0, newLine
syscall

li $v0, 4
la $a0, HelpText
syscall

li $v0, 4
la $a0, newLine
syscall

jr $ra

#Get the user's input to run a command.
Command: #NEED TO CYCLE THROUGH POSSIBLE OUTTCOMES

li $v0, 5
syscall
move $s3, $v0

beq $s3, 1, Summon
beq $s3, 2, Attack
beq $s3, 3, Switch
beq $s3, 4, EndTurn

#An error has occured if none of the numbers has been entered.
#The code below handles that scenario.
li $v0, 4
la $a0, ErrorText
syscall
li $v0, 4
la $a0, newLine
syscall
j Command

#Ends Command function.
CommandEnd:
jr $ra

#Summon
Summon: 
li $v0, 4
la $a0, SummonText
syscall

#Get integer input from user
li $v0, 5
syscall

beq $v0, 1, SummonHandOne
beq $v0, 2, SummonHandTwo
beq $v0, 3, SummonHandThree

#Ends summon command
EndSummon:
#Print a new line.
li $v0, 4
la $a0, newLine
syscall
j CommandEnd

#Attack
Attack:
#Display text to say the first player's monster attacks.
li $v0, 4
la $a0, AttackText
syscall
li $v0, 4
la $a0, newLine
syscall

#Attack with the monster.
beq $t1, 0, AttackMonsterOne
beq $t1, 1, AttackMonsterTwo
beq $t1, 2, AttackMonsterThree
beq $t1, 3, AttackMonsterFour
beq $t1, 4, AttackMonsterFive

#I need code for battle between monsters still.
j CommandEnd

#Switch the battle position of the monster.
Switch:
beq $t3, 0, SwitchToDefense
beq $t3, 1, SwitchToAttack
j CommandEnd

#Switch the battle position of the monster to defense mode.
SwitchToDefense:
li $t3, 1
j CommandEnd

#Switch the battle position of the monster to attack mode.
SwitchToAttack:
li $t3, 0
j CommandEnd

EndTurn:
#End the Program
 li      $v0, 10             
 syscall
 
#This function begins the next turn.
#It has no arguments.
BeginNextTurn:
j NextTurn

#This function shows what monster cards are in the player's hand currently.
ShowHandFirst:
li $v0, 4
la $a0, newLine
syscall

#Tells player what monsters are in their hand
li $v0, 4
la $a0, HandText
syscall
#Print hand number
li $v0, 4
la $a0, HandOne
syscall

#Display the monster
beq $s4, 0, DisplayMonsterOne
beq $s4, 1, DisplayMonsterTwo
beq $s4, 2, DisplayMonsterThree
beq $s4, 3, DisplayMonsterFour
beq $s4, 4, DisplayMonsterFive

ShowHandSecond:
#Print hand number
li $v0, 4
la $a0, HandTwo
syscall

#Display the monster
beq $s5, 0, DisplayMonsterOne
beq $s5, 1, DisplayMonsterTwo
beq $s5, 2, DisplayMonsterThree
beq $s5, 3, DisplayMonsterFour
beq $s5, 4, DisplayMonsterFive

ShowHandThird:
#Print hand number
li $v0, 4
la $a0, HandThree
syscall

#Display the monster
beq $s6, 0, DisplayMonsterOne
beq $s6, 1, DisplayMonsterTwo
beq $s6, 2, DisplayMonsterThree
beq $s6, 3, DisplayMonsterFour
beq $s6, 4, DisplayMonsterFive

#New line
li $v0, 4
la $a0, newLine
syscall

jr $ra

#Displays Gene-Warped Warwolf on text. This is used for drawing to the hand, summoning, and showing the hand.
DisplayMonsterOne:
li $v0, 4
la $a0, MonsterOne
syscall

jr $ra

#Add Hunter Dragon to the hand
DisplayMonsterTwo:
li $v0, 4
la $a0, MonsterTwo
syscall

jr $ra

#Add 7 Colored Fish to hand
DisplayMonsterThree:
li $v0, 4
la $a0, MonsterThree
syscall

jr $ra

#Addd Dunames Dark Witch to hand
DisplayMonsterFour:
li $v0, 4
la $a0, MonsterFour
syscall

jr $ra

#Add Giant Soldier of Stone to hand
DisplayMonsterFive:
li $v0, 4
la $a0, MonsterFive
syscall

jr $ra

#Displays Gene-Warped Warwolf on text. This is used for drawing to the hand, summoning, and showing the hand.
DisplayMonsterOneSummoning:
li $v0, 4
la $a0, MonsterOne
syscall

j ChooseBattlePosition

#Add Hunter Dragon to the hand
DisplayMonsterTwoSummoning:
li $v0, 4
la $a0, MonsterTwo
syscall

j ChooseBattlePosition

#Add 7 Colored Fish to hand
DisplayMonsterThreeSummoning:
li $v0, 4
la $a0, MonsterThree
syscall

j ChooseBattlePosition

#Addd Dunames Dark Witch to hand
DisplayMonsterFourSummoning:
li $v0, 4
la $a0, MonsterFour
syscall

j ChooseBattlePosition

#Add Giant Soldier of Stone to hand
DisplayMonsterFiveSummoning:
li $v0, 4
la $a0, MonsterFive
syscall

j ChooseBattlePosition

#Summon monster from the first card in the hand.
SummonHandOne:
#Field
li $v0, 4
la $a0, PlayingFieldTextOne
syscall
li $v0, 4
la $a0, PlayingFieldTextTwo
syscall

#Put monster card one in monster zone 1
move $t1, $s4
#Reset hand to blank.
li $s4, 100 

#Display the monster
beq $t1, 0, DisplayMonsterOneSummoning
beq $t1, 1, DisplayMonsterTwoSummoning
beq $t1, 2, DisplayMonsterThreeSummoning
beq $t1, 3, DisplayMonsterFourSummoning
beq $t1, 4, DisplayMonsterFiveSummoning

j EndSummon

#Summon monster from the second card in the hand.
SummonHandTwo:
#Field
li $v0, 4
la $a0, PlayingFieldTextOne
syscall
li $v0, 4
la $a0, PlayingFieldTextTwo
syscall

#Put monster card one in monster zone 1
move $t1, $s5
#Reset hand to blank.
li $s5, 100 

#Display the monster
beq $t1, 0, DisplayMonsterOneSummoning
beq $t1, 1, DisplayMonsterTwoSummoning
beq $t1, 2, DisplayMonsterThreeSummoning
beq $t1, 3, DisplayMonsterFourSummoning
beq $t1, 4, DisplayMonsterFiveSummoning
j EndSummon

#Summon monster from the third card in the hand.
SummonHandThree:
#Field
li $v0, 4
la $a0, PlayingFieldTextOne
syscall
li $v0, 4
la $a0, PlayingFieldTextTwo
syscall

#Put monster card one in monster zone 1
move $t1, $s6
#Reset hand to blank.
li $s6, 100 

#Display the monster
beq $t1, 0, DisplayMonsterOneSummoning
beq $t1, 1, DisplayMonsterTwoSummoning
beq $t1, 2, DisplayMonsterThreeSummoning
beq $t1, 3, DisplayMonsterFourSummoning
beq $t1, 4, DisplayMonsterFiveSummoning

j EndSummon

ChooseBattlePosition:
li $v0, 4
la $a0, newLine
syscall
#Prompts the user to pick a battle position to summon the monster in.
li $v0, 4
la $a0, SummonModeText
syscall
li $v0, 4
la $a0, newLine
syscall

li $v0, 5
syscall
move $t4, $v0

beq $t4, 1, SummonInAttack
beq $t4, 2, SummonInDefense

li $v0, 4
la $a0, InvalidBP
syscall

j ChooseBattlePosition

SummonInAttack:
li $t3, 0

beq $t1, 0, SummonMonsterOneAttack
beq $t1, 1, SummonMonsterTwoAttack
beq $t1, 2, SummonMonsterThreeAttack
beq $t1, 3, SummonMonsterFourAttack
beq $t1, 4, SummonMonsterFiveAttack

SummonInDefense:
li $t3, 1

beq $t1, 0, SummonMonsterOneDefense
beq $t1, 1, SummonMonsterTwoDefense
beq $t1, 2, SummonMonsterThreeDefense
beq $t1, 3, SummonMonsterFourDefense
beq $t1, 4, SummonMonsterFiveDefense

#The next five functions set the amount of attack points to each corresponding monster summoned to player 1.
SummonMonsterOneAttack:
li $t5, 2000

li $v0, 4
la $a0, AttackPointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon

SummonMonsterTwoAttack:
li $t5, 1700

li $v0, 4
la $a0, AttackPointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon
SummonMonsterThreeAttack:
li $t5, 1800

li $v0, 4
la $a0, AttackPointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon
SummonMonsterFourAttack:
li $t5, 1800

li $v0, 4
la $a0, AttackPointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon
SummonMonsterFiveAttack:
li $t5, 1300

li $v0, 4
la $a0, AttackPointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon

#The next five functions set the amount of defense points to each corresponding monster summoned to player 1.
SummonMonsterOneDefense:
li $t5, 0

li $v0, 4
la $a0, DefensePointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon

SummonMonsterTwoDefense:
li $t5, 100

li $v0, 4
la $a0, DefensePointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon

SummonMonsterThreeDefense:
li $t5, 800

li $v0, 4
la $a0, DefensePointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon

SummonMonsterFourDefense:
li $t5, 1050

li $v0, 4
la $a0, DefensePointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon

SummonMonsterFiveDefense:
li $t5, 2000

li $v0, 4
la $a0, DefensePointsText
syscall

li $v0, 1
move $a0, $t5
syscall

j EndSummon

#The next five functions handle the direct attack to the opponent's lifepoints.
AttackMonsterOne:
subi $s2, $s2, 2000
jr $ra
AttackMonsterTwo:
subi $s2, $s2, 1700
jr $ra
AttackMonsterThree:
subi $s2, $s2, 1800
jr $ra
AttackMonsterFour:
subi $s2, $s2, 1800
jr $ra
AttackMonsterFive:
subi $s2, $s2, 1300
jr $ra

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