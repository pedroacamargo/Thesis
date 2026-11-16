.intel_syntax noprefix
.global _start
.text
_start:

mov rax, 5
mov rbx, rax
add rcx, 0x1234

;# Similar as *pointer
;# Get the value of this line and write to rdx
mov rdx, [0x00401000]

mov r15, 1