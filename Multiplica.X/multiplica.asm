#include "p16F628a.inc"
__CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

RES_VECT CODE 0x0000 ; processor reset vector
GOTO START ; go to beginning of program
; TODO ADD INTERRUPTS HERE IF USED
MAIN_PROG CODE ; let linker place main program
 
a equ 0x32
aux equ 0x33
r equ 0x34

START
 
    MOVLW 0x07
    MOVWF CMCON
    BCF STATUS, RP1
    BSF STATUS, RP0
    MOVLW b'11111111'
    MOVWF TRISA
    MOVLW b'00000000'
    MOVWF TRISB
    BCF STATUS, RP0
    
inicio:
    MOVLW d'0'
    MOVWF r
    MOVFW PORTA
    MOVWF a
    SWAPF a, 0
    MOVWF aux
    BCF aux, 7
    BCF aux, 6
    BCF aux, 5
    BCF aux, 4
rec:
    BTFSC a, 0
    CALL sum
    RLF aux, 1
    BTFSC a, 1
    CALL sum
    RLF aux, 1
    BTFSC a, 2
    CALL sum
    RLF aux, 1
    BTFSC a, 3
    CALL sum
    MOVFW r
    MOVWF PORTB
    GOTO inicio
    
sum:
    MOVFW aux
    ADDWF r, 1
    RETURN
END   