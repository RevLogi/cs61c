.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi t0, zero, 5
    bne t0, a0, error2

    # PROLOGUE
    # h matrix and o matrix is stored in 48(sp) and 52(sp)
    addi sp, sp, -56
    sw s0, 0(sp)
    sw s1, 4(sp)

    # Prepare for saving the numbers of columns and rows
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)

    # Reserve space for m0, m1 and input
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw ra, 44(sp)

    mv s0, a1
    mv s1, a2

    # Read pretrained m0
    addi sp, sp, -8
    lw a0, 4(s0)
    mv a1, sp
    addi a2, sp, 4
    jal ra, read_matrix
    lw s2, 0(sp)
    lw s3, 4(sp)
    addi sp, sp, 8

    mv s8, a0

    # Read pretrained m1
    addi sp, sp, -8
    lw a0, 8(s0)
    mv a1, sp
    addi a2, sp, 4
    jal ra, read_matrix
    lw s4, 0(sp)
    lw s5, 4(sp)
    addi sp, sp, 8

    mv s9, a0

    # Read input matrix
    addi sp, sp, -8
    lw a0, 12(s0)
    mv a1, sp
    addi a2, sp, 4
    jal ra, read_matrix
    lw s6, 0(sp)
    lw s7, 4(sp)
    addi sp, sp, 8

    mv s10, a0

    # Compute h = matmul(m0, input)
    mul t0, s2, s7
    slli t0, t0, 2
    mv a0, t0
    jal ra, malloc
    beqz a0, error1

    sw a0, 48(sp)

    # m0 matrix
    mv a0, s8
    mv a1, s2
    mv a2, s3
    # input matrix
    mv a3, s10
    mv a4, s6
    mv a5, s7
    # Store h matrix
    lw a6, 48(sp)
    jal ra, matmul

    # Compute h = relu(h)
    lw a0, 48(sp)
    mul a1, s2, s7
    jal ra, relu

    # Compute o = matmul(m1, h)
    mul t0, s4, s7
    slli t0, t0, 2
    mv a0, t0
    jal ra, malloc
    beqz a0, error1

    sw a0, 52(sp)

    # m1 matrix
    mv a0, s9
    mv a1, s4
    mv a2, s5
    # h matrix
    lw a3, 48(sp)
    mv a4, s2
    mv a5, s7
    # Store o matrix
    lw a6, 52(sp)
    jal ra, matmul

    # Write output matrix o
    lw a0, 16(s0)
    lw a1, 52(sp)
    mv a2, s4
    mv a3, s7
    jal ra, write_matrix

    # Compute and return argmax(o)
    lw a0, 52(sp)
    mul a1, s4, s7
    jal ra, argmax
    mv s0, a0

    # If enabled, print argmax(o) and newline
    bnez s1, skip_print
    jal ra, print_int
    li a0 '\n'
    jal ra, print_char

skip_print:
    # Free the allocated memory
    lw a0, 48(sp)
    jal ra, free
    lw a0, 52(sp)
    jal ra, free
    mv a0, s8
    jal ra, free
    mv a0, s9
    jal ra, free
    mv a0, s10
    jal ra, free

    mv a0, s0

    # EPILOGUE
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw ra, 44(sp)
    addi sp, sp, 56

    jr ra

error1:
    li a0, 26
    j exit

error2:
    li a0, 31
    j exit
