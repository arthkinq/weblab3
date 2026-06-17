.text
    .org 0x100

_start:
    movea.l 0xF00, A7
    movea.l 0x80, A0
    movea.l 0x84, A1
    movea.l 0x800, A3
    move.l  0, D7

entry_read:
    move.l  0, D0
    move.b  (A0), D0
    cmp.b   10, D0
    beq     entry_decode
    add.l   1, D7
    cmp.l   64, D7
    beq     exit_overflow
    move.b  D0, (A3)+
    jmp     entry_read

entry_decode:
    jsr     proc_main
    movea.l 0, A2
entry_print:
    move.l  0, D0
    move.b  (A2)+, D0
    beq     entry_halt
    move.b  D0, (A1)
    jmp     entry_print

entry_halt:
    halt

exit_invalid:
    move.l  -1, (A1)
    halt

exit_overflow:
    move.l  0xCCCCCCCC, (A1)
    halt

proc_main:
    link    A6, -4
    move.l  D7, D0
    and.l   3, D0
    bne     exit_invalid
    move.l  D7, -4(A6)
    movea.l 0x800, A3
    movea.l 0, A2
    move.l  0, D5
proc_loop:
    move.l  -4(A6), D7
    cmp.l   0, D7
    beq     proc_done
    move.l  0, D0
    move.b  (A3)+, D0
    jsr     proc_map
    cmp.l   64, D0
    beq     exit_invalid
    cmp.l   -1, D0
    beq     exit_invalid
    move.l  D0, D1
    move.l  0, D0
    move.b  (A3)+, D0
    jsr     proc_map
    cmp.l   64, D0
    beq     exit_invalid
    cmp.l   -1, D0
    beq     exit_invalid
    move.l  D0, D2
    move.l  0, D0
    move.b  (A3)+, D0
    jsr     proc_map
    cmp.l   -1, D0
    beq     exit_invalid
    move.l  D0, D3
    move.l  0, D0
    move.b  (A3)+, D0
    jsr     proc_map
    cmp.l   -1, D0
    beq     exit_invalid
    move.l  D0, D4
    sub.l   4, D7
    move.l  D7, -4(A6)
    move.l  D1, D0
    lsl.l   2, D0
    move.l  D2, D6
    lsr.l   4, D6
    or.l    D6, D0
    jsr     proc_write
    cmp.l   64, D3
    beq     proc_pad2
    move.l  D2, D0
    and.l   15, D0
    lsl.l   4, D0
    move.l  D3, D6
    lsr.l   2, D6
    or.l    D6, D0
    jsr     proc_write
    cmp.l   64, D4
    beq     proc_pad1
    move.l  D3, D0
    and.l   3, D0
    lsl.l   6, D0
    or.l    D4, D0
    jsr     proc_write
    jmp     proc_loop
proc_pad2:
    cmp.l   64, D4
    bne     exit_invalid
proc_pad1:
proc_done:
    move.l  0, D0
    move.b  D0, (A2)+
    unlk    A6
    rts

proc_write:
    cmp.l   63, D5
    bge     exit_overflow
    move.b  D0, (A2)+
    add.l   1, D5
    rts

proc_map:
    cmp.l   43, D0
    beq     proc_plus
    cmp.l   47, D0
    beq     proc_slash
    cmp.l   61, D0
    beq     proc_padchar
    cmp.l   48, D0
    blt     proc_fail
    cmp.l   57, D0
    ble     proc_num
    cmp.l   65, D0
    blt     proc_fail
    cmp.l   90, D0
    ble     proc_up
    cmp.l   97, D0
    blt     proc_fail
    cmp.l   122, D0
    ble     proc_low
proc_fail:
    move.l  -1, D0
    rts
proc_plus:
    move.l  62, D0
    rts
proc_slash:
    move.l  63, D0
    rts
proc_padchar:
    move.l  64, D0
    rts
proc_num:
    add.l   4, D0
    rts
proc_up:
    sub.l   65, D0
    rts
proc_low:
    sub.l   71, D0
    rts