
section .data

	menumsg db 10,10,'Menu:'
		db 10,'1) Hex to BCD'
		db 10,'2) BCD to Hex'
		db 10,'3) Exit'
		db 10,10,'Please Enter Choice :'
	menumsg_len equ $-menumsg

	wrchmsg db 10,10,'Invalid choice....Please try again!!!',10,10
	wrchmsg_len equ $-wrchmsg

	hexinmsg db 10,10,'Enter a 4 digit hex number :'
	hexinmsg_len equ $-hexinmsg

	bcdopmsg db 10,10,'Its BCD Equivalent :'
	bcdopmsg_len equ $-bcdopmsg

	bcdinmsg db 10,10,'Enter 5 digit BCD number :'
	bcdinmsg_len equ $-bcdinmsg

	hexopmsg db 10,10,'Its Hex Equivalent :'
	hexopmsg_len equ $-hexopmsg

section .bss

	numascii resb 06
	opbuff resb 05
	dnumbuff resb 08

%macro dispmsg 2
	mov eax,04
	mov ebx,01
	mov ecx,%1
	mov edx,%2
	int 80h

%endmacro

%macro accept 2
	mov eax,03
	mov ebx,00
	mov ecx,%1
	mov edx,%2
	int 80h

%endmacro

section .text
	global _start
_start:

	dispmsg menumsg,menumsg_len
	accept numascii,2

	cmp byte[numascii],'1'
	jne case2
	call hex2bcd_proc
	jmp _start
case2:
	cmp byte [numascii],'2'
	jne case3
	call bcd2hex_proc
	jmp _start
case3:
	cmp byte [numascii],'3'
	je exit
	dispmsg wrchmsg,wrchmsg_len
	jmp _start
exit:
	mov eax,01
	int 80h

hex2bcd_proc:

	dispmsg hexinmsg,hexinmsg_len
	accept numascii,5
	call packnum
	mov rcx,0
	mov ax,bx
	mov bx,10
h2bup1:
	mov dx,0
	div bx
	push rdx
	inc rcx
	cmp ax,0
	jne h2bup1
	mov rdi,opbuff

h2bup2:
	pop rdx
	add dl,30h
	mov [rdi],dl
	inc rdi
	loop h2bup2

	dispmsg bcdopmsg,bcdopmsg_len
	dispmsg opbuff,5
ret

bcd2hex_proc:

	dispmsg bcdinmsg,bcdinmsg_len
	accept numascii,6

	dispmsg hexopmsg,hexopmsg_len

	mov rsi,numascii
	mov rcx,05
	mov rax,0
	mov ebx,0ah

b2hup1:
	mov rdx,0
	mul ebx
	mov dl,[rsi]
	sub dl,30h
	add rax,rdx
	inc rsi
	loop b2hup1
	mov ebx,eax
	call disp32_num
ret

packnum:
	mov bx,0
	mov ecx,04
	mov esi,numascii
up1:
	rol bx,04
	mov al,[esi]
	cmp al,39h
	jbe skip1
	sub al,07h
skip1:
	sub al,30h
	add bl,al
	inc esi
	loop up1
	ret

disp32_num:

	mov rdi,dnumbuff
	mov rcx,08

dispup1:

	rol ebx,4
	mov dl,bl
	and dl,0fh
	add dl,30h
	cmp dl,39h
	jbe dispskip1
	add dl,07h

dispskip1:

	mov [rdi],dl
	inc rdi
	loop dispup1
	dispmsg dnumbuff+3,5
ret

