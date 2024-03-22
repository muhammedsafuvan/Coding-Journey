DATA SEGMENT
        MSG_ROW DB 10,13,'ROWS: $'
        MSG_COL DB 10,13,'COLUMNS: $'
        COMMA DB ', $'
        SPACE DB ' $'
        TAB DB '        $'
        MSG_A DB 10,13,'MATRIX A: $'
        MSG_B DB 10,13,'MATRIX B: $'
        SUMIS DB 10,13,'SUM : $'
        NEWLINE DB 10,13, "$"
        ROWS DB 00H
        COLS DB 00H
        MAT_A DB 25 DUP(0)
        MAT_B DB 25 DUP(0)
        MAT_SUM DB 25 DUP(0)
        TEMP_ROW DW 00H
        TEMP_COL DW 00H
        TEMP_PRT DB 10 DUP('$')
        CNT DW ?
        NUM DB 3 DUP('$')
        ELE DB ?
        
    READ MACRO NUM
        MOV AH, 01H                 ;read character
        INT 21H                     ;read 1st character
        MOV BH, AL                  ;store it in bh
        INT 21H                     ;read next character
        MOV BL, AL                  ;store it in bl
        SUB BH, 30H                 ;converts to integer
        MOV AL, 0AH                 ;ah=10
        MUL BH                      ;al=bh*10
        SUB BL, 30H
        ADD AL, BL                  ;al=al+bl
        MOV NUM, AL
    ENDM

    
     WRITE MACRO 
       MOV DL,AL                    ;macro to print a number
       ADD DL,30H
       MOV AH,02H
       INT 21H 
     ENDM

    PRINT MACRO S
        MOV AH, 09H                 ;macro to print a string
        MOV DX, OFFSET S
        INT 21H
    ENDM
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
    START:
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX
    PRINT MSG_ROW
    READ ROWS                       ;read number of rows
    PRINT MSG_COL
    READ COLS                       ;read number of columns

    
    PRINT MSG_A                     ;reading matrix A
    
    LEA SI,MAT_A                    ;load address of A
    CALL READMATRIX                 ;reading
    PRINT MSG_B                     ;reading matrix B
    
    LEA SI,MAT_B                    ;load address of B
    CALL READMATRIX                 ;reading
   
    PRINT NEWLINE
    PRINT MSG_A                     
    PRINT NEWLINE
    LEA SI,MAT_A                    ;load address of A
    CALL dispOutput                 ;print matrix A
    PRINT MSG_B                     
    PRINT NEWLINE
    LEA SI,MAT_B                    ;load address of B
    CALL dispOutput                 ;print matrix B


    PRINT SUMIS                     ;print sum matrix
    PRINT NEWLINE
    CALL ADDMATRIX                  ;additon procedure
    LEA SI,MAT_SUM                  ;load address of sum matrix
    CALL DISPOUTPUT                 ;print sum matrix
    MOV AH, 4CH
    INT 21H

   
    ADDMATRIX PROC
        MOV BX,0000H                ;bx is used as index
        MOV AX,0000H                ;bx=0,ax=0
        MOV AL,ROWS                 ;al=rows
        MOV CL,COLS                 ;bl=cols
        MUL CL                      ;al=al*cl
        MOV CX,AX                   ;cx=ax ie. number of elements in matrix
        ADDL:
        LEA SI,MAT_A                ;load address of matrix A to SI
        MOV AL,[BX][SI]             ;al= element in loaction [si+bx] SI is base bx is index 
        LEA SI,MAT_B                ;load address of matrix B to SI
        ADD AL,[BX][SI]             ;adding element at [si+bx] with AL and store in AL
        ; WRITE
        LEA SI,MAT_SUM              ;load address of sum matrix
        MOV [BX][SI],AL             ;value in AL is transferred to location [si+al]. Sum is stored
        INC BX                      ;increment index bx
        LOOP ADDL                   ;loops cx times
        RET
    ADDMATRIX ENDP

    READMATRIX PROC NEAR
        MOV AL, ROWS
        MOV BL, COLS
        MUL BL
        MOV CX,AX                   ;cx=row*col. Number of elements
        READARRAY:
            READ ELE                ;read number
            PRINT SPACE
            MOV AL, ELE
            MOV [SI], AL            ;mov number to location SI
            INC SI                  ;increment SI
            
            LOOP READARRAY          ;loops CX times
        RET
    READMATRIX ENDP



    DISPOUTPUT PROC
        MOV AL, ROWS
        MOV BL, COLS
        MUL BL
        MOV CX,AX                   ;cx=row*col. Number of elements
        PRINTARRAY:
        
        MOV AX,0000H                ;ax=0
        MOV AL,[SI]                 ;ax=element in location SI

            PUSH BX                 
            PUSH CX                 ;push bx,cx int0 stack
            
            MOV CX,0000H            ;cx=0    
            MOV BX,000AH            ;bx=10
        L6:   MOV DX,0000H          ;dx=0
            DIV BX                  ;divide by 10
            PUSH DX                 ;push remainder to stack
            INC CX                  ;increment counter
            CMP AX,BX               ;compare and jumb id ax >= 10
            JGE L6
        
            WRITE                   ;write macro print ax
        L7:   POP AX                ;pop from ax
            WRITE
            LOOP L7                 ;loop cx times
            POP CX                  ;restore value of cx
            POP BX

        PRINT SPACE
        INC SI                      ;increment si
        DEC BL                      ;decrement bl
        CMP BL,0                    ;compare bl with 0. BL is number of elements in a row
        JNE NXT                     ;jumb next iteration if bl!=0
        PRINT NEWLINE               ;else 
        MOV BL,COLS                 ;bl=cols
        NXT:
        LOOP PRINTARRAY             ;loops cx times
    RET
    DISPOUTPUT ENDP  


CODE ENDS
END START