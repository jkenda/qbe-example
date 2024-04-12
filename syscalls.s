.equ SYS_write, 1
.equ SYS_exit , 60

.text
exit:
    pushq %rbp
    movq %rsp, %rbp

    mov $SYS_exit, %rax

    syscall
    
    leave
    ret

.globl write
write:
    push %rbp
    mov %rsp, %rbp

    mov $SYS_write, %rax

    syscall

    leave
    ret

.globl _start
_start:
    # TODO: argc, argv
    call main
    mov %rax, %rdi
    call exit
