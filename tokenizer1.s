
#=========================================================================
# Tokenizer
#=========================================================================
# Split a string into alphabetic, punctuation and space tokens
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
newline:                .asciiz  "\n"
        
#-------------------------------------------------------------------------
# Global variables in memory
#-------------------------------------------------------------------------
# 
content:                .space 2049     # Maximun size of input_file + NULL
tokens:			.align 2
			.space 4198401


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
        sb   $0,  content($t0)

        li   $v0, 16                    # system call for close file
        move $a0, $s0                   # file descriptor to close
        syscall                         # fclose(input_file)
#------------------------------------------------------------------
# End of reading file block.
#------------------------------------------------------------------

TOKENIZER:
	addi $t0, $zero, 0
	do:
		lb   $t1,content($t0)
    		beqz $t1,exit
    		
    		slti $t2, $t1, 64
    		bne $t2, $zero, next11
    		
    		do1:
    			li $v0, 11
    			move $a0, $t1
    			syscall 
    			
    			addi $t0, $t0,1
    			lb $t1, content($t0)
    			
    			slti $t2, $t1, 64
    			bne $t2, $zero, next1 
    			j do1
		next1:
			li $v0, 4
			la $a0, newline
			syscall
		next11:
		
		#slti $t2, $t1, 64
    		#beq $t2, $zero, next21
		#slti $t2, $t1, 33
    		#bne $t2, $zero, next21 
    		
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
    			li $v0, 11
    			move $a0, $t1
    			syscall 
    			
    			addi $t0, $t0,1
    			lb $t1, content($t0)
    			
    			#slti $t2, $t1, 64
    			#beq $t2, $zero, next2
			#slti $t2, $t1, 33
    			#bne $t2, $zero, next2 
    			
    			addi $t3, $zero, 33
    			beq $t1, $t3, do2 
    		
    			addi $t3, $zero, 44
    			beq $t1, $t3, do2 
    		
    			addi $t3, $zero, 46
    			beq $t1, $t3, do2 
    		
    			addi $t3, $zero, 63
    			beq $t1, $t3, do2 
		next2:
			li $v0, 4
			la $a0, newline
			syscall
		next21:
		
		
		
		addi $t3, $zero, 32
    		bne $t1, $t3, next31 
    		
    		do3:
    			li $v0, 11
    			move $a0, $t1
    			syscall 
    			
    			addi $t0, $t0,1
    			lb $t1, content($t0)
    			
    			addi $t3, $zero, 32
    			bne $t1, $t3, next3 
    			j do3
		next3:
			li $v0, 4
			la $a0, newline
			syscall
		next31:
		
		j do
		
		
	exit:

	
	print_tokens:
			la $t1, content
			li $v0, 11
    			move $a0, $t1
    			syscall 
    			

        
        
#------------------------------------------------------------------
# Exit, DO NOT MODIFY THIS BLOCK
#------------------------------------------------------------------
main_end:      
        li   $v0, 10          # exit()
        syscall

#----------------------------------------------------------------
# END OF CODE
#----------------------------------------------------------------
