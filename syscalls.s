.text
exit:
    pushq %rbp
    movq %rsp, %rbp

    mov %rdi, %rdi
    mov $60, %rax

    syscall
    
    leave
    ret

.globl write
write:
    push %rbp
    mov %rsp, %rbp

    mov %rsi, %rdx # arg 2
    mov %rdi, %rsi # arg 1

    mov $1, %rax
    mov $1, %rdi

    syscall

    leave
    ret

.globl _start
_start:
    # TODO: argc, argv
    call main
    mov %rax, %rdi
    call exit
