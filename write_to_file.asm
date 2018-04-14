%include"file_macro.asm"

section .data
  file_nm db "test.txt",0

  text db "this is my sample text2",0ah
  text_len equ $-text

  text2 db "this is my sample text"
  text2_len equ $-text2

section .text
global _start
_start:
  open file_nm

  write text2, text2_len
  close

  mov rax, 60
  mov rdi, 0
  syscall
