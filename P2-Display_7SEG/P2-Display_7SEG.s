;--------------------------------
    ;@file    P2-Display_7SEG.s
    ;@brief   mostrar los valores alfanuméricos(0-9 y A-F) en un display
    ;@date    15/01/2023
    ;@author  Aury Janirey Sernaque Seminario
    ;@Version and program:	MPLAB X IDE v6.00
   
;--------------------------------
    

PROCESSOR 18F57Q84   
#include "config.inc" /*config statements should precede project file includes.*/
#include "retardos.inc"
#include <xc.inc>

PSECT resetVect,class=CODE, reloc=2
resetVect:
    goto Main
PSECT CODE
Main:
    CALL    Configuracion_Osc
    CALL    Configuracion_Port
    NOP
    
Condition_button:
    BTFSC PORTA,3,1
    GOTO Numeros
    Letras:
    Letra_A:
    CLRF	PORTD,0
    BSF 	PORTD,3,0
    CALL	Delay_1s
    BTFSC	PORTA,3,0
    GOTO Numeros
	  
    Letra_B:
    CLRF	PORTD,0
    BSF	        PORTD,0,0
    BSF	        PORTD,1,0
    CALL	Delay_1s
    BTFSC       PORTA,3,0
    GOTO        Numeros
    
    Letra_C:
    CLRF        PORTD,0
    BSF 	PORTD,1,0
    BSF 	PORTD,2,0
    BSF	        PORTD,6,0
    CALL        Delay_1s
    BTFSC	PORTA,3,0
    GOTO        Numeros
    
    Letra_D:
    CLRF        PORTD,0
    BSF	        PORTD,0,0
    BSF	        PORTD,5,0
    CALL        Delay_1s
    BTFSC       PORTA,3,0
    GOTO        Numeros
    
    Letra_E:
    CLRF        PORTD,0
    BSF	        PORTD,1,0
    BSF	        PORTD,2,0
    CALL        Delay_1s
    BTFSC	PORTA,3,0
    GOTO	Numeros
    
    Letra_F:
    CLRF	PORTD,0
    BSF	        PORTD,1,0
    BSF	        PORTD,2,0
    BSF	        PORTD,3,0
    CALL        Delay_1s
    BTFSC       PORTA,3,0
    GOTO        Numeros
    GOTO        Letras
	  
    Numeros:
    Numero_0:
    CLRF        PORTD,0
    BSF	        PORTD,6,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
    
    Numero_1:
    SETF	PORTD,0
    BCF	        PORTD,1,0
    BCF	        PORTD,2,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
    
    Numero_2:
    CLRF	PORTD,0
    BSF	        PORTD,2,0
    BSF	        PORTD,5,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
    
    Numero_3:
    CLRF	PORTD,0
    BSF	        PORTD,4,0
    BSF	        PORTD,5,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
    Numero_4:
    CLRF	PORTD,0
    BSF	        PORTD,0,0
    BSF	        PORTD,3,0
    BSF  	PORTD,4,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
	  
    Numero_5:
    CLRF	PORTD,0
    BSF	        PORTD,1,0
    BSF	        PORTD,4,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
	  
    Numero_6:
    CLRF	PORTD,0
    BSF	        PORTD,1,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
	  
    Numero_7:
    SETF	PORTD,0
    BCF  	PORTD,0,0
    BCF	        PORTD,1,0
    BCF	        PORTD,2,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
	  
    Numero_8:
    CLRF	PORTD,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
	  
    Numero_9:
    CLRF	PORTD,0
    BSF 	PORTD,3,0
    BSF  	PORTD,4,0
    CALL        Delay_1s
    BTFSS	PORTA,3,0
    GOTO        Letras
    GOTO        Numeros
    
Configuracion_Osc:
    ;configuración del Oscilador interno a una frecuencia de 4Mhz
    BANKSEL OSCCON1
    MOVLW 0x60	;seleccionamos el bloque del oscilador interno con un div:1
    MOVWF OSCCON1
    MOVLW 0X02	;seleccionamos a una frecuencia de 4Mhz
    MOVWF OSCFRQ
    RETURN
 
Configuracion_Port:	;PORT-LAT-ANSEL-TRIS LED:RF3,  BUTTON:RA3
    ;Configuracion Button
    BANKSEL LATA
    CLRF    LATA,1	;PORTA<7,0> = 0
    CLRF    ANSELA,1	;PORTA DIGITAL
    BSF	    TRISA,3,1	;RA3 COMO ENTRADA
    BSF	    WPUA,3,1	;ACTIVAMOS LA RESISTENCIA PULLUP DEL PIN RA3
    ;Configuracion Port D
    BANKSEL PORTD
    SETF    PORTD,1	;PORTE<7,0> = 1
    CLRF    ANSELD,1	;PORTE DIGITAL
    CLRF    TRISD,1	;PORTE COMO SALIDA
    RETURN

END resetVect