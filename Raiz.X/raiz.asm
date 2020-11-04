#include "p16F628a.inc"    ;incluir librerias relacionadas con el dispositivo
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF    
;configuración del dispositivo todo en OFF y la frecuencia de oscilador
;es la del "reloj del oscilador interno" (INTOSCCLK)     
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program
; TODO ADD INTERRUPTS HERE IF USED
MAIN_PROG CODE                      ; let linker place main program

resultado equ 0x30
lectura equ 0x31
contador equ 0x32
m equ 0x33
band equ 0x34

;inicio del programa:
START
    MOVLW 0x07 ;Apagar comparadores
    MOVWF CMCON
    BCF STATUS, RP1 ;Cambiar al banco 1
    BSF STATUS, RP0
    MOVLW b'11111111' ;Establecer puerto B como salida (los 8 bits del puerto)
    MOVWF TRISA
    MOVLW b'00000000' ;Establecer puerto B como salida (los 8 bits del puerto)
    MOVWF TRISB
    BCF STATUS, RP0 ;Regresar al banco 0
    GOTO INICIO

;Empezar
INICIO
    ;Leemos el numero
    MOVFW PORTA
    ;MOVLW d'4'
    MOVWF lectura
    ;Inicializamos contador en 1
    MOVLW d'0'
    MOVWF contador
    
    ;Comprobar que no tengamos valor 0
    MOVFW lectura
    XORLW d'0'
    MOVWF band
    
    BTFSC band,0 ;Si es 0 salta a la siguiente instruccion
    GOTO CICLO
    BTFSC band,1
    GOTO CICLO
    BTFSC band,2
    GOTO CICLO
    BTFSC band,3
    GOTO CICLO
    BTFSC band,4
    GOTO CICLO
    BTFSC band,5
    GOTO CICLO
    BTFSC band,6
    GOTO CICLO
    BTFSC band,7
    GOTO CICLO
    GOTO FINAL
    
CICLO
    INCF contador,1
    ;Inicializamos m en el valor que tenga contador
    MOVFW contador
    MOVWF m
    ;Inicializamos W
    MOVLW d'0'
    ;Hacemos la multiplicacion
    MULTI
    ADDWF contador,0
    DECFSZ m
    GOTO MULTI
    ;Almacenamos en resultado
    MOVWF resultado
    
    ;Comprobar si son iguales
    MOVFW lectura
    XORWF resultado,0
    MOVWF band
    
    BTFSC band,0 ;Si es 0 salta a la siguiente instruccion
    GOTO CICLO
    BTFSC band,1
    GOTO CICLO
    BTFSC band,2
    GOTO CICLO
    BTFSC band,3
    GOTO CICLO
    BTFSC band,4
    GOTO CICLO
    BTFSC band,5
    GOTO CICLO
    BTFSC band,6
    GOTO CICLO
    BTFSC band,7
    GOTO CICLO
    
    ;Imprimir en Proteus
    FINAL
    MOVFW contador ;Guardamos el valor de resultado en W
    MOVWF PORTB ;Mandamos al puerto B el valor de W / Resultado
    
END