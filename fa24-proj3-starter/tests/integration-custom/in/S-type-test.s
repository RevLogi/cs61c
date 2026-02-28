# test_rtype.s

# --- 1. Initialize Registers using addi ---
addi x1, x0, 15      # x1 = 15 (0x0000000F)
addi x2, x0, 10      # x2 = 10 (0x0000000A)
addi x3, x0, -8      # x3 = -8 (0xFFFFFFF8)
addi x4, x0, 2       # x4 = 2  (Used for shift amounts)
addi x5, x0, -1      # x5 = -1 (0xFFFFFFFF) (Used for multiplication)

# --- 2. Arithmetic Instructions ---
add x6, x1, x2       # x6 = 15 + 10 = 25 (0x00000019)
sub x7, x1, x2       # x7 = 15 - 10 = 5  (0x00000005)

# --- 3. Logical Instructions ---
and x8, x1, x2       # x8 = 15 & 10 = 10 (0x0000000A)
or  x9, x1, x2       # x9 = 15 | 10 = 15 (0x0000000F)
xor x10, x1, x2      # x10 = 15 ^ 10 = 5 (0x00000005)

# --- 4. Shift Instructions ---
sll x11, x1, x4      # x11 = 15 << 2 = 60 (0x0000003C)
srl x12, x1, x4      # x12 = 15 >> 2 = 3  (0x00000003)
sra x13, x3, x4      # x13 = -8 >> 2 = -2 (0xFFFFFFFE) - Tests sign-extension!

# --- 5. Set Less Than ---
slt x14, x1, x2      # x14 = (15 < 10) ? 1 : 0 = 0 (0x00000000)
slt x15, x3, x1      # x15 = (-8 < 15) ? 1 : 0 = 1 (0x00000001)

# --- 6. Multiplication Instructions ---
# mul gets the lower 32 bits
mul x16, x5, x4      # x16 = -1 * 2 = -2 (0xFFFFFFFE)

# mulh gets the upper 32 bits (Treats inputs as Signed)
# -1 * 2 = -2. The 64-bit result of -2 is 0xFFFFFFFFFFFFFFFE.
# The upper 32 bits are 0xFFFFFFFF.
mulh x17, x5, x4     # x17 = 0xFFFFFFFF 

# mulhu gets the upper 32 bits (Treats inputs as Unsigned)
# 0xFFFFFFFF * 2 = 0x1FFFFFFFE.
# The upper 32 bits are 0x00000001.
mulhu x18, x5, x4    # x18 = 0x00000001
