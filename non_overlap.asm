%include "macro.asm"
section .data
menumsg db 10,10,'----MENU for non--overlapped block Transfer---',10
  db 10,'1:Block Transfer without using string instructions'
  db 10,'2.Block Transfer with using string instructions'
  db 10,'3:Exit'
  db 10,'Enter your choice: '
menumsg_len equ $-menumsg
wrchmsg db 10,10,'Choice entered is invalid !',10,10
wrchmsg_len equ $-wrchmsg
blk_bfrmsg db 10,'Block transfer before transfer: '
blk_bfrmsg_len equ $-blk_bfrmsg
blk_afrmsg db 10,'Block transfer after transfer: '
blk_afrmsg_len equ $-blk_afrmsg
srcblk db 01h,02h,03h,04h,05h,00h,00h,00h,00h
cnt equ 05
spacechar db 20h
lfmsg db 10,10

section .bss
optionbuff resb 02
dispbuff resw 02

section .text
global _start
_start:
  print blk_bfrmsg,blk_bfrmsg_len
  call dispblk_proc

menu:
  print menumsg,menumsg_len
  accept optionbuff,02
  mov al,[optionbuff]
case1:
  cmp al,'1'
  jne case2
  call blkxferwo_proc
  jmp exit1

case2:
  cmp al,'2'
  jne case3
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
 jmp menu

ext:
  mov rax,60
  mov rbx,0
  syscall

; sub routine to displau the block
dispblk_proc:
  mov rsi,srcblk
  mov rcx,cnt
  add rcx,5

rdisp:
  push rcx
  mov bl,[rsi]
  push rsi
  call disp8_proc ; To display hex number
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
  mov rcx,cnt
  add rdi,rcx

blkup1:
  mov al,[rsi]
  mov [rdi],al
  dec rsi
  dec rdi
  loop blkup1
ret

;function to use string instruction
blkxferw_proc:
  mov rsi,srcblk+4
  mov rdi,rsi
  mov rcx,cnt
  add rdi,rcx
  std ;set direction flag for reverse transfer
  rep movsb ;move string bytes
ret

;display procedure
disp8_proc:
  mov cl,2 ;for dup looping
  mov rdi,dispbuff

dup1:
  rol bl,4
  mov dl,bl
  and dl,0fh ;masking upper bits
  cmp dl,09h ;check if greater than 9
  jbe dskip
  add dl,07h

dskip:
  add dl,'0'
  mov [rdi],dl
  inc rdi
  loop dup1

  print dispbuff,2
  ret
