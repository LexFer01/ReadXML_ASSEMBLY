# MACROS DE PROPÓSITO GENERAL

## Descripción

En este apartado se encuentran varios macros de propósito general que son utilizada para completar la lógica del ejemplo, poder interactuar con el usuario y macros usados durante durante el análisis. 

Algunas de las macros descrita en este apartado fueron implementados usando la **interrupción (INT) 21h**

---

## Visualización de un carácter en pantalla

> ### Macro

```nasm
imprimirC MACRO character

    MOV ah, 02h
    MOV dl, character
    INT 21h

ENDM   
```

> ### Propósito

**imprimirC:** macro para imprimir o visualizar una carácter en pantalla, el carácter debe de estar en su valor ascii.

> ### Parámetros

| Parámetro | Descripción                        |
| --------- | ---------------------------------- |
| character | carácter  a visualizar en pantalla |

> ### Retorno

```nasm
nada
```

---

## Visualización de una cadena de caracteres en pantalla

> ### Macro

```nasm
imprimir MACRO string

    MOV ah, 09h
    MOV dx, offset string
    INT 21h

ENDM
```

> ### Propósito

**imprimir:** macro para imprimir o visualizar una cadena de caracteres en pantalla, los caracteres deben estar en su valor ascii.

> ### Parámetros

| Parámetro | Descripción                                                            |
| --------- | ---------------------------------------------------------------------- |
| string    | buffer que contiene el conjunto de caracteres a visualizar en pantalla |

> ### Retorno

```nasm
nada
```

--- 

## Entrada o lectura de carácter

> ### Macro

```nasm
leerCaracter MACRO

    MOV ah, 01h     ;; con ECHO
    ; MOV ah, 08h     ;; sin ECHO
    INT 21h

ENDM 
```

> ### Propósito

**leerCaracter:** macro para leer un carácter del dispositivo de entrada, este puede tener dos variantes. 

1. Con Echo: `Mov ah, 01h` , el carácter de entrada se muestra en pantalla o el dispositivo de salida.

2. Sin Echo: `Mov ah, 08h`, el carácter de entrada **no** se muestra en pantalla o el dispositivo de salida.

> ### Parámetros

> ### Retorno

```nasm
AL = 'código ascii del carácter leído'
```

--- 

## Entrada o lectura de una cadena de caracteres

> ### Macro

```nasm
leerCadena MACRO buffer

    LOCAL LEER, FIN
    XOR si, si

    LEER:
        leerCaracter
        CMP al, 13                 ; 0ah->\n (LINE FEED) 0dh-> retorno de carro
            JE FIN

        MOV buffer[si], al
        INC si
        JMP LEER

    FIN:
        MOV buffer[si], 00h

ENDM    
```

> ### Propósito

**leerCadena:** macro para leer una cadena de caracteres del dispositivo de entrada.

> ### Parámetros

| Parámetro | Descripción                                                           |
| --------- | --------------------------------------------------------------------- |
| buffer    | buffer el cual servirá para almacenar la cadena de caracteres leídos. |

> ### Retorno

```nasm
nada
```

--- 

## Limpiar pantalla o consola

> ### Macro

```nasm
limpiarConsola MACRO

    MOV AX,0600H     ;Llamada a la función
    MOV BH,07H         ;color de fondo y color de letra
    MOV CX,0000H     ;coordenadas de inicio
    MOV DX,184FH     ;coordenadas de fin
    INT 10H

ENDM    
```

```nasm
limpiarConsola MACRO

    LOCAL CLEAR
    MOV cx, 15
    CLEAR:
        printChar 0Ah
        LOOP      CLEAR

ENDM
```

> ### Propósito

**clearConsole:** macro para limpiar la consola, para este hay dos soluciones:

1. La primera es usando la interrupción 10h.

2. La segunda es hacer un LOOP imprimiendo saltos de linea. 

> ### Parámetros

> ### Retorno

```nasm
nada
```

--- 

## Convertir una cadena de texto a minúsculas

> ### Nota

Ya que estamos trabajando con los valores ascii de los caracteres es muy sencillo convertir las letras en mayúsculas o minúsculas, basta con observar una tabla de los valores ascii, tomemos por ejemplo las siguientes letras 

| Valor Ascii (decimal) | Letra Mayúscula |     | Valor Ascii (decimal) | Letra Minúscula |
| --------------------- | --------------- | --- | --------------------- | --------------- |
| 65                    | A               |     | 97                    | a               |
| 66                    | B               |     | 98                    | b               |
| 67                    | C               |     | 99                    | c               |
| .<br/>.<br/>.         | .<br/>.<br/>.   |     | .<br/>.<br/>.         | .<br/>.<br/>.   |
| 88                    | X               |     | 120                   | x               |
| 89                    | Y               |     | 121                   | y               |
| 90                    | Z               |     | 122                   | z               |

En conclusión:

- El rango de las letras mayúsculas esta entre [65, 90].

- El rango de las letras minúsculas esta entre [97, 122]

- Para pasar de Mayúscula a Minúscula basta con sumar **32(d)** al valor ascii del carácter. 

- Para pasar de Minúscula  a Mayúscula basta con restar **32(d)** al valor ascii del carácter.

> ### Macro

```nasm
toLowerCase    MACRO string 
    LOCAL ITERATE, NEXT, END_TO_LOWERCASE

    XOR si, si
    MOV cx, LENGTHOF string

    ITERATE:
        CMP string[si], 36
            JE     END_TO_LOWERCASE                ;; jump if string[si] == '$'
        CMP string[si], 65
            JB     NEXT                            ;; jump if string[si] < 65d
        CMP string[si], 90
            JA     NEXT                            ;; jump if string[si] > 90d

        ADD string[si], 32
        INC si

        LOOP     ITERATE
        JMP     END_TO_LOWERCASE

    NEXT:
        INC si
        JMP ITERATE

    END_TO_LOWERCASE:

ENDM
```

> ### Propósito

**toLowerCase:** macro que convierte una cadena de letras a minúsculas, modificando la misma cadena o buffer que es pasado.

> ### Parámetros

| Parámetro | Descripción                                          |
| --------- | ---------------------------------------------------- |
| string    | cadena de texto o buffer para convertir a minúsculas |

> ### Retorno

```nasm
nada
```

--- 

## Comparar dos cadenas de caracteres o buffer's

> ## Algo de teoría

Para poder manipular bloques de datos hay instrucciones primitivas que nos permite manejar o procesar de forma fácil arrays de *bytes*, *words* y *double words*. 

#### COMPARE (CMPSB, CMPSW, CMPSD)

Esta instrucción primitiva nos ayuda a comparar el contenido de de dos posiciones de memoria direccionadas o indexadas por los registros **SI** (8 y 16 bits) o **ESI** (32 bits) y **DI**(8 y 16 bits) o **EDI** (32 bits). 

| INSTRUCCIÓN | DESCRIPCIÓN           |
| ----------- | --------------------- |
| CMPSB       | comparar bytes        |
| CMPSW       | comparar words        |
| CMPSD       | comparar double words |

Ambos registros, **SI** o **ESI** y **DI** o **EDI**, se incrementan de forma automática.

En esta macro aparece el nenómico `REP` de repetición. 

El prefijo de repetición le permite procesar un array completa usando una sola instrucción. Se pueden utilizar los siguientes prefijos de repetición:

| INSTRUCCIÓN  | DESCRIPCIÓN                                                                                                                          |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| REP          | repetir mientras **CX > 0**<br/> repetir mientras **ECX > 0**<br/>                                                                   |
| REPE, REPZ   | repetir mientras la bandera **Z = 1**  Y **CX > 0** (8 y 16 bits)<br/>repetir mientras la bandera **Z = 1** Y **ECX > 0**  (32 bits) |
| REPNE, REPNZ | repetir mientras la bandera **Z = 0** Y **CX > 0** (8 y 16 btis)<br/>repetir mientras la bandera **Z = 0** Y **ECX > 0** (32 btis)   |

