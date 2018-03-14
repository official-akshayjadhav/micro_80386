
section .data
	msg db 10, 'count positive and negative numbers in array ',10    ;display msg on screen

msg_len equ $-msg

pmsg db 10, 'count of +ve nos :'
pmsg_len equ $-pmsg

nmsg db 10, 'count of -ve nos : '
nmsg_len equ $-nmsg

newline db 10

array dq 10, 20, -30, -40, 50, 60, 70
arrcnt equ 7

pcnt dq 0
ncnt dq 0

section .bss
	dispbuff resb 2
	%macro print 2
		mov eax, 4
		mov ebx, 1
		mov ecx, %1
		mov edx, %2
	%endmacro

section .text
global _start
_start:
	print msg, msg_len
	mov rsi, array
	mov rcx, arrcnt

	up1:
		;mov rax,[rsi]
		bt rax, 63
		jnc pnxt
		inc byte[ncnt]
		jmp pskip

	pnxt:
		inc byte[pcnt]

	pskip:
		add rsi, 08
		loop up1

	print pmsg, pmsg_len
	mov bl, [pcnt]
	call disp8num

	print nmsg, nmsg_len
	mov bl, [ncnt]
	call disp8num

	print newline,1

	exit:
		mov eax, 01
		mov ebx, 0
		int 80h

	disp8num:
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
	ret
