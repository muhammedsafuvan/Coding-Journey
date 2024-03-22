; string case conversion

.model small
.stack 64h


.data
    	buffer  db  100,?,100 DUP(0)
    	result  db  101 DUP(0)
    	mssg1   db  10,13," Enter string : $"
    	mssg2   db  10,13," Result       : $"
    	newline db  10,13,"$"
    
    	display macro   mssg
            	lea     dx,mssg
            	mov     ah,09h
            	int     21h
       	endm
          
            
.code
	main	proc
    		
    	mov     ax,@data
    	mov     ds,ax
    
     	;input string
    	display mssg1
    	mov     ah,0ah
    	mov     dx,offset buffer
    	int     21h
        
        ;set si and di
    	lea     si,buffer
    	inc     si
    	mov     cx,0
    	mov     cl,[si]
    	lea     di,result

	;loop to find upper case or lower case and convert
	convert:
    		inc     si
    		mov     al,[si]
    		cmp     al,65
    		jl      skip
    		cmp     al,90
    		jle     to_lower
    		cmp     al,97
    		jl      skip
    		cmp     al,122
    		jle     to_upper
    		jmp     skip
    
    		to_lower:
    		add     al,32
    		jmp     skip
    
		to_upper:
    		sub     al,32
    
		skip:
    		mov     [di],al
    		inc     di
    		loop    convert

    	mov     [di],'$' 

    	display mssg2
    	display result
    
	exit:
	display	newline
    	mov     ah,4ch
    	int     21h
    
    	main	endp
   

end main


