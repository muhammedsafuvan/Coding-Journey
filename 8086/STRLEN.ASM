;macro for printing a string
print macro m
mov ah,09h
mov dx,offset m
int 21h
endm

.model small

.data

msg db 10,13, "Exiting the program $"

empty db 10,13, "   $"
str1 db 25,?,25 dup('$')

len db ?
mstring db 10,13, "Enter the string: $"
mlength db 10,13, "Length is: $"


.code

start:
        mov ax,@data
        mov ds,ax

        print mstring    
		call accept_string   ;function call to accept a string

        mov cl,str1+1        ;storing length in cl from first byte of the array
        mov bl,cl            ;copying in bl for displaying 
		print mlength
        call display1        ;printing the length

exit:
mov ah,4ch       ;exit the program
int 21h


;accept procedure

accept proc near

mov ah,01
int 21h
ret
accept endp

display1 proc near

   mov al,bl
   mov bl,al
   and al,0f0h
   mov cl,04
   rol al,cl

   cmp al,09
   jbe number
   add al,07
number:  add al,30h
         mov dl,al
         mov ah,02
         int 21h

         mov al,bl
         and al,00fh
         cmp al,09
         jbe number2
         add al,07
number2:  add al,30h
          mov dl,al
          mov ah,02
          int 21h
ret
display1 endp



accept_string proc near

mov ah,0ah          ;accept string from user function
mov dx,offset str1  ; store the string in memory pointed by "DX"
int 21h
ret
accept_string endp

end start
end