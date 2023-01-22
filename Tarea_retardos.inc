;--------------------------------
    ;@file    Tarea_retardos.inc
    ;@brief   Libreria que contiene retardos para una implementacion 
    ;@date    09/01/2023
    ;@author  Aury Janirey Sernaque Seminario
    ;Nota:Frecuencia = 4MHz y TCY = 1us
    ;@Version and program:	MPLAB X IDE v6.00
   
;--------------------------------
    
    
PSECT udata_acs
Contador1: DS 1      ;reserva 1 Byte en access ram
Contador2: DS 1      ;reserva 1 Byte en access ram
  
PSECT code
    ;T=(6+4x)*Tcy
    ;Primer_retardo(10us)
Delay_10us:                  ;  2TCY -> CALL
    MOVLW  1                 ;  1TCY
    MOVWF  Contador1,0       ;  1TCY
Loop_1:   
    NOP                      ;  x*TCY
    DECFSZ Contador1,1,0     ;  (x-1) + 3*TCY
    GOTO   Loop_1            ;  (x-1)*2TCY
    RETURN                   ;  2*TCY
    
    ;Segundo_retardo(25us)
Delay_25us:                  ;  2TCY -> CALL
    MOVLW  5                 ;  1TCY
    MOVWF  Contador1,0       ;  1TCY
Loop_2:   
    NOP                      ;  x*TCY
    DECFSZ Contador1,1,0     ;  (x-1) + 3*TCY
    GOTO   Loop_2            ;  (x-1)*2TCY
    RETURN                   ;  2*TCY
    
    ;Tercer_retardo(50us)
Delay_50us:                  ;  2TCY -> CALL
    MOVLW  11                ;  1TCY
    MOVWF  Contador1,0       ;  1TCY
Loop_3:   
    NOP                      ;  x*TCY
    DECFSZ Contador1,1,0     ;  (x-1) + 3*TCY
    GOTO   Loop_3            ;  (x-1)*2TCY
    RETURN                   ;  2*TCY
                                                  
    ;Cuarto_retardo(100us)
Delay_100us:                 ;  2TCY -> CALL
    MOVLW  24                ;  1TCY
    MOVWF  Contador1,0       ;  1TCY
Loop_4:   
    NOP                      ;  x*TCY
    DECFSZ Contador1,1,0     ;  (x-1) + 3*TCY
    GOTO   Loop_4            ;  (x-1)*2TCY
    RETURN                   ;  2*TCY
                                  
    ;Quinto_retardo(200us)
Delay_200us:                 ;  2TCY -> CALL
    MOVLW  49                ;  1TCY
    MOVWF  Contador1,0       ;  1TCY
Loop_5:   
    NOP                      ;   x*TCY
    DECFSZ Contador1,1,0     ;  (x-1) + 3*TCY
    GOTO   Loop_5            ;  (x-1)*2TCY
    RETURN                   ;  2*TCY
                                  
    ;Sexto_retardo(250us)
Delay_250us:                 ;  2TCY -> CALL
    MOVLW  61                ;  1TCY
    MOVWF  Contador1,0       ;  1TCY
Loop_6:   
    NOP                      ;   x*TCY
    DECFSZ Contador1,1,0     ;  (x-1) + 3*TCY
    GOTO   Loop_6            ;  (x-1)*2TCY
    RETURN                   ;  2*TCY
                                  
    ;Septimo_retardo(500us)
Delay_500us:                 ;  2TCY -> CALL
    MOVLW  124               ;  1TCY
    MOVWF  Contador1,0       ;  1TCY
Loop_7:   
    NOP                      ;   x*TCY
    DECFSZ Contador1,1,0     ;  (x-1) + 3*TCY
    GOTO   Loop_7            ;  (x-1)*2TCY
    RETURN                   ;  2*TCY
   
    ;Octavo_retardo(1ms)
Delay_1ms:                    ;  2TCY -> Call
    MOVLW  1                  ;  1TCY
    MOVWF  Contador2,0        ;  1TCY
Loop_Ext_1:  
    MOVLW  249                ;  x2*TCY
    MOVWF  Contador1,0        ;  x2*TCY
Loop_Int_1:
    Nop                       ;  x2*x*TCY
    DECFSZ Contador1,1,0      ;  x2*((x-1) + 3*TCY)
    GOTO   Loop_Int_1         ;  x2((x-1)*2TCY)
    DECFSZ Contador2,1,0      ;  (x2-1) + 3*TCY
    GOTO   Loop_Ext_1         ;  (x2-1)*2TCY
    RETURN                    ;  2*TCY

    ;Noveno_retardo(5ms)
Delay_5ms:                    ;  2TCY -> Call
    MOVLW  5                  ;  1TCY
    MOVWF  Contador2,0        ;  1TCY
Loop_Ext_2:  
    MOVLW  249                ;  x2*TCY
    MOVWF  Contador1,0        ;  x2*TCY
