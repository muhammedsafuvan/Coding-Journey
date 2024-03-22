data segment    
    msg1 db "Enter the limit:$"
    msg2 db 0ah,0dh,"Enter the 8bit numbers:$"
    msg3 db 0ah,0dh,"The sorted order is :$"
    msg4 db 0ah,0dh,"$"
    msg5 db 0ah,0dh,"arry read complete$"
    arr dw 20 dup(0)
    T DW ?
    N DW 10

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
        mov [si],bx
        inc si
        inc si
        loop l1

	    msgDisp msg5

        pop dx
        push dx
        dec dx
        mov T,dx


   l4:  mov cx,T
        lea si,arr
   l2:  mov ax,[si]
        inc si
        inc si
        cmp ax,[si] 
        jc l3
        xchg ax,[si]
        xchg ax,[si-2]
   l3:  dec cx
        jnz l2
        dec dx
        jnz l4

        pop cx
        lea si,arr

        msgDisp msg3
        
   l5:  msgDisp msg4
        mov ax,[si]
        
        call dispOutput
        inc si
        inc si
        dec cx
        jnz l5

        mov ah,4ch
        int 21h

    READ PROC
        MOV AX,0
        MOV BX,0
        MOV AH,1H
        INT 21H ;
        SUB AL,'0'


        MUL N ; AX = AL * 10
        MOV BL,AL

        MOV AH,1H
        INT 21H 
        SUB AL,'0'
        ADD AL,BL
    
        MOV BL,AL

        
        MOV AX,BX
        MUL N
        MUL N
        MOV T,AX

        MOV AX,0
        MOV BX,0
        MOV AH,1H
        INT 21H ;
        SUB AL,'0'


        MUL N ; AX = AL * 10
        MOV BL,AL

        MOV AH,1H
        INT 21H 
        SUB AL,'0'
        ADD AL,BL
    
        MOV BL,AL

        
        MOV AX,BX
        ADD AX,T
        mov bx,ax

    
    RET
    READ ENDP

      dispOutput PROC
        push cx
        mov cx,0 
        mov dx,0

        cmp ax,0
        jne label1
        push dx
        inc cx
        
        label1: 
            
            cmp ax,0 
            je print1	 	
            mov bx,10		 
            
            div bx				 
            push dx			 
            inc cx			 
            
            xor dx,dx 
            jmp label1 
        print1: 

            cmp cx,0 
            je exit
            pop dx 
            
            ;add 48 so that it 
            ;represents the ASCII 
            ;value of digits 
        
            add dx,48 

            mov ah,02h 
            int 21h 
            
            dec cx 
            jmp print1 
    exit: 
    pop cx
    ret 
      dispOutput ENDP  

code ends
end start