; ----------------------------------------------------------------------
; acat.asm
;
; A simple cat which write on STDOUT all what it reads on STDIN
; To assemble and run:
;
;     nasm -felf64 acat.asm acat.data.asm \
;		&& ld acat.o acat.data.o && ./a.out
; ----------------------------------------------------------------------

%define CODE		1
%include "syscalls.inc.asm"
%include "start.inc.asm"
%include "acat.inc.asm"

; ----------------------------------------------------------------------
ENTRY_POINT
loop:
	sys_read  STDIN, rchar, dataSize	; read dataSize chars from STDIN
	cmp rax, 0							; rax contains the number of bytes
	jz end_loop							; rax <= 0, end of file or error
	jb cant_read
	sys_write STDOUT, rchar, rax		; write the buffer
	cmp rax, 0
	jb cant_write
	jmp loop							; loop
cant_write:
	push rax
	sys_write STDERR, writeerror, [Lwriteerror]
	pop rax
	jmp end_loop
cant_read:
	push rax
	sys_write STDERR, readerror, [Lreaderror]
	pop rax
	jmp end_loop
end_loop:
	sys_exit	rax						; exit with last exit code
