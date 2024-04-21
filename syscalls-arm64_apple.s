// HEADER

.section __TEXT,__text
.globl _start
_start:
    ldr x0, [sp]
    add x1, sp, #8

    bl _main
    b _exit

.macro def_scall name num
.globl _\name
_\name:
    mov x16, #\num
    svc #0x80

    ret
.endm


// SYSCALL TABLE

def_scall   exit,  1
// ...
def_scall   read,  3
def_scall   write, 4
// ...
