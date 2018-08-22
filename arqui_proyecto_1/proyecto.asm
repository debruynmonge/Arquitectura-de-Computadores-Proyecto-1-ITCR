;proyecto 1 arquitectura de Computadores
%include "linux64.inc"

section .data
; aqui se definen las varibles inicializadas
archconf db "configuracion.txt",0	;nombre del archivo con texto
archdat db "archivo.txt",0		;nombre del archivo con los datos
textordnotas db "--------El archivo a sido ordenado--------/n----------de acuerdo a las notas obtenidas-----------",0
textordalfa db "--------El archivo a sido ordenado--------/n----------Por orden alfabetico-----------",0
voyaqui db "voy por aqui",0
iguales db "son iguales",0
f1esmenor db "f1 es menor",0
f1esmayor db "f1 es mayor",0



ttc equ 140    ;almacena ttc= tamaño de texto de configuracion
ttd equ 950	; almacena tad =tamaño de texto con datos
contadorfilas db 0d
byteactualcopia dw 0d
bubletimes dw 0d

section .bss
;aqui se definen las variables no inicializadas

textconf resb 140 ; Guarda el archivo de texto del configuracion
textdat resb 950  ;Guarda el archivo de texto con los datos
numcolum resb 2	  ; Almacena el  numero de columnas del Histograma
numfil resb 2	 ; Almacena el numero de filas del histograma
textdatcopia resb 150  ;Guarda una copia del archivo de texto para poder ordenarlo


;Las siguientes variables pertenecen a informacion del archivo configuracion
	nda resb 3 ;esta variable almacena la nda= nota de aprobacion
	ndr resb 3 ;esta variabla almacena la ndr = nota de  reposicion
	tdgn resb 3 ; almacena  el tdgn =tamaño de los grupos de notas
	edg resb 3 ;esta variable almacena la edg = escala del grafico
	tdo resb 2; esta variable almacena el tdo = tipo de ordenamiento

;Variables para el ordenamiento
	iniciof1 resb 2
	iniciof2 resb 2
	finalf1 resb 2
	finalf2 resb 2
	byteactual resb 2
	var1 resb 1
	var2 resb 1
	byteiniciocopia1 resb 2
	bytefinalcopia1 resb 2
        byteiniciocopia2 resb 2
        bytefinalcopia2 resb 2
	dif1 resb 2
	linea1 resb 2
	linea2 resb 2


section .text
	global _start
	_start:    ; aqui comienza el programa


	;-----------------Leer el archivo de configuracion----------------------

	; Abriendo el archivo
		mov rax, SYS_OPEN
		mov rdi, archconf
		mov rsi, O_RDONLY
		mov rdx, 0
		syscall

	;Leyendo el  archivo
		push rax
		mov rdi, rax
		mov rax, SYS_READ
		mov rsi, textconf
		mov rdx,ttc
		syscall

	;cerrando el archivo
		mov rax, SYS_CLOSE
		pop rdi
		syscall


	;Imprimir texto leido
		print textconf

	;extraer informacion del texto leido
		;leyendo nota de aprobación
		mov ax,[textconf+21] ; almacena en ax el contenido de la direccion
		mov word [nda], ax	; almacena en nda el contenido de ax
		;leyendo nota de  reposición
                mov ax,[textconf+45]
                mov word [ndr], ax
		;leyendo el tamaño de los grupos de notas
                mov ax,[textconf+80]
                mov word [tdgn], ax
		;leyendo Escala del gráfico
                mov ax,[textconf+105] ; almacena en ax el contenido de la direc$
                mov word [edg], ax   ; almacena en edg el contenido de ax
		;leyendo Tipo de Ordenamiento
                mov al,[textconf+122] ; almacena en ax el contenido de la direc$
                mov byte [tdo], al   ; almacena en tdo el contenido de ax





        ;-----------------Leer el archivo de datos----------------------

        ; Abriendo el archivo
                mov rax, SYS_OPEN
                mov rdi, archdat
                mov rsi, O_RDONLY
                mov rdx, 0
                syscall

        ;Leyendo el  archivo
                push rax
                mov rdi, rax
                mov rax, SYS_READ
                mov rsi, textdat
                mov rdx,ttd
                syscall

        ;cerrando el archivo
                mov rax, SYS_CLOSE
                pop rdi
                syscall

	; imprimir texto con datos
		print textdat

	;------------------------------------------------ordenando el texto--------------------------------------------
	; algoritmo bubble sort
bublesort1:
	;Paso 1; identificar donde comienza fila 1
		cmp byte [contadorfilas], 0d  ; si la fila es la numero cero, se entiende que comienza en el byte 0 del texto
		jne filaceroNO
		;--------fila cero Si--------
		mov word [iniciof1],0d
		mov word [byteactual],0d
		jmp lugarbyte
filaceroNO:   mov word ax,[iniciof2]
		mov word [iniciof1],ax

lugarbyte:	mov word ax, [byteactual]   ;carga en ax  el byte actual
		cmp byte [textdat+rax],10d  ; es el byte actual igual a enter
		je Efinalf1
		;incrementa en 1 el byte actual
		mov word ax, [byteactual]
		inc ax
		mov word [byteactual],ax
		jmp lugarbyte


Efinalf1:	 mov word ax,[byteactual] ; almacena el byte donde finaliza la fila 1
		mov word [finalf1],ax
		;incrementar el contador de fila en 1
		mov word dx,[contadorfilas]
		inc dx
		mov word [contadorfilas],dx

		;Establecer el inicio de la fila 2
		inc ax
		mov word [iniciof2],ax
		mov word [byteactual],ax

		;Comparar el byte actual para saber si es un enter
lugarbyte2:	mov word ax, [byteactual]    ;almacena en ax el byte actual
		cmp  byte [textdat+rax],10d   ;compara si el byte actual es un enter
		je Efinalf2
		;se incrementa en 1 el byte actual
		inc ax
		mov word [byteactual],ax
		jmp lugarbyte2

Efinalf2:       ;Almacenando la direccion del final de la fila f2
		mov word ax, [byteactual]
		inc ax
		mov word [finalf2],ax


		;-----------Determina el tipo de ordenamiento---------------
		cmp word [tdo], 97d  ; compara si el tipo de ordenamiento comienza con a de alfabetico
		je ordenalfa
		print textordnotas




		;---------------------ordenamiento por notas-----------------
		;Paso 1 Leer el la fila e identificar donde comienza y donde ter


		jmp finordenamiento
		; ordenamiento alfabetico




ordenalfa:
		;guardar el inicio general de la linea
                mov word r8w,[iniciof1]
                mov word [linea1], r8w
                mov word r8w,[iniciof2]
                mov word [linea2], r8w
		mov word r9w,[linea1]


alfabetico:	mov word ax,[iniciof1] ;almacena en ax los byte de inicio de la fila 1
		mov word bx,[iniciof2] ;almacena en bx los byte de inicio de la fila 2
		mov byte cl, [textdat+rax] ;carga en cl el dato en la fila 1
		mov byte dl, [textdat+rbx] ;carga en dl el dato en fila 2
		mov byte [var1],cl
		mov byte [var2],dl
		;print var1
		;print var2

prueba1:



		;Determinando si el la letra de la fila 1 es mayor que la letra de la fila 2
		;f1>f2
comparacion:	mov byte cl, [var1]
		mov byte dl, [var2]
		cmp byte cl,dl
		jg f1mayorf2
		mov byte cl,[var1]
		mov byte dl,[var2]
		cmp byte dl,cl
		jg f1menorf2
		;Ambas letras son iguales, se incrementea
		; el byte de inicio de ambas filas
		;incrementando byte de inicio fila 1
		mov word ax, [iniciof1]
		inc ax
		mov word [iniciof1],ax
		;incrementando byte de inicio fila 2
		mov word ax,[iniciof2]
		inc ax
		mov word [iniciof2],ax
		jmp alfabetico  ;salta al inicio de las comparaciones

	;Caso cuando  f1 mayor a f2
f1mayorf2:
		;Copiando la linea en orden
                ;Almacenando la direccion en la nueva variable
                ;Almacena el limite final de la fila que se va a copiar
                mov word ax,[finalf2]
                mov word [bytefinalcopia1],ax
                ;Almacena el limite inicial de la fila que se va a copiar
                mov word ax,[linea2]
                mov word [byteiniciocopia1],ax

		;Almacenando la direccion en la nueva variable
                ;Almacena el limite final de la fila que se va a copiar
                mov word ax,[finalf1]
                mov word [bytefinalcopia2],ax
                ;Almacena el limite inicila de la fila que se va a copiar
                mov word ax,[linea1]
                mov word [byteiniciocopia2],ax


		jmp copiarfilas


	;Caso cuando f1 menor que f2
f1menorf2:

		;Copiando la linea en orden
		;Almacenando la direccion en la nueva variable
		;Almacena el limite final de la primer fila que se va a copiar
		mov word ax,[finalf1]
		mov word [bytefinalcopia1],ax
		;Almacena el limite inicial de la fila que se va a copiar
		mov word ax,[linea1]
		mov word [byteiniciocopia1],ax


		;Almacena el limite final de la segunda fila que se va a copiar
                mov word ax,[finalf2]
                mov word [bytefinalcopia2],ax
                ;Almacena el limite inicial de la fila que se va a copiar
                mov word ax,[linea2]
                mov word [byteiniciocopia2],ax








copiarfilas:



		;Calcular diferencia
           	 ;cargar en ax el bytfinalcopia1
		mov word ax, [bytefinalcopia1]
		mov word bx,[byteiniciocopia1]
		sub  ax,bx
		mov word [dif1],ax







copiaf1:	;Copiar  el dato
		mov word bx, [byteiniciocopia1] ;cargar numero de byte a copiar
		mov byte al,[textdat+rbx]  ;extrer el byte a copiar
		mov word bx,[byteactualcopia]  ;cargar la direccion donde se va a copiar
		mov byte [textdatcopia+rbx],al  ;copia el byte en la nueva variable



		;Incrementar el byte acual copia
		mov word ax, [byteactualcopia]
		inc ax
		mov word [byteactualcopia],ax
		;Incrementar el byte de inicio copia 1

                mov word ax, [byteiniciocopia1]
                inc ax
                mov word [byteiniciocopia1],ax


		;comparar para saber si llego al final de la linea
		;cargar dif en registro
		mov word [dif1], ax
		cmp ax, [bytefinalcopia1]; compara dif y el bytefinalcopia1
		jb copiaf1




		;Calcular diferencia 2
		mov word ax,[bytefinalcopia2]
		mov word bx,[byteiniciocopia2]
		sub ax,bx
		;calcular el nuevo dif1
		add ax,[dif1]
		mov word [dif1],ax


copiaf2:        ;Copiar  el dato
                mov word bx, [byteiniciocopia2] ;cargar numero de byte a copiar
                mov byte al,[textdat+rbx]  ;extrer el byte a copiar
                mov word bx,[byteactualcopia]  ;cargar la direccion donde se va$
                mov byte [textdatcopia+rbx],al  ;copia el byte en la nueva vari$



                ;Incrementar el byte acual copia
                mov word ax, [byteactualcopia]
                inc ax
                mov word [byteactualcopia],ax

		;Incrementar el byte de inicio copia 2

                mov word ax, [byteiniciocopia2]
                inc ax
                mov word [byteiniciocopia2],ax


                ;comparar para saber si llego al final de la linea
                ;cargar dif en registro
                mov word [dif1], ax
                cmp ax, [bytefinalcopia2]; compara dif y el bytefinalcopia1
                jb copiaf2



;-------------------Remplazar la copia en el archivo original------------------
remplazo:
	;cargar la direccion donde se va a sobre escribir
		mov word bx,[linea1]
	;cargar el hasta donde se va a sobrescribir
		mov word cx,[finalf2]
	;calcular el numero de bytes que hay que copiar
		sub cx,bx
		mov word [dif1],cx
	;el regitro ax va a almacenar la cantidad de bytes ya copiados
		mov word ax,0d
traspaso:	;traspasar el dato
		mov byte r13b,[textdatcopia+rax]
		mov byte [textdat+rax],r13b
		;incrementa ax
		inc ax
		;compara si ax llego al final de la copia
		cmp word ax,[byteactualcopia]
		jne traspaso

;-----------limpiar byte de posicion en textdat copia---------------------
                mov word [byteactualcopia],0d

print textdat

; Realiza el primer reamplazo de forma exitosa
;-------------------------hasta aqui todo bien---------------------------


finalcopiarfila:;------------------------------Verificar que el contador de bytes sea menor que el final del archivo----------------
		;-------aqui abajo hay un error-------------------
		mov word ax,[bytefinalcopia2]
		cmp ax,ttd
		jne bublesort1













		;mov word ax,[bubletimes]
		;inc ax
		;mov word [bubletimes],ax
		;mov word bx,[contadorfilas]
		;cmp ax,bx ;contadorfilas=bubletimes?
		;mov word [contadorfilas],0d
		;mov word [byteactual],0d
		;print textdat
		;jne bublesort1












finordenamiento:




		;-------------------------------------Tratando informacion extraida del archivo de configuracion---------------------------
		;Determinando el numero de  columnas del histograma (grupos de notas)
		;print nda
		;print ndr
		;print tdgn
		;print edg
		;print tdo





        ;--------------------------------leer archivo con datos----------------------------------------------


	 .finalprograma: ; codigo para finalizar correctamente el programa
			; y solucionar el segmentation fault

			mov rax,60	;cargando la llamada 60d(sys_exit)
			mov rdi,0	;cargando 0 en rdi
			syscall		;llamando al sistema operativo


