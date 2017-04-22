
 .model tiny
 .code
 ORG 0100h
 start:
    jmp trans

     intvect dd ?
    temp db 00h
     hr db ?
     min db ?
     sec db ?
 resi:
    push ax
    push bx
    push cx
    push dx

    push si
    push di
    push sp
    push bp

    push ss
    push ds
    push es

    mov ah,02h  ; read real time clock
    int 1Ah

    mov cs:hr,ch
    mov cs:min,cl
    mov cs:sec,dh

    inc cs:temp

    mov ax,0B800h  ;set AX to hexadecimal value of B800h for graphics mode.
    mov es,ax
    mov di,0100

    mov al,cs:hr
    and al,0F0h
    mov cl,04h
    shr al,cl
    add al,30h
    mov es:[di],al
    inc di
    inc di

    mov al,cs:hr
    and al,0Fh
    add al,30h
    mov es:[di],al
    inc di
    inc di

    mov al,':'
    mov es:[di],al

    inc di
    inc di

    mov al,cs:min
    and al,0F0h
    mov cl,04h
    shr al,cl
    add al,30h
    mov es:[di],al
    inc di
    inc di

    mov al,cs:min
    and al,0Fh
    add al,30h
    mov es:[di],al
    inc di
    inc di

    mov al,':'
    mov es:[di],al
    inc di
    inc di

    mov al,cs:sec
    and al,0F0h
    mov cl,04h
    shr al,cl
    add al,30h
    mov es:[di],al
    inc di
    inc di

    mov al,cs:sec
    and al,0Fh
    add al,30h
    mov es:[di],al

        cmp cs:temp,100
    

    mov cs:temp,00h
       
      ret
trans:
    cli

    mov ah,35h
    mov al,08h
    int 21h

    mov word ptr intvect,bx
    mov word ptr intvect+2,es

    mov ah,25h
    mov al,08h
    mov dx,offset resi
    int 21h

    mov ah,31h
    mov al,00h
    mov dx,offset trans
    sti
    int 21h

 end start

