.intel_syntax noprefix
.global _start

.text


_start:

  mov rax, [reg16]
  lea rbx, [reg16]    #; load effective address
  add rbx, 8
  mov rax, [rbx]
  
  lea rsp, [mem]
  
  mov [mem], rax
  
  mov al, 0x43

;# rax = 8 byte register
;# eax = 4 byte register (subset of rax)
;# ax = 2 byte register (subset of eax)
;# ah = 1 byte register (subset of AX) <-
;# al = 1 byte register (subset of AX) ->


.data

  reg16: .quad 0xaaaabbbbccccddee
  reg17: .quad 0xbbbbbbbbbbbbbbbb
  
  mem: .byte 0x1, 0x2, 0x3, 0x4
       .word 0xabcd
  
  ;# Fill the stack memory 1024 bytes of 0xff
  mem2: .skip 1024, 0xff
  
;# 402000: ee
;# 402001: dd
;# 402002: cc
;# 402003: cc
;# 402004: bb
;# 402005: bb
;# 402006: aa
;# 402007: aa
;# 402008: bb
;# 402009: bb
;# 40200a: bb
;# 40200b: bb
;# 40200c: bb
;# 40200d: bb
;# 40200e: bb
;# 40200f: bb


;# 8-bits = 1 byte
;# 16-bits = 2 bytes = WORD
;# 32-bits = 4 bytes = DOUBLE WORD (2 words)
;# 64-bits = 8 bytes = QUAD WORD (4 words)

