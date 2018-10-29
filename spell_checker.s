
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



# same as in task 1
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
	
	
	
	# I used an implementation differnt from one I did in c, so no way I can comment using my c code
	#but I will try to use other code that make it intuitive
	check_spell: 
		move $s0, $t8
		la $s1,tokens
        		li $t0, 0
        		li $t1, 0
        		li $t2,0
        		
        		
        		mul $s2, $s0, 20 # tokens_number*maxwordsize =21

        		
     		tkn_loop: #for(i=0;i<tokens_number;i++)

                	add $t2, $t1,$s1
                	add $t2,$t2,$t0
                	 
                	
                	la $a2, dictionary
                	
                	
                	
    			lb $t5, ($t2)
    			slti $t4, $t5, 65
    			bne $t4, $zero, match 
                	
                	
                	
                	dc_loop: #for(j=0;j<=DICTIONARY_SIZE;j++)
                		move $a1, $t2
                		
                		jal strsEqual # call string compare function which return $v0
                		
                		bne $v0, $zero, match #v0=1 if equal and $v0=0 if false
                		
                		nextword: # this loop to next word in dictionary when in the last checking the dictionary word'size was longer than the token
                		lb $t4, ($a2)
                		blez $t4,not_match    #if dictionary[i]=='\0' go to not_match    
        			addi $t5, $0, 10	 
        			addi $a2,$a2,1              # if dictionary[i]=='\n' jump we know the next string is coming so go check for new word
        			beq  $t4, $t5, dc_loop
        			j nextword
        			
        			
        		
        			
        			
        			
        		match: #jumps to this function if $v0=1
        		
        		li $v0, 4
                	move $a0, $t2
               		syscall
        		
        		addi $t0,$t0,1
			mul $t1,$t0, 20

               		slt $t3,$t1, $s2 
    			bne $t3,$zero, tkn_loop #while (i < tokens_number) goto back tkn_loop
    			
    			
    			j exit2
        		
        		
        		not_match: #jumps to this function if $v0=0
        		

        		li $v0, 11
        		
        		li $t7, 95
                	move $a0, $t7
               		syscall	# print _ around a false word
        		
        		li $v0, 4
                	move $a0, $t2
               		syscall # print a world
               		
               		li $v0, 11
               		move $a0, $t7
               		syscall # print _ around a false word
        		
        		addi $t0,$t0,1
			mul $t1,$t0, 20

               		slt $t3,$t1, $s2  
    			bne $t3,$zero, tkn_loop  #while (i < tokens_number) goto back tkn_loop
    			j exit2
        		
        		
                		
                		
                		
                		
                		
                		
                		
                		
                	
                	
                	
                	
                	
			
			
    			
    			
    	# strsEqual function that check if a current word in token is equal to a partiucalar stiring in dictionary starting at particular index up to '\n'	
    	strsEqual:
    	#a2 as dictionary and a1 as current string
    	#a1 as address of first character of token string 
    		li $v0, 1
    	
    		lb $t4, ($a2) # a=dictionary[i]
    		lb $t5, ($a1) # b=token[i][j]
    		addi $t6, $0, 10 #new line
    		
    		 #return (c>='A' && c<='Z') ? (c + 32) : (c);
    		slti $t7, $t5, 65
    		bne $t7, $zero, dontLowerCase
    		
    		slti $t7, $t5, 97
    		beq $t7, $zero, dontLowerCase
    		addiu $t5, $t5,32
    		dontLowerCase:
    		
    		
		
    		
    		
    		beq $t4,$t5, equalChar #if(a==b) goto equalChar
    		
    		beq  $t4, $t6, endword # goto endworld check if it was the next of dictionary string too
    		beq  $t5, $0, endtoken # vice versa 
    		
    		j exit
    		
    		 
    		
    		equalChar: # this increment to the next address of character for both token and dictionary
    			beq $0, $t5, equalLastWord # when it is last word in dictionary where the it ends with '/0' rather than '/n'
    			addi $a2, $a2, 1
    			addi $a1, $a1, 1

    			j strsEqual # go to start of fuction and check if next character are the equal
    		
    		equalLastWord: # this a special case when the word that was equal to the token was the last word
    			jr $ra
    			

        	endtoken:
        		bne  $t4, $t6, exit 
        		jr $ra
        		
        	endword:
        		bne  $t5, $0, exit
        		jr $ra
        		
        	
        	
    			
    		exit: # if no match found return $v0=0
		
    			li $v0, 0
    			jr $ra
    	
    	
    	
   
	
	exit2:	# end of spell checker function
	
	
	
		
    			
        
        
#------------------------------------------------------------------
# Exit, DO NOT MODIFY THIS BLOCK
#------------------------------------------------------------------
main_end:      
        li   $v0, 10          # exit()
        syscall

#----------------------------------------------------------------
# END OF CODE
#----------------------------------------------------------------
