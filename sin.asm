
;Sin wave
.model small
.stack 100
.data
msg db 10,13,'this is Sin wave$'
x dd 0.0
xad dd 3.0
one80 dd 180.0
sixty dd 30.0
hundred dd 50.0
row db 00
col db 00
xcursor dd 00
ycursor dt 00
count dw 360
x1 dw 0
.code
.386
main: mov ax,@data
mov ds,ax
mov ah,00
mov al,6
int 10h
;set video mode
up1:finit
fldpi
fdiv one80
fmul x
fsin
fmul sixty
fld hundred
fsub st,st(1) ;=100-60 sin((pi/180))*x
fbstp ycursor
lea esi,ycursor
mov ah,0ch
mov al,01h
mov bh,0h
mov cx,x1
mov dx,[si]
;write graphics pixelint 10h
inc x1
fld x
fadd xad
fst x
dec count
jnz up1
mov ah,09h
lea dx,msg
int 21h
mov ah,4ch
int 21h
end main

