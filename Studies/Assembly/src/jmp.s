.intel_syntax noprefix
.global _start
.text

_start:
  lea r15, [return_print]
  jmp print
  
return_print:
  jmp exit
  
exit:
  mov rax, 60
  xor rdi, rdi
  syscall

print:
  mov rax, 1
  mov rdi, 1
  lea rsi, [message]
  lea rdx, [messagelen]
  syscall
  jmp r15

;# call
;# ret

.data
message: .ascii "Hello!"
messagelen = . - message

question: .ascii "How are you?"
question_len = . - message