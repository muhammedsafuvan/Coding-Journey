; Palindrome

.model small
.stack 64h

.data
    	buffer db 100,?,100 DUP(0)
    	mssg1  db 10,13," Enter string: $"
    	mssg2  db 10,13," The string is a palindrome.",10,13,"$"
    	mssg3  db 10,13," The string is not a palindrome.",10,13,"$"
    
   	display macro   mssg
            	lea     dx,mssg
            	mov     ah,09h
            	int     21h
	endm
            
.code

	main  proc
    	
    	mov     ax,@data
    	mov     ds,ax
    
    	;input string
    	display mssg1
    	mov     ah,0ah
    	mov     dx,offset buffer
    	int     21h
        
        ;set si to the start and di to the end of buffer
    	lea     si,buffer
    	inc     si
    	mov     cx,0
    	mov     cl,[si]
    	mov     di,si
    	add     di,cx
    	inc     si

	;loop to compare si and di
	check:    
    		cmp     si,di
    		jge     success
		mov	al,[si]
    		cmp     al,[di]
    		jne     break
    		dec     di
    		inc     si
    		jmp     check
    	end_check:

	;print if palindrome
	success:
    	display mssg2
    	jmp     exit

	;print if not palindrome
	break:
    	display mssg3
	
	exit:
    	mov     ah,4ch
    	int     21h

	main  endp
	
end main