Loop_Int_2:
    Nop                       ;  x2*x*TCY
    DECFSZ Contador1,1,0      ;  x2*((x-1) + 3*TCY)
    GOTO   Loop_Int_2         ;  x2((x-1)*2TCY)
    DECFSZ Contador2,1,0      ;  (x2-1) + 3*TCY
    GOTO   Loop_Ext_2         ;  (x2-1)*2TCY
    RETURN                    ;  2*TCY
    
    ;Decimo_retardo(10ms)
Delay_10ms:                   ;  2TCY -> Call
    MOVLW  10                 ;  1TCY
    MOVWF  Contador2,0        ;  1TCY
Loop_Ext_3:  
    MOVLW  249                ;  x2*TCY
    MOVWF  Contador1,0        ;  x2*TCY
Loop_Int_3:
    Nop                       ;  x2*x*TCY
    DECFSZ Contador1,1,0      ;  x2*((x-1) + 3*TCY)
    GOTO   Loop_Int_3         ;  x2((x-1)*2TCY)
    DECFSZ Contador2,1,0      ;  (x2-1) + 3*TCY
    GOTO   Loop_Ext_3         ;  (x2-1)*2TCY
    RETURN                    ;  2*TCY  
    
    ;Onceavo_retardo(25ms)
Delay_25ms:                   ;  2TCY -> Call
    MOVLW  25                 ;  1TCY
    MOVWF  Contador2,0        ;  1TCY
Loop_Ext_4:  
    MOVLW  249                ;  x2*TCY
    MOVWF  Contador1,0        ;  x2*TCY
Loop_Int_4:
    Nop                       ;  x2*x*TCY
    DECFSZ Contador1,1,0      ;  x2*((x-1) + 3*TCY)
    GOTO   Loop_Int_4         ;  x2((x-1)*2TCY)
    DECFSZ Contador2,1,0      ;  (x2-1) + 3*TCY
    GOTO   Loop_Ext_4         ;  (x2-1)*2TCY
    RETURN                    ;  2*TCY    
    
    ;Doceavo_retardo(50ms)
Delay_50ms:                   ;  2TCY -> Call
    MOVLW  50                 ;  1TCY
    MOVWF  Contador2,0        ;  1TCY
Loop_Ext_5:  
    MOVLW  249                ;  x2*TCY
    MOVWF  Contador1,0        ;  x2*TCY
Loop_Int_5:
    Nop                       ;  x2*x*TCY
    DECFSZ Contador1,1,0      ;  x2*((x-1) + 3*TCY)
    GOTO   Loop_Int_5         ;  x2((x-1)*2TCY)
    DECFSZ Contador2,1,0      ;  (x2-1) + 3*TCY
    GOTO   Loop_Ext_5         ;  (x2-1)*2TCY
    RETURN                    ;  2*TCY  
                                   
    ;Treceavo_retardo(100ms)
Delay_100ms:                  ;  2TCY -> Call
    MOVLW  100                ;  1TCY
    MOVWF  Contador2,0        ;  1TCY
Loop_Ext_6:  
    MOVLW  249                ;  x2*TCY
    MOVWF  Contador1,0        ;  x2*TCY
Loop_Int_6:
    Nop                       ;  x2*x*TCY
    DECFSZ Contador1,1,0      ;  x2*((x-1) + 3*TCY)
    GOTO   Loop_Int_6         ;  x2((x-1)*2TCY)
    DECFSZ Contador2,1,0      ;  (x2-1) + 3*TCY
    GOTO   Loop_Ext_6         ;  (x2-1)*2TCY
    RETURN                    ;  2*TCY                              
   
    ;Catorceavo_retardo(200ms)
Delay_200ms:                  ;  2TCY -> Call
    MOVLW  200                ;  1TCY
    MOVWF  Contador2,0        ;  1TCY
Loop_Ext_7:  
    MOVLW  249                ;  x2*TCY
    MOVWF  Contador1,0        ;  x2*TCY
Loop_Int_7:
    Nop                       ;  x2*x*TCY
    DECFSZ Contador1,1,0      ;  x2*((x-1) + 3*TCY)
    GOTO   Loop_Int_7         ;  x2((x-1)*2TCY)
    DECFSZ Contador2,1,0      ;  (x2-1) + 3*TCY
    GOTO   Loop_Ext_7         ;  (x2-1)*2TCY
    RETURN                    ;  2*TCY 
    
    ;Quinceavo_retardo(250ms)
Delay_250ms:                  ;  2TCY -> Call
    MOVLW  250                ;  1TCY
    MOVWF  Contador2,0        ;  1TCY
Loop_Ext_8:  
    MOVLW  249                ;  x2*TCY
    MOVWF  Contador1,0        ;  x2*TCY
Loop_Int_8:
    Nop                       ;  x2*x*TCY
    DECFSZ Contador1,1,0      ;  x2*((x-1) + 3*TCY)
    GOTO   Loop_Int_8         ;  x2((x-1)*2TCY)
    DECFSZ Contador2,1,0      ;  (x2-1) + 3*TCY
    GOTO   Loop_Ext_8         ;  (x2-1)*2TCY
    RETURN                    ;  2*TCY


