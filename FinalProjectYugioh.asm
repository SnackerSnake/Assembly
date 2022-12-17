#By David Hernandez
#Credits to J Bacon for Exception.s; Most of that code is in here. Only a few exception lines are made by me.

#Special notes:
#100 for the monster value registers $t1 and $t2 (e.g. on the field) is considered to be our "blank" for no monster.

#$t1 and $t2 monster zones
#$t3 battle position, 0 means attack, 1 means defense
#$t4 for summon battle position checking
#$t5 for points of monster player one
#$t7 for opponent’s monster points
#$t8 life point damage to either player
#$s1-$s2 life points
#$s3 checks if player one attacked in battle phase (0 for able, 1 for not able)
#Hand: $s4 to $s6

#Functions have no inputs unless specified.

#The AI will always attack and place monsters in attack mode.

.data 
newLine: .asciiz "\n"
 
MonsterOne: .asciiz  "Gene-Warped Warwolf"
MonsterTwo: .asciiz "Hunter Dragon"
MonsterThree: .asciiz  "7 Colored Fish"
MonsterFour: .asciiz  "Dunames Dark Witch"
MonsterFive: .asciiz  "Giant Soldier of Stone"

MonsterOneWithStats: .asciiz "Gene-Warped Warwolf ATK: 2000 DEF: 0"
MonsterTwoWithStats: .asciiz "Hunter Dragon ATK: 1700 DEF: 100"
MonsterThreeWithStats: .asciiz "7 Colored Fish ATK: 1800 DEF: 800"
MonsterFourWithStats: .asciiz "Dunames Dark Witch ATK: 1800 DEF: 1050"
MonsterFiveWithStats: .asciiz "Giant Soldier of Stone ATK: 1300 DEF: 2000"

OpponentMonsterOne: .asciiz "Alien Shocktrooper"
OpponentMonsterTwo: .asciiz "Elemental Hero Avian"
OpponentMonsterThree: .asciiz "Science Soldier"

PlayerOneLifePointsText: .asciiz "Player One's Life Points: "
PlayerTwoLifePointsText: .asciiz "Player Two's Life Points: "

HandText: .asciiz "Hand: "

FirstTurnExplanation: .asciiz "Because you are the first turn player, you cannot attack nor switch the battle position of your summoned monster."

SummonText: .asciiz "Choose a monster to summon by inputting their number."
SummonModeText: .asciiz "Summon in 1. Attack Mode or 2. Defense Mode?"
InvalidBP: .asciiz "Not a valid input. Please choose again."
AttackPointsText: .asciiz "Attack Mode: "
DefensePointsText: .asciiz "Defense Mode: "

HelpText: .asciiz "Enter a number to do a command: 1.Summon 2.Attack 3.Switch Battle Position 4. End Test"
ErrorText: .asciiz "Error: You typed in improper input. You need to type a number for the corresponding word command. Enter a number to do a command:"
AttackText: .asciiz "Your monster attacks!"
CannotAttackText: .asciiz "You cannot attack because your monster is in defense mode."
DrawingNewCardText: .asciiz "Drawing New Card: "
NoneText: .asciiz "None"
AlreadyHaveMonsterText: .asciiz "You already control a monster, so there is no need to summon another."
OpponentSkipMainPhaseOne: .asciiz "The AI opponent already controls a monster, so the first main phase 1 is skipped.\n"
SwitchCheckExplanation: .asciiz "You cannot change your monster's battle position for one of the following reasons: you summoned a monster, you switched battle positions already, you attacked, or your monster is destroyed."

HandOne: .asciiz "1."
HandTwo:.asciiz " 2."
HandThree:.asciiz " 3."

DrawPhaseText: .asciiz "DRAW PHASE"
MainPhaseOneText: .asciiz "\nMAIN PHASE 1\n"
BattlePhaseText: .asciiz "\nBATTLE PHASE\n"
MainPhaseTwoText: .asciiz "\nMAIN PHASE 2\n"
EndPhaseText: .asciiz "\nEND PHASE\n"

AttackDecisionText: .asciiz "Do you wish to attack with your monster? 1. Yes 2. No"
SwitchDecisionText: .asciiz "Do you wish to switch your monster's battle positions? 1. Yes 2. No"

PlayingFieldTextOne: .asciiz "\nPLAYING FIELD: \n"
PlayingFieldTextTwo: .asciiz "Player 1's Monster (You): "
PlayingFieldTextThree: .asciiz "\nPlayer 2's Monster (Opponent): "

OpponentTurnStart: .asciiz "\nThe AI opponent begins his turn.\n"
OpponentTurnSummonText: .asciiz "The opponent summons a monster.\n"
OpponentAttackText: .asciiz "The AI opponent attacks!\n"

WinPlayerOneText: .asciiz "\nYour opponent's life points are 0. You win!"
WinPlayerTwoText: .asciiz "\nYour life points are 0. You lose!"

