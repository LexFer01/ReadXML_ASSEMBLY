# MANEJO DE ARCHIVOS

## Descripción

En este apartado se encuentra la macros utilizadas para el manejo de archivos, para la implementación de estas macros se utilizó la **interrupción (INT) 21h**

--- 

## Abrir un Archivo

> ### Macro

```nasm
abrirArchivo MACRO path, handle

    LOCAL ERROR, FIN

    MOV ah, 3dh
    MOV al, 10b
    LEA dx, path
    INT 21h
    MOV handle, ax
    JC    ERROR 
    JNC    FIN

    ERROR:
        imprimir errorOpenFile
        JMP MAIN_MENU

    FIN:

ENDM
```

> ### Propósito

**abrirArchivo:** Mediante esta macro se abre un fichero ya existente, y se almacena un manejador del archivo para poder escribir o leer el fichero posteriormenten.

> ### Parámetros

| Parámetro | Descripción                                                                                  |
|:--------- |:-------------------------------------------------------------------------------------------- |
| path      | ruta donde se encuentra el archivo a abrir.                                                  |
| handle    | variable donde se almacenara el manejador de 16bits para accerder posteriormente al archivo. |

***

## Cerrar un Archivo

> ### Macro

```nasm
cerrarArchivo MACRO handle

    LOCAL ERROR, FIN

    MOV ah, 3eh
    MOV handle, bx
    INT 21h
    JC  ERROR 
    JNC FIN

    ERROR:
        imprimir errorCloseFile
        JMP MAIN_MENU

    FIN:

ENDM
```

> ### Propósito

**cerrarArchivo:** Mediante esta macro se cierra un fichero que estuviera abierto. Se utiliza el Handle para indicar el fichero a cerrar. Tras cerrar el fichero, dicho Handle se libera para nuevos ficheros. 

> ### Parámetros

| Parámetro | Descripción                      |
|:--------- |:-------------------------------- |
| handle    | manejador de  archivo de 16bits. |

*****

## Lectura de un Archivo

> ### Macro

```nasm
leerArchivo MACRO buffer, size, handle
    LOCAL ERROR, FIN

    MOV ah, 3fh
    MOV bx, handle
    MOV cx, size
    LEA dx, buffer
    INT 21h
    JC     ERROR 
    JNC FIN

    ERROR:
        imprimir errorReadFile
        JMP MAIN_MENU

    FIN:

ENDM
```

> ### Propósito

**leerArchivo:** Dado un handle válido, se realiza una transferencia desde el fichero referenciado por el handle hacia el buffer de memoria especificado mediante DS:DX. Se transferirán tantos caracteres como se especifique en CX. Acto seguido, se actualiza el puntero de fichero hasta el carácter que sigue al bloque leído. Mediante esta función es posible leer caracteres del teclado, usando el handle 0.

> ### Parámetros

| Parámetro | Descripción                                                      |
|:--------- |:---------------------------------------------------------------- |
| buffer    | buffer donde se almacenará el contenido del fichero              |
| size      | cantidad de caracteres que se transferirán del archivo al buffer |
| handle    | manejador del archivo del cual se leerá                          |
