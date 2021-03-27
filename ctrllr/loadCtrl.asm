fileLoadController MACRO
	
	.data
		manejador	  	DW ?
		bufferRuta    	DB 0100 DUP('$'), 0
		bufferContenido DB 9999 DUP('$'), '$'

		msg1  	DB 0Ah, 0Ah, 09h, "Ingrese la ruta del archivo: ", 0Ah, " > $"
		msg2	DB 0Ah, 0Ah, 09h, "Archivo Leido Satisfactoriamente!! $"


	.code
		imprimir 		msg1
		leerCadena 		bufferRuta

		abrirArchivo 	bufferRuta, manejador
		leerArchivo		bufferContenido, SIZEOF bufferContenido, manejador
		cerrarArchivo	manejador

		analisis 		bufferContenido

		imprimir 		msg2

		leerCaracter
        JMP     	MAIN_MENU  
	
ENDM
