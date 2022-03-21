.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    addi sp, sp -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)



loop_start:

    beq a0, x0, loop_end
    addi t0, x0, 0
    add s0, a0, x0
    add s1, a1, x0



loop_continue:
    slli t3, t0, 2
    add t4, s0, t3
    lw t5, 0(t4)
    addi a0, t4, 0
    slt t6, x0, t5
    beq t6, x0, default_zero
return:
    addi t0, t0, 1
    beq t0, s1, loop_end
    jal ra, loop_continue
    



    

default_zero:
    sw x0, 0(a0)
    jal x0, return
     
    




loop_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    # Epilogue
    ret
