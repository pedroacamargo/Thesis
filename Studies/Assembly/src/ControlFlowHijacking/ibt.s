.intel_syntax noprefix
.global _start

.section .text

_start:

    # Get the address of target
    lea rax, [rip + target]

    # Uncomment this line to skip ENDBR64
    # add rax, 4

    # Indirect function call
    call rax

    # Exit with the function's return value
    mov edi, eax
    mov eax, 60
    syscall


target:
    endbr64
    mov eax, 42
    ret
