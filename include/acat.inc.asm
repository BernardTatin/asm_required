; ----------------------------------------------------------------------
; acat.data.asm
;
; A simple cat which write on STDOUT all what it reads on STDIN
; To assemble and run:
;
;     nasm -felf64 acat.asm acat.data.asm \
;		&& ld acat.o acat.data.o && ./a.out
; ----------------------------------------------------------------------

%define dataSize  1024

%ifdef DATA
	global	readerror
	global 	Lreaderror
	global 	writeerror
	global 	Lwriteerror
	global 	rchar
%else
	extern	readerror
	extern 	Lreaderror
	extern 	writeerror
	extern 	Lwriteerror
	extern 	rchar
%endif
