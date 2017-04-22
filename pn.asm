
section .data
pmsg db 10 ,'count of positive number'
pmsg_len equ $-pmsg

nmsg db 10,'count of negative number'
nmsg_len equ $-nmsg

array dw 000AH,101BH,000CH,9F00H,9491H,007H,1002H
arrcnt equ 7
pcnt db 0
ncnt db 0

section .bss
dispbuff resb 2

%macro print 2
                mov eax,4
 			mov ebx,1
			mov ecx,%1
			mov edx,%2
			int 0x80
%endmacro

section .text
  global _start
 _start:
              mov esi,array
              mov ecx,arrcnt
  up1:
             bt word[esi],15
             jnc pskip
  pnxt:
            inc byte[pcnt]
  pskip:
            inc esi
            inc esi
loop up1

print pmsg,pmsg_len
    mov bl,[pcnt]
     call disp8num
     
print nmsg,nmsg_len
    mov bl,[ncnt]
     call disp8num

exit:
         mov eax,1
         mov ebx,0
         int 0x80

disp8num: 
                   mov edi,dispbuff
                    mov ecx,2

dispup1:
                  rol bl,4
                  mov  dl,bl
                  and dl,0FH
                  add dl,30H
                  cmp dl,39H
                 jbe dispskip1
                 add dl,07H

dispskip1:
                  mov [edi],dl
                  inc edi
                  loop dispup1
                  print dispbuff,2
                  ret
                  

