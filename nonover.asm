
section .data
menumsg db 10,10,"Menu for non overlap block transfer",10
	db 10,"1.Block transfer without using string instruction",10
	db 10,"2.Block transfer with using string function",10
	db 10,"3.Exit",10
menumsg_len equ $-menumsg
wrchmsg db 10,10,"Wrong choice enter",10,10
wrchmsg_len equ $-wrchmsg

blk_bfrmsg db 10,"Block content before transfer"
blk_bfrmsg_len equ $-blk_bfrmsg

blk_afrmsg db 10,"Block content after transfer"
blk_afrmsg_len equ $-blk_afrmsg

srcmsg db 10,"Source block content:",10
srcmsg_len equ $-srcmsg

dstmsg db 10,"Destination block content:",10
dstmsg_len equ $-dstmsg

srcblk db 01H,02H,03H,04H,05H
dstblk times 5 db 0
cnt equ 05

spacechar db 20H
lfmsg db 10,10

section .bss
optionbuff resb 02
dispbuff resb 02

%macro dispmsg 2
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 0x80
%endmacro

%macro accept 2
	mov eax,3
	mov ebx,2
	mov ecx,%1
	mov edx,%2
	int 0x80
%endmacro

section .text
global _start
_start:
	dispmsg blk_bfrmsg,blk_bfrmsg_len
	call showblks
	
menu:
	dispmsg menumsg,menumsg_len
	accept optionbuff,02
	cmp byte[optionbuff],'1'
	jne case2
	call blkxferwo_proc
	jmp exit1

case2:
	cmp byte[optionbuff],'2'

jne case3
	call blkxferw_proc
	jmp exit1
	
case3:
	cmp byte[optionbuff],'3'
	je exit
	
	dispmsg wrchmsg,wrchmsg_len
	jmp menu
	
exit1:
	dispmsg blk_afrmsg,blk_afrmsg_len
	call showblks
	dispmsg lfmsg,2

exit:
	mov eax,1
	mov ebx,0
	int 0x80
	
dispblk_proc:
	mov rcx,cnt
rdisp:
	push rcx
	mov bl,[esi]
	call disp8_proc
	inc esi
	dispmsg spacechar,1
	pop rcx
	loop rdisp
	ret
	
blkxferwo_proc:
	mov esi,srcblk
	mov edi,dstblk
	mov ecx,cnt
blkup1:
	mov al,[esi]
	mov [edi],al
	inc esi
	inc edi
	loop blkup1
	ret
	
blkxferw_proc:
	mov esi,srcblk
	mov edi,dstblk
	mov ecx,cnt
	cld
	rep movsb
	ret
	
showblks:
	dispmsg srcmsg,srcmsg_len
	mov esi,srcblk
	call dispblk_proc
	
	
	dispmsg dstmsg,dstmsg_len
	mov esi,dstblk
	call dispblk_proc
	ret
	
disp8_proc:
	mov ecx,02
	mov edi,dispbuff
	dup1:
	rol bl,4
	mov al,bl
	and al,0FH
	cmp al,09H
	jbe dispskip
	add al,07H
	
dispskip:
	add al,30H
	mov [edi],al
	inc edi
	loop dup1
	dispmsg dispbuff,03
	ret	

