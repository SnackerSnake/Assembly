.data
   number: .word    0 #This variable will store the input.
   userInput: .asciiz "Enter a number: " #This variable will be responsible for prompting the user for an input.
   newLine: .asciiz "\n" #A new line variable
   
   
.text
   main:
       #These three lines prints the userInput's "Enter a number: "
       li $v0,4
       la $a0,userInput
       syscall
      
       #These two lines read the user input stored in $v0.
       li $v0, 5
       syscall
      
       #This line loads the address of number in $t0.
       la $t0,number
       
       #This line stores the user input at address stored in $t0.
       sw $v0,0($t0) #I think this part does indeed save the decimal number to data memory. 
      
       #This line loads the address of number in $t0.
       la $t0,number
       
       #These three lines print a new line.
       addi $a0, $0, 0xA 
       addi $v0, $0, 0xB 
       syscall
      
       #This line loads the value of the variable "number" from address stored in $t0 and the value of $a0.
       lw $a0,0($t0) 
       
       #These two lines print out the binary value of the inputed number.
       li $v0,35 
       syscall
       
       #These three lines print a new line at the end.
       li $v0, 4
       la $a0, newLine
       syscall
      
       #These two lines finish the program.
       li $v0,10
       syscall
