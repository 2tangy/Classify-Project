.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"
m0: .word 1 2 3 4 5 6 7 8 9
m1: 3
m2: 3
.text
main:
    # Read matrix into memory
    read_matrix

    # Print out elements of matrix
    

    # Terminate the program
    addi a0, x0, 10
    ecall