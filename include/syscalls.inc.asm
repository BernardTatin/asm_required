; ----------------------------------------------------------------------
; syscalls.inc.asm
;
;	macros around system calls

; ----------------------------------------------------------------------

%define STDIN 	0
%define STDOUT	1
%define STDERR	2

; ----------------------------------------------------------------------
;; %1: exit code
%macro	sys_exit	1
	mov	rdi, %1				; exit code %1
	mov	rax, 60				; system call for exit
	syscall
%endmacro


; ----------------------------------------------------------------------
;; %1: file handle,
;; %2: address of bytes to write,
;; %3: number of bytes.
%macro sys_write	3
	mov rdi, %1
	mov rsi, %2
	mov rdx, %3
	mov rax, 1
	syscall
%endmacro

; ----------------------------------------------------------------------
;; %1: file handle,
;; %2: address of bytes to read,
;; %3: number of bytes.
%macro sys_read		3
	mov rdi, %1
	mov rsi, %2
	mov rdx, %3
	mov rax, 0
	syscall
%endmacro
