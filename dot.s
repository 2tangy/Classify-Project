.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

    addi sp, sp -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)

    add s0, x0, a0
    add s1, x0, a1
    add s2, x0, a2
    add s3, x0, a3
    add s4, x0, a4
    #s5: dot product total
    li s5, 0
    addi s6, x0, 0
    addi s7, x0, 0
    slli s8, s2, 2
    addi s9, x0, 0


    addi t0, x0, 0
    beq a0, x0, loop_end

loop_start:
    #mul s9, s3, 4
    slli s9, s3, 2
    #mul s6, s4, 4
    slli s6, s4, 2

    mul t1, t0, s9
    mul t2, t0, s6

    #bge t1, s8, loop_end
    #bge t2, s8, loop_end



    add t3, s0, t1
    add t4, s1, t2

    lw t5, 0(t3)
    lw t6, 0(t4)

    mul s7, t5, t6
    add s5, s7, s5

    addi t0, t0, 1
    beq t0, s2, loop_end
    
    jal ra, loop_start



loop_end:
    mv a0, s5
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
    addi sp, sp, 44    
    ret