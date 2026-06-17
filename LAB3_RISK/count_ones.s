.data
input_address:   .word  0x80
output_address:  .word  0x84

.text
_start:
    lui      sp, 1
    lui      t0, %hi(input_address)
    addi     t0, t0, %lo(input_address)
    lw       t0, 0(t0)
    lw       a0, 0(t0)
    jal      ra, count_ones
    lui      t0, %hi(output_address)
    addi     t0, t0, %lo(output_address)
    lw       t0, 0(t0)
    sw       a0, 0(t0)
    halt

count_ones:
    addi     sp, sp, -8
    sw       ra, 4(sp)
    sw       s1, 0(sp)
    beqz     a0, base_case
    addi     t0, zero, 1
    and      s1, a0, t0
    srl      a0, a0, t0
    jal      ra, count_ones
    add      a0, a0, s1
    j        epilogue

base_case:
    mv       a0, zero

epilogue:
    lw       ra, 4(sp)
    lw       s1, 0(sp)
    addi     sp, sp, 8
    jr       ra