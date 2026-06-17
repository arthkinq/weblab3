.data
    lw:  .word 0
    hw:  .word 0
    tmp: .word 0
    one: .word 1

.text
_start:
    load_imm 0
    store lw
    store hw

loop:
    load_addr 0x80
    beqz done

    store tmp

    load lw
    add tmp
    store lw

    bcs add_carry

check_negative:
    load tmp
    ble is_negative
    jmp loop

add_carry:
    load hw
    add one
    store hw
    jmp check_negative

is_negative:
    load hw
    sub one
    store hw
    jmp loop

done:
    load hw
    store_addr 0x84
    load lw
    store_addr 0x84
    halt