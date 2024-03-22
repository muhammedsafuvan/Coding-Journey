print macro s
        mov ah, 09h
        mov dx, offset s
        int 21h
endm
data segment
        msg db 'Enter a string: $'
        msg2 db 'Enter a substring: $'
        msg_y db 'Substring Present!$'
        msg_n db 'Substring Not Present!$'
        nl db 0dh, 0ah,'$'
        str db 50 dup('$')
        sstr db 50 dup('$')
data ends
code segment
        assume ds:data, cs:code
        start:
        mov ax, data
        mov ds, ax
        mov es, ax
        print msg
        mov si, offset str
        mov ah, 01h
        LOOP1:
                int 21h
                cmp al, 0dh
                jz STOP1
                mov [si], al
                inc si
                jmp LOOP1
        STOP1:
        mov [si],0f00h
        print nl
        print msg2
        mov si, offset sstr
        mov ah, 01h
        LOOP2:
                int 21h
                cmp al, 0dh
                jz STOP2
                mov [si], al
                inc si
                jmp LOOP2
        STOP2:
        mov [si],0f00h
        print nl
        mov si, offset str
        mov di, offset sstr
        LOOP3:
                cmp [di],0f00h
                jz PRESENT
                cmp [si], 0f00h
                jz NOTPRESENT
                mov bl, [di]
                cmp [si], bl
                jnz NOTEQUAL
                        inc di
                        inc si
                jmp LOOP3
                NOTEQUAL:
                        mov di, offset sstr
                        inc si              
                jmp LOOP3
        PRESENT:
                print msg_y
                jmp SKIP
        NOTPRESENT:
                print msg_n
        SKIP:
        mov ah, 4ch
        int 21h
code ends
end start