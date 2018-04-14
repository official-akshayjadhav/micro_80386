;
%include "macros.asm"
section .data
menumsg db 10,10,'------MENU for overlapped Block Transfer----',10
        db 10,'1.Block Transfer without using string instructions'
        db 10,'2.Block Transfer with using string instructions'
        db 10,'3.Exit'
        db 10,'Enter your choice: '
menumsg_len equ $-menumsg
wrchmsg db 10,10,'Wrong choice entered .. Please try again !',10,10
wrchmsg_len equ $-wrchmsg
blk_bfrmsg db 10,'Block contents before transfer::'
blk_bfrmsg_len equ $-blk_bfrmsg
blk_afrmsg db 10,'Block contents after transfer::'
blk_afrmsg_len equ $-blk_bfrmsg
position db 10,'Enter position to overlap::'
pos_len equ $-position
srcblk db 01h,02h,03h,04h,05h,00h,00h,00h,00h,00h
cnt equ 05
spacechar db 20h ;20h is ASCII for space
lfmsg db 10,10

section .bss
optionbuff resb 02
dispbuff resw 02
pos resb 1

section .text
global _start
_start:
print blk_bfrmsg,blk_bfrmsg_len
call dispblk_proc
menu: print menumsg,menumsg_len
      read optionbuff,02
      mov al,[optionbuff]
case1:
      cmp al,'1'
      jne case2
      print position,pos_len
      read optionbuff,02
      call packnum_proc
      call blkxferwo_proc
      jmp exit1

case2: cmp al,'2'
      jne case3
      print position,pos_len
      accept optionbuff,02
      call packnum_proc
      call blkxferw_proc
      jmp exit1

case3:
       cmp al,'3'
       je ext
       print wrchmsg,wrchmsg_len
       jmp menu

exit1:
       print blk_afrmsg,blk_afrmsg_len
       call dispblk_proc
       print lfmsg,2

ext: mov rax,60
     mov rbx,0
     syscall

dispblk_proc:
              mov rsi,srcblk
              mov rcx,cnt
              add rcx,[pos]
rdisp:
      push rcx
      mov bl,[rsi]
      push rsi
      call disp8_proc
      pop rsi
      inc rsi
      push rsi
      print spacechar,1
      pop rsi
      pop rcx
      loop rdisp
ret

blkxferwo_proc:
  mov rsi,srcblk+4
  mov rdi,rsi
  add rdi,[pos]
  mov rcx,cnt
blkup1:
  mov al,[rsi]
  mov [rdi],al
  dec rsi
  dec rdi
  loop blkup1
ret
blkxferw_proc:
  mov rsi,srcblk+4
  mov rdi,rsi
  add rdi,[pos]
  mov rcx,cnt
  std
  rep movsb
  ret

disp8_proc:
  mov cl,2
  mov rdi,dispbuff

dup1:
  rol bl,4
  mov dl,bl
  and dl,0fh
  cmp dl,09
  jbe dskip
  add dl,07h

dskip:
  add dl,30h
  mov [rdi],dl
  inc rdi
  loop dup1
  print dispbuff,2
  ret

packnum_proc:
  mov rsi,optionbuff
  mov bl,[rsi]
  cmp bl,39h
  jbe skip1
  sub bl,07h

skip1:
  sub bl,30h
  mov [pos],bl
  ret
