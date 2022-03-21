.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    li t0, 5
    bne a0, t0, mismatched_args

    #s0: store argv address
    #s1: pointer to row int for m0
    #s2: pointer to col int for m0
    #s3: pointer to row int for m1
    #s4: pointer to col int for m1
    #s5: pointer to row int for input
    #s6: pointer to col int for input
    #s7: pointer to m0 matrix
    #s8: pointer to m1 matrix
    #s9: pointer to input matrix
    #s10: pointer to first matmul array d
    #s11: pointer to array of scores

    addi s0, a1, 0    

    addi s1, x0, 0
    addi s2, x0, 0
    
    #lw s3, 4(s0)
    #lw s4, 8(s0)
    #lw s5, 12(s0)
    #lw s6, 16(s0)

    addi s7, x0, 0
    addi s8, x0, 0
    addi s9, x0, 0





	# =====================================
    # LOAD MATRICES
    # =====================================
    

    # Malloc integer pointers
    li a0, 4
    jal ra malloc
    addi s1, a0, 0
    sw x0, 0(s1)
    
    li a0, 4
    jal ra malloc
    addi s2, a0, 0
    sw x0, 0(s2)

    li a0, 4
    jal ra malloc
    addi s3, a0, 0
    sw x0, 0(s3)
    
    li a0, 4
    jal ra malloc
    addi s4, a0, 0
    sw x0, 0(s4)

    li a0, 4
    jal ra malloc
    addi s5, a0, 0
    sw x0, 0(s5)
    
    li a0, 4
    jal ra malloc
    addi s6, a0,  0
    sw x0, 0(s6)


    # Load pretrained m0
    lw a0, 4(s0)
    addi a1, s1, 0
    addi a2, s2, 0

    jal ra read_matrix
    addi s7, a0, 0



    # Load pretrained m1
    lw a0, 8(s0)
    addi a1, s3, 0
    addi a2, s4, 0
  
    jal ra read_matrix
    addi s8, a0, 0


    # Load input matrix
    lw a0, 12(s0)
    addi a1, s5, 0
    addi a2, s6, 0

    jal ra read_matrix
    addi s9, a0, 0





    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    #t0: total number of elements in resulting matrix
    #t1: num of rows of m0
    #t2: num of columns of input
    #t3: total number of bytes for d
    #t4: num of rows in m1
    #t5: num of columns in relu-ed s10
    #t6: total number of elements in resulting scores matrix
    #t6 is also modified again to become total number of bytes for score array


    lw t1, 0(s1)
    lw t2, 0(s6)

    mul t0, t1, t2
    slli t3, t0, 2

    #Malloc d array
    mv a0, t3
    jal ra malloc
    addi s10, a0, 0

    
    #First Matrix Multiplication
    addi a0, s7, 0
    lw a1, 0(s1)
    lw a2, 0(s2)

    addi a3, s9, 0
    lw a4 0(s5)
    lw a5, 0(s6)
    addi a6, s10, 0

    jal ra matmul

    #Relu s10
    lw t1, 0(s1)
    lw t2, 0(s6)

    mul t0, t1, t2

    addi a0, s10, 0
    mv a1, t0

    jal ra relu

    #Malloc for score array
    lw t4, 0(s3)
    lw t5, 0(s6)

    mul t6, t4, t5
    slli t6, t6, 2

    mv a0, t6
    jal ra malloc
    addi s11, a0, 0

    #Second Matrix Multiplication
    addi a0, s8, 0
    lw a1, 0(s3)
    lw a2, 0(s4)

    addi a3, s10, 0
    lw a4, 0(s1)
    lw a5, 0(s6)
    addi a6, s11, 0

    jal ra matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename
    addi a1, s11, 0
    lw a2, 0(s3)
    lw a3, 0(s6)

    jal ra write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t4, 0(s3)
    lw t5, 0(s6)
 
    mul t6, t4, t5

    addi a0, s11, 0
    mv a1, t6

    jal ra argmax

    # Print classification
    mv a1, a0
    jal ra print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit



mismatched_args:
    li a1 3
    jal exit2

