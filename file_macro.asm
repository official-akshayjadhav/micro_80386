%macro open 1
  mov rax, 2       ; ID to open a file
  mov rdi, %1      ; file name passes as a parameter
  mov rsi, 2       ; flag
  mov rdx, 0664o   ; file permissions mode

  syscall

  push rax

%endmacro

%macro close 0
  mov rax, 3
  pop rdi

  syscall

%endmacro

%macro write 2 ;;1 - text, 2 - text_len

  mov rdi, rax
  mov rax, 1
  mov rsi, %1
  mov rdx, %2

  syscall

%endmacro
