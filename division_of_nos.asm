;prog : to use division instructions



section .bss
	num resw 2


section .code
	
global _start
_start:

	;any number
	mov eax, 5ah
	
	;convert this number into equivalent string
	
cont:
	xor edx,edx ;;clearing edx
	
	mov edx, 0ah
	idiv edx
		
	;;remainder will be in edx
	
	;add edx, 30h
	mov [num], edx
	;push rax
	
	mov eax, 4
	mov	ebx, 1
	mov ecx, num
	mov edx, 1
	
	int 80h
	
	cmp eax, 0
	jnz cont

exit:	
	mov eax, 01h
	mov ebx, 0h
	
	int 80h
	
	
