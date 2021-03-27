mainMenuView MACRO 

	.DATA
		texto0 DB 0Ah, " UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", 0Ah, " FACULTAD DE INGENIERIA", 0Ah, " ESCUELA DE CIENCIAS Y SISTEMAS $"
		texto1 DB 0Ah, "   POR: Alex Mendez $"
		
        menu0  DB 0Ah, 09h, "  _______         __             _______                       $"
        menu1  DB 0Ah, 09h, " |   |   |.---.-.|__|.-----.    |   |   |.-----..-----..--.--. $"
        menu2  DB 0Ah, 09h, " |       ||  _  ||  ||     |    |       ||  -__||     ||  |  | $"
        menu3  DB 0Ah, 09h, " |__|_|__||___._||__||__|__|    |__|_|__||_____||__|__||_____| $"
                                                          
        menu4  DB 0Ah, 09h, 09h, 09h,  "[1] Carga de Archivo", 0Ah, 09h, 09h, 09h, "[2] Salir", 0Ah,"$"
		menu5  DB 0Ah, 09h, 09h, 09h, "Escoge una Opcion: $"
	

	.CODE
	    limpiarConsola
        imprimir   texto0
        imprimir   texto1
        imprimir   frame
        
        imprimir   menu0
        imprimir   menu1
        imprimir   menu2
        imprimir   menu3
        imprimir   frame

        imprimir   menu4
        imprimir   frame

        imprimir   menu5
        
        menuController

ENDM