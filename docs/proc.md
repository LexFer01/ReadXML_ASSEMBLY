# PROCEDIMIENTOS

## Descripción

En este apartado se encuentran los procedimientos  usados para el desarrollo del ejemplo. 

--- 

## Procedimientos declarados en archivo *main.asm*

### Main

> #### Proc

```nasm
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
```

> #### Propósito

**main:** procedimiento principal, el cual es llamado al ejecutarse el programa.

---

### Limpiar Registros

> #### Proc

```nasm
limpiarRegistros PROC
        XOR ax, ax
        XOR bx, bx
        XOR cx, cx
        XOR dx, dx
        XOR si, si
        XOR di, di
        ret
limpiarRegistros ENDP
```

> #### Propósito

**limpiarRegistros:** procedimiento para limpiar los registros mas usados. 

---

### Respaldar la información de los registros

> #### Proc

```nasm
.data
    axBk DW ?
    bxBK DW ?
    cxBK DW ?
    dxBk DW ?
    siBk DW ?
    diBk DW ?

.code
    respaldo PROC

        MOV axBk, ax
        MOV bxBk, bx
        MOV cxBk, cx
        MOV dxBk, dx
        MOV siBk, si
        MOV diBk, di
        ret

    respaldo ENDP
```

> #### Propósito

**respaldo:** procedimiento para respaldar el contenido de los registros en memoria, esto debido a que algunas macros hacen una limpieza de algunos de ellos, por lo tanto, antes de de ser llamados es necesario hacer un respaldo y no perder la información. 

Este procedimiento se usa mas durante el análisis. 

---

### Restaurar la información de los registros

> #### Proc

```nasm
.data
    axBk DW ?
    bxBK DW ?
    cxBK DW ?
    dxBk DW ?
    siBk DW ?
    diBk DW ?

.code
    restaurar PROC

        MOV ax, axBk
        MOV bx, bxBk
        MOV cx, cxBk
        MOV dx, dxBk
        MOV si, siBk
        MOV di, diBk
        ret

    restaurar ENDP
```

> #### Propósito

**restaurar:** procedimiento para restaurar el contenido de los registros que se encuentra en memoria. 

Este procedimiento se usa mas durante el análisis.

--- 

## Procedimientos declarados en archivo *analysis.asm*

### Leer Nombre

> #### Proc

```nasm
leerNombre PROC
    XOR di, di 

    L1:
        CALL siguienteCaracter

        CMP  bl, 60                        ;; if bl == '<'
         JE  L2 
        CMP  bl, 32                        ;; if bl == ' '
         JE  L1 

        MOV bufferNombre[di], bl
        INC di

        JMP L1 

    L2: 
        ret
leerNombre ENDP
```

> #### Propósito

**leerNombre:** procedimiento para almacenar el nombre ignorado los espacios, luego de encontrar la etiqueta `<name>` durante la lectura y análisis del archivo xml.

---

### Leer Carnet

> #### Proc

```nasm
leerCarnet PROC
    XOR di, di 

    L1:
        CALL siguienteCaracter

        CMP  bl, 60                        ;; if bl == '<'
        JE  L2 
        CMP  bl, 45                        ;; if bl == '-'
         JE  L1
        MOV bufferRegistro[di], bl
        INC di

        JMP L1 

    L2: 
        ret
leerCarnet ENDP
```

> #### Propósito

**leerCarnet:** procedimiento para almacenar el carnet en el ignorado los guiones (-), luego de encontrar la etiqueta `<idcard>` durante la lectura y análisis del archivo xml.

### Obtener siguiente Carácter

> #### Proc

```nasm
siguienteCaracter PROC
    INC si
    MOV bl, buffer[si]
    ret 
siguienteCaracter ENDP
```

> #### Propósito

**siguienteCaracter:** procedimiento para obtener el siguiente carácter, del buffer que contiene todo el contenido del archivo  durante el análisis del archivo
