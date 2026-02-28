.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12 (sp)
    sw s4, 16 (sp)
    sw s5, 20 (sp)
    sw s6, 24 (sp)
    sw ra, 28 (sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Open the file
    addi a1, zero, 0
    jal ra, fopen
    mv s3, a0 # Save the file descriptor
    addi a0, a0, 1
    beqz a0, error2

    # Read row number
    mv a0, s3
    mv a1, s1
    addi a2, zero, 4
    jal ra, fread
    lw s4, 0(s1) # Store the row number
    addi t0, zero, 4
    bne t0, a0, error4

    # Read column number
    mv a0, s3
    mv a1, s2
    addi a2, zero, 4
    jal ra, fread
    lw s5, 0(s2) # Store the column number
    addi t0, zero, 4
    bne t0, a0, error4

    # Malloc the memory
    mul a0, s4, s5
    slli a0, a0, 2
    jal ra, malloc
    beqz a0, error1
    mv s6, a0

    # Read the matrix
    mv a0, s3
    mv a1, s6
    mul a2, s4, s5
    slli a2, a2, 2
    jal ra, fread
    mul t0, s4, s5
    slli t0, t0, 2
    bne t0, a0, error4

    # Close the file
    mv a0, s3
    jal ra, fclose
    bnez a0, error3

    mv a0, s6

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12 (sp)
    lw s4, 16 (sp)
    lw s5, 20 (sp)
    lw s6, 24 (sp)
    lw ra, 28 (sp)
    addi sp, sp, 32

    jr ra

error1:
    li a0, 26
    j exit

error2:
    li a0, 27
    j exit

error3:
    li a0, 28
    j exit

error4:
    li a0, 29
    j exit

