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
	%define _ATTR_	global
%else
	%define _ATTR_	extern
%endif

_ATTR_	readerror
_ATTR_ 	Lreaderror
_ATTR_ 	writeerror
_ATTR_ 	Lwriteerror
_ATTR_ 	rchar
