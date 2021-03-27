;*******************************************************
;       	MACRO SEGMENT
;*******************************************************
INCLUDE analysis/analysis.asm

INCLUDE ctrllr/loadCtrl.asm
INCLUDE ctrllr/menuCtrl.asm

INCLUDE macros/file.asm
INCLUDE macros/macros.asm

INCLUDE views/loadView.asm
INCLUDE views/menuView.asm

;*******************************************************
;          END MACRO SEGMENT
;*******************************************************


.MODEL  small
;*******************************************************
;       	STACK SEGMENT
;*******************************************************

.STACK  100h

;*******************************************************
;           END STACK SEGMENT
;*******************************************************

;*******************************************************
;       	DATA SEGMENT
;*******************************************************
.DATA
    frame  DB 0Ah, '|------------------------------------------------------------------------------|$'
    
    comparasionFlag  DB 0

    axBk DW ?
    bxBK DW ?
    cxBK DW ?
    dxBk DW ?
    siBk DW ?
    diBk DW ?


; // error messages
    errorCreateFile DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to create file... $'
    errorCloseFile  DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to close  file... $'
    errorOpenFile   DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to open   file... $'
    errorReadFile   DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to read   file... $'
    errorWriteFile  DB 0Ah, 0Ah, 09h, 09h, 'ERROR, to write  file... $'



;*******************************************************
;       	END DATA SEGMENT
;*******************************************************


;*******************************************************
;       	CODE SEGMENT
;*******************************************************
.CODE

    main PROC
    
        MOV dx, @data
        MOV ds, dx
        MOV es, dx

        MAIN_MENU:
            mainMenuView
        LOAD_FILE:
            fileLoadView 

        EXIT:
            MOV ah, 4ch
            INT 21h

    main ENDP

    limpiarRegistros PROC
        XOR ax, ax
        XOR bx, bx
        XOR cx, cx
        XOR dx, dx
        XOR si, si
        XOR di, di
        ret
    limpiarRegistros ENDP

    respaldo PROC
        MOV axBk, ax
        MOV bxBk, bx
        MOV cxBk, cx
        MOV dxBk, dx
        MOV siBk, si
        MOV diBk, di
        ret
    respaldo ENDP

    restaurar PROC
        MOV ax, axBk
        MOV bx, bxBk
        MOV cx, cxBk
        MOV dx, dxBk
        MOV si, siBk
        MOV di, diBk
        ret
    restaurar ENDP


END


;*******************************************************
;       	END CODE SEGMENT
;*******************************************************


