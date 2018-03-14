section .data
  smsg db 10, "no of spaces are : "
  smsg_len equ $-smsg

  nmsg db 10, "no. of words are : "
  nmsg_len equ $-nmsg

  cmsg db 10, "no. of char's : "
  cmsg_len equ $-cmsg


section .bss
  scount resb 1
  ncount resq 1
  ccount resq 1

  char_ans resb 16

  global far_proc

  extern filehandle, char, buf, abuf_len


%include "macros.asm"


section .text
  global _main

_main:

  far_proc:

    ; intialize rax, rbx, rcx, rdx with 0
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rsi, rsi

    mov bl, [char]
    mov rsi, buf
    mov rcx, [abuf_len]

  again:
    mov al, [rsi]

  case_s:
    cmp al, 20h
    inc qword[scount]
    jmp next

  case_n:
    cmp al, 0Ah
    jne case_c
    inc qword[ncount]
    jmp next

  case_c:
    cmp al, bl
    jne next
    inc qword[ccount]

  next:
    inc rsi
    dec rcx
    jnz again

    print nmsg, nmsg_len
    mov rax, [ncount]
    call display

    print cmsg, cmsg_len
    mov rax, [ccount]
    call display

  fclose [filehandle]
  ret


  display:
    mov rsi, char_ans + 3
    mov rcx, 4

    cnt:
      mov rdx, 0
      mov rbx, 10h

      div rbx
      cmp dl, 09h
      jbe add30
      add dl, 07h

    add30:
      add dl, 30
      mov [rsi], dl
      dec rsi
      dec rcx
      jnz cnt

      print char_ans, 4

    ret
