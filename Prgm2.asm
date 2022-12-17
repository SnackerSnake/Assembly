.data
   number       : .word    0                    #variable to store input
   userInput: .asciiz "Enter a number: "    #string for prompt user to input 
   
.text
   main:
       #syscall $v0=4 to print promptMessage string
       li $v0, 4
       la $a0, userInput #store address of promptMessage in $a0
       syscall
      
       #read user input stored in $v0
       li $v0, 5
       syscall
      
       #load address of number(variable) in $t0
       la $t0, number
       sw $v0,0($t0) #store user input at address stored in $t0
      
       #load address of number(variable) in $t0
       la $t0, number
       lw $s0,0($t0) #load value in $s0
      
       li $t1, 0 #t1=0
       li $s1, 0 #s1=0
       #for multipication add 5 time user input and store in register and print
       loop:#loop label
           beq $t1,5,exit #run a loop till $t1 not equal to 5 if so jump to exit label
          
           add $s1,$s1,$s0 #s1=$s0+$s0
          
           addi $t1,$t1,1 #t1=t1+1
           j loop #jump to loop label
      
          exit:      #exit label
                 addi $a0,$s1,0 #move multiply value in $a0
                 li $v0,1 #syscall 1 to print value
                 syscall
      
           #syscall to terminate program
           li $v0,10
           syscall