; ----------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
; To assemble and run:
;
;     nasm -felf64 hello.asm && ld hello.o && ./a.out
; ----------------------------------------------------------------------

%include "syscalls.inc.asm"

%define dataSize  1024

; ----------------------------------------------------------------------
section   .text
          global    _start

_start:
loop:
	sys_read  STDIN, rchar, dataSize
	cmp rax, 0
	jna end_loop
	;; jb end_loop
	sys_write STDOUT, rchar, rax
	jmp loop
end_loop:
	sys_exit	rax

; ----------------------------------------------------------------------
section   .bss
rchar:   resb      dataSize
