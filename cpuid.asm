; ----------------------------------------------------------------------
; cpuid.asm
;
; A CPUID
; To assemble and run:
;
;     nasm -felf64 cpuid.asm \
;		&& ld -o cpuid cpuid.o && ./cpuid
; ----------------------------------------------------------------------

%define CODE
%include "syscalls.inc.asm"
%include "start.inc.asm"
%include "cpuid.inc.asm"

; ----------------------------------------------------------------------
ENTRY_POINT
	sys_write 	STDOUT, title, [Ltitle]
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

	sys_write 	STDOUT, model, [Lmodel]
	pop_main_regs
	ret
