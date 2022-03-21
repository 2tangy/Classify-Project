.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

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
    addi s2, a2, 0
    addi s3, a3, 0

    addi a1, s0, 0
    li a2, 1
    jal ra fopen
    addi s4, a0, 0
    li t0, -1

    #s0: pointer to filename
    #s1: pointer to matrix
    #s2: number of rows
    #s3: number of columns
    #s4: file descriptor
    #s5: pointer to row int
    #s6: pointer to col int

    beq s4, t0, eof_or_error

    li a0, 4
    jal ra malloc
    addi s5, a0, 0
    sw s2, 0(s5)

    li a0, 4
    jal ra malloc
    addi s6, a0, 0
    sw s3, 0(s6)

    mv a1, s4
    mv a2, s5
    li a3, 1
    li a4, 4

    jal ra fwrite

    bne a3, a0, eof_or_error

    mv a1, s4
    mv a2, s6
    li a3, 1
    li a4, 4

    jal ra fwrite

    bne a3, a0, eof_or_error

    mv a1, s4
    mv a2, s1
    
    mul t1, s2, s3
    mv a3, t1
    li a4, 4

    jal ra fwrite

    bne a3, a0, eof_or_error

    mv a1, s4
    jal ra fclose
    li t2, -1
    beq t2, a0, eof_or_error


    mv a0, s0
    mv a1, s1




    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp 32

    ret

eof_or_error:
    li a1 1
    jal exit2
    
