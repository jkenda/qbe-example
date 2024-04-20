.text

.globl _start
_start:
    # get argc, argv
    mov 0(%rsp), %rdi
    lea 8(%rsp), %rsi

    call main

    mov %rax, %rdi
    jmp exit

.macro wscall num
    push %rcx
    push %r11

    mov \num, %rax
    syscall

    pop %r11
    pop %rcx

    ret
.endm


.globl read
.globl write
.globl exit

read:   wscall $READ
write:  wscall $WRITE
exit:   wscall $EXIT

.equ READ , 0
.equ WRITE, 1
# ...
.equ EXIT , 60
# ...