TutorialText: .asciiz "Welcome to Yu-Gi-Oh! Simplified!\nBoth players start with 4,000 Life Points, and the player to get their opponent to 0 Life Points wins."
TutorialTextTwo: .asciiz "\nYou accomplish this goal by summoning monsters and battling.\nYou start the game with three cards in your hand.\nThe game has several phases each turn in a specific order: Draw Phase, Main Phase 1, Battle Phase, Main Phase 2, and End Phase."
TutorialTextThree: .asciiz "\nIn the Draw Phase, you draw a card to replace played cards.\nIn the Main Phase 1, you can summon monsters in Attack Mode or Defense Mode from your hand."
TutorialTextFour: .asciiz "\nAttack Mode allows you to attack your opponent. Defense Mode ensures that your life points are safe, but you cannot attack."
TutorialTextFive: .asciiz "\nYou can change between these modes in the Main Phase 1 or 2 if you have not summoned, attacked, or already changed modes in the same turn."
TutorialTextSix: .asciiz "\nThe next phase is the Battle Phase. You can declare an attack on your opponent's monster in this phase. If they have no monsters, you can attack directly!"
TutorialTextSeven: .asciiz "\nThen goes the Main Phase 2. After that phase, the End Phase occurs and ends your turn.\nYour opponent then takes their turn to summon monsters and attack, and then your turn goes again."
TutorialTextEight: .asciiz "\nThe game keeps going between each player until someone's Life Points are 0."
TutorialTextNine: .asciiz "\nHow Battling Works:\nIn Attack Mode versus Attack Mode, the monster with less attack points loses, and their owner takes battle damage equal to the difference."
TutorialTextTen: .asciiz "\nIf both monsters have the same amount, both are destroyed, and neither player takes damage.\nIn Attack Mode versus Defense Mode, the higher number wins."
TutorialTextEleven: .asciiz "\nIf the attacker wins, the defender is destroyed without any battle damage. \nHowever, if the defender wins, no monster is destroyed, but the attacker's owner takes damage equal to the difference."
TutorialTextTwelve: .asciiz "\nIf both monsters points are equal, neither is destroyed, and both players' life points remain the same.\nSCROLL UP FOR FULL TUTORIAL!\n\n\n\n"

############ EXCEPTION STUFF #####################################
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
#############END OF EXCEPTION STUFF FOR NOW####################

 .text
 main:
 # Enable exceptions globally
	lw      $t1, EXC_ENABLE_MASK
	or      $t0, $t0, $t1

	mtc0    $t0, $12
	
#Prints out the tutorial of the game.##########################
li $v0, 4
la $a0, TutorialText
syscall
li $v0, 4
la $a0, TutorialTextTwo
syscall
li $v0, 4
la $a0, TutorialTextThree
syscall
li $v0, 4
la $a0, TutorialTextFour
syscall
li $v0, 4
la $a0, TutorialTextFive
syscall
li $v0, 4
la $a0, TutorialTextSix
syscall
li $v0, 4
la $a0, TutorialTextSeven
syscall
li $v0, 4
la $a0, TutorialTextEight
syscall
li $v0, 4
la $a0, TutorialTextNine
syscall
li $v0, 4
la $a0, TutorialTextTen
syscall
li $v0, 4
la $a0, TutorialTextEleven
syscall
li $v0, 4
la $a0, TutorialTextTwelve
syscall
#Tutorial ends after this syscall.##########################

###Start of First Player Turn###############################	
###The first turn of Yugioh is slightly different because the player who goes first cannot attack.#####
###Player 1, the human player, will always go first in this simulation.###

#Initliaze initial life point amounts.
addi $s1, $s1, 4000
addi $s2, $s2, 4000

#Both players start with no monsters on the field.
li $t1, 100
li $t2, 100

#Tells the player that they start in the draw phase.
li $v0, 4
la $a0, DrawPhaseText
syscall

#New Line
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

#First player draws three cards when the duel starts.
jal DrawFirst

#Print hand number
li $v0, 4
la $a0, HandTwo
syscall

#Draw the second card.
jal DrawSecond

#Print hand number
li $v0, 4
la $a0, HandThree
syscall

#Draw the third card.
jal DrawThird

#New line
li $v0, 4
la $a0, newLine
syscall

#Show updated Life Points
jal StartTurn

#Main Phase 1
li $v0, 4
la $a0, MainPhaseOneText
syscall

#Allow the player to summon a monster.
jal Summon

#The first player cannot attack, so we skip the battle phase and main phase two. 
li $v0, 4
la $a0, FirstTurnExplanation
syscall

#New line
li $v0, 4
la $a0, EndPhaseText
syscall

#####Opponent's First Turn#################################################
#Tells the player the opponent's turn has begun.
li $v0, 4
la $a0, OpponentTurnStart
syscall

#The opponent will summon a monster and attack with it.
#The game will display both players' life points and battlefield.
#The Wait functions make the program wait a little bit after each line so that the player can read.
jal StartTurn
jal Wait
jal OpponentSummonPartOne
jal Wait
jal OpponentSummonPartTwo
jal Wait
jal OpponentSummonPartThree
jal Wait
jal OpponentSummonPartFour
jal Wait
jal OpponentAttack
jal Wait

##########################################################################

###Every Other Turn of Yugioh For Human Player 1##########################
##This is the part of we wish to start again at over and over until the game ends by someone's life points going to 0.##
NextTurn:

#Make the program wait a little bit.
jal Wait
#Show updated Life Points
jal StartTurn

#Print new line.
li $v0, 4
la $a0, newLine
syscall

#Draw Phase
li $v0, 4
la $a0, DrawPhaseText
syscall

