data segment    
    msg1 db "Enter the limit:$"
    msg2 db 0ah,0dh,"Enter the 8bit numbers:$"
    msg3 db 0ah,0dh,"The sorted order is :$"
    msg4 db 0ah,0dh,"$"
    msg5 db 0ah,0dh,"arry read complete$"
    arr db 20 dup(0)

    msgDisp MACRO msg
      lea dx,msg
      mov ah,09h
      int 21h 
      ENDM 

       write MACRO 
       mov dl,al
       add dl,30h
       mov ah,02h
       int 21h 
      ENDM

data ends

code segment
assume cs:code,ds:data
start:
        mov ax,data
        mov ds,ax

        msgDisp msg1
        call read
        mov cx,bx
        push cx

        msgDisp msg2
        lea si,arr
   l1:  msgDisp msg4
        call read
        mov [si],bl
        inc si
        loop l1

	msgDisp msg5

        pop dx
        push dx
        dec dl
        mov cl,dl

   l4:  mov ch,dl
        lea si,arr
   l2:  mov al,[si]
        inc si
        cmp al,[si]
        jc l3
        xchg al,[si]
        xchg al,[si-1]
   l3:  dec ch
        jnz l2
        dec cl
        jnz l4

        pop cx
        lea si,arr
        msgDisp msg3
   l5:  msgDisp msg4
        mov al,[si]
        mov ah,00h
        call dispOutput
        inc si
        loop l5

        mov ah,4ch
        int 21h

        read PROC
           mov ah,01h
           int 21h
           sub al,30h
           mov ah,00h
           mov bx,000ah
           mul bx
           mov bx,ax
       
           mov ah,01h
           int 21h
           mov ah,00h
           sub al,30h
           add bx,ax 
           ret
      read ENDP

      dispOutput PROC
           push cx
           mov cx,0000h     
           mov bx,000ah
     l6:   mov dx,0000h
           div bx
           push dx
           inc cx
           cmp ax,bx
           jge l6
      
           write
     l7:   pop ax
           write
           loop l7
           pop cx
        ret
      dispOutput ENDP  

code ends
end start
