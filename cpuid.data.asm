; ----------------------------------------------------------------------
; cpuid.data.asm
;
; A CPUID
; To assemble and run:
;
;     nasm -felf64 cpuid.asm \
;		&& ld -o cpuid cpuid.o && ./cpuid
; ----------------------------------------------------------------------

%define DATA
%include "cpuid.inc.asm"


; ----------------------------------------------------------------------
section		.data
title		db	'A simple CPUID', 10
Ltitle		dq	$-title

model		db	'Model:    '
efmodel		db	'00.'	; bits 20-27 / 8
eemodel		db	'0.'	; bits 16-19 / 4
ptmodel		db	'0.'	; bits 12-13 / 2
fmodel		db	'0.'	; bits  8-11 / 4
mmodel		db	'0.'	; bits  4- 7 / 4
smodel		db	'0'		; bits  0- 3 / 4
			db	10
Lmodel		dq	$-model


hexdump		db	'0123456789abcdef'