#The program will replace cards in human player's hand and show every monster. It will also show the new card above the list.
jal RefillHand
jal ShowHandFirst
jal ShowHandSecond
jal ShowHandThird

#Print new line.
li $v0, 4
la $a0, newLine
syscall

#Main Phase 1
li $v0, 4
la $a0, MainPhaseOneText
syscall

#Main Phase 1 lets the human player summon a monster.
jal SwitchMainPhaseOne
jal SummonAFT

#Battle Phase
li $v0, 4
la $a0, BattlePhaseText
syscall

#This lets the player be able to attack. Then the game will check if either player won.
jal AttackDecision
jal CheckWin

#Main Phase 2
li $v0, 4
la $a0, MainPhaseTwoText
syscall

#This lets the player change the battle position of their monster.
jal SwitchDecisionCheck

#This resets s3 so that the player can change battle position in future turns.
li $s3, 0

#New line
li $v0, 4
la $a0, EndPhaseText
syscall
#############################################################################

#####Opponent's Turn#########################################################
#Tells the player the opponent's turn has begun.
li $v0, 4
la $a0, OpponentTurnStart
syscall

#Because the programming logic is different when the AI opponent has a monster and when it does not, the program checks for it.
bne $t2, 100, OpponentWithMonster
j OpponentWithoutMonster

#If the AI opponent has no monster on the field, it will summon one.
#The opponent will summon a monster and attack with it.
#The game will display both players' life points and battlefield.
#The Wait functions make the program wait a little bit after each line so that the player can read.
OpponentWithoutMonster:
jal StartTurn
jal Wait
jal OpponentSummonPartOne
jal OpponentSummonPartTwo
jal Wait
jal OpponentSummonPartThree
jal OpponentSummonPartFour
jal Wait
jal OpponentAttack
jal CheckWin
j BeginNextTurn

#Otherwise, the existing monster will stay.
#The opponent will attack with the monster.
#The game will display both players' life points and battlefield.
#The Wait functions make the program wait a little bit after each line so that the player can read.
OpponentWithMonster:
li $v0, 4
la $a0, OpponentSkipMainPhaseOne
syscall

jal StartTurn
jal Wait
jal OpponentSummonPartOneWithMonster
jal OpponentSummonPartTwoWithMonster
jal Wait
jal OpponentSummonPartThreeWithMonster
jal OpponentSummonPartFourWithMonster
jal Wait
jal OpponentAttack
jal CheckWin
j BeginNextTurn
#########################################################################
 
 
 
 
#Automatically draw the player's first card from the deck to the hand before the turn starts.
#Output $s4
DrawFirst:
li $a1, 5  #Here you set $a1 to the max bound.
li $v0, 42  #Generates the random number.
syscall

move $s4, $a0 #$a0 has the randomly generated number $v0, 42 generates

#Based on the random number generated, display the first monster in the hand.
beq $s4, 0, DisplayMonsterOne
beq $s4, 1, DisplayMonsterTwo
beq $s4, 2, DisplayMonsterThree
beq $s4, 3, DisplayMonsterFour
beq $s4, 4, DisplayMonsterFive

#Automatically draw the player's second card from the deck to the hand before the turn starts.
#Output $s5
DrawSecond:
li $a1, 5  #Here you set $a1 to the max bound.
li $v0, 42  #Generates the random number.
syscall

move $s5, $a0 #$a0 has the randomly generated number $v0, 42 generates

#Based on the random number generated, display the second monster in the hand.
beq $s5, 0, DisplayMonsterOne
beq $s5, 1, DisplayMonsterTwo
beq $s5, 2, DisplayMonsterThree
beq $s5, 3, DisplayMonsterFour
beq $s5, 4, DisplayMonsterFive

#Automatically draw the player's second card from the deck to the hand before the turn starts.
#Output $s6
DrawThird:
li $a1, 5  #Here you set $a1 to the max bound.
li $v0, 42  #Generates the random number.
syscall

move $s6, $a0 #$a0 has the randomly generated number $v0, 42 generates

#Based on the random number generated, display the third monster in the hand.
beq $s6, 0, DisplayMonsterOne
beq $s6, 1, DisplayMonsterTwo
beq $s6, 2, DisplayMonsterThree
beq $s6, 3, DisplayMonsterFour
beq $s6, 4, DisplayMonsterFive

#This function checks every card in the hand to see which one is missing a card.
#Input: $s4, $s5, $s6
RefillHand:
beq $s4, 100, RefillHandFirst
beq $s5, 100, RefillHandSecond
beq $s6, 100, RefillHandThird

jr $ra

#This fucntion replaces the first part of the hand with a monster card if it's empty.
#Input: $s4
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
#Input: $s5
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
#Input: $s6
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
#Input: $s1, $s2
StartTurn:
#Display life points text
li $v0, 4
la $a0, PlayerOneLifePointsText
syscall

#Loads the amount of life points player one has.
li $v0, 1
move $a0, $s1
syscall

#New line
li $v0, 4
la $a0, newLine
syscall

#Display life points text
li $v0, 4
la $a0, PlayerTwoLifePointsText
syscall

#Loads the amount of life points player two has.
li $v0, 1
move $a0, $s2
syscall

#New line
li $v0, 4
la $a0, newLine
syscall

jr $ra



#Ends Command function.
CommandEnd:
jr $ra



#This function lets the user summon a monster.
Summon:
#Tell the user they can enter a number to pick a monster from their hand to summon.
li $v0, 4
la $a0, SummonText
syscall

#Get integer input from user
li $v0, 5
syscall

#Based on the number entered, the corresponding card in the hand is played.
beq $v0, 1, SummonHandOne
beq $v0, 2, SummonHandTwo
beq $v0, 3, SummonHandThree

#Exception handling: If the player did not summon by typing the wrong input, they still get to summon.
j Summon

#This function lets the user summon a monster after the first turn.
#Input: $t1
#Output: $s3
SummonAFT:
#Skip summoning if a monster is already in play
bne $t1, 100, EndSummonAFT

#Tell the user they can enter a number to pick a monster from their hand to summon.
li $v0, 4
la $a0, SummonText
syscall

#Get integer input from user
li $v0, 5
syscall

#Disables changing battle position if the monster was summoned.
li $s3, 1

#Based on the number entered, the corresponding card in the hand is played.
beq $v0, 1, SummonHandOne
beq $v0, 2, SummonHandTwo
beq $v0, 3, SummonHandThree

j SummonAFT

#Ends summon command
EndSummon:
#Print a new line.
li $v0, 4
la $a0, newLine
syscall
j CommandEnd

#Ends summon command after first turn
EndSummonAFT:
#Display that the player already has a monster.
li $v0, 4
la $a0, AlreadyHaveMonsterText
syscall

jr $ra


#Lets the player decide if he wants to attack.
AttackDecision:
li $v0, 4
la $a0, AttackDecisionText
syscall

#Check for user input.
li $v0, 5
syscall

#1 for if the user wants to attack, 2 if they don't
beq $v0, 1, Attack
beq $v0, 2, AttackNot

#Exception Handling: If the user does not type 1 or 2, the user will still be able to attack.
j AttackDecision

#The player decided to not attack with his or her monster.
AttackNot:
jr $ra

#This function lets the user attack.
#Input: $t1, $t2, $t3
#Output $s3
Attack:
#Tells the game that the player decided to attack. We use this register for switching in main phase 2.
li $s3, 1

#Display text to say the first player's monster attacks.
li $v0, 4
la $a0, AttackText
syscall

#new line
li $v0, 4
la $a0, newLine
syscall

#If the player put their monster in defense mode, they cannot attack.
beq $t3, 1, CannotAttack

#If the enemy has a monster, the game enters Attack Mode vs Attack Mode battle calculation.
bne $t2, 100, AttackVsAttack

#If the enemy has no monster, the player can attack directly
beq $t1, 0, AttackMonsterOne
beq $t1, 1, AttackMonsterTwo
beq $t1, 2, AttackMonsterThree
beq $t1, 3, AttackMonsterFour
beq $t1, 4, AttackMonsterFive

#I need code for battle between monsters still.
j CommandEnd

#This function plays if the user cannot attack if their monster is in defense mode.
CannotAttack:

#new line
li $v0, 4
la $a0, newLine
syscall

#Tells the player that they cannot attack if their monster is in defense mode.
li $v0, 4
la $a0, CannotAttackText
syscall

#new line
li $v0, 4
la $a0, newLine
syscall

jr $ra

#Handles battles if human player 1 attacks AI opponent/player 2.
#Input $t5 $t7
AttackVsAttack:
#If the attack of player 1 is greater than player two's attack.
bgt $t5, $t7, AttackVsAttackSituationOne
#If the attack of player 1 is equal to player one's attack.
beq $t5, $t7, AttackVsAttackSituationTwo
#If the attack of player 1 is less than to player two's attack.
blt $t5, $t7, AttackVsAttackSituationThree

jr $ra

#Player 2's monster is destroyed, and it loses life points equal to the difference.
#Input: $t5, $t7
#Output: $t2, $t7, $s2
AttackVsAttackSituationOne:
#Battle Damage calculation
li $t8, 0 #Resets $t8 in case used before
addu $t8, $t8, $t7
subu $t8, $t8, $t5
addu $s2, $s2, $t8

#Remove player 2's monster from the field.
li $t2, 100
li $t7, 0

jr $ra

#Both monsters die. No one takes battle damage.
#Output: $t1, $t2, $t5, $t7
AttackVsAttackSituationTwo:
#Removes both player's monsters from the field
li $t1, 100
li $t2, 100
#Sets both player's ATK/DEF to 0
li $t5, 0
li $t7, 0

jr $ra

#Player 1's monster dies. Player 1 loses life points.
#Input: $t5, $t7
#Output: $t1, $t5
AttackVsAttackSituationThree:
#Battle Damage calculation
li $t8, 0 #Resets $t8 in case used before
addu $t8, $t8, $t5
subu $t8, $t8, $t7
addu $s1, $s1, $t8

#Remove player 2's monster from the field.
li $t1, 100
li $t5, 0

jr $ra

#This checks if player one attacked. If they did, they cannot switch battle position in the main phase 2.
#Input: $t1, $s3
SwitchDecisionCheck:
#If the player does not control a monster, they cannot switch the battle positions of a monster that they do not have.
beq $t1, 100, SwitchCheckExplanationTwo
#This lets the player choose to change battle position or not.
beq $s3, 0, SwitchDecision

