.intel_syntax noprefix
.global _start
.text
_start:

  mov rax, 1 ;# syscall WRITE
  mov rdi, 1 ;# TERMINAL, stdout
  lea rsi, [message]
  lea rdx, [messagelen]
  syscall
  
  mov rax, 60
  xor rdi, rdi
  syscall
  
;# System call code: RAX
;# RDI 
;# RSI 
;# RDX 
;# RCX 
;# R8 
;# R9 

.data
message: .ascii "Te amo, Carolina linda\n"
messagelen = . - message
