; PROGRAM: CONCATINATE 2 STRINGS

print macro s
        mov ah, 09h
        mov dx, offset s
        int 21h
endm
data segment
        msg db 'Enter a string: $'
        msg2 db 'Concatenated String: $'
        nl db 0dh, 0ah,'$'
        str1 db 50 dup('$')
        str2 db 50 dup('$')
data ends
code segment
        assume ds:data, cs:code
        start:
        mov ax, data
        mov ds, ax
 mov es, ax
        print msg
        mov di, offset str1
        mov ah, 01h
        LOOP1:
                int 21h
                cmp al, 0dh
                jz STOP1
                mov [di], al
                inc di
                jmp LOOP1
        STOP1:
        print nl
        print msg
        mov si, offset str2
        mov ah, 01h
        mov cx, 0000h
        LOOP2:
                int 21h
                cmp al, 0dh
                jz STOP2
                mov [si], al
                inc si
                inc cx
                jmp LOOP2
        STOP2:
        cld
        mov si, offset str2
        rep movsb
        print nl
        print msg2
        print str1
        mov ah, 4ch
        int 21h
code ends
end start