#Otherwise, if the player attacked, the game explains that they cannot change their monster's battle position if that monster attacked.
li $v0, 4
la $a0, SwitchCheckExplanation
syscall

jr $ra

#This functions plays if the human player controls no monster in main phase 2.
SwitchCheckExplanationTwo:
#Explains why the player cannot change battle positions.
li $v0, 4
la $a0, SwitchCheckExplanation
syscall

jr $ra

#Lets the player decide if he wants to switch the battle position of their monster.
SwitchDecision:
li $v0, 4
la $a0, SwitchDecisionText
syscall

#Check for user input
li $v0, 5
syscall

#1 for switching battle position, 2 for not switching battle position
beq $v0, 1, Switch
beq $v0, 2, SwitchNot

#Exception Handling: If the user does not type 1 or 2, they still get the option to change their monster's battle position or not.
j SwitchDecision

#The player decided to not to switch the battle position of their monster.
SwitchNot:
jr $ra

#Switch the battle position of the monster.
#Input $t3
#Output: $s3
Switch:
#Disables changing battle position in case this was used in main phase 1 already.
li $s3, 1

#Checks for the program which mode to switch player one's monster to.
#If the monster is in attsck, it will switch to defense.
#If the monster is in defense, it will switch to attack.
beq $t3, 0, SwitchToDefense
beq $t3, 1, SwitchToAttack
j CommandEnd

#Switch the battle position of the monster to defense mode.
#Output $t3
SwitchToDefense:
li $t3, 1
j CommandEnd

#Switch the battle position of the monster to attack mode.
#Output $t3
SwitchToAttack:
li $t3, 0
j CommandEnd

#If player one has a monster on the field already on main phase 1, they can change their battle position.
#Else, continue.
#Input t1
SwitchMainPhaseOne:
bne $t1, 100, SwitchDecision
jr $ra

 
#This function begins the next turn.
#It has no arguments.
BeginNextTurn:
j NextTurn




#This function shows what monster is in the first card in the player's hand currently.
#Input $s4
ShowHandFirst:
#new line
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

#Display the monster based on the saved register
beq $s4, 0, DisplayMonsterOne
beq $s4, 1, DisplayMonsterTwo
beq $s4, 2, DisplayMonsterThree
beq $s4, 3, DisplayMonsterFour
beq $s4, 4, DisplayMonsterFive

#This function shows what monster is in the second card in the player's hand currently.
#Input $s5
ShowHandSecond:
#Print hand number
li $v0, 4
la $a0, HandTwo
syscall

#Display the monster on the saved register
beq $s5, 0, DisplayMonsterOne
beq $s5, 1, DisplayMonsterTwo
beq $s5, 2, DisplayMonsterThree
beq $s5, 3, DisplayMonsterFour
beq $s5, 4, DisplayMonsterFive

#This function shows what monster is in the third card in the player's hand currently.
#Input $s6
ShowHandThird:
#Print hand number
li $v0, 4
la $a0, HandThree
syscall

#Display the monster on the saved register
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
la $a0, MonsterOneWithStats
syscall

jr $ra

#Add Hunter Dragon to the hand
DisplayMonsterTwo:
li $v0, 4
la $a0, MonsterTwoWithStats
syscall

jr $ra

#Add 7 Colored Fish to hand
DisplayMonsterThree:
li $v0, 4
la $a0, MonsterThreeWithStats
syscall

jr $ra

#Addd Dunames Dark Witch to hand
DisplayMonsterFour:
li $v0, 4
la $a0, MonsterFourWithStats
syscall

jr $ra

#Add Giant Soldier of Stone to hand
DisplayMonsterFive:
li $v0, 4
la $a0, MonsterFiveWithStats
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
#Input: $s4
#Output: $t1, $s4
SummonHandOne:
#Tells the player that the monster field is being displayed
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

#Display the monster on the field
beq $t1, 0, DisplayMonsterOneSummoning
beq $t1, 1, DisplayMonsterTwoSummoning
beq $t1, 2, DisplayMonsterThreeSummoning
beq $t1, 3, DisplayMonsterFourSummoning
beq $t1, 4, DisplayMonsterFiveSummoning

j EndSummon

#Summon monster from the second card in the hand.
#Input: $s5
#Output: $t1, $s5
SummonHandTwo:
#Tells the player that the monster field is being displayed
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

#Display the monster on the field
beq $t1, 0, DisplayMonsterOneSummoning
beq $t1, 1, DisplayMonsterTwoSummoning
beq $t1, 2, DisplayMonsterThreeSummoning
beq $t1, 3, DisplayMonsterFourSummoning
beq $t1, 4, DisplayMonsterFiveSummoning
j EndSummon

#Summon monster from the third card in the hand.
#Input: $s6
#Output: $t1, $s6
SummonHandThree:
#Tells the player that the monster field is being displayed
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

#Display the monster on the field
beq $t1, 0, DisplayMonsterOneSummoning
beq $t1, 1, DisplayMonsterTwoSummoning
beq $t1, 2, DisplayMonsterThreeSummoning
beq $t1, 3, DisplayMonsterFourSummoning
beq $t1, 4, DisplayMonsterFiveSummoning

j EndSummon



