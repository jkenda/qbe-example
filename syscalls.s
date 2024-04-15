.equ WRITE, 1
.equ EXIT , 60

.text
.globl _start
_start:
    # TODO: argc, argv
    call main
    mov %rax, %rdi
    jmp exit

.globl write
write:
    push %rcx
    push %r11

    mov $WRITE, %rax
    syscall

    pop %r11
    pop %rcx
    ret

exit:
    mov $EXIT, %rax
    syscall
