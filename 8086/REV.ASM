;macro for printing a string
print macro m
mov ah,09h
mov dx,offset m
int 21h
endm

.model small


;******  Data Segment ******
.data

empty db 10,13, "   $"
str1 db 25,?,25 dup('$')
str2 db 25,?,25 dup('$')
mstring db 10,13, "Enter the string: $"
mstring2 db 10,13, "Enter second string: $"
mreverse db 10,13, "Reversed string: $"

;********** Code Segment ************

.code

start:
mov ax,@data
mov ds,ax

        print mstring
        call accept_string
        

        mov si,offset str1      ;point si to start of string1 
        mov di,offset str2      ;point di to start of string2



        mov al,[si]         ;copy first two locations of string1 to string2
        mov [di],al         ;since these contain the size and length of the string
        inc si              ;which are same in reverse string also
        inc di


        mov al,[si]
        mov [di],al
        inc si
        inc di

        mov cl,str1+1 ;        copy length in cl
        mov ch,00              
        add si,cx              ;add length of string1 to si to move it to last location
        dec si                 ;si at last location of string1
        
move_more: mov al,[si]       ;copying character one by one from string1 pointed by si
           mov [di],al       ; to string2 pointed by "di" in reverse order as si moves
           dec si            ; from last character to first character 
           inc di
           dec cl
           jnz move_more

        
		print mreverse
        print str2+2     ;  printing the reversed string
		print empty

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