#This function lets the user pick which battle position the monster is summoned in.
#Input $t4
ChooseBattlePosition:
#new line
li $v0, 4
la $a0, newLine
syscall
#Prompts the user to pick a battle position to summon the monster in.
li $v0, 4
la $a0, SummonModeText
syscall
#new line
li $v0, 4
la $a0, newLine
syscall

#Check for user input
li $v0, 5
syscall
move $t4, $v0

#1 for attack; 2 for defense
beq $t4, 1, SummonInAttack
beq $t4, 2, SummonInDefense

#Exception handling: Tells the user if they type a wrong input to input again
li $v0, 4
la $a0, InvalidBP
syscall

j ChooseBattlePosition



#The AI opponent does his main phase 1 by summoning a monster.
#This part shows the human player current phase and part of the field.
#Input: $t1
OpponentSummonPartOne:
#Says main phase 1
li $v0, 4
la $a0, MainPhaseOneText
syscall

#Tells the player that the opponent is summoningg a monster.
li $v0, 4
la $a0, OpponentTurnSummonText
syscall 

#Tells the user that the monster field is being displayed
li $v0, 4
la $a0, PlayingFieldTextOne
syscall
li $v0, 4
la $a0, PlayingFieldTextTwo
syscall

#Display the monster based on what the human player 1 has on the field
beq $t1, 0, DisplayMonsterOne
beq $t1, 1, DisplayMonsterTwo
beq $t1, 2, DisplayMonsterThree
beq $t1, 3, DisplayMonsterFour
beq $t1, 4, DisplayMonsterFive

#Tells the human player that they have no monster on the field.
li $v0, 4
la $a0, NoneText
syscall

jr $ra

#This part shows the human player how many attack or defense points his monster has.
#Input $t3
OpponentSummonPartTwo:
#Prints out a new line.
li $v0, 4
la $a0, newLine
syscall

#This doesn't really summon. It just redisplays the human player's attack or defense.
#It should work because they do not change for each monster.
beq $t3, 0, SummonInAttack
beq $t3, 1, SummonInDefense

jr $ra

#The AI opponent does his main phase 1 by summoning a monster.
#This part actually summons a monster to the AI opponent's side.
#Output $t2
OpponentSummonPartThree:
#Shows what monster the opponent has on the field
li $v0, 4
la $a0, PlayingFieldTextThree
syscall

li $a1, 3  #Here you set $a1 to the max bound.
li $v0, 42  #Generates the random number.
syscall

#Choose the monster based on the random number generator.
move $t2, $a0

#Summons one of three possible monsters to the opponent's side of the field
beq $t2, 0, DisplayOpponentMonsterOne
beq $t2, 1, DisplayOpponentMonsterTwo
beq $t2, 2, DisplayOpponentMonsterThree

#This should not happen. It exists in case of a bug.
jr $ra

#This part shows the attack points of the opponent AI's monster.
#For now, the AI can only summon in attack mode.
#Input $t2
OpponentSummonPartFour:
#Print out new line.
li $v0, 4
la $a0, newLine
syscall

#Print out attack points.
li $v0, 4
la $a0, AttackPointsText
syscall

#Shows the attack points of the opponent's monster
beq $t2, 0, DisplayOpponentMonsterOneAttack
beq $t2, 1, DisplayOpponentMonsterTwoAttack
beq $t2, 2, DisplayOpponentMonsterThreeAttack

jr $ra

#Displays Alient Shocktrooper on the field.
DisplayOpponentMonsterOne:
#Displays monster on the field
li $v0, 4
la $a0, OpponentMonsterOne
syscall

#Displays Elemental Hero Avian on the field.
jr $ra 
DisplayOpponentMonsterTwo:
#Displays monster on the field
li $v0, 4
la $a0, OpponentMonsterTwo
syscall

jr $ra

#Displays Science Soldier on the field.
DisplayOpponentMonsterThree:
#Displays monster on the field
li $v0, 4
la $a0, OpponentMonsterThree
syscall

jr $ra

#Displays Alient Shocktrooper's attack points.
#Output $t7
DisplayOpponentMonsterOneAttack:
#Saves ATK points to the game
li $t7, 1900

#Prints out the attack points.
li $v0, 1
move $a0, $t7
syscall

jr $ra 

#Displays Elemental Hero Avian's attack points.
#Output $t7
DisplayOpponentMonsterTwoAttack:
#Saves ATK points to the game
li $t7, 1000

#Prints out the attack points.
li $v0, 1
move $a0, $t7
syscall

jr $ra

#Displays Science Soldier's attack points.
#Output $t7
DisplayOpponentMonsterThreeAttack:
#Saves ATK points to the game
li $t7, 800

#Prints out the attack points.
li $v0, 1
move $a0, $t7
syscall

jr $ra

#This function handles the AI opponent attacking the human player's monster or directly.
#Input $t1, $t3
OpponentAttack:
#Displays the opponent's battle phase and that he is attacking.
li $v0, 4
la $a0, BattlePhaseText
syscall
li $v0, 4
la $a0, OpponentAttackText
syscall

#Check if the human player has no monsters
beq $t1, 100, OpponentDirectAttack
#Check if the human player's monster is in attack mode or defense mode.
beq $t3, 0, OpponentAttackVSAttack
beq $t3, 1, OpponentAttackVSDefense

