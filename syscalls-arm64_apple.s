.section __TEXT,__text
.globl _start
_start:
    ldr x0, [sp]
    add x1, sp, #8

    bl _main

    mov x0, x0
    b _exit

.macro wscall num
    mov x16, \num
    svc 0

    ret
.endm

.globl _read
.globl _write
.globl _exit

_read:
    wscall =READ
_write:
    wscall =WRITE
_exit:
    wscall =EXIT

.equ READ,  63
.equ WRITE, 64
.equ EXIT,  93
