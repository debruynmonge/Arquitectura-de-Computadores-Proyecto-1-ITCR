;proyecto 1 arquitectura de Computadores
%include "linux64.inc"

section .data
; aqui se definen las varibles inicializadas
archconf db "configuracion.txt",0	;nombre del archivo con texto
archdat db "archivo.txt",0		;nombre del archivo con los datos
voyaqui db "voy por aqui",10
ttc equ 140    ;almacena ttc= tamaño de texto de configuracion
tad equ 900	; almacena tad =tamaño de archivo con datos



section .bss
;aqui se definen las variables no inicializadas

textconf resb 140 ; Guarda el archivo de texto del configuracion
textdat resb 900  ;Guarda el archivo de texto con los datos
numcolum resb 2	  ; Almacena el  numero de columnas del Histograma
numfil resb 2	 ; Almacena el numero de filas del histograma

;Las siguientes variables pertenecen a informacion del archivo configuracion
	nda resb 3 ;esta variable almacena la nda= nota de aprobacion
	ndr resb 3 ;esta variabla almacena la ndr = nota de  reposicion
	tdgn resb 3 ; almacena  el tdgn =tamaño de los grupos de notas
	edg resb 3 ;esta variable almacena la edg = escala del grafico
	tdo resb 2; esta variable almacena el tdo = tipo de ordenamiento


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

		;-------------------------------------Tratando informacion extraida del archivo de configuracion---------------------------
		;Determinando el numero de  columnas del histograma (grupos de notas)
print nda
print ndr
print tdgn
print edg
print tdo
print voyaqui
		print tdgn
_breakpoint0:	mov rdx, [tdgn]

_breakpoint1:
		call _ascii2decimal
_breakpoint2:
		mov word [numcolum], ax
_breakpoint3:
		print  voyaqui
		print numcolum



		;Determinar el numero de filas del histograma (escala del gráfico)








        ;--------------------------------leer archivo con datos----------------------------------------------


	 .finalprograma: ; codigo para finalizar correctamente el programa
			; y solucionar el segmentation fault

			mov rax,60	;cargando la llamada 60d(sys_exit)
			mov rdi,0	;cargando 0 en rdi
			syscall		;llamando al sistema operativo

	_ascii2decimal: ; Esta subrutina convierte de ascii a decimal
			; para usar esta subrutina hay que cargar en ax el valor a convertir
			sub dl,48d	 ;trasforma de ascii a decimal el primer digito
			sub dh, 48d  ; transforma de ascii a decimal el segundo digito
			mov bh,dh   ; cambia la informacion de registro
			mov cl,dl	; cambia la informacion de registro
			mov ax,10d	;guarda 10 en ax para multiplicarlo por bh
			mul bh		; convierte el primer digito a decenas y  almacena en ax 
			add ax,cx
			mov ax,dx
			ret
