.data
greet_start:    .byte 0, 'Hello, '
name_buf:       .byte '_______________________'
buf_limit:      .byte '_____'
nl_char:        .word 10
ask_name_str:   .byte 19, 'What is your name?\n'
mask_8bit:      .word 255
port_in:        .word 0x80
port_out:       .word 0x84

    .text

.org 0x88

math_sub:
    inv lit 1 + +
    ;

fetch_input:
    lit name_buf a!
    @p port_in b!
input_iter:
    a lit buf_limit math_sub
    -if err_limit
    @b dup @p nl_char xor
    if input_done
    @ lit 0xffff_ff00 and +
    !+
    input_iter ;
input_done:
    drop
    a lit name_buf xor if err_limit
    @ lit 0xffff_ff00 and lit 33 + !
    a
    lit greet_start a!
    @ + !
    ;

write_pstr:
    @p port_out b!
    @+ @p mask_8bit and
write_iter:
    dup if write_done
    lit -1 +
    @+ @p mask_8bit and
    dup if write_done
    !b
    write_iter ;
write_done:
    drop
    ;

_start:
    lit ask_name_str a!
    write_pstr
    fetch_input
    lit greet_start a!
    write_pstr
    halt

err_limit:
    @p port_out a!
    lit 0xCCCCCCCC !
    halt