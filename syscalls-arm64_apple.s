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
    svc #0x80

    ret
.endm

.globl _read
.globl _write
.globl _exit

_read:  wscall #READ
_write: wscall #WRITE
_exit:  wscall #EXIT

.equ EXIT,  1
.equ READ,  3
.equ WRITE, 4
