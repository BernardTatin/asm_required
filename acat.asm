; ----------------------------------------------------------------------
; acat.asm
;
; A simple cat which write on STDOUT all what it reads on STDIN
; To assemble and run:
;
;     nasm -felf64 acat.asm && ld hello.o && ./a.out
; ----------------------------------------------------------------------

%include "syscalls.inc.asm"

%define dataSize  1024

; ----------------------------------------------------------------------
section 	.text
%ifdef WITH_LD
	global _start

_start:
%endif
%ifdef WITH_GCC
	global main

main:
%endif
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
	sys_write STDERR, writeerror, Ewriteerror-writeerror
	pop rax
	jmp end_loop
cant_read:
	push rax
	sys_write STDERR, readerror, Ereaderror-readerror
	pop rax
	jmp end_loop
end_loop:
	sys_exit	rax						; exit with last exit code

; ----------------------------------------------------------------------
section	.data
readerror	db 'Cannot read STDIN', 10
Ereaderror	db 0

writeerror	db 'Cannot write STDIN', 10
Ewriteerror db 0
; ----------------------------------------------------------------------
section .bss
rchar:  resb      dataSize				; the buffer
