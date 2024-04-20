.section __TEXT,__text
.globl _start
_start:
    ldr x0, [sp]
    add x1, sp, #8

    bl _main
    b _exit

.macro def_syscall name num
.globl _\name
_\name:
    mov x16, #\num
    svc #0x80

    ret
.endm


def_syscall read,   1
// ...
def_syscall write,  3
def_syscall exit,   4
// ...
