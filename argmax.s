.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:
    # Prologue
    addi sp, sp -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)


loop_start:
    beq a0, x0, loop_end
    addi t0, x0, 1
    add s0, a0, x0
    add s1, a1, x0
    li a0, 0
    lw s2, 0(s0)
    beq t0, s1, loop_end  

loop_continue:
    slli t1, t0, 2
    add t3, s0, t1
    lw t5, 0(t3)
    #slt t4, t5, s2
    #beq t4, x0, index_set
    
    addi sp,sp -24
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw t5, 20(sp)
    blt s2, t5, index_set 

return:
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)
    addi sp, sp, 24 
    addi t0, t0, 1
    beq t0, s1, loop_end
    jal ra, loop_continue

index_set:
    add a0, t0, x0
    slli t2, t0, 2
    add t3, s0, t2
    lw s2, 0(t3)
    jal x0, return 

loop_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    # Epilogue
    ret
