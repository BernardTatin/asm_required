; ----------------------------------------------------------------------
; ahex.inc.asm
;
; A simple cat which write on STDOUT all what it reads on STDIN
; To assemble and run:
;
;     nasm -felf64 acat.asm acat.data.asm \
;		&& ld acat.o acat.data.o && ./a.out
; ----------------------------------------------------------------------

%assign 	buffer_size 	16


%ifdef DATA
	%define _ATTR_	global
%else
	%define _ATTR_	extern
%endif

_ATTR_ buffer_in
_ATTR_ buffer_len
_ATTR_ address
_ATTR_ ptr_out
_ATTR_ chars2display

_ATTR_ line
_ATTR_ bytes1
_ATTR_ bytes2
_ATTR_ chars
_ATTR_ Lline

_ATTR_ hexsymbols

