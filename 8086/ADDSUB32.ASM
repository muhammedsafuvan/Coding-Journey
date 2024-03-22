data segment
	msg1	db "Enter first 32bit number :$"
	msg2	db 10,13, "Enter second 32bit number :$"
	resultSub	db 10,13, "Difference is = $"
	resultAdd	db 10,13, "Sum = $"
	negative db 10,13, "- $"
	nh	dw ?
	nl	dw ?
	mh	dw ?
	ml	dw ?
	rh      dw ?
	rl      dw ?
	carry	dw ?
	borrow	dw ?
	

	msgDisplay MACRO msg	;MACRO declaration
		   lea	 dx,msg
		   mov	 ah,09h
		   int	 21h
	ENDM					;MACRO termination

	
data ends
code segment
	assume ds:data, cs:code
	start:
		mov	ax,data
		mov	ds,ax

		msgDisplay	msg1
		call	readInput
		mov	mh,ax
		
		call	readInput
		mov	ml,ax
		

		msgDisplay	msg2
		call	readInput
		mov	nh,ax
		call	readInput
		mov	nl,ax
	
		call ADDITION

		msgDisplay resultAdd
		mov	ax,rh
		call	displayOutput
		mov 	ax,rl
		call	displayOutput

		call	SUBTRACTION
		mov	ax,rh
		call	displayOutput
		mov 	ax,rl
		call	displayOutput


		mov	ah,4ch
		int	21h

ADDITION PROC
   ;ADDITION
		add	ax,ml
		mov	dx,0
		mov	bx,10000
		div     bx
		mov	carry,ax
		mov	rl,dx

		mov	bx,nh
		mov	ax,mh
		add     ax,carry
		add     ax,bx
		mov	rh,ax     

ret
ADDITION ENDP

SUBTRACTION PROC
	
		;subtraction
		msgDisplay resultSub
		mov	ax,mh
		cmp	ax,nh
		jge	positive
		msgDisplay	negative
		mov	ax,nl   
		cmp     ax,ml
		jge     sub1 
		mov     ax,nl
		add     ax,10000
		sub     ax,ml   
		mov     borrow,1
		mov     rl,ax
		mov     ax,nh
		sub     ax,borrow 
		sub     ax,mh 
		mov     rh,ax 
		jmp     subend

	sub1:
		mov ax,nl
		sub ax,ml   
		mov rl,ax
                mov ax,nh
		sub ax,mh
		mov rh,ax 
		jmp subend
        positive:
		mov ax,ml  
		cmp ax,nl
		jge againPositive
		mov ax,ml
		add ax,10000
		sub ax,nl
		mov rl,ax
		mov borrow,1
                mov ax,mh
		sub ax,borrow
		sub ax,nh
		mov rh,ax
		jmp subend
        againPositive:
		sub ax,nl
		mov rl,ax
		mov ax,mh
		sub ax,nh
		mov rh,ax
	subend:


ret
SUBTRACTION ENDP


readInput PROC
		mov cx,0004h
		readLoop:
			mov	ah,01h
			int	21h
			mov	ah,00h
			sub     al,30h
			push	ax
			loop	readLoop
			
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
	readInput ENDP

        displayOutput PROC
		
		mov	cx,0
		mov	bx,10
		nextdigit:
			mov	dx,0h
			div	bx
			push	dx
			inc	cx
			cmp     ax,0
			JE      dispchar
			jmp	nextdigit

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
displayOutput ENDP 

code ends
end start  ; Terminate Program