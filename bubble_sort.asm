%include "macros.asm"

section .data
  arr db 9h, 8h, 7h, 6h, 5h, 4h, 3h, 2h, 1h
  arr_cnt equ $-arr

  flg db 10,"OK"
  nl db 10

section .bss
  dispbuff resb 2

section .text
global _start
_start:

  mov esi, arr
  mov rcx, arr_cnt

  outer_loop:
    mov edi, arr
    push rcx
    mov rcx, arr_cnt

    inner_loop:
      mov al, [esi]
      mov bl, [edi]

      cmp al, bl
      jbe _skip

      swap:
        ;mov [esi], bl
        ;mov [edi], al

      _skip:
        inc byte[edi]
        dec rcx
        jnz inner_loop


      pop rcx
      inc byte[esi]
      dec rcx
      jnz outer_loop


    mov esi, arr
    mov rcx, arr_cnt

    display_array:
      print nl,1
      mov bl, [esi]
      push rcx

    disp_num:
  		mov rcx, 2
  		mov rdi, dispbuff

  		dup1:
  			rol bl, 4
  			mov al, bl
  			and al, 0fh
  			cmp al, 09h
  			jbe dskip
  			add al, 07h

  		dskip:
  			add al, 30h
  			mov [edi], al
  			inc rdi
  			loop dup1

  		print dispbuff, 2

      pop rcx
      inc byte[esi]
      dec rcx
      jnz display_array

      print flg, 3
    _exit:
      exit
