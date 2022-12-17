.data
   number: .word 0 #This variable will store the input.
   userInput: .asciiz "Enter a number: " #string for prompt user to input 
   newLine: .asciiz "\n" #A new line variable
   
.text
   main:
       #These three lines prints the userInput's "Enter a number: "
       li $v0, 4
       la $a0, userInput
       syscall
      
       #These two lines read the user input.
       li $v0, 5
       syscall
      
       #This line stores the user input at address stored in $t0.
       la $t0, number
       sw $v0,0($t0) #I think this part does indeed save the decimal number to data memory.
      
       #This line loads the user input at address stored in $t0. The next line loads the value in $s0.
       la $t0, number
       lw $s0,0($t0)
      
      #Intiliaze the loop variables.
       li $t1, 0 
       li $s1, 0 
       
       #These three lines print a new line at the end.    
       addi $a0, $0, 0xA 
       addi $v0, $0, 0xB 
       syscall
       
       #This loop multiplies the user input by 5 by adding the same number to itself 4 times total.
       loop:
           beq $t1,5,exit 
           add $s1,$s1,$s0
           addi $t1,$t1,1 
           j loop 
          exit:      
                 addi $a0,$s1,0 
                 li $v0, 34 #This line does the hexadecimal conversion.
                 syscall
                 
       #These three lines print a new line at the end.    
       addi $a0, $0, 0xA 
       addi $v0, $0, 0xB 
       syscall
      
       #These lines end the program.
       li $v0,10
       syscall