; ----------------------------------------------------------------------
; ahex.asm
;
; A simple cat which write on STDOUT all what it reads on STDIN
; To assemble and run:
;
;     nasm -felf64 acat.asm acat.data.asm \
;		&& ld acat.o acat.data.o && ./a.out
; ----------------------------------------------------------------------

%define CODE		1
%include "syscalls.inc.asm"
%include "start.inc.asm"
%include "ahex.inc.asm"


; %define HEXSTOSB

; ----------------------------------------------------------------------
ENTRY_POINT

main_loop:
	;§g fill buffer_in from STDIN
	sys_read 	STDIN, buffer_in, buffer_size
	cmp			rax, 0
	;§g if rax == 0, no more bytes to read
	jz			end_loop
	;§g if rax < 0, it's an error
	jb			onerror
	; r14 <- number of read bytes
	mov			r14, rax
	;§g fill the line to put on STDOUT
	call		fillline
	;§g write the line
	sys_write	STDOUT, line, [Lline]
	;§g w continue while we can read bytes from STDIN
	jmp			main_loop
	;§g exit without error
end_loop:
	sys_exit 	rax
	;§g exit with error, musst be enhanced in the future
onerror:
	sys_exit 	rax

; -----------------------------------------------
	; filling the line
fillline:

	; push		r14
	; mov			rdi, bytes1
	; call		reset_bytes_1_2
	; mov			rdi, bytes2
	; call		reset_bytes_1_2
	call		reset_chars
	; pop			r14

	; rdi points on line
	mov			rdi, line
	; we process only 8 nibbles of the address
	mov			rcx, 8

	mov			r10d, [address]
	push		r10
	call		tohex
	pop			r10
	add			r10d, buffer_size
	mov			[address], r10d
	ret

	push		r14
	mov			rsi, buffer_in
	mov			rdi, bytes1
	call		loopbytes
	mov			rdi, bytes2
	call		loopbytes
	pop			r14

	mov			rsi, buffer_in
	mov			rdi, chars
	mov			rcx, buffer_size
	cmp			rcx, r14
	jnb			loopchars
	mov			rcx, r14
	cld
loopchars:
	lodsb
	cmp			al, 020h
	jb			badchars
	cmp			ax, 128
	jb			savechar
badchars:
	mov			al, '.'
savechar:
	stosb
	loop		loopchars

end_fill_line:
	ret

; -----------------------------------------------
;	r10: value in input
;	rcx : number of output chars
;	rdi : address of the receiving string
tohex:
	; save rsi, rdi
	push		rsi
	push		rdi
	; rsi is a pointer on hexsymbols
	mov			rsi, hexsymbols
	; rdi must point on the last byte of the receiving string
	; => rdi += rcx - 1
	add			rdi, rcx
	dec			rdi
%ifdef HEXSTOSB
	std
%endif
looptohex:
	; r11 <- input value
	mov			r11, r10
	; mask r11 to keep only the lowest nible
	and 		r11, 0fh
	; al byte <- hexsymbols[r11]
	mov			al, [rsi + r11]
%ifdef HEXSTOSB
	stosb
%else
	; put al byte in  the string
	mov			[rdi], al
	; rdi points on previous byte
	dec			rdi
%endif
	; r10 <- a shift to get the next 4 bits
	shr			r10, 4
	; loop
	loop		looptohex
	; restore rdi, rsi
	pop			rdi
	pop			rsi
	; return to caller
	ret

; -----------------------------------------------
	; rsi: pointer on buffer_in
	; rdi: pointer on bytes1/2
loopbytes:
	mov 		rcx, buffer_size
	shr			rcx, 1
	; cmp			r14, rcx
	; ja			inner_loopbytes
	; mov			rcx, r14
inner_loopbytes:
	push		rcx
	mov			rcx, 2
	mov			r10b, [rsi]
	call		tohex
	inc			rsi
	add			rdi, 3
	pop			rcx
	loop		inner_loopbytes
	ret


; -----------------------------------------------
	; rdi: pointer on bytes1/2
reset_bytes_1_2:
	mov			rcx, buffer_size
	add			rcx, buffer_size
	add			rcx, buffer_size
	mov			al, ' '
	cld
rep	stosb
	ret

; -----------------------------------------------
reset_chars:
	mov			rdi, chars
	mov			cx, buffer_size
	mov			al, ' '
	cld
rep	stosb
	ret
