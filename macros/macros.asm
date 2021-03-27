imprimir MACRO string

	MOV ah, 09h
	MOV dx, offset string
	INT 21h

ENDM

imprimirC MACRO character
	MOV ah, 02h
	MOV dl, character
	INT 21h
ENDM

limpiarConsola MACRO
	MOV AX,0600H 	;Llamada a la función
	MOV BH,07H 		;color de fondo y color de letra
	MOV CX,0000H 	;coordenadas de inicio
	MOV DX,184FH 	;coordenadas de fin
	INT 10H
ENDM


leerCaracter MACRO
	MOV ah, 01h     ;; con ECHO
	; MOV ah, 08h 	;; sin ECHO
	INT 21h
ENDM


leerCadena MACRO buffer
	LOCAL LEER, FIN
	XOR si, si
	
	LEER:
		leerCaracter
		CMP al, 13 				; 0ah->\n (LINE FEED) 0dh-> retorno de carro
			JE FIN

		MOV buffer[si], al
		INC si
		JMP LEER
	
	FIN:
		MOV buffer[si], 00h
	
ENDM


compararCadenas MACRO string, string2
	LEA si, string
	LEA di, string2
	MOV cx, LENGTHOF string	
	REPE CMPSB

ENDM

compararIngorandoCase MACRO string, string2
	toLowerCase 	string
	toLowerCase 	string2
	compararCadenas	string, string2
ENDM

toLowerCase	MACRO string 
	LOCAL ITERATE, NEXT, END_TO_LOWERCASE

	XOR si, si
	MOV cx, LENGTHOF string

	ITERATE:
		CMP string[si], 36
			JE 	END_TO_LOWERCASE				;; jump if string[si] == '$'
		CMP string[si], 65
			JB 	NEXT							;; jump if string[si] < 65d
		CMP string[si], 90
			JA 	NEXT							;; jump if string[si] > 90d

		ADD string[si], 32
		INC si

		LOOP 	ITERATE
		JMP 	END_TO_LOWERCASE

	NEXT:
		INC si
		JMP ITERATE

	END_TO_LOWERCASE:

ENDM


copyData MACRO arrayDestination,array_source
	LOCAL COPY
	
	COPY:
		CLD
		LEA si, array_source
		LEA di, arrayDestination
		MOV cx, LENGTHOF arrayDestination - 1
		REP MOVSB

ENDM


limpiarBuffer MACRO buffer
	MOV al, 24h

	LEA di, buffer
	MOV cx, LENGTHOF buffer
	CLD
	REP stosb

ENDM
