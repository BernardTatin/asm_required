; ----------------------------------------------------------------------
; acat.data.asm
;
; A simple cat which write on STDOUT all what it reads on STDIN
; To assemble and run:
;
;     nasm -felf64 acat.asm acat.data.asm \
;		&& ld acat.o acat.data.o && ./a.out
; ----------------------------------------------------------------------

%define DATA		1
%include "acat.inc.asm"


; ----------------------------------------------------------------------
section	.data
readerror	db 'Cannot read STDIN', 10
Ereaderror	db 0
Lreaderror 	dq Ereaderror - readerror

writeerror	db 'Cannot write STDIN', 10
Ewriteerror db 0
Lwriteerror dq Ewriteerror - writeerror
; ----------------------------------------------------------------------
section .bss
rchar:  resb      dataSize				; the buffer

