.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    blez a1, error
    addi t2, a1, -1
    lw t0, 0(a0)
    addi a0, a0, 4
    addi a1, a1, -1
    sub t3, t2, a1
    blez a1, loop_end

loop_start:
    lw t1, 0(a0)
    addi a0, a0, 4
    addi a1, a1, -1
    bge t0, t1, skip_refresh
    mv t0, t1
    sub t3, t2, a1

skip_refresh:
    bgtz a1, loop_start

loop_end:
    # Epilogue
    mv a0, t3
    jr ra

error:
    li a0, 36
    j exit
