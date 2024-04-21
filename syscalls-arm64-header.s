// HEADER

.text
.globl _start
_start:
    ldr x0, [sp]
    add x1, sp, #8

    bl  main_proc
    b   exit_proc

.macro def_scall name num
.globl \name
\name:
    mov x16, #\num
    svc #scall_int

    ret
.endm

