data segment
    msg1	db " FIRST NUMBER = $"
	msg2	db 10,13, " SECOND NUMBER = $"
	msg3	db 10,13, " PRODUCT = $"
	msg4	db 10,13, " QUATIENT = $"
	msg5    db 10,13, " REMAINDER = $"
    newline db 10,13, "$"
	nh	dw ?
	nl	dw ?
	ml	dw ?
    num1 dw 0
    num2 dw 0
    num3 dw 0
	rh      dw ?
	rl      dw ?
	quat	dw ?
	rem	dw ?
	zero	dw 0
    th      dw 10000

	
	printstr macro var
    mov ah,9h
    lea dx,var
    int 21h
	endm
	
data ends

code segment
	assume ds:data, cs:code 
	start:
        mov	ax,data
		mov	ds,ax

        printstr	msg1            ;first number 32 bit
		call	readinput
		mov	nh,ax		
		call	readinput
		mov	nl,ax
		printstr newline

		printstr	msg2            ;second number 16 bit
		call	readinput
		mov	ml,ax

        printstr newline
        
        call multiplication
        printstr msg3
        mov ax,num3
        call displayoutput
        mov ax,num2
        call displayoutput
        mov ax,num1
        call displayoutput

        printstr newline
        mov ax,0
        mov bx,0
        mov cx,0
        call division
        printstr msg4
        mov ax,quat
        call displayoutput
        
        printstr newline
        printstr msg5
        mov ax,rem
        call displayoutput

        

    mov	ah,4ch
    int	21h




multiplication proc
    mov cx,ml
    mov ax,0
    mov bx,0
    mov num3,0

add1:
    mov dx,0
    mov ax,num1
    add ax,nl
    
    div th
    mov num1,dx

    mov dx,0
    mov bx,num2
    add bx,nh
    add ax,bx
    div th
    mov num2,dx
    add num3,ax
    dec cx
    
    jnz add1
    
    exmul:
        ret
multiplication endp

division proc
    mov ax,nl
    mov cx,nh
    mov bx,0
l1:

    cmp ax,ml
    jnc l2
    
    cmp cx,0
    je exdiv
    dec cx
    add ax,th
    
l2:
    sub ax,ml
    inc bx
    jmp l1


    exdiv:
        mov quat,bx
        mov rem,ax
        ret
division endp

readinput proc
    mov cx,0004h
    readloop:
        mov	ah,01h
        int	21h
        mov	ah,00h
        sub     al,30h
        push	ax
        loop	readloop
        
        pop	cx
        pop	bx
        mov	ax,10
        mul     bx
        add     cx,ax

        pop	bx
        mov	ax,100
        mul     bx
        add     cx,ax

        pop	bx
        mov	ax,1000
        mul     bx
        add	ax,cx
        ret
readinput endp

displayoutput proc

    mov	cx,0
    mov	bx,10
    nextdigit:
        mov	dx,0h
        div	bx
        push	dx
        inc	cx
        cmp     ax,0
        je      temp
        jmp	nextdigit

    temp:
        cmp cx,4
        jge dispchar
        push zero
        inc cx
        jmp temp

    dispchar:
        cmp	cx,0
        je	exit
        
        pop	dx
        add     dx,30h
        mov	ah,02h 
        int	21h	
        dec	cx
        jmp	dispchar

    exit: 
        ret 
displayoutput endp 


code ends
end start