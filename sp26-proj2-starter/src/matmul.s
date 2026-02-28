.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    blez a1, error
    blez a2, error
    blez a4, error
    blez a5, error
    bne a2, a4, error

    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    slli s2, s2, 2

    # Used for initialization of inner_loop
    mv s7, a3 # Preserve the address of m1
    mv s8, a5 # Preserve the column number of m1

    j inner_loop_start

outer_loop_start:
    # Initialize m1 and its column for inner_loop
    mv s3, s7
    mv s5, s8

inner_loop_start:
    mv a0, s0
    mv a1, s3
    mv a2, s4
    addi a3, zero, 1 # Stride for m0 is 1
    mv a4, s8

    jal ra, dot

    # Store the result in m2
    sw a0, 0(s6)
    addi s6, s6, 4

    # Re-prepare for the next function calling
    addi s3, s3, 4
    addi s5, s5, -1
    bgtz s5, inner_loop_start

inner_loop_end:
    # Move to the next row
    add s0, s0, s2

    addi s1, s1, -1
    bgtz s1, outer_loop_start

outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40

    jr ra

error:
    li a0, 38
    j exit
