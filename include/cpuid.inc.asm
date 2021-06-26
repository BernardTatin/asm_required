; ----------------------------------------------------------------------
; cpuid.inc.asm
;
; A CPUID
; To assemble and run:
;
;     nasm -felf64 cpuid.asm \
;		&& ld -o cpuid cpuid.o && ./cpuid
; ----------------------------------------------------------------------

%ifdef DATA
%define _ATTR_ global
%else
%define _ATTR_ extern
%endif

_ATTR_ title
_ATTR_ Ltitle

_ATTR_ model
_ATTR_ efmodel
_ATTR_ eemodel
_ATTR_ ptmodel
_ATTR_ fmodel
_ATTR_ mmodel
_ATTR_ smodel
_ATTR_ Lmodel

_ATTR_ hexdump
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

