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

; ----------------------------------------------------------------------
%macro fillbuffer 3
	sys_read 	%1, %2, %3
	cmp			rax, 0
%endmacro

; ----------------------------------------------------------------------
ENTRY_POINT

main_loop:
	;§g fill buffer_in from STDIN
	fillbuffer 	STDIN, buffer_in, buffer_size
	;§g if rax == 0, no more bytes to read
	jz			end_loop
	;§g if rax < 0, it's an error
	jb			onerror
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

	;§g filling the line
fillline:
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

	mov			rsi, buffer_in
	mov			rdi, bytes1
	call		loopbytes
	mov			rdi, bytes2
	call		loopbytes

	mov			rsi, buffer_in
	mov			rdi, chars
	mov			rcx, 16
loopchars:
	mov			al, [rsi]
	cmp			al, 020h
	jb			badchars
	cmp			ax, 128
	jb			savechar
badchars:
	mov			al, '.'
savechar:
	mov			[rdi], al
	inc			rsi
	inc			rdi
	loop		loopchars

end_fill_line:
	ret

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
looptohex:
	; r11 <- input value
	mov			r11, r10
	; mask r11 to keep only the lowest nible
	and 		r11, 0fh
	; r12 byte <- hexsymbols[r11]
	mov			r12b, [rsi + r11]
	; put r12 byte in  the string
	mov			[rdi], r12b
	; rdi points on previous byte
	dec			rdi
	; r10 <- a shift to get the next 4 bits
	shr			r10, 4
	; loop
	loop		looptohex
	; restore rdi, rsi
	pop			rdi
	pop			rsi
	; return to caller
	ret

loopbytes:
	mov 		rcx , 8
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

