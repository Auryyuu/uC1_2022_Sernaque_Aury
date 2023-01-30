;--------------------------------
    ;@file    Ejercicio2.s
    ;@brief   Secuencia con pulsadores
    ;@date    29/01/2023
    ;@author  Aury Janirey Sernaque Seminario
    ;@Version and program:	MPLAB X IDE v6.00
   
;--------------------------------

PROCESSOR 18F57Q84
#include "config.inc"   /*config statements should precede project file includes.*/
#include <xc.inc>
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVectLowPriority:
    BTFSS   PIR1,0,0	;  ¿Se ha producido la INT0?
    GOTO    Exit_0
Leds_Sec:
    BCF	    PIR1,0,0	; limpiamos la bandera de INT0
    GOTO    SECUENCIA
Leds_off:
    CLRF    PORTC,0
    BCF	    PIR1,0,0	; limpiamos la bandera de INT0
Exit_0:
    BCF	    PIR1,0,0    ; limpiamos la bandera de INT0
    RETFIE

PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
Boton_RES:
    BTFSS   PIR10,0,0	; ¿Se ha producido la INT2?
    GOTO    DETENIMIENTO
    GOTO    RES_SEC
Exit:
    BCF	    PIR10,0,0
    BCF	    PIR6,0,0
    RETFIE

    
PSECT udata_acs
contador_1: DS 1	   ;reserva 1 byte en acces ram
contador_2: DS 1	   ;reserva 1 byte en acces ram
contador_3: DS 1	   ;reserva 1 byte en acces ram
offset:	    DS 1           ;reserva 1 byte en acces ram
counter:    DS 1           ;reserva 1 byte en acces ram
counter_1:  DS 1           ;reserva 1 byte en acces ram
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1_INT2,1
    GOTO    Sin_Interrupcion 

Sin_Interrupcion:
   toggle:
   BTG	   LATF,3,0
   CALL    Delay_500ms,1
   BTG	   LATF,3,0
   CALL    Delay_500ms,1
   goto	   toggle
 
    
SECUENCIA:   
    MOVLW   0x05	
    MOVWF   counter_1,0	; carga del contador con el numero de repeticiones-->5
N_OFFSET:
    MOVLW   0x0A	
    MOVWF   counter,0	; carga del contador con el numero de offsets-->10
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial-->0
    GOTO    Loop
    
DETENIMIENTO:
    BTFSS   PIR6,0,0	;SE A PRODUCIDO LA INT1?
    GOTO    Exit
    GOTO    DETENIMIENTO2
DETENIMIENTO2:
    BCF     PIR6,0,0	;limpiamos la bandera int1	
DETENIMIENTO3:
    BTFSC   PIR10,0,0	;SE A PRODUCIDO LA INT2?
    GOTO    RES_SEC
    BTFSS   PIR6,0,0	;SE A PRODUCIDO denuevo LA INT1?
    GOTO    DETENIMIENTO3
    GOTO    Exit
    
Tabla:
    ADDWF   PCL,1,0
    RETLW   10000001B	; offset: 0 -> LEDS 0 y 7 ON
    RETLW   01000010B	; offset: 1 -> LEDS 1 Y 6 ON
    RETLW   00100100B	; offset: 2 -> LEDS 2 Y 5 ON
    RETLW   00011000B	; offset: 3 -> LEDS 3 Y 4 ON
    RETLW   00000000B	; offset: 4 -> LEDS <0,7> OFF
    RETLW   00011000B	; offset: 5 -> LEDS 3 Y 4 ON
    RETLW   00100100B	; offset: 6 -> LEDS 2 Y 5 ON
    RETLW   01000010B	; offset: 7 -> LEDS 1 Y 6 ON
    RETLW   10000001B	; offset: 8 -> LEDS 0 Y 7 ON
    RETLW   00000000B	; offset: 9 -> LEDS <0,7> OFF
    
Loop:
    BSF	    LATF,3,0	    ;LED PLACA OFF
    BANKSEL PCLATU
    MOVLW   low highword(Tabla) 
    MOVWF   PCLATU,1	    ;cargas el menor byte del word mas significativo a pclatu
    MOVLW   high(Tabla)
    MOVWF   PCLATH,1	    ;cargas el mayor byte del word menos significativo a pclath
    RLNCF   offset,0,0	    ;rotacion a la izquierda en el registro f y lo fuardas en w
    CALL    Tabla
    MOVWF   LATC,0	    ;mueves w al registro latc
    CALL    Delay_250ms,1
    DECFSZ  counter,1,0	    ;decrementa 1 el counter y salta si es 0
    GOTO    Next_Seq
    DECFSZ  counter_1,1,0    ;decrementa en 1 el counter1 y salta si es 0
    GOTO    N_OFFSET
    GOTO    Leds_off
    
Next_Seq:
    INCF    offset,1,0	    ;incrementra en 1 el offset
    GOTO    Loop
  
Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
Config_Port:	
    
    ;Config User Button
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1	
    BSF	    WPUA,3,1
    
    ;Config Ext Button
    BANKSEL PORTB
    CLRF    PORTB,1	
    CLRF    ANSELB,1	
    BSF	    TRISB,4,1	
    BSF	    WPUB,4,1
    
    ;Config PORTC
    BANKSEL PORTC
    CLRF    PORTC,1		
    CLRF    ANSELC,1	
    CLRF    TRISC,1
   
    ;Config PORTF
    BANKSEL PORTF
    CLRF    PORTF,0
    CLRF    ANSELF,1	
    BSF	    TRISF,2,1
    BCF	    TRISF,3,1
    BSF	    WPUF,2,1
    RETURN
    
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3
    
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	; INT1 --> RB4
    
;    Config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1	; INT2 --> RF2    
    RETURN
 
Config_INT0_INT1_INT2:
    ;Configuracion de prioridades
    BSF	    INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	    IPR1,0,1    ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BCF     IPR6,1,1    ; IPR6<INT1IP> = 0 -- INT1 de alta prioridad
    BCF     IPR10,1,1   ; IPR6<INT1IP> = 0 -- INT2 de alta prioridad
    
    ;Config INT0
    BCF     INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	    PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	    PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	    INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF     PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	    PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
;    ;Config INT2
    BCF	    INTCON0,2,0 ; INTCON0<INT1EDG> = 0 -- INT2 por flanco de bajada
    BCF     PIR10,0,0    ; PIR10<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	    PIE10,0,0    ; PIE10<INT0IE> = 1 -- habilitamos la interrupcion ext2
    
    ;Habilitacion de interrupciones
    BSF     INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF     INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
    
 Delay_250ms:		        ; 2Tcy -- Call
    MOVLW   250		        ; 1Tcy -- k2
    MOVWF   contador_2,0        ; 1Tcy
; T = (6 + 4k)us	    1Tcy = 1us
Ext_Loop:		    
    MOVLW   249		        ; 1Tcy -- k1
    MOVWF   contador_1,0	; 1Tcy
Int_Loop:
    NOP			        ; k1*Tcy
    DECFSZ  contador_1,1,0      ; (k1-1)+ 3Tcy
    GOTO    Int_Loop	        ; (k1-1)*2Tcy
    DECFSZ  contador_2,1,0
    GOTO    Ext_Loop
    RETURN		        ; 2Tcy
;500ms
Delay_500ms:
    MOVLW   2
    MOVWF   contador_3,0
    Loop_250ms:		        ;2tcy
    MOVLW   250		        ;1tcy
    MOVWF   contador_2,0        ;1tcy
    Loop_1ms8:			     
    MOVLW   249			;k Tcy
    MOVWF   contador_1,0	;k tcy
    INT_LOOP8:			    
    Nop				;249k TCY
    DECFSZ  contador_1,1,0	;251k TCY 
    Goto    INT_LOOP8		;496k TCY
    DECFSZ  contador_2,1,0	;(k-1)+3tcy
    GOTO    Loop_1ms8		;(k-1)*2tcy
    DECFSZ  contador_3,1,0
    GOTO    Loop_250ms
    RETURN  
    
Ext_Loop1:		    
    MOVLW   20                  ; 1Tcy -- k1
    MOVWF   contador_1,0	; 1Tcy
Int_Loop1:
    NOP			        ; k1*Tcy
    DECFSZ  contador_1,1,0      ; (k1-1)+ 3Tcy
    GOTO    Int_Loop1	        ; (k1-1)*2Tcy
    DECFSZ  contador_2,1,0
    GOTO    Ext_Loop1
    RETURN		        ; 2Tcy
    
RES_SEC:
    BCF	PIR10,0,0
    
END resetVect




