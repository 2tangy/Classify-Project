.globl read_matrix

.import utils.s
.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:


    
    # Prologue
    addi sp, sp -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)	
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    addi s0, a0, 0
    addi s1, a1, 0
    #lw s1, 0(a1)
    
    addi s2, a2, 0

    ###IMPORTANT###
    #Check for null if a1 and a2 are not actual arrays and if empty array would count as null

    
    #lw s2, 0(a2)

    addi a1, s0, 0
    li a2, 0
    jal ra fopen
    addi s3, a0, 0
    li t2, -1


    #s2 malloc'ed buffer
    #s3 file descriptor
    #s4 total number of bytes to read
    beq a0, t2, eof_or_error

    addi a1, s3, 0
    addi a2, s1, 0
    li a3, 4

    jal ra fread

    bne a3, a0, eof_or_error

    addi a1, s3, 0
    addi a2, s2, 0
    li a3, 4

    jal ra fread

    bne a3, a0, eof_or_error

    lw t1, 0(s1)
    lw t2, 0(s2)

    mul s6, t1, t2
    slli s4, s6, 2

    mv a0, s4
    jal ra malloc
    addi s5, a0, 0

    addi a1, s3, 0
    addi a2, s5, 0
    addi a3, s4, 0
    
    jal ra fread

    bne a3, a0, eof_or_error

    mv a1, s3
    jal ra fclose
    li t2, -1
    beq t2, a0, eof_or_error

    mv a0, s5
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32

    ret

eof_or_error:
    li a1 1
    jal exit2
    
