;proyecto 1 arquitectura de Computadores
%include "linux64.inc"

section .data
; aqui se definen las varibles inicializadas
archconf db "configuracion.txt",0	;nombre del archivo con texto
archdat db "archivo.txt",0		;nombre del archivo con los datos
voyaqui db "voy por aqui",10


byteactual dw 0d
finalf1 dw 0d
iniciof1 dw 0d
iniciof2 dw 0d
finalf2 dw 0d
bytefinaltext dw 0d
contadorletras dw 0d
copiadorfilas dw 0d

sizef1 dw 0d
sizef2 dw 0d




section .bss
; aqui se se reservan espacios para variables sin definir tu valor inicial

textconf resb 150 ; reserva espacio para el texto de configuracion
textdat resb 1000 ; reserva espacio para el texto de datos
ttc resb 150  ; reserva espacio para almacenar el texto de configuracion
ttd resb 1000 ; reserva espacio para almacenar el texto con los datos






;Las siguientes variables pertenecen a informacion del archivo configuracion
	nda resb 3 ;esta variable almacena la nda= nota de aprobacion
	ndr resb 3 ;esta variabla almacena la ndr = nota de  reposicion
	tdgn resb 3 ; almacena  el tdgn =tamaño de los grupos de notas
	edg resb 3 ;esta variable almacena la edg = escala del grafico
	tdo resb 2; esta variable almacena el tdo = tipo de ordenamiento

	letra1 resb 1
	letra2 resb 1
	copiafila1 resb 40
	copiafila2 resb 40


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

;-----------------------------hasta aqui todo bien--------------

bublesort:

	;Determinar el inicio y el final de la fila 1
	; cargar letra actual
        mov word bx,[byteactual]
	mov byte al, [textdat +rbx ]

	;Copiar letra actual en direccion copiafila1+copiadorfilas
		mov word r10w,[copiadorfilas]
		mov byte [copiafila1+r10],al

	;incrementar copiador filas
		inc word r10w
		mov word [copiadorfilas],r10w

        ; Almacena  byteactual en final fila 1
                mov word cx,[byteactual]
		mov word  [finalf1], cx

	; incrementa el byte actual
		inc word cx
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


	; cargar letra actual
Efila2:		mov word ax,[byteactual]
		mov byte bl,[textdat+rax]

	;Copiar letra actual en  direccion copiafila2+copiadorfilas
		mov word r8w,[copiadorfilas]
		mov byte [copiafila2+r8],bl

	;incrementar copiador de filas
		inc word r8w
		mov word [copiadorfilas],r8w

	;Almacenar en final fila 2 el byte actual
		mov word [finalf2],ax
	;Incrementar byte actual
		inc ax
		mov word [byteactual],ax
	; Es letra actual igual a enter?
		cmp byte bl,10d
		jne Efila2
	; es letra actual igual a final de texto
		cmp byte bl, 03d
		jne antesdeordenamiento
	;si es igual a final de texto almacena  el byte actual menos 1 en byte final de texto
		dec ax
		mov word [bytefinaltext],ax

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
		inc word dx
		mov word [contadorletras],dx

	;Es letra1 igual a letra2
print letra1
print letra2
		mov byte al,[letra1]
		mov byte bl,[letra2]
		cmp byte al,bl
		je alfabetico


	;limpiar contador letras
		mov byte [contadorletras],0d

	;limpiar copiador letras
		mov byte [copiadorfilas],0d


	;es letra1 mayor a letra2?
		jb  letra1mayor




	;------------letra1 es menor a letra 2------------
	; iniciof1=iniciof2
		mov word r8w,[iniciof2]
		mov word [iniciof1],r8w

	;byteactual=iniciof2
		mov word [byteactual],r8w
print textdat
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
		inc word dx
		mov word [copiadorfilas],dx

	; Es copiador filas mayor a tamaño fila 2?
		mov word ax,[sizef2]
		cmp word dx,ax
		jbe letra1mayor

	;limpiar copiador filas
		mov word [copiadorfilas],0d

	;actualizar byte actual
		inc ax
		add ax,[iniciof1]
		mov word [byteactual],ax

copyf1: ;copiar fila 1
	;Cargar en al lo que esta en copiafila1+copiadorfilas
		mov word bx,[copiadorfilas]
		mov byte al,[copiafila1+rbx]

	;copiar al en direccion textdat+byteactual+copiadorfilas
		add word bx,[byteactual]
		mov byte al,[textdat+rbx]

	;incrementar copiador filas
		mov word bx,[copiadorfilas]
		inc word bx
		mov word [copiadorfilas],bx

	; Es copiadorfilas mayor a tamañofila1?
		mov word ax,[sizef1]
		cmp word bx,ax
		jbe copyf1


	;Limpiar copiador de filas
		mov word [copiadorfilas],0d

	;iniciof1=byteactual
		mov word ax,[byteactual]
		mov word [iniciof1],ax


finaldelremplazo:
print voyaqui
print textdat
print copiafila1
print copiafila2






	 .finalprograma: ; codigo para finalizar correctamente el programa
			; y solucionar el segmentation fault

			mov rax,60	;cargando la llamada 60d(sys_exit)
			mov rdi,0	;cargando 0 en rdi
			syscall		;llamando al sistema operativo
