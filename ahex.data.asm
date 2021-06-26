; ----------------------------------------------------------------------
; ahex.data.asm
;
; A simple cat which write on STDOUT all what it reads on STDIN
; To assemble and run:
;
;     nasm -felf64 acat.asm acat.data.asm \
;		&& ld acat.o acat.data.o && ./a.out
; ----------------------------------------------------------------------

%define DATA		1
%include "ahex.inc.asm"

; ----------------------------------------------------------------------
section	.data
address 		dd		0	; current address in file
buffer_len		dq		0	; number of bytes in buffer_in
ptr_out			dq		0	; pointer in buffer_in of thr
							; next char to display
chars2display	dq		0	; #char to display

line			db 		'00000000'
				db		'  '
bytes1			db		'xx xx xx xx xx xx xx xx'
				db		'  '
bytes2			db		'xx xx xx xx xx xx xx xx'
				db		'  |'
chars			db		'................'
				db		'|', 10
Lline			dq		$-line

hexsymbols		db		'0123456789abcdef'
; ----------------------------------------------------------------------
section .bss
buffer_in: 	resb 	buffer_size				; the buffer
