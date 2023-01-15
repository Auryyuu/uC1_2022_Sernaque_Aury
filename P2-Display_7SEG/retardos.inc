;PSECT udata_acs
contador_1: DS 1   
contador_2: DS 1            ; reserva 1 byte en access ram
contador_3: DS 1    
PSECT code
Delay_1s:
    MOVLW 4
    MOVWF contador_3,0
    Loop_250ms:			  ;2tcy
    MOVLW 250				  ;1tcy
    MOVWF contador_2,0			  ;1tcy
    Loop_1s:			     
    MOVLW   249				  ;k Tcy
    MOVWF   contador_1,0			  ;k tcy
    INT_LOOP9:			    
    Nop					  ;249k TCY
    DECFSZ  contador_1,1,0		  ;251k TCY 
    Goto    INT_LOOP9			  ;496k TCY
    DECFSZ  contador_2,1,0		  ;(k-1)+3tcy
    GOTO    Loop_1s			  ;(k-1)*2tcy
    DECFSZ  contador_3,1,0
    GOTO Loop_250ms
    RETURN			           ;2 TCY