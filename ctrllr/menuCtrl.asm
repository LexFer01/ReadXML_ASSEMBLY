menuController MACRO
	
	leerCaracter

    CMP al, 49
        JE  LOAD_FILE
    CMP al, 50
        JE  EXIT

    JMP MAIN_MENU

ENDM