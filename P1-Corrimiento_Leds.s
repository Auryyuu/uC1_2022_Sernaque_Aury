;--------------------------------
    ;@file    P1-Corrimiento_Leds.s
    ;@brief   Corrimiento de leds conectados al puerto C
    ;@date    15/01/2023
    ;@author  Aury Janirey Sernaque Seminario
    ;@Version and program:	MPLAB X IDE v6.00
   
;--------------------------------
    
PROCESSOR 18F57Q84
#include "P1-Corrimiento_Leds_config"  // config statements should precede project file includes.
#include <xc.inc>  

PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT udata_acs
contador_1: DS 1   
contador_2: DS 1            ; reserva 1 byte en access ram
contador_3: DS 1    
    
PSECT CODE
 
Main:
     CALL Configuracion_Osc,1
     CALL Configuracion_Port,1

BUTTON:
    BANKSEL   LATA
    CLRF      LATC,b
    BCF       LATE,1,b	              ;enciende el led cuando hay corrimiento par
    BCF       LATE,0,b	              ;enciende cuando hay corrimiento impar
    BTFSC     PORTA,3,b        	      ;salta si es cero 
    goto      BUTTON	              ;cuando no presione ejecuta esta instruccion 
    goto      CORRIMIENTO_PAR
     
CORRIMIENTO_PAR:
    CLRF  LATC,b                      ;comienza con todos los led apagados
    BCF   LATE,0,b                    ;apaga el led impar
    BSF   LATE,1,b                    ;enciende el led par
    MOVLW 00000010B                   ;carga el acumulador con valor 2
    MOVWF LATC,1                      ;enciende el led 1
    CALL  Delay_500ms,1	              ;se presenta un retardo 
    BTFSS PORTA,3,0                   ;salta si led no esta encendido
    GOTO  BUTTON_1                    ;ejecuta cuando esta presionado el boton
    
    BSF   LATE,1,b                    ;prende el led de corrimiento par 
    BCF   LATE,0,b                    ;apaga el led de corrimiento impar
    MOVLW 00001000B                   ;carga el acumulador con valor de 8
    MOVWF LATC,1                      ;enciendera el led 4
    CALL  Delay_500ms,1	              ;hay corrimiento
    BTFSS PORTA,3,0                   ;salta si es 1
    GOTO  BUTTON_1
    
    BSF   LATE,1,b
    BCF   LATE,0,b
    MOVLW 00100000B
    MOVWF LATC,1
    CALL  Delay_500ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON_1
    
    BSF   LATE,1,b
    BCF   LATE,0,b
    MOVLW 10000000B
    MOVWF LATC,1
    CALL  Delay_500ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON_1
    
 CORRIMIENTO_IMPAR:
    CLRF  LATC,b
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00000001B
    MOVWF LATC,1
    CALL  Delay_250ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON_2
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00000100B
    MOVWF LATC,1
    CALL  Delay_250ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON_2
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 00010000B
    MOVWF LATC,1
    CALL  Delay_250ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON_2
    
    BCF   LATE,1,b
    BSF   LATE,0,b
    MOVLW 01000000B
    MOVWF LATC,1
    CALL  Delay_250ms,1
    BTFSS PORTA,3,0
    GOTO  BUTTON_2

    GOTO  CORRIMIENTO_PAR
    
BUTTON_1:
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    GOTO    BUTTON_1
    GOTO    CORRIMIENTO_PAR
    
BUTTON_2:
    CALL    Delay_250ms,1
    BTFSC   PORTA,3,0
    GOTO    BUTTON_1
    GOTO    CORRIMIENTO_IMPAR    
   
Configuracion_Osc:
;Configuracion del Oscilador interno a una frecuencia interna de 4Mhz 
    BANKSEL OSCCON1
    MOVLW 0X60                        ;Seleccionamos el bloque del osc con un Div:1
    MOVWF OSCCON1,1
    MOVLW 0X02                        ;Seleccionamos una Frecuencia de 4Mhz
    MOVWF OSCFRQ ,1
    RETURN

Configuracion_Port:                   ;PORT-LAT-ANSEL-TRIS  LED:RF3,  BUTTON:RA3
    ;Configuracion Led
    BANKSEL  PORTF
    CLRF     TRISC,b                  ;TRISC = 0 Como salida
    CLRF     ANSELC,b                 ;ANSELC<7:0> = 0 - Port C digital
    BCF      TRISE,1,b                ;TRISF<1> = 0  RE1 como SALIDA
    BCF      TRISE,0,b                ;TRISF<0> = 0  RF0 como SALIDA
    BCF      ANSELE,1,b               ;TRISF<1> = 0  RE1 como Digital
    BCF      ANSELE,0,b               ;TRISF<0> = 0  RE0 como Digital
    
    ;Configuracion Button
    BANKSEL PORTA
    CLRF    PORTA,b                  ;PortA<7:0> = 0 
    CLRF    ANSELA,b                 ;PortA Digital
    BSF     TRISA,3,b                ;RA3 entrada
    BSF     WPUA,3,b                 ;Activamos la resistencia Pull-up del pin RA3
    RETURN   

Tiempos:
    
;T= (6 + 4k1)(k2)(k3)us            1Tcy=1us   
Delay_500ms:
    MOVLW   2                        ;1Tcy--k3
    MOVWF   contador_3,0             ;1Tcy
    
D_500ms:                             ;2Tcy--call
    MOVLW   250                      ;1Tcy--k2
    MOVWF   contador_2,0             ;1Tcy
    
Ext500ms_Loop:                  
    MOVLW   249                      ;1Tcy--k1
    MOVWF   contador_1,0             ;1Tcy
    
Int500ms_Loop:
    NOP                              ;K1*Tcy
    DECFSZ  contador_1,1,0           ;(k1-1)+ 3Tcy           
    GOTO    Int500ms_Loop            ;2Tcy
    DECFSZ  contador_2,1,0           ;2Tcy
    GOTO    Ext500ms_Loop            ;2Tcy 
    DECFSZ  contador_3,1,0
    GOTO    D_500ms
    RETURN                           ;2Tcy   
 
;T= (6 + 4k1)k2us            1Tcy=1us  
    
Delay_250ms:                         ;2Tcy--call
    MOVLW   250                      ;1Tcy--k2
    MOVWF   contador_2,0             ;1Tcy
    
Ext250ms_Loop:                  
    MOVLW   249                      ;1Tcy--k1
    MOVWF   contador_1,0             ;1Tcy
    
Int250ms_Loop:
    NOP                              ;K1*Tcy
    DECFSZ  contador_1,1,0           ;(k1-1)+ 3Tcy           
    GOTO    Int250ms_Loop            ;2Tcy
    DECFSZ  contador_2,1,0           ;2Tcy
    GOTO    Ext250ms_Loop            ;2Tcy   
    RETURN                           ;2Tcy     
    
END resetVect


