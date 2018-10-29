
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
tokens_number: .word
.align 4
tokens:			.space 4198401 #char tokens[MAX_INPUT_SIZE + 1][MAX_INPUT_SIZE + 1]

 



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
#this basically the same implementation as in c codes 
TOKENIZER:
	
	la $t5,tokens	#loads $t5= tokens[size][size]
	li $t8,0	#tokens_number=0
	li $s0, 21	# maxwordsize= 21
	

	addi $t0, $zero, 0 # char_index from content
	do:			#do {
		
		
		lb   $t1,content($t0)	#content[char_index]
    		beqz $t1,exit		#if(c == '\0'){break;}
    		
    		slti $t2, $t1, 64	# if((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
    		bne $t2, $zero, next11	#else goto next11 or
    		li $t4, 0		#token_c_idx=0
    		
    		do1:			#do {
    			sb $t1, ($t5)	#tokens[tokens_number][token_c_idx] = c;
    			addi $t5, $t5,1 #allocate space for the upcoming character
    			 
    			
    			addi $t0, $t0,1	#c_idx += 1;
    			lb $t1, content($t0) # c = content[c_idx];
    			
    			addi $t4, $t4,1 # token_c_idx += 1;
    			
    			slti $t2, $t1, 64 #while((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'));
    			bne $t2, $zero, next1 
    			j do1
		next1:
		
			sb $0, ($t5)
			subu $t4,$s0, $t4 # $t4=21-token_c_idx to calculate start of next element in array
    			add $t5, $t5,$t4  # tokens[i+1][]
    			addi $t8, $t8,1 #tokens_number++
    		next11:
		
    		li $t4, 0	#token_c_idx=0
    		# if((c == ',') || (c == '.') || (c == '!') || (c == '?')) {
    		addi $t3, $zero, 33 
    		beq $t1, $t3, do2 
    		
    		addi $t3, $zero, 44
    		beq $t1, $t3, do2 
    		
    		addi $t3, $zero, 46
    		beq $t1, $t3, do2  
    		
    		addi $t3, $zero, 63
    		beq $t1, $t3, do2 
    		
    		j next21
    		
    		do2:			#do {
    			sb $t1, ($t5)	#tokens[tokens_number][token_c_idx] = c;
    			addi $t5, $t5,1	#allocate space for the upcoming character
    			
    			addi $t0, $t0,1	#c_idx += 1;
    			lb $t1, content($t0) # c = content[c_idx];
    			
    			addi $t4, $t4,1 # token_c_idx += 1;
    			
    			
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
			subu $t4,$s0, $t4 # $t4=21-token_c_idx to calculate start of next element in array
    			add $t5, $t5,$t4  # tokens[i+1][]
    			addi $t8, $t8,1 #tokens_number++
    		next21:
		
		
		
		li $t4, 0	##token_c_idx=0
		addi $t3, $zero, 32
    		bne $t1, $t3, next31
    		
    		do3:			#do {
    			sb $t1, ($t5)	#tokens[tokens_number][token_c_idx] = c;
    			addi $t5, $t5,1	#allocate space for the upcoming character
    			
    			addi $t0, $t0,1	#c_idx += 1;
    			lb $t1, content($t0) # c = content[c_idx];
    			
    			addi $t4, $t4,1 # token_c_idx += 1;
    			
    			addi $t3, $zero, 32
    			bne $t1, $t3, next3 
    			j do3
		next3:
			sb $0, ($t5)
			subu $t4,$s0, $t4 # $t4=21-token_c_idx to calculate start of next element in array
    			add $t5, $t5,$t4  # tokens[i+1][]
    			addi $t8, $t8,1 #tokens_number++
    		next31:
		
		j do
		
		sw $t8, tokens_number
		move $s2, $t8
	exit:

	
	print_tokens:		#output tokens
	# this prints my logical array of strings
		
    			la $s1,tokens
        		li $t0, 0
        		li $t1, 0
        		li $t2,0
        		
        		mul $t8, $t8, 20 # tokens_number*maxwordsize =20 
        		
     		loop: #do

                	add $t2, $t1,$s1  #$t2=current_address+rowindex
                	add $t2,$t2,$t0 
                	 
                	
                	
                	li $v0, 4
                	move $a0, $t2
               		syscall	#output(tokens[i])
               		
               		li $v0, 4
			la $a0, newline
			syscall	#output("\n");
			
			addi $t0,$t0,1 #incrementing rowsize
			
			mul $t1,$t0, 20 #rowindex * size of maxwordsize

               		slt $t3,$t1, $t8 
    			bne $t3,$zero, loop # while (i < tokens_number) goto loop
    			
  			
				
	
	
	

        
        
#------------------------------------------------------------------
# Exit, DO NOT MODIFY THIS BLOCK
#------------------------------------------------------------------
main_end:      
        li   $v0, 10          # exit()
        syscall

#----------------------------------------------------------------
# END OF CODE
#----------------------------------------------------------------