> ### Macro

```nasm
compararCadenas MACRO string, string2

    LEA  si, string
    LEA  di, string2
    MOV  cx, LENGTHOF string
    REPE CMPSB

ENDM    
```

> ### Propósito

**compareString:** comparar el contenido entre dos cadenas o buffer's, la comparación lo realiza a través del valor ascii de cada carácter, tener en cuenta que la comparación es debe ser de dos arrays de tipo *byte.*

> ### Parámetros

| Parámetro | Descripción                        |
| --------- | ---------------------------------- |
| string    | primera cadena o buffer a comparar |
| string2   | segunda cadena o buffer a comparar |

> ### Retorno

Si las cadenas son iguales

```nasm
ZF(zero flag) = 1
```

Si las cadenas **No** son iguales

```nasm
ZF(zero flag) = 0
```

--- 

## Comparar dos cadenas de caracteres o buffer's case-insensitive

> ### Macro

```nasm
compararIngorandoCase MACRO string, string2

    toLowerCase     string
    toLowerCase     string2
    compareString     string, string2

ENDM    
```

> ### Propósito

**compararIngorandoCase:** comparar el contenido entre dos cadenas o buffer's de forma case-insensitive, para lograrlo se opto deliberadamente por modificar ambas cadenas o buffer's y convertirlas ambas a minúsculas,  la comparación lo realiza a través del valor ascii de cada carácter. 

> ### Parámetros

| Parámetro | Descripción                        |
| --------- | ---------------------------------- |
| string    | primera cadena o buffer a comparar |
| string2   | segunda cadena o buffer a comparar |

> ### Retorno

Si las cadenas son iguales

```nasm
ZF(zero flag) = 1
```

Si las cadenas No son iguales

```nasm
ZF(zero flag) = 0
```

--- 

## Copiar el contenido de una buffer a otro buffer

> ### Algo de teoría

Anteriormente se menciono de las instrucciones para manipular de forma fácil bloques de de memoria, es decir arrays. 

#### MOVES (MOVSB, MOVSW, MOVSD)

Para esta macro se volvió a usar una de esas intrucciones el cual nos ayuda a copiar data o información que esta indexada por el registro **SI** (8 y 16 bits) o **ESI** (32 bits), hacia  la posición que esta  indexada por el registro **DI** (8 y 16 bits) o **EDI** (32 bits).

| INSTRUCCIÓN | DESCRIPCIÓN                 |
| ----------- | --------------------------- |
| MOVSB       | mover (copiar) bytes        |
| MOVSW       | mover (copiar) words        |
| MOVSD       | mover (copiar) double words |

Ambos registros, **SI** o **ESI** y **DI** o **EDI**, se incrementan o disminuye de forma automática, dependiendo del la bandera dirección

| INSTRUCCION | SIGNIFICADO          | VALOR DE LA BANDERA DIRRECCION | EFECTO SOBRE SI/ESI y DI/EDI | DIRRECCION     |
| ----------- | -------------------- | ------------------------------ | ---------------------------- | -------------- |
| CLD         | clear direction flag | clear (0)                      | Incrementar                  | hacia adelante |
| STD         | set direction flag   | set (1)                        | Decrementar                  | hacia atrás    |

Nuevamente aparece el nemónico `REP` , anteriormente explicado, pero recordenemo que lo podemos usar de las siguientes maneras

| INSTRUCCIÓN  | DESCRIPCIÓN                                                                                                                          |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| REP          | repetir mientras **CX > 0** (8 y 16 bits)<br/> repetir mientras **ECX > 0** (32 bits)<br/>                                           |
| REPE, REPZ   | repetir mientras la bandera **Z = 1**  Y **CX > 0** (8 y 16 bits)<br/>repetir mientras la bandera **Z = 1** Y **ECX > 0**  (32 bits) |
| REPNE, REPNZ | repetir mientras la bandera **Z = 0** Y **CX > 0** (8 y 16 btis)<br/>repetir mientras la bandera **Z = 0** Y **ECX > 0** (32 btis)   |

