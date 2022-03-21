.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4 mismatched_dimensions

    #d may need mismatched dimensions if it is not big enough to store all values

    # Prologue
    addi sp, sp -48
    sw ra, 0(sp)
    sw s0, 4(sp) #start of the m0
    sw s1, 8(sp) # num of rows in m0
    sw s2, 12(sp) # num of cols in m0
    sw s3, 16(sp) # start of m0
    sw s4, 20(sp) # num of rows in m1
    sw s5, 24(sp) # num of cols in m1
    sw s6, 28(sp) # start of resulting array d
    sw s7, 32(sp) 
    sw s8, 36(sp) #  counter for d
    sw s9, 40(sp) # outer loop counter
    sw s10, 44(sp) # inner loop couunter
    
    add s0, x0, a0
    add s1, x0, a1
    #s2 is row length
    add s2, x0, a2
    add s3, x0, a3
    #s4 is column length
    add s4, x0, a4
    add s5, x0, a5
    add s6, x0, a6
    mul s7, a1, a5

    beq a0, x0, outer_loop_end
    beq a3, x0, outer_loop_end
    beq a6, x0, outer_loop_end

    #Starting outer element offset
    addi t0, x0, 0
    #Starting inner element offset
    addi t1, x0, 0
    
    #Outer loop counter
    addi s9, x0, 0
    #Inner loop counter
    addi s10, x0, 0
    #Counter for d
    addi s8, x0, 0
    


outer_loop_start:
    # registers that put pointer to curr element of row
    slli t4, t0, 2
    add t5, s0, t4
    add t6, s3, x0 # keeps track of address in outer


inner_loop_start:
    # ft registers put current pointer to d-element
    slli t2, s8, 2
    add t3, s6, t2

    addi sp, sp, -52

    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    sw t6, 24(sp)
    sw a1, 28(sp)
    sw a2, 32(sp)
    sw a3, 36(sp)
    sw a4, 40(sp)
    sw a5, 44(sp)
    sw a6, 48(sp)

    mv a0, t5
    mv a1, t6
    mv a2, s2
    li a3, 1
    mv a4, s5

    jal ra dot

    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    lw t6, 24(sp)
    lw a1, 28(sp)
    lw a2, 32(sp)
    lw a3, 36(sp)
    lw a4, 40(sp)
    lw a5, 44(sp)
    lw a6, 48(sp)

    addi sp, sp, 52

    sw a0, 0(t3)
    addi s10, s10, 1
    addi s8, s8, 1
    addi t6, t6, 4
    beq s10, s5, inner_loop_end
    jal ra, inner_loop_start

inner_loop_end:
    li s10, 0
    addi s9, s9, 1
    beq s9, s1, outer_loop_end
    add t0, t0, s2
    jal ra, outer_loop_start



outer_loop_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48


    # Epilogue
    
    
    ret


mismatched_dimensions:
    li a1 2
    jal exit2
