.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    blez a1, error

loop_start:
    lw t0, 0(a0)
    bge t0, zero, skip_store
    sw zero, 0(a0)

skip_store:
    addi a0, a0, 4
    addi a1, a1, -1
    bgtz a1, loop_start
    # Epilogue
    jr ra

error:
    li a0, 36
    j exit
