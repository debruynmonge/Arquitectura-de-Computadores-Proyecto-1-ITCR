;proyecto 1 arquitectura de Computadores
%include "linux64.inc"

section .data
; aqui se definen las varibles inicializadas
archconf db "configuracion.txt",0	;nombre del archivo con texto
archdat db "archivo.txt",0		;nombre del archivo con los datos
ttc equ 140    ;almacena ttc= tamaño de texto de configuracion
tad equ 900	; almacena tad =tamaño de archivo con datos



section .bss
;aqui se definen las variables no inicializadas

textconf resb 140 ; Guarda el archivo de texto del configuracion
textdat resb 900  ;Guarda el archivo de texto con los datos
numcolum resb 2	  ; Almacena el  numero de columnas del Histograma
numfil resb 2	 ; Almacena el numero de filas del histograma

;Las siguientes variables pertenecen a informacion del archivo configuracion
	nda resb 2 ;esta variable almacena la nda= nota de aprobacion
	ndr resb 2 ;esta variabla almacena la ndr = nota de  reposicion
	tdgn resb 2 ; almacena  el tdgn =tamaño de los grupos de notas
	edg resb 2 ;esta variable almacena la edg = escala del grafico
	tdo resb 1; esta variable almacena el tdo = tipo de ordenamiento

;Las siguientes variables son parte de la rutina para convertir de ascii a decimal
var1 resb 1
var2 resb 1
resulconv resb 1


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
		mov [nda], ax	; almacena en nda el contenido de ax
		print nda
		;leyendo nota de  reposición
                mov ax,[textconf+45]
                mov [ndr], ax
                print ndr
		;leyendo el tamaño de los grupos de notas
                mov ax,[textconf+80]
                mov [tdgn], ax
                print tdgn
		;leyendo Escala del gráfico
                mov ax,[textconf+105] ; almacena en ax el contenido de la direc$
                mov [edg], ax   ; almacena en edg el contenido de ax
                print edg
		;leyendo Tipo de Ordenamiento
                mov al,[textconf+122] ; almacena en ax el contenido de la direc$
                mov [tdo], al   ; almacena en tdo el contenido de ax
                print tdo

		;-------------------------------------Tratando informacion extraida del archivo de configuracion---------------------------
		;Determinando el numero de  columnas del histograma (grupos de notas)
		;add tdgn, 2
		mov  ax, tdgn
		call _ascii2decimal
aqui:

		;print tdgn


		;Determinar el numero de filas del histograma (escala del gráfico)








        ;--------------------------------leer archivo con datos----------------------------------------------


	 finalprograma: ; codigo para finalizar correctamente el programa
			; y solucionar el segmentation fault

			mov rax,60	;cargando la llamada 60d(sys_exit)
			mov rdi,0	;cargando 0 en rdi
			syscall		;llamando al sistema operativo

	_ascii2decimal: ; Esta subrutina convierte de ascii a decimal
			; para usar esta subrutina hay que cargar en ax el valor a convertir
			; compara el el byte superior del dato con el numero y si son iguales asigna el numero a una variable auxiliar
			cmp ah, 0
			je var1cero
			cmp ah,1
			je var1uno
                        cmp ah,2
			je var1dos
                        cmp ah,3
			je var1tres
                        cmp ah,4
			je var1cuatro
                        cmp ah,5
			je var1cinco
                        cmp ah,6
			je var1seis
                        cmp ah,7
			je var1siete
                        cmp ah,8
			je var1ocho
                        mov byte [var1], 9
			jmp segpart
		var1cero: mov byte [var1], 0  ; Asigna a var1 el valor correspondiente
                        jmp segpart     ;Salta a la segunda parte
		var1uno: mov byte [var1], 1  ; Asigna a var1 el valor correspondiente
			jmp segpart	;Salta a la segunda parte
		var1dos: mov byte [var1], 2  ; Asigna a var1 el valor correspondiente
                        jmp segpart     ;Salta a la segunda parte
		var1tres: mov byte [var1], 3  ; Asigna a var1 el valor correspondiente
                        jmp segpart     ;Salta a la segunda parte
		var1cuatro: mov byte [var1],4  ; Asigna a var1 el valor correspondiente
                        jmp segpart     ;Salta a la segunda parte
		var1cinco: mov byte [var1],5  ; Asigna a var1 el valor correspondiente
                        jmp segpart     ;Salta a la segunda parte
		var1seis: mov byte [var1], 6  ; Asigna a var1 el valor correspondiente
                        jmp segpart     ;Salta a la segunda parte
		var1siete: mov byte [var1],7  ; Asigna a var1 el valor correspondiente
                        jmp segpart     ;Salta a la segunda parte
		var1ocho: mov byte [var1],8  ; Asigna a var1 el valor correspondiente

		segpart: ;Segunda parte del convertidor aqui se convierte la segunda variable a binario

	  ; compara el el byte inferior del dato con el numero y si son iguales asigna el numero a una variable auxiliar
                        cmp al, 0
                        je var2cero
                        cmp al,1
                        je var2uno
                        cmp al,2
                        je var2dos
                        cmp al,3
                        je var2tres
                        cmp al,4
                        je var2cuatro
                        cmp al,5
                        je var2cinco
                        cmp al,6
                        je var2seis
                        cmp al,7
                        je var2siete
                        cmp al,8
                        je var2ocho
                        mov byte [var2], 9
                        jmp terpart

 		var2cero: mov byte [var2], 0  ; Asigna a var2 el valor correspondiente
                        jmp terpart     ;Salta a la tercera parte
                var2uno: mov byte [var2], 1  ; Asigna a var2 el valor correspondiente
                        jmp terpart     ;Salta a la tercera parte
                var2dos: mov byte [var2], 2  ; Asigna a var2 el valor correspondiente
                        jmp terpart     ;Salta a la tercera parte
                var2tres: mov byte [var2], 3  ; Asigna a var2 el valor correspondiente
                        jmp terpart     ;Salta a la tercera parte
                var2cuatro: mov byte [var2],4  ; Asigna a var2 el valor correspondiente
			    jmp terpart     ;Salta a la tercera parte
                var2cinco: mov byte [var2],5  ; Asigna a va21 el valor correspondiente
                        jmp terpart     ;Salta a la tercera parte
                var2seis: mov byte [var2], 6  ; Asigna a var2 el valor correspondiente
                        jmp terpart     ;Salta a la tercera parte
                var2siete: mov byte [var2],7  ; Asigna a var2 el valor correspondiente
                        jmp terpart     ;Salta a la tercera parte
                var2ocho: mov byte [var2],8  ; Asigna a var2 el valor correspondiente


		 ; aquí se va a combinar las dos variables obtenidas anteriormente para producir el resultado
		terpart:
			mov al, var1
			mov cl, 10
			mul cl
			mov [resulconv],al
			ret
