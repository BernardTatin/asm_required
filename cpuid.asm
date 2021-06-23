; ----------------------------------------------------------------------
; cpuid.asm
;
; A CPUID
; To assemble and run:
;
;     nasm -felf64 cpuid.asm && ld hello.o && ./a.out
; ----------------------------------------------------------------------

%include "syscalls.inc.asm"

; ----------------------------------------------------------------------
%macro push_main_regs 0
	push		rax
	push		rbx
	push		rcx
	push		rdx
	push		r11
	push		r12
%endmacro

%macro pop_main_regs 0
	pop			r12
	pop			r11
	pop			rdx
	pop			rcx
	pop			rbx
	pop			rax
%endmacro

%macro save_hbyte 2
	mov			r12, %1
	and			r12, 0fh
	mov			r11, [hexdump + r12]
	mov			[%2], r11b
%endmacro

%macro save_2bits 2
	mov			r12, %1
	and			r12, 03h
	mov			r11, [hexdump + r12]
	mov			[%2], r11b
%endmacro

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
	sys_write 	STDOUT, title, Etitle-title
	mov 		eax, 01h
	cpuid
	call		decode_model

	sys_exit 	0

decode_model:
	push_main_regs
	save_hbyte 	rax, smodel
	shr			rax, 4
	save_hbyte 	rax, mmodel
	shr			rax, 4
	save_hbyte 	rax, fmodel
	shr			rax, 4
	save_2bits 	rax, ptmodel
	shr			rax, 4
	save_hbyte 	rax, eemodel
	shr			rax, 4
	save_hbyte 	rax, efmodel + 1
	shr			rax, 4
	save_hbyte 	rax, efmodel + 0

	sys_write 	STDOUT, model, Emodel-model
	pop_main_regs
	ret
; ----------------------------------------------------------------------
section		.data
title		db	'A simple CPUID', 10
Etitle		db	0

model		db	'Model:    '
efmodel		db	'00.'	; bits 20-27 / 8
eemodel		db	'0.'	; bits 16-19 / 4
ptmodel		db	'0.'	; bits 12-13 / 2
fmodel		db	'0.'	; bits  8-11 / 4
mmodel		db	'0.'	; bits  4- 7 / 4
smodel		db	'0'		; bits  0- 3 / 4
			db	10
Emodel		db	0


hexdump		db	'0123456789abcdef'