jr $ra

#If the human player has no monsters on the field, the AI gets to attack directly.
#Input $t7
#Output $s1
OpponentDirectAttack:
#Human player one takes damage equal to the AI opponent's monster's attack.
subu $s1, $s1, $t7

jr $ra

#Handles situations of the opponent attacking the human player's attack mode monster.
#Input t5, t7
OpponentAttackVSAttack:
#If the attack of player 2 is greater than player one.
bgt $t7, $t5, OpponentAttackVSAttackSituationOne
#If the attack of player 2 is equal to player one.
beq $t7, $t5, OpponentAttackVSAttackSituationTwo
#If the attack of player 2 is less than to player one.
blt $t7, $t5, OpponentAttackVSAttackSituationThree

jr $ra

#Player 1's monster is destroyed, and he loses life points equal to the difference.
#Input: $t5, $t7
#Output $s1, $t1, $t5
OpponentAttackVSAttackSituationOne:
#Battle Damage calculation
li $t8, 0 #Resets $t8 in case used before
addu $t8, $t8, $t5
subu $t8, $t8, $t7
addu $s1, $s1, $t8

#Remove player 1's monster from the field.
li $t1, 100
li $t5, 0

jr $ra

#Both monsters die. No one takes battle damage.
#Output: $t1, $t2, $t5, $t7
OpponentAttackVSAttackSituationTwo:
#Both monsters die.
li $t1, 100
li $t2, 100

#Both player's ATK go to 0.
li $t5, 0
li $t7, 0

jr $ra

#Player 2's monster dies. Player 2 loses life points.
#Input $t5, %t7
#Output $t2, $t7, $s2
OpponentAttackVSAttackSituationThree:
#Battle Damage calculation
li $t8, 0 #Resets $t8 in case used before
addu $t8, $t8, $t7
subu $t8, $t8, $t5
addu $s2, $s2, $t8

#Remove player 2's monster from the field.
li $t2, 100
li $t7, 0

jr $ra

#If the AI attacks a defense mode monster that player one has.
#Battle damage cannot occur to player one if monsters are in defense mode.
#Input $t5, $t7
OpponentAttackVSDefense:
#If the attack of player 2 is greater than player one's defense.
bgt $t7, $t5, OpponentAttackVSDefenseSituationOne
#If the attack of player 2 is equal to player one's defense.
beq $t7, $t5, OpponentAttackVSDefenseSituationTwo
#If the attack of player 2 is less than to player one's defense.
blt $t7, $t5, OpponentAttackVSDefenseSituationThree

jr $ra

#Player 2 destroys the human player's monster.
#Output: $t1
OpponentAttackVSDefenseSituationOne:
li $t1, 100

jr $ra

#Both monsters live.
OpponentAttackVSDefenseSituationTwo:
jr $ra

#Player 2 takes battle damage.
#Input: $t7, $t5
#Output $s2
OpponentAttackVSDefenseSituationThree:
#Battle Damage calculation
li $t8, 0 #Resets $t8 in case used before
addu $t8, $t8, $t7
subu $t8, $t8, $t5
addu $s2, $s2, $t8
jr $ra



#Even thought the AI opponent skips his main phase 1, the field should still display monsters.
#This part shows the human player current phase and part of the field.
#Input $t1
OpponentSummonPartOneWithMonster:

#This tells the player that the monsters on the field will be displayed.
li $v0, 4
la $a0, PlayingFieldTextOne
syscall
li $v0, 4
la $a0, PlayingFieldTextTwo
syscall

#Display the monster on the field based on what's saved in $t1
beq $t1, 0, DisplayMonsterOne
beq $t1, 1, DisplayMonsterTwo
beq $t1, 2, DisplayMonsterThree
beq $t1, 3, DisplayMonsterFour
beq $t1, 4, DisplayMonsterFive

#Says that no monster is on the field.
li $v0, 4
la $a0, NoneText
syscall

jr $ra

#This part shows the human player how many attack or defense points his monster has.
#Input t1, t3
OpponentSummonPartTwoWithMonster:
#Prints out a new line.
li $v0, 4
la $a0, newLine
syscall

#This doesn't really summon. It just redisplays the human player's attack or defense.
#It should work because they do not change for each monster.
beq $t1, 100, CommandEnd
beq $t3, 0, SummonInAttack
beq $t3, 1, SummonInDefense

jr $ra

#Shows the opponent's monster name.
#Input t2
OpponentSummonPartThreeWithMonster:
#Tells player what monster the opponent AI has
li $v0, 4
la $a0, PlayingFieldTextThree
syscall

#Based on what monster the opponent AI has, the game will display its name.
beq $t2, 0, DisplayOpponentMonsterOne
beq $t2, 1, DisplayOpponentMonsterTwo
beq $t2, 2, DisplayOpponentMonsterThree

#This should not happen. It exists in case of a bug.
jr $ra

#This part shows the attack points of the opponent AI's monster.
#Input t2
OpponentSummonPartFourWithMonster:
#Print out new line.
li $v0, 4
la $a0, newLine
syscall

#Print out attack points.
li $v0, 4
la $a0, AttackPointsText
syscall

#Display the ATK points of the AI opponent's monster.
beq $t2, 0, DisplayOpponentMonsterOneAttack
beq $t2, 1, DisplayOpponentMonsterTwoAttack
beq $t2, 2, DisplayOpponentMonsterThreeAttack

