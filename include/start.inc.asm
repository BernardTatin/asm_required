; ----------------------------------------------------------------------
; start.inc.asm
;
;	macro defining entry point

; ----------------------------------------------------------------------


%macro ENTRY_POINT 0
section 	.text
%ifdef WITH_ld
	global _start

_start:
%endif
%ifdef WITH_gcc
	global main

main:
%endif
%endmacro
