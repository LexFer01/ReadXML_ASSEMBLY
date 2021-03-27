fileLoadView MACRO

	.DATA
		loadFile0 	DB 0Ah, 09h, " _____                     __       _______  __  __         $"
		loadFile1 	DB 0Ah, 09h, "|     |_ .-----..---.-..--|  |     |    ___||__||  |.-----. $"
		loadFile2 	DB 0Ah, 09h, "|       ||  _  ||  _  ||  _  |     |    ___||  ||  ||  -__| $"
		loadFile3 	DB 0Ah, 09h, "|_______||_____||___._||_____|     |___|    |__||__||_____| $"
                                                       

	.CODE
		limpiarConsola
		imprimir loadFile0
		imprimir loadFile1
		imprimir loadFile2
		imprimir loadFile3
        imprimir frame

        fileLoadController

ENDM