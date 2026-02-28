.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    blez a2, error1
    blez a3, error2
    blez a4, error2
    addi, t3, zero, 0
    slli a3, a3, 2
    slli a4, a4, 2

loop_start:
    lw t0, 0(a0)
    lw t1, 0(a1)
    mul t2, t0, t1
    add t3, t3, t2
    add a0, a0, a3
    add a1, a1, a4
    addi a2, a2, -1
    bgtz a2, loop_start

loop_end:
    mv a0, t3
    # Epilogue
    jr ra

error1:
    li a0, 36
    j exit

error2:
    li a0, 37
    j exit