jr $ra



#Summon the human player's monster in attack mode.
#Input t1
#Output t3
SummonInAttack:
li $t3, 0

#If no monster is on player one's side of the field.
beq $t1, 100, CommandEnd

#Based on the monster chosen, it will display the select monster.
beq $t1, 0, SummonMonsterOneAttack
beq $t1, 1, SummonMonsterTwoAttack
beq $t1, 2, SummonMonsterThreeAttack
beq $t1, 3, SummonMonsterFourAttack
beq $t1, 4, SummonMonsterFiveAttack

#Summon the human player's monster in defense mode.
#Input t1
#Output t3
SummonInDefense:
li $t3, 1

#If no monster is on player one's side of the field.
beq $t1, 100, CommandEnd

#Based on the monster chosen, it will display the select monster.
beq $t1, 0, SummonMonsterOneDefense
beq $t1, 1, SummonMonsterTwoDefense
beq $t1, 2, SummonMonsterThreeDefense
beq $t1, 3, SummonMonsterFourDefense
beq $t1, 4, SummonMonsterFiveDefense

#Set the amount of attack points of Gene-Warped Warwolf.
#Output $t5
SummonMonsterOneAttack:
#Saves attack points to the game.
li $t5, 2000

#Display that the attack points are being displayed.
li $v0, 4
la $a0, AttackPointsText
syscall

#Displays the amount of attack points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of attack points of Hunter Dragon
#Output $t5
SummonMonsterTwoAttack:
#Saves attack points to the game.
li $t5, 1700

#Display that the attack points are being displayed.
li $v0, 4
la $a0, AttackPointsText
syscall

#Displays the amount of attack points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of attack points of 7 Colored Fish.
#Output $t5
SummonMonsterThreeAttack:
#Saves attack points to the game.
li $t5, 1800

#Display that the attack points are being displayed.
li $v0, 4
la $a0, AttackPointsText
syscall

#Displays the amount of attack points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of attack points of Dunames Dark Witch.
#Output $t5
SummonMonsterFourAttack:
#Saves attack points to the game.
li $t5, 1800

#Display that the attack points are being displayed.
li $v0, 4
la $a0, AttackPointsText
syscall

#Displays the amount of attack points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of attack points of Giant Soldier of Stone.
#Output $t5
SummonMonsterFiveAttack:
#Saves attack points to the game.
li $t5, 1300

#Display that the attack points are being displayed.
li $v0, 4
la $a0, AttackPointsText
syscall

#Displays the amount of attack points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of defense points of gene-Warped Warwolf.
#Output $t5
SummonMonsterOneDefense:
#Saves defense points to the game.
li $t5, 0

#Display that the defense points are being displayed.
li $v0, 4
la $a0, DefensePointsText
syscall

#Displays the amount of defense points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of defense points of Hunter Dragon.
#Output $t5
SummonMonsterTwoDefense:
#Saves defense points to the game.
li $t5, 100

#Display that the defense points are being displayed.
li $v0, 4
la $a0, DefensePointsText
syscall

#Displays the amount of defense points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of defense points of 7 Colored Fish.
#Output $t5
SummonMonsterThreeDefense:
#Saves defense points to the game.
li $t5, 800

#Display that the defense points are being displayed.
li $v0, 4
la $a0, DefensePointsText
syscall

#Displays the amount of defense points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of defense points of Dunames Dark Witch.
#Output $t5
SummonMonsterFourDefense:
#Saves defense points to the game.
li $t5, 1050

#Display that the defense points are being displayed.
li $v0, 4
la $a0, DefensePointsText
syscall

#Displays the amount of defense points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#Set the amount of defense points of Giant Soldier of Stone.
#Output $t5
SummonMonsterFiveDefense:
#Saves defense points to the game.
li $t5, 2000

#Display that the defense points are being displayed.
li $v0, 4
la $a0, DefensePointsText
syscall

#Displays the amount of defense points.
li $v0, 1
move $a0, $t5
syscall

j EndSummon

#The next five functions handle the direct attack to the opponent's lifepoints.
#All Outputs: $s2
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

#This functions slows down the game so that the user can see what the AI opponent does.
Wait:
li $v0, 32
la $a0, 1500 #Change to 1500 after finished; original was 2000 (2 seconds)
syscall

jr $ra

#Checks to see if either player won. 
#If either player loses, it will always say they have 0 instead of a negative number because you technically cannot have negative life points in Yugioh.
#Input $s1, $s2
CheckWin:
#If player 2's life poitns are 0 o less, player one wins.
ble $s2, 0, PlayerOneWon
#If player 1's life points are 0 or less, player 2 wins.
ble $s1, 0, PlayerTwoWon

jr $ra

#If player 2's life poitns are 0 o less, player one wins.
PlayerOneWon:
#Tells the player they won.
li $v0, 4
la $a0, WinPlayerOneText
syscall

#End the Program
 li      $v0, 10             
 syscall
 
#If player 1's life points are 0 or less, player 2 wins.
PlayerTwoWon:
#Tells the player they lost
li $v0, 4
la $a0, WinPlayerTwoText
syscall

#End the Program
li      $v0, 10             
syscall


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
	


