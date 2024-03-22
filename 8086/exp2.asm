.model small
.stack 64h

.data
	num1 dw 0
	num2 dw 0	
	num  dw 0
	temp  dw 0 	
	arr  db 5 DUP(?)
	in1   db 'number1 = $'
	in2   db 'number = $'
	mssg1 db 'sum = $'
	mssg2 db 10,13,'difference = $'
	mssg3 db 10,13,'product = $'
	mssg4 db 10,13,'quotient = $'
	mssg5 db '  remainder = $'
	

	
.code




	read	PROC
		
		mov num,0
		mov cx,10
		
		read_loop:
		
			mov ah,01h
			int 21h
			cmp al,0dh
			je  end_read_loop
			
			sub al,30h
			mov ah,0h
			mov bx,ax
			mov ax,num
			mul cx
			add ax,bx
			mov num,ax
			jmp read_loop
			
		end_read_loop:
			
			mov ax,num
			RET	
	
	read	ENDP
	
	
	
	
	
	
	
	
	write	PROC
		
		mov num,ax
		mov cx,0
		mov bx,10
		lea si,arr
		
		store_loop:
			
			mov dx,0h
			div bx
			mov [si],dx
			mov num,ax	 
			inc si
			inc cx
			
			cmp ax,0h
			je  end_store_loop
			jmp store_loop
		
		end_store_loop:

		write_loop:
			
			dec cx
			dec si
			mov dx,[si]
			add dx,30h
			mov ah,2h
			int 21h
			cmp cx,0h
			je  end_write_loop
			jmp write_loop
			
		end_write_loop:
			
			RET
		
	write	ENDP
	
	
	
	
	
	
	
	
	main    PROC
	
		mov  ax,@data
		mov  ds,ax
		
		lea  dx,in1
		mov  ah,09h
		int  21h
		call read
		mov  num1,ax
		
		lea  dx,in2
		mov  ah,09h
		int  21h
		call read
		mov  num2,ax
		
		sum:
			lea  dx,mssg1
			mov  ah,09h
			int  21h
			mov  ax,0h
			mov  ax,num1
			add  ax,num2
			call write 
		
		diff:
			lea  dx,mssg2
			mov  ah,09h
			int  21h
			mov  ax,0h
			mov  ax,num1
			sub  ax,num2
			call write 
			
		prod:
			lea  dx,mssg3
			mov  ah,09h
			int  21h
			mov  ax,0h
			mov  ax,num1
			mul  num2
			call write 
			
		quo:
			lea  dx,mssg4
			mov  ah,09h
			int  21h
			mov  dx,0
			mov  ax,0h
			mov  ax,num1
			div  num2
			mov  temp,dx
			call write
			lea  dx,mssg5
			mov  ah,09h
			int  21h 
			mov  ax,temp
			call write
		
		mov  ah,4ch
		int  21h
		
	main    ENDP
	
	
	END     main
