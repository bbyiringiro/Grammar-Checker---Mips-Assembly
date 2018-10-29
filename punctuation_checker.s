
#=========================================================================
# Spell checker 
#=========================================================================
# Marks misspelled words in a sentence according to a dictionary
# 
# Inf2C Computer Systems
# 
# Siavash Katebzadeh
# 8 Oct 2018
# 
#
#=========================================================================
# DATA SEGMENT
#=========================================================================
.data
#-------------------------------------------------------------------------
# Constant strings
#-------------------------------------------------------------------------

input_file_name:        .asciiz  "input.txt"
dictionary_file_name:   .asciiz  "dictionary.txt"
newline:                .asciiz  "\n"
        
#-------------------------------------------------------------------------
# Global variables in memory
#-------------------------------------------------------------------------
# 

ellipsis: .space 4
content:                .space 2049     # Maximun size of input_file + NULL
.align 4                                # The next field will be aligned
dictionary:             .space 200001   # Maximum number of words in dictionary *
.align 4
tokens:			.space 4198401
 

# You can add your data here!
        
#=========================================================================
# TEXT SEGMENT  
#=========================================================================
.text

#-------------------------------------------------------------------------
# MAIN code block
#-------------------------------------------------------------------------

.globl main                     # Declare main label to be globally visible.
                                # Needed for correct operation with MARS
main:
#-------------------------------------------------------------------------
# Reading file block. DO NOT MODIFY THIS BLOCK
#-------------------------------------------------------------------------

# opening file for reading

        li   $v0, 13                    # system call for open file
        la   $a0, input_file_name       # input file name
        li   $a1, 0                     # flag for reading
        li   $a2, 0                     # mode is ignored
        syscall                         # open a file
        
        move $s0, $v0                   # save the file descriptor 

        # reading from file just opened

        move $t0, $0                    # idx = 0

READ_LOOP:                              # do {
        li   $v0, 14                    # system call for reading from file
        move $a0, $s0                   # file descriptor
                                        # content[idx] = c_input
        la   $a1, content($t0)          # address of buffer from which to read
        li   $a2,  1                    # read 1 char
        syscall                         # c_input = fgetc(input_file);
        blez $v0, END_LOOP              # if(feof(input_file)) { break }
        lb   $t1, content($t0)          
        addi $v0, $0, 10                # newline \n
        beq  $t1, $v0, END_LOOP         # if(c_input == '\n')
        addi $t0, $t0, 1                # idx += 1
        j    READ_LOOP
END_LOOP:
        sb   $0,  content($t0)          # content[idx] = '\0'

        # Close the file 

        li   $v0, 16                    # system call for close file
        move $a0, $s0                   # file descriptor to close
        syscall                         # fclose(input_file)


        # opening file for reading

        li   $v0, 13                    # system call for open file
        la   $a0, dictionary_file_name  # input file name
        li   $a1, 0                     # flag for reading
        li   $a2, 0                     # mode is ignored
        syscall                         # fopen(dictionary_file, "r")
        
        move $s0, $v0                   # save the file descriptor 

        # reading from file just opened

        move $t0, $0                    # idx = 0

READ_LOOP2:                             # do {
        li   $v0, 14                    # system call for reading from file
        move $a0, $s0                   # file descriptor
                                        # dictionary[idx] = c_input
        la   $a1, dictionary($t0)       # address of buffer from which to read
        li   $a2,  1                    # read 1 char
        syscall                         # c_input = fgetc(dictionary_file);
        blez $v0, END_LOOP2             # if(feof(dictionary_file)) { break }
        lb   $t1, dictionary($t0)               
        lb   $t1, dictionary($t0)               
        beq  $t1, $0,  END_LOOP2        # if(c_input == '\n')
        addi $t0, $t0, 1                # idx += 1
        j    READ_LOOP2
END_LOOP2:
        sb   $0,  dictionary($t0)       # dictionary[idx] = '\0'

        # Close the file 

        li   $v0, 16                    # system call for close file
        move $a0, $s0                   # file descriptor to close
        syscall                         # fclose(dictionary_file)
#------------------------------------------------------------------
# End of reading file block.
#------------------------------------------------------------------

#loods ellipsis into memory for easy comparison as I already have string comparizon function
LoadEllipsis:
	la $t0, ellipsis
	addi $t1, $zero, 46 #ascci 46 for .
	sb $t1, 0($t0)
	sb $t1, 1($t0)
	sb $t1, 2($t0)
	sb $0, 3($t0)
	
    		
	


#same as in task 1
TOKENIZER:
	
	la $t5,tokens
	li $t4, 0
	li $t8,0
	li $s0, 21
	

	addi $t0, $zero, 0
	do:
		
		
		lb   $t1,content($t0)
    		beqz $t1,exit0
    		
    		slti $t2, $t1, 64
    		bne $t2, $zero, next11
    		li $t4, 0
    		
    		do1:
    			sb $t1, ($t5)
    			addi $t5, $t5,1
    			 
    			
    			addi $t0, $t0,1
    			lb $t1, content($t0)
    			
    			addi $t4, $t4,1
    			
    			slti $t2, $t1, 64
    			bne $t2, $zero, next1 
    			j do1
		next1:
		
			sb $0, ($t5)
			subu $t4,$s0, $t4
    			add $t5, $t5,$t4
    			addi $t8, $t8,1 #increment tokens number
    		next11:
		
    		li $t4, 0
    		addi $t3, $zero, 33
    		beq $t1, $t3, do2 
    		
    		addi $t3, $zero, 44
    		beq $t1, $t3, do2 
    		
    		addi $t3, $zero, 46
    		beq $t1, $t3, do2 
    		
    		addi $t3, $zero, 63
    		beq $t1, $t3, do2 
    		
    		j next21
    		
    		do2:
    			sb $t1, ($t5)
    			addi $t5, $t5,1
    			
    			addi $t0, $t0,1
    			lb $t1, content($t0)
    			
    			addi $t4, $t4,1
    			
    			
    			addi $t3, $zero, 33
    			beq $t1, $t3, do2 
    		
    			addi $t3, $zero, 44
    			beq $t1, $t3, do2 
    		
    			addi $t3, $zero, 46
    			beq $t1, $t3, do2 
    		
    			addi $t3, $zero, 63
    			beq $t1, $t3, do2 
		next2:
			sb $0, ($t5)
    			subu $t4,$s0, $t4
    			add $t5, $t5,$t4
    			addi $t8, $t8,1
    		next21:
		
		
		
		li $t4, 0
		addi $t3, $zero, 32
    		bne $t1, $t3, next31
    		
    		do3:
    			sb $t1, ($t5)
    			addi $t5, $t5,1
    			
    			addi $t4, $t4,1
    			
    			addi $t0, $t0,1
    			lb $t1, content($t0)
    			
    			addi $t3, $zero, 32
    			bne $t1, $t3, next3 
    			j do3
		next3:
			sb $0, ($t5)
    			subu $t4,$s0, $t4
    			add $t5, $t5,$t4
    			addi $t8, $t8,1
    		next31:
		
		j do
		
		
		
	exit0:
	
	
	
	# it is same as in spell checker where it is different, I have added comments
	check_puctionation:
		move $s0, $t8
		la $s1,tokens
        		li $t0, 0
        		li $t1, 0
        		li $t2,0
        		
        		#li $s2, 2048
        		mul $s2, $s0, 20 # tokens_number*maxwordsize =21

        		
     		tkn_loop:

                	add $t2, $t1,$s1
                	add $t2,$t2,$t0
                	 
                	
                	la $a2, dictionary
                	
                	
                	
                	
                	
    			lb $t5, ($t2)
    			
    			#check if a character is among puctuations then jump to checkPunct otherwise it checks spell
    			addi $t4, $zero, 32
    			beq $t4, $t5, match
    			slti $t4, $t5, 65
    			bne $t4, $zero, checkPuct # goto checkPuct if current_char === '.'|'?'|'!'
                	
                	
                	#check spelling
                	dc_loop:
                		move $a1, $t2
                		
                		jal strsEqual
                		
                		bne $v0, $zero, match #v0=1 if equal
                		
                		nextword:
                		lb $t4, ($a2)
                		blez $t4,not_match        
        			addi $t5, $0, 10
        			addi $a2,$a2,1                # equal to newline \n
        			beq  $t4, $t5, dc_loop
        			j nextword
        			
        			
        			
        			
        		match:
        		
        		li $v0, 4
                	move $a0, $t2
               		syscall
        		
        		addi $t0,$t0,1
			mul $t1,$t0, 20

               		slt $t3,$t1, $s2 
    			bne $t3,$zero, tkn_loop
    			
    			
    			j exit2
        		
        		
        		not_match:
        		

        		li $v0, 11
        		
        		li $t7, 95
                	move $a0, $t7
               		syscall
        		
        		li $v0, 4
                	move $a0, $t2
               		syscall
               		
               		li $v0, 11
               		move $a0, $t7
               		syscall
        		
        		addi $t0,$t0,1
			mul $t1,$t0, 20

               		slt $t3,$t1, $s2 
    			bne $t3,$zero, tkn_loop
    			j exit2
        		
        		
        		checkPuct:
        			subi $t4, $t2,21 # tokens[i][j-1]
        			lb $t4, ($t4)
        			addi $t5, $zero, 32 # temp=' '
        			beq $t4, $t5, not_match # if tokens[i][j-1]==temp goto not_match
        			
        			#else if
        			addi $t4, $t2,21 # tokens[i][j-1]
        			lb $t4, ($t4)
        			slti $t4,$t4, 65 
        			beq $zero, $t4, not_match # if tokens[i][j+1]==any alphabet goto not_match
        			
        			la $a2, ellipsis # lood an ellipsis address
        			move $a1, $t2 
        			jal strsEqual # call strsEqual fuction to compare if it is equal to tokens[i][j+1]
        			bne $zero, $v0, match # if yes go to match
        			
        			addi $t4, $t2,1 #check if punction is only one and has no more than one puctions
        			lb $t4, ($t4) 
        			bne $zero, $t4, not_match #go to not_match has more
        			
        			#default go match 
        			j match
        			
        			
        		
                		
                		
                		
                		
                		
                		
                		
                		
                	
                	
                	
                	
                	
			
			
    			
    			
    			
    	strsEqual:
    	#a2 as dictionary and a1 as current string
    		li $v0, 1
    	
    		lb $t4, ($a2)
    		lb $t5, ($a1)
    		addi $t6, $0, 10 #new line
    		
    		
    		slti $t7, $t5, 65
    		bne $t7, $zero, dontLowerCase
    		
    		slti $t7, $t5, 97
    		beq $t7, $zero, dontLowerCase
    		addiu $t5, $t5,32
    		dontLowerCase:
    		
    		
		
    		
    	
    		beq $t4,$t5, equalChar
    		
    		beq  $t4, $t6, endword
    		beq  $t5, $0, endtoken
    		
    		j exit
    		
    		 
    		
    		equalChar:
    			beq $0, $t5, equalLastWord
    			addi $a2, $a2, 1
    			addi $a1, $a1, 1

    			j strsEqual
    		
    		equalLastWord:
    			jr $ra
    			
    		

        	endtoken:
        		bne  $t4, $t6, exit
        		jr $ra
        		
        	endword:
        		bne  $t5, $0, exit
        		jr $ra
        		
        	
        	
    			
    		exit: 
		
    			li $v0, 0
    			jr $ra
	
	exit2:	
	
	
	
        
        
#------------------------------------------------------------------
# Exit, DO NOT MODIFY THIS BLOCK
#------------------------------------------------------------------
main_end:      
        li   $v0, 10          # exit()
        syscall

#----------------------------------------------------------------
# END OF CODE
#----------------------------------------------------------------
