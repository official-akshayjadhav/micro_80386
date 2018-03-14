
extern far_proc

global filehandle, char, buf, abuf_len

%include "macros.asm"

section .data
  filemsg db 10,"Enter file name for string operations :"
  filemsg_len equ $-filemsg

  charmsg db 10,"Enter charachter to search : "
  charmsg_len equ $-charmsg

  errmsg db 10,"Error while opening file ..."
  errmsg_len equ $-errmsg

  exitmsg db 10,10,"Exit from program ",10
  exitmsg_len equ $-exitmsg


section .bss
  buf resb 4096
  buf_len equ $-buf

  filename resb 50
  char resb 2
  filehandle resq 1
  abuf_len resq 1


section .text
  global _start
  _start:
    print filemsg, filemsg_len
    read filename, 50
    dec rax
    mov byte[filename + rax], 0

    print charmsg, charmsg_len
    read char, 2

    fopen filename
    cmp rax, -1h
    jle Error
    mov [filehandle], rax

    fread [filehandle], buf, buf_len
    mov [abuf_len], rax

   call far_proc

   jmp Exit

   Error: print errmsg, errmsg_len
   Exit : print exitmsg, exitmsg_len

   exit