> ### Macro

```nasm
copyData MACRO arrayDestination,array_source
    LOCAL COPY

    COPY:
        CLD
        LEA si, array_source
        LEA di, arrayDestination
        MOV cx, LENGTHOF arrayDestination - 1
        REP MOVSB

ENDM   
```

> ### Propósito

**copyData:** macro para copiar una cantidad de caracteres iniciando desde la posición 0 de un buffer de partida a un buffer destino. 

Esto lo hace copiando el byte de una dirección de memoria indexada por el registro `SI` haca otra dirección de memoria indexada por el registro `DI`

> ### Parámetros

| Parámetro         | Descripción                                            |
| ----------------- | ------------------------------------------------------ |
| array_destination | buffer de destino, donde se copiaran los caracteres    |
| array_source      | buffer de partida, del cual se copiaran los caracteres |
| quantity          | cantidad de caracteres a copiar                        |

> ### Retorno

```nasm
nada
```

--- 

## Limpiar el contenido de un buffer

> ### Algo de teoría

Para esta macro nuevamente se volvió a usar una de esas intrucciones que nos permite manipular arrays. 

#### **SOTORAGE (STOSB, STOSW, STOSD)**

Esta instrución nos permite almacenar  el contenido de `AL/AX/EAX`, respectivamente a un espacio de memoria direccionada o indexada por el registro **DI** (para 8 y 16 bits) o el el registro **EDI**  (para 32 bits)

| INSTRUCCIÓN | DESCRIPCIÓN          |
| ----------- | -------------------- |
| STOSB       | guardar bytes        |
| STOSW       | guardar words        |
| STOSD       | guardar double words |

Ya se el registro **DI** o **EDI**, se incrementan o disminuye de forma automática, dependiendo del la bandera dirección

| INSTRUCCION | SIGNIFICADO          | VALOR DE LA BANDERA DIRRECCION | EFECTO SOBRE SI/ESI y DI/EDI | DIRRECCION     |
| ----------- | -------------------- | ------------------------------ | ---------------------------- | -------------- |
| CLD         | clear direction flag | clear (0)                      | Incrementar                  | hacia adelante |
| STD         | set direction flag   | set (1)                        | Decrementar                  | hacia atrás    |

Nuevamente aparece el nemónico `REP` , anteriormente explicado, pero recordemos que lo podemos usar de las siguientes maneras

| INSTRUCCIÓN  | DESCRIPCIÓN                                                                                                                          |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| REP          | repetir mientras **CX > 0** (8 y 16 bits)<br/> repetir mientras **ECX > 0** (32 bits)<br/>                                           |
| REPE, REPZ   | repetir mientras la bandera **Z = 1**  Y **CX > 0** (8 y 16 bits)<br/>repetir mientras la bandera **Z = 1** Y **ECX > 0**  (32 bits) |
| REPNE, REPNZ | repetir mientras la bandera **Z = 0** Y **CX > 0** (8 y 16 btis)<br/>repetir mientras la bandera **Z = 0** Y **ECX > 0** (32 btis)   |

> ### Macro

```nasm
limpiarBuffer MACRO buffer
    MOV al, 24h

    LEA di, buffer
    MOV cx, LENGTHOF buffer
    CLD
    REP stosb

ENDM
```

> ### Propósito

**limpiarBuffer:** macro para limpiar el contenido de un buffer iniciando desde la posición 0, lo que hace es colocar el carácter de fin de cadena (**$**) en todas las pociones del buffer

> ### Parámetros

| Parámetro | Descripción      |
| --------- | ---------------- |
| buffer    | buffer a limpiar |

> ### Retorno

```nasm
nada
```
