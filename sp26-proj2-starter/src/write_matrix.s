.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # Store rows and columns in memory for fwrite to call
    addi sp, sp, -8
    sw a2, 0(sp)
    sw a3, 4(sp)

    # Open the file with write permission
    addi a1, zero, 1
    jal ra, fopen
    addi t0, zero, -1
    beq a0, t0, error1
    mv s4, a0 # Save the file descriptor

    # Write the number of rows
    # Now a0 is file descriptor
    mv a1, sp
    addi a2, zero, 1
    addi a3, zero, 4
    jal ra, fwrite
    addi t0, zero, 1
    bne t0, a0, error2

    addi sp, sp, 4

    # Write the number of columns
    mv a0, s4
    mv a1, sp
    addi a2, zero, 1
    addi a3, zero, 4
    jal ra, fwrite
    addi t0, zero, 1
    bne t0, a0, error2

    addi sp, sp, 4

    # Write the matrix
    mv a0, s4
    mv a1, s1
    mul a2, s2, s3
    addi a3, zero, 4
    jal ra, fwrite
    mul t0, s2, s3
    bne t0, a0, error2

    # Close the file
    mv a0, s4
    jal ra, fclose
    bnez a0, error3

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    jr ra

error1:
    li a0, 27
    j exit

error2:
    li a0, 30
    j exit

error3:
    li a0, 28
    j exit
