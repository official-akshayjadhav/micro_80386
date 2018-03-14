section .data

	msg db 'welcome to assembly :)', 0Ah

section .text
global _start
_start:

	call strlen
	call print
	call exit

	
;calculate str len
strlen:
	mov eax, msg
	mov ebx, eax
	nextchar:
		cmp byte[eax], 0
		jz finish
		inc eax
		jmp nextchar

	finish:
		sub eax, ebx
ret

print:
	mov edx, eax
	mov ecx, msg
	mov ebx, 1
	mov eax, 4
	int 80h
ret

;exit
exit:
	mov ebx, 01
	mov eax, 01
	int 80h
ret