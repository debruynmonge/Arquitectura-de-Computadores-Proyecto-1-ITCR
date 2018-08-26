;proyecto 1 arquitectura de Computadores
%include "linux64.inc"

section .data
; aqui se definen las varibles inicializadas
archconf db "configuracion.txt",0	;nombre del archivo con texto
archdat db "archivo.txt",0		;nombre del archivo con los datos
voyaqui db "voy por aqui",10




section .bss
; aqui se se reservan espacios para variables sin definir tu valor inicial

textconf resb 150 ; reserva espacio para el texto de configuracion
textdat resb 1000 ; reserva espacio para el texto de datos
ttc resb 150  ; reserva espacio para almacenar el texto de configuracion
ttd resb 1000 ; reserva espacio para almacenar el texto con los datos

byteactual resw 1
finalf1 resw 1
iniciof1 resw 1
iniciof2 resw 1
finalf2 resw 1


bytefinaltext resw 1
contadorletras resw 1
copiadorfilas resw 1

sizef1 resw 1
sizef2 resw 1

bubletimes resw 1
contadorfilas resw 1


arraynotas resb 100
arrayestudiantes resb 100

nota resb 1



;Las siguientes variables pertenecen a informacion del archivo configuracion
	nda resb 3 ;esta variable almacena la nda= nota de aprobacion
	ndr resb 2 ;esta variabla almacena la ndr = nota de  reposicion
	tdgn resb 2 ; almacena  el tdgn =tamaño de los grupos de notas
	edg resb 2 ;esta variable almacena la edg = escala del grafico
	tdo resb 1; esta variable almacena el tdo = tipo de ordenamiento

	letra1 resb 1
	letra2 resb 1
	copiafila1 resb 40
	copiafila2 resb 40



;variables histograma
	canty resw 1
	cantx resw 1
	edgb resb 1
	residuoy resb 1
	residuox resb 1
	tdgnb resb 1


section .text
	global _start
	_start:		;aqui inicia el programa


	;--------------leer el archivo de configuracion---------------------
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
                mov word [ndr],ax
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


mov word [bubletimes],0d
limpiarvariables:
;limpiar variables a utilizar
mov word [byteactual],0d
mov word [iniciof1],0d
mov word [finalf1],0d
mov word [iniciof2],0d
mov word [finalf2],0d

mov word [bytefinaltext],900d
mov word [contadorletras],0d
mov word [copiadorfilas],0d
mov word [sizef1],0d
mov word [sizef2],0d
mov word [contadorfilas],1d




bublesort:


	;Determinar el inicio y el final de la fila 1
	; cargar letra actual
        mov word bx,[byteactual]
	mov byte al, [textdat +rbx ]

	;Copiar letra actual en direccion copiafila1+copiadorfilas
		mov word r10w,[copiadorfilas]
		mov byte [copiafila1+r10],al

	;incrementar copiador filas
		add word r10w,1d
		mov word [copiadorfilas],r10w

        ; Almacena  byteactual en final fila 1
                mov word cx,[byteactual]
		mov word  [finalf1], cx

	; incrementa el byte actual
		mov word [byteactual],cx
		add word cx, 1d
		mov word [byteactual],cx


	;Es letra actual igual a enter?
		cmp byte al,10d ; compara letra actual
		jne bublesort

	;Guardar copiador filas en tamañofila 1
		mov word r9w,[copiadorfilas]
		mov word [sizef1],r9w

	;limpiar copiador filas
		mov word [copiadorfilas],0d

	;Almacenar byte actual en inicio de fila 2

		mov word [iniciof2],cx

;incrementa contador filas
mov word r11w,[contadorfilas]
add word r11w, 1d
mov word [contadorfilas],r11w



	; cargar letra actual
Efila2:		mov word ax,[byteactual]
		mov byte bl,[textdat+rax]

	;Copiar letra actual en  direccion copiafila2+copiadorfilas
		mov word r8w,[copiadorfilas]
		mov byte [copiafila2+r8],bl

	;incrementar copiador de filas
		add word r8w,1d
		mov word [copiadorfilas],r8w

	;Almacenar en final fila 2 el byte actual
		mov word [finalf2],ax
	;Incrementar byte actual
		add word ax,1d
		mov word [byteactual],ax

mov byte r14b,bl

;es la letra siguiente igual al final del archivo?

        mov byte r13b,[textdat+rax]
        cmp byte r13b,0d
        jne igualenter
;si la siguiente letra es igual al final entonces almacena el byteactual
        mov word  [bytefinaltext],ax
	mov word [bytefinaltext],ax


        ; Es letra actual igual a enter?
igualenter:
		 cmp byte bl,10d
                jne Efila2







antesdeordenamiento:
	;Guardar copiadorfila en tamaño de fila 2
		mov word r8w,[copiadorfilas]
		mov word [sizef2],r8w

	;limpiar copiador filas
		mov word [copiadorfilas],0d



	;-----------------------ordenamiento---------------
ordenamiento:
	;Es tipo de ordenamiento alfabetico
	mov byte [tdo],al
	cmp byte al,97d
	je alfabetico

;------------------------- tipo de ordenamiento por  notas-----------------








;--------------------------tipo de ordenamiento alfabetico-------------
alfabetico:

	;cargar en letra1 lo que esta en la direccion textdat+iniciof1+ contadorletras
		mov word ax,[iniciof1]
;aqui hay un error segun el debugeer
		add word ax,[contadorletras]
		mov byte cl,[textdat+rax]
		mov byte [letra1],cl
	;Cargar en letra 2 lo que esta en el textdat+iniciof2+contadorletras
                mov word ax,[iniciof2]
                add word ax,[contadorletras]
                mov byte cl,[textdat+rax]
                mov byte [letra2],cl


	;incrementar contador letras
		mov word dx,[contadorletras]
		add word dx,1d
		mov word [contadorletras],dx

	;Es letra1 igual a letra2
		mov byte al,[letra1]
		mov byte bl,[letra2]
		cmp byte al,bl
		je alfabetico


	;limpiar contador letras
		mov byte [contadorletras],0d

	;limpiar copiador letras
		mov byte [copiadorfilas],0d


	;es letra1 mayor a letra2?
		jg  letra1mayor




	;------------letra1 es menor a letra 2------------
	; iniciof1=iniciof2
	mov word r12w,[iniciof2]
	mov word [iniciof1],r12w

	;byteactual=iniciof2
	mov word [byteactual],r12w

	;Salto  a final del remplazo
	jmp finaldelremplazo

	;------------------------letra 1 es mayor que letra 2----------
letra1mayor:
	;copiar fila 2 en textdat
	;cargar en al lo que esta en copiafila2+copiadorfilas
		mov word bx,[copiadorfilas]
		mov byte al,[copiafila2+rbx]

	;Copiar al en direccion textdat+iniciof1+copiadorfilas
		add word bx,[iniciof1]
		mov byte [textdat+rbx],al

	;incrementar copiador filas
		mov word dx,[copiadorfilas]
		add word dx,1d
		mov word [copiadorfilas],dx

	; Es copiador filas mayor a tamaño fila 2?
		mov word ax,[sizef2]
		cmp word dx,ax
		jb letra1mayor

	;actualizar byte actual byteactual=iniciof1+sizef2+1 o = iniciof1+copiadorfilas +1
		mov word ax,[copiadorfilas]
		add ax,[iniciof1]
		mov word [byteactual],ax

	  ;limpiar copiador filas
                mov word [copiadorfilas],0d


copyf1: ;copiar fila 1
	;Cargar en al lo que esta en copiafila1+copiadorfilas
		mov word bx,[copiadorfilas]
		mov byte al,[copiafila1+rbx]

	;copiar al en direccion textdat+byteactual+copiadorfilas
		add word bx,[byteactual]
		;dec word bx
		mov byte [textdat+rbx],al

	;incrementar copiador filas
		mov word bx,[copiadorfilas]
		add word bx,1d
		mov word [copiadorfilas],bx

	; Es copiadorfilas mayor a tamañofila1?
		mov word ax,[sizef1]
		cmp word bx,ax
		jb copyf1


	;Limpiar copiador de filas
		mov word [copiadorfilas],0d

	;iniciof1=byteactual
		mov word ax,[byteactual]
		mov word [iniciof1],ax


finaldelremplazo:
;print voyaqui
;print textdat
;print copiafila1
;print copiafila2

print textdat
;print copiafila1
;es finalf2 el final del documento?

	mov word ax,[finalf2]
	mov word bx, [bytefinaltext]
	cmp word ax,bx

	jb bublesort




;incrementando bubletimes
aqui:	mov word ax,[bubletimes]
	add word ax,1d
	mov word [bubletimes],ax

; es el la cantidad de veces igual a la cantidad de filas

	mov word bx,[contadorfilas]
	mov word [contadorfilas],0d
	cmp word ax,bx
	jb limpiarvariables

;hasta aqui todo bien, logra ordenar en orden alfabetico la lista



;---------------------Histograma----------------------
;Determinar numero de filas del histograma
;cantidad de valores en eje y=division entera(100/escala del grafico)
;si residuo es mayor a 1, se le suma residuo al ultimo grupo
;convirtiendo edg a decical
	mov byte ah,[edg]
	mov byte al,[edg+1]
	call _wascii2dec
	mov byte [edgb],al

;dividir 100 entre la escala
	mov byte al, 100d
	mov byte bl,[edgb]
	div byte bl
	mov byte [canty],al
;calcular residuoy
	mov byte [residuoy],ah



;------------tamaño de los grupos de notas------------
 ;leyendo el tamaño de los grupos de notas
                mov byte ah,[textconf+80]
		mov byte al,[textconf+81]
                mov byte [tdgn], ah
		mov byte [tdgn+1],al

	call _wascii2dec
	mov byte [tdgnb],al

;dividir 100 entre el tamaño de los grupos
        mov byte al, 100d
        mov byte bl,[tdgnb]
        div byte bl
        mov byte [cantx],al

;Calcular residuox
       mov byte [residuox],ah

; si hay residuo se agrega un nuevo grupo de notas
	mov byte bl,[residuox]
	cmp bl,0d
	je residuo2 
	mov byte al,[cantx]
	add byte al,1d
	mov byte [cantx],al

residuo2:
	mov byte bl, [residuoy]
	cmp bl,0d
	je finalresiduo
	mov byte al,[canty]
	add byte al,1d
	mov byte [canty],al

finalresiduo:



;----------------Clasificar notas------------------


;limpiar vector notas y estudiantes
	mov byte dl,0d
limpiarnotas:
		mov byte [arraynotas+rdx],0d
		mov byte [arrayestudiantes+rdx],0d
		cmp byte dl,100d
		add byte dl,1d
		jb limpiarnotas

; asignar notas a arreglo de notas
		mov byte dl,1d ; el registro dl es un contador
		mov byte r9b,[cantx]
		mov byte bl,[tdgnb]
		mov byte [nota],0d
; Error aqui---------------- no copia notas.------
asignarnotas:
		;calcular nota
		;multiplicar tamaño por el contador
		;asi se obtiene limite actual del grupo
		mov byte al,dl
		mul byte bl
bp1:		mov byte [nota],al
		mov byte al,dl
		sub byte al,1d
		mov byte r14b,[nota]
		mov byte [arraynotas+rax],r14b
		;incrementar contador
		add byte dl,1d
		mov byte r10b,dl
		;comparar si ya se llego al final de los grupos
		cmp byte r10b,r9b
		jbe asignarnotas




;limpiar variable contador
	mov word [byteactual],0d
;buscar notas en el archivo textdat




finalnotas:




	 .finalprograma: ; codigo para finalizar correctamente el programa
			; y solucionar el segmentation fault

			mov rax,60	;cargando la llamada 60d(sys_exit)
			mov rdi,0	;cargando 0 en rdi
			syscall		;llamando al sistema operativo



_wascii2dec:
	;convertir cada byte a decimal
	sub byte ah,48d
	sub byte al,48d
	;fransferir bytes
	mov byte bl,ah
	mov byte dl,al
	;multiplicar bh por 10d
	mov byte al,10d
	mul byte bl
	;sumar bytes
	add byte dl,al
	mov byte al,dl

	ret

