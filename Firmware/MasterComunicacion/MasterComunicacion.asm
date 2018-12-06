
_ConfiguracionPrincipal:

;MasterComunicacion.c,61 :: 		void ConfiguracionPrincipal(){
;MasterComunicacion.c,63 :: 		TRISB0_bit = 1;
	BSF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;MasterComunicacion.c,64 :: 		TRISB1_bit = 0;
	BCF        TRISB1_bit+0, BitPos(TRISB1_bit+0)
;MasterComunicacion.c,65 :: 		TRISB2_bit = 1;
	BSF        TRISB2_bit+0, BitPos(TRISB2_bit+0)
;MasterComunicacion.c,66 :: 		TRISB3_bit = 0;
	BCF        TRISB3_bit+0, BitPos(TRISB3_bit+0)
;MasterComunicacion.c,67 :: 		TRISB5_bit = 0;
	BCF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;MasterComunicacion.c,68 :: 		TRISB6_bit = 0;
	BCF        TRISB6_bit+0, BitPos(TRISB6_bit+0)
;MasterComunicacion.c,70 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF        INTCON+0, 7
;MasterComunicacion.c,71 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF        INTCON+0, 6
;MasterComunicacion.c,74 :: 		UART1_Init(19200);                                 //Inicializa el UART1 a 19200 bps
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;MasterComunicacion.c,77 :: 		T1CON = 0x30;
	MOVLW      48
	MOVWF      T1CON+0
;MasterComunicacion.c,78 :: 		TMR1IF_bit = 0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;MasterComunicacion.c,79 :: 		TMR1H = 0x0B;
	MOVLW      11
	MOVWF      TMR1H+0
;MasterComunicacion.c,80 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;MasterComunicacion.c,81 :: 		TMR1IE_bit = 1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;MasterComunicacion.c,82 :: 		INTCON = 0xC0;
	MOVLW      192
	MOVWF      INTCON+0
;MasterComunicacion.c,85 :: 		T2CON = 0x78;
	MOVLW      120
	MOVWF      T2CON+0
;MasterComunicacion.c,86 :: 		PR2 = 249;
	MOVLW      249
	MOVWF      PR2+0
;MasterComunicacion.c,87 :: 		TMR2IE_bit        = 1;
	BSF        TMR2IE_bit+0, BitPos(TMR2IE_bit+0)
;MasterComunicacion.c,90 :: 		INTCON.INTE = 1;                                   //Habilita la interrupcion externa
	BSF        INTCON+0, 4
;MasterComunicacion.c,91 :: 		INTCON.INTF = 0;                                   //Limpia la bandera de interrupcion externa
	BCF        INTCON+0, 1
;MasterComunicacion.c,92 :: 		OPTION_REG.INTEDG = 0;                             //Activa la interrupcion en el flanco de bajada
	BCF        OPTION_REG+0, 6
;MasterComunicacion.c,94 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_ConfiguracionPrincipal0:
	DECFSZ     R13+0, 1
	GOTO       L_ConfiguracionPrincipal0
	DECFSZ     R12+0, 1
	GOTO       L_ConfiguracionPrincipal0
	DECFSZ     R11+0, 1
	GOTO       L_ConfiguracionPrincipal0
	NOP
;MasterComunicacion.c,96 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN
; end of _ConfiguracionPrincipal

_CalcularCRC:

;MasterComunicacion.c,102 :: 		unsigned int CalcularCRC(unsigned char* trama, unsigned char tramaSize){
;MasterComunicacion.c,105 :: 		for(CRC16=0xFFFF; tramaSize!=0; tramaSize --){
	MOVLW      255
	MOVWF      R3+0
	MOVLW      255
	MOVWF      R3+1
L_CalcularCRC1:
	MOVF       FARG_CalcularCRC_tramaSize+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_CalcularCRC2
;MasterComunicacion.c,106 :: 		CRC16 ^=*trama ++;
	MOVF       FARG_CalcularCRC_trama+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORWF      R3+0, 1
	MOVLW      0
	XORWF      R3+1, 1
	INCF       FARG_CalcularCRC_trama+0, 1
;MasterComunicacion.c,107 :: 		for(ucCounter =0; ucCounter <8; ucCounter ++){
	CLRF       R2+0
L_CalcularCRC4:
	MOVLW      8
	SUBWF      R2+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_CalcularCRC5
;MasterComunicacion.c,108 :: 		if(CRC16 & 0x0001)
	BTFSS      R3+0, 0
	GOTO       L_CalcularCRC7
;MasterComunicacion.c,109 :: 		CRC16 = (CRC16 >>1)^POLMODBUS;
	RRF        R3+1, 1
	RRF        R3+0, 1
	BCF        R3+1, 7
	MOVLW      1
	XORWF      R3+0, 1
	MOVLW      160
	XORWF      R3+1, 1
	GOTO       L_CalcularCRC8
L_CalcularCRC7:
;MasterComunicacion.c,111 :: 		CRC16>>=1;
	RRF        R3+1, 1
	RRF        R3+0, 1
	BCF        R3+1, 7
L_CalcularCRC8:
;MasterComunicacion.c,107 :: 		for(ucCounter =0; ucCounter <8; ucCounter ++){
	INCF       R2+0, 1
;MasterComunicacion.c,112 :: 		}
	GOTO       L_CalcularCRC4
L_CalcularCRC5:
;MasterComunicacion.c,105 :: 		for(CRC16=0xFFFF; tramaSize!=0; tramaSize --){
	DECF       FARG_CalcularCRC_tramaSize+0, 1
;MasterComunicacion.c,113 :: 		}
	GOTO       L_CalcularCRC1
L_CalcularCRC2:
;MasterComunicacion.c,114 :: 		return CRC16;
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
;MasterComunicacion.c,115 :: 		}
L_end_CalcularCRC:
	RETURN
; end of _CalcularCRC

_EnviarMensajeRS485:

;MasterComunicacion.c,119 :: 		void EnviarMensajeRS485(unsigned char *tramaPDU, unsigned char sizePDU){
;MasterComunicacion.c,123 :: 		CRCPDU = CalcularCRC(tramaPDU, sizePDU);           //Calcula el CRC de la trama pdu
	MOVF       FARG_EnviarMensajeRS485_tramaPDU+0, 0
	MOVWF      FARG_CalcularCRC_trama+0
	MOVF       FARG_EnviarMensajeRS485_sizePDU+0, 0
	MOVWF      FARG_CalcularCRC_tramaSize+0
	CALL       _CalcularCRC+0
	MOVF       R0+0, 0
	MOVWF      EnviarMensajeRS485_CRCPDU_L0+0
	MOVF       R0+1, 0
	MOVWF      EnviarMensajeRS485_CRCPDU_L0+1
;MasterComunicacion.c,124 :: 		ptrCRCPDU = &CRCPDU;                               //Asociacion del puntero CrcTramaError
	MOVLW      EnviarMensajeRS485_CRCPDU_L0+0
	MOVWF      EnviarMensajeRS485_ptrCRCPDU_L0+0
;MasterComunicacion.c,126 :: 		tramaRS485[0]=HDR;                                 //A�ade la cabecera a la trama a enviar
	MOVLW      58
	MOVWF      _tramaRS485+0
;MasterComunicacion.c,127 :: 		tramaRS485[sizePDU+2]=*ptrCrcPdu;                  //Asigna al elemento CRC_LSB de la trama de respuesta el LSB de la variable crcTramaError
	MOVLW      2
	ADDWF      FARG_EnviarMensajeRS485_sizePDU+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _tramaRS485+0
	MOVWF      R1+0
	MOVF       EnviarMensajeRS485_ptrCRCPDU_L0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;MasterComunicacion.c,128 :: 		tramaRS485[sizePDU+1]=*(ptrCrcPdu+1);              //Asigna al elemento CRC_MSB de la trama de respuesta el MSB de la variable crcTramaError
	MOVF       FARG_EnviarMensajeRS485_sizePDU+0, 0
	ADDLW      1
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _tramaRS485+0
	MOVWF      R1+0
	INCF       EnviarMensajeRS485_ptrCRCPDU_L0+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;MasterComunicacion.c,129 :: 		tramaRS485[sizePDU+3]=END1;                        //A�ade el primer delimitador de final de trama
	MOVLW      3
	ADDWF      FARG_EnviarMensajeRS485_sizePDU+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _tramaRS485+0
	MOVWF      FSR
	MOVLW      13
	MOVWF      INDF+0
;MasterComunicacion.c,130 :: 		tramaRS485[sizePDU+4]=END2;                        //A�ade el segundo delimitador de final de trama
	MOVLW      4
	ADDWF      FARG_EnviarMensajeRS485_sizePDU+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _tramaRS485+0
	MOVWF      FSR
	MOVLW      10
	MOVWF      INDF+0
;MasterComunicacion.c,131 :: 		RE_DE = 1;                                         //Establece el Max485 en modo escritura
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;MasterComunicacion.c,132 :: 		for (i=0;i<(sizePDU+5);i++){
	CLRF       EnviarMensajeRS485_i_L0+0
L_EnviarMensajeRS4859:
	MOVLW      5
	ADDWF      FARG_EnviarMensajeRS485_sizePDU+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__EnviarMensajeRS48564
	MOVF       R1+0, 0
	SUBWF      EnviarMensajeRS485_i_L0+0, 0
L__EnviarMensajeRS48564:
	BTFSC      STATUS+0, 0
	GOTO       L_EnviarMensajeRS48510
;MasterComunicacion.c,133 :: 		if ((i>=1)&&(i<=sizePDU)){
	MOVLW      1
	SUBWF      EnviarMensajeRS485_i_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_EnviarMensajeRS48514
	MOVF       EnviarMensajeRS485_i_L0+0, 0
	SUBWF      FARG_EnviarMensajeRS485_sizePDU+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_EnviarMensajeRS48514
L__EnviarMensajeRS48556:
;MasterComunicacion.c,135 :: 		UART1_Write(tramaPDU[i-1]);                 //Envia el contenido de la trama PDU a travez del UART1
	MOVLW      1
	SUBWF      EnviarMensajeRS485_i_L0+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_EnviarMensajeRS485_tramaPDU+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;MasterComunicacion.c,136 :: 		} else {
	GOTO       L_EnviarMensajeRS48515
L_EnviarMensajeRS48514:
;MasterComunicacion.c,137 :: 		UART1_Write(tramaRS485[i]);                 //Envia el contenido del resto de la trama de peticion a travez del UART1
	MOVF       EnviarMensajeRS485_i_L0+0, 0
	ADDLW      _tramaRS485+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;MasterComunicacion.c,138 :: 		}
L_EnviarMensajeRS48515:
;MasterComunicacion.c,132 :: 		for (i=0;i<(sizePDU+5);i++){
	INCF       EnviarMensajeRS485_i_L0+0, 1
;MasterComunicacion.c,139 :: 		}
	GOTO       L_EnviarMensajeRS4859
L_EnviarMensajeRS48510:
;MasterComunicacion.c,140 :: 		while(UART1_Tx_Idle()==0);                         //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarMensajeRS48516:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_EnviarMensajeRS48517
	GOTO       L_EnviarMensajeRS48516
L_EnviarMensajeRS48517:
;MasterComunicacion.c,141 :: 		RE_DE = 0;                                         //Establece el Max485-2 en modo de lectura;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;MasterComunicacion.c,143 :: 		byteTrama=0;                                    //Limpia la variable del byte de la trama de peticion
	CLRF       _byteTrama+0
;MasterComunicacion.c,147 :: 		T1CON.TMR1ON = 1;                                  //Enciende el Timer1
	BSF        T1CON+0, 0
;MasterComunicacion.c,148 :: 		TMR1IF_bit = 0;                                    //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;MasterComunicacion.c,149 :: 		TMR1H = 0x0B;                                      //Se carga el valor del preload correspondiente al tiempo de 250ms
	MOVLW      11
	MOVWF      TMR1H+0
;MasterComunicacion.c,150 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;MasterComunicacion.c,151 :: 		}
L_end_EnviarMensajeRS485:
	RETURN
; end of _EnviarMensajeRS485

_VerificarCRC:

;MasterComunicacion.c,158 :: 		unsigned int VerificarCRC(unsigned char* trama, unsigned char tramaPDUSize){
;MasterComunicacion.c,163 :: 		crcCalculado = 0;                                  //Inicializa los valores del CRC obtenido y calculado con valores diferentes
	CLRF       VerificarCRC_crcCalculado_L0+0
	CLRF       VerificarCRC_crcCalculado_L0+1
;MasterComunicacion.c,164 :: 		crcTrama = 1;
	MOVLW      1
	MOVWF      VerificarCRC_crcTrama_L0+0
	MOVLW      0
	MOVWF      VerificarCRC_crcTrama_L0+1
;MasterComunicacion.c,165 :: 		for (j=0;j<=(tramaPDUSize);j++){                   //Rellena la trama de PDU con los datos de interes de la trama de peticion, es decir, obviando los ultimos 2 bytes de CRC y los 2 de End
	CLRF       VerificarCRC_j_L0+0
L_VerificarCRC18:
	MOVF       VerificarCRC_j_L0+0, 0
	SUBWF      FARG_VerificarCRC_tramaPDUSize+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_VerificarCRC19
;MasterComunicacion.c,166 :: 		pdu[j] = trama[j+1];
	MOVF       VerificarCRC_j_L0+0, 0
	ADDLW      VerificarCRC_pdu_L0+0
	MOVWF      R2+0
	MOVF       VerificarCRC_j_L0+0, 0
	ADDLW      1
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_VerificarCRC_trama+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;MasterComunicacion.c,165 :: 		for (j=0;j<=(tramaPDUSize);j++){                   //Rellena la trama de PDU con los datos de interes de la trama de peticion, es decir, obviando los ultimos 2 bytes de CRC y los 2 de End
	INCF       VerificarCRC_j_L0+0, 1
;MasterComunicacion.c,167 :: 		}
	GOTO       L_VerificarCRC18
L_VerificarCRC19:
;MasterComunicacion.c,168 :: 		crcCalculado = CalcularCRC(pdu, tramaPDUSize);     //Invoca la funcion para el calculo del CRC de la trama PDU
	MOVLW      VerificarCRC_pdu_L0+0
	MOVWF      FARG_CalcularCRC_trama+0
	MOVF       FARG_VerificarCRC_tramaPDUSize+0, 0
	MOVWF      FARG_CalcularCRC_tramaSize+0
	CALL       _CalcularCRC+0
	MOVF       R0+0, 0
	MOVWF      VerificarCRC_crcCalculado_L0+0
	MOVF       R0+1, 0
	MOVWF      VerificarCRC_crcCalculado_L0+1
;MasterComunicacion.c,169 :: 		ptrCRCTrama = &CRCTrama;                           //Asociacion del puntero CRCPDU
	MOVLW      VerificarCRC_crcTrama_L0+0
	MOVWF      VerificarCRC_ptrCRCTrama_L0+0
;MasterComunicacion.c,170 :: 		*ptrCRCTrama = trama[tramaPDUSize+2];              //Asigna el elemento CRC_LSB de la trama de respuesta al LSB de la variable CRCPDU
	MOVLW      2
	ADDWF      FARG_VerificarCRC_tramaPDUSize+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_VerificarCRC_trama+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       VerificarCRC_ptrCRCTrama_L0+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;MasterComunicacion.c,171 :: 		*(ptrCRCTrama+1) = trama[tramaPDUSize+1];          //Asigna el elemento CRC_MSB de la trama de respuesta al MSB de la variable CRCPDU
	INCF       VerificarCRC_ptrCRCTrama_L0+0, 0
	MOVWF      R2+0
	MOVF       FARG_VerificarCRC_tramaPDUSize+0, 0
	ADDLW      1
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       R0+0, 0
	ADDWF      FARG_VerificarCRC_trama+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;MasterComunicacion.c,172 :: 		if (crcCalculado==CRCTrama) {                      //Verifica si el CRC calculado sea igual al CRC obtenido de la trama de peticion
	MOVF       VerificarCRC_crcCalculado_L0+1, 0
	XORWF      VerificarCRC_crcTrama_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__VerificarCRC66
	MOVF       VerificarCRC_crcTrama_L0+0, 0
	XORWF      VerificarCRC_crcCalculado_L0+0, 0
L__VerificarCRC66:
	BTFSS      STATUS+0, 2
	GOTO       L_VerificarCRC21
;MasterComunicacion.c,173 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_VerificarCRC
;MasterComunicacion.c,174 :: 		} else {
L_VerificarCRC21:
;MasterComunicacion.c,175 :: 		return 0;
	CLRF       R0+0
	CLRF       R0+1
;MasterComunicacion.c,177 :: 		}
L_end_VerificarCRC:
	RETURN
; end of _VerificarCRC

_EnviarACK:

;MasterComunicacion.c,183 :: 		void EnviarACK(){
;MasterComunicacion.c,184 :: 		RE_DE = 1;                                         //Establece el Max485 en modo escritura
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;MasterComunicacion.c,185 :: 		UART1_Write(ACK);                                  //Envia el valor de la Cabecera de la trama ACK por el puerto UART1
	MOVLW      170
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;MasterComunicacion.c,186 :: 		while(UART1_Tx_Idle()==0);                         //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarACK23:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_EnviarACK24
	GOTO       L_EnviarACK23
L_EnviarACK24:
;MasterComunicacion.c,187 :: 		RE_DE = 0;                                         //Establece el Max485 en modo de lectura;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;MasterComunicacion.c,188 :: 		}
L_end_EnviarACK:
	RETURN
; end of _EnviarACK

_EnviarNACK:

;MasterComunicacion.c,194 :: 		void EnviarNACK(){
;MasterComunicacion.c,195 :: 		RE_DE = 1;                                         //Establece el Max485 en modo escritura
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;MasterComunicacion.c,196 :: 		UART1_Write(NACK);                                 //Envia el valor de la Cabecera de la trama ACK por el puerto UART1
	MOVLW      175
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;MasterComunicacion.c,197 :: 		while(UART1_Tx_Idle()==0);                         //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarNACK25:
	CALL       _UART1_Tx_Idle+0
	MOVF       R0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_EnviarNACK26
	GOTO       L_EnviarNACK25
L_EnviarNACK26:
;MasterComunicacion.c,198 :: 		RE_DE = 0;                                         //Establece el Max485 en modo de lectura;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;MasterComunicacion.c,199 :: 		}
L_end_EnviarNACK:
	RETURN
; end of _EnviarNACK

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MasterComunicacion.c,205 :: 		void interrupt(){
;MasterComunicacion.c,209 :: 		if (INTCON.INTF==1){
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt27
;MasterComunicacion.c,210 :: 		INTCON.INTF=0;                                  //Limpia la badera de interrupcion externa
	BCF        INTCON+0, 1
;MasterComunicacion.c,213 :: 		tramaSPI[0]=0x09;                               //Id esclavo
	MOVLW      9
	MOVWF      _tramaSPI+0
;MasterComunicacion.c,214 :: 		tramaSPI[1]=0x02;                               //# datos
	MOVLW      2
	MOVWF      _tramaSPI+1
;MasterComunicacion.c,215 :: 		tramaSPI[2]=0x05;                               //Funcion
	MOVLW      5
	MOVWF      _tramaSPI+2
;MasterComunicacion.c,216 :: 		tramaSPI[3]=0x06;                               //Dato 1
	MOVLW      6
	MOVWF      _tramaSPI+3
;MasterComunicacion.c,217 :: 		tramaSPI[4]=0x07;                               //Dato 2
	MOVLW      7
	MOVWF      _tramaSPI+4
;MasterComunicacion.c,219 :: 		direccionRpi = tramaSPI[0];                     //Guarda el dato de la direccion del dispositvo con que se desea comunicar
	MOVF       _tramaSPI+0, 0
	MOVWF      _direccionRpi+0
;MasterComunicacion.c,220 :: 		sizeSPI = tramaSPI[1] + 3;                      //Guarda el dato de la longitud de la trama PDU
	MOVLW      5
	MOVWF      _sizeSPI+0
;MasterComunicacion.c,221 :: 		funcionRpi = tramaSPI[2];                       //Guarda el dato de la funcion requerida
	MOVLW      5
	MOVWF      _funcionRpi+0
;MasterComunicacion.c,223 :: 		if (direccionRpi==0xFD || direccionRpi==0xFE || direccionRpi==0xFF){
	MOVF       _tramaSPI+0, 0
	XORLW      253
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt60
	MOVF       _direccionRpi+0, 0
	XORLW      254
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt60
	MOVF       _direccionRpi+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L__interrupt60
	GOTO       L_interrupt30
L__interrupt60:
;MasterComunicacion.c,224 :: 		if (funcionRpi==0x01){                       //Verifica el campo de Funcion para ver si se trata de una sincronizacion de segundos
	MOVF       _funcionRpi+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt31
;MasterComunicacion.c,226 :: 		} else if (funcionRpi==0x02){                //Verifica el campo de Funcion para ver si se trata de una solicitud de sincronizacion de fecha y hora
	GOTO       L_interrupt32
L_interrupt31:
	MOVF       _funcionRpi+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt33
;MasterComunicacion.c,228 :: 		} else {
	GOTO       L_interrupt34
L_interrupt33:
;MasterComunicacion.c,229 :: 		EnviarMensajeRS485(tramaSPI, sizeSPI);    //Invoca a la funcion para enviar la peticion
	MOVLW      _tramaSPI+0
	MOVWF      FARG_EnviarMensajeRS485_tramaPDU+0
	MOVF       _sizeSPI+0, 0
	MOVWF      FARG_EnviarMensajeRS485_sizePDU+0
	CALL       _EnviarMensajeRS485+0
;MasterComunicacion.c,230 :: 		}
L_interrupt34:
L_interrupt32:
;MasterComunicacion.c,231 :: 		} else {
	GOTO       L_interrupt35
L_interrupt30:
;MasterComunicacion.c,232 :: 		EnviarMensajeRS485(tramaSPI, sizeSPI);       //Invoca a la funcion para enviar la peticion
	MOVLW      _tramaSPI+0
	MOVWF      FARG_EnviarMensajeRS485_tramaPDU+0
	MOVF       _sizeSPI+0, 0
	MOVWF      FARG_EnviarMensajeRS485_sizePDU+0
	CALL       _EnviarMensajeRS485+0
;MasterComunicacion.c,233 :: 		}
L_interrupt35:
;MasterComunicacion.c,235 :: 		}
L_interrupt27:
;MasterComunicacion.c,243 :: 		if (PIR1.F5==1){
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt36
;MasterComunicacion.c,245 :: 		IU1 = 1;                                        //Enciende el indicador de interrupcion por UART1
	BSF        RC4_bit+0, BitPos(RC4_bit+0)
;MasterComunicacion.c,246 :: 		byteTrama = UART1_Read();                       //Lee el byte de la trama de peticion
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _byteTrama+0
;MasterComunicacion.c,248 :: 		if ((byteTrama==ACK)&&(banTI==0)){              //Verifica si recibio un ACK
	MOVF       R0+0, 0
	XORLW      170
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt39
	MOVF       _banTI+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt39
L__interrupt59:
;MasterComunicacion.c,250 :: 		TMR1IF_bit = 0;                              //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;MasterComunicacion.c,251 :: 		T1CON.TMR1ON = 0;                            //Apaga el Timer1
	BCF        T1CON+0, 0
;MasterComunicacion.c,252 :: 		banTI=0;                                     //Limpia la bandera de inicio de trama
	CLRF       _banTI+0
;MasterComunicacion.c,253 :: 		byteTrama=0;                                 //Limpia la variable del byte de la trama de peticion
	CLRF       _byteTrama+0
;MasterComunicacion.c,254 :: 		}
L_interrupt39:
;MasterComunicacion.c,256 :: 		if ((byteTrama==NACK)&&(banTI==0)){             //Verifica si recibio un NACK
	MOVF       _byteTrama+0, 0
	XORLW      175
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt42
	MOVF       _banTI+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt42
L__interrupt58:
;MasterComunicacion.c,258 :: 		TMR1IF_bit = 0;                              //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;MasterComunicacion.c,259 :: 		T1CON.TMR1ON = 0;                            //Apaga el Timer1
	BCF        T1CON+0, 0
;MasterComunicacion.c,260 :: 		if (contadorNACK<3){
	MOVLW      3
	SUBWF      _contadorNACK+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt43
;MasterComunicacion.c,261 :: 		EnviarMensajeRS485(tramaSPI, sizeSPI);    //Si recibe un NACK como respuesta, le renvia la trama
	MOVLW      _tramaSPI+0
	MOVWF      FARG_EnviarMensajeRS485_tramaPDU+0
	MOVF       _sizeSPI+0, 0
	MOVWF      FARG_EnviarMensajeRS485_sizePDU+0
	CALL       _EnviarMensajeRS485+0
;MasterComunicacion.c,262 :: 		contadorNACK++;                           //Incrrmenta en una unidad el valor del contador de NACK
	INCF       _contadorNACK+0, 1
;MasterComunicacion.c,263 :: 		} else {
	GOTO       L_interrupt44
L_interrupt43:
;MasterComunicacion.c,265 :: 		contadorNACK = 0;                         //Limpia el contador de Time-Out-Trama
	CLRF       _contadorNACK+0
;MasterComunicacion.c,266 :: 		EnviarACK();
	CALL       _EnviarACK+0
;MasterComunicacion.c,267 :: 		}
L_interrupt44:
;MasterComunicacion.c,268 :: 		banTI=0;                                     //Limpia la bandera de inicio de trama
	CLRF       _banTI+0
;MasterComunicacion.c,269 :: 		byteTrama=0;                                 //Limpia la variable del byte de la trama de peticion
	CLRF       _byteTrama+0
;MasterComunicacion.c,270 :: 		}
L_interrupt42:
;MasterComunicacion.c,272 :: 		if ((byteTrama==HDR)&&(banTI==0)){
	MOVF       _byteTrama+0, 0
	XORLW      58
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt47
	MOVF       _banTI+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt47
L__interrupt57:
;MasterComunicacion.c,273 :: 		tramaRS485[0]=byteTrama;                     //Guarda el primer byte de la trama en la primera posicion de la trama de peticion
	MOVF       _byteTrama+0, 0
	MOVWF      _tramaRS485+0
;MasterComunicacion.c,274 :: 		banTI = 1;                                   //Activa la bandera de inicio de trama
	MOVLW      1
	MOVWF      _banTI+0
;MasterComunicacion.c,275 :: 		i1 = 1;                                      //Define en 1 el subindice de la trama de peticion
	MOVLW      1
	MOVWF      _i1+0
;MasterComunicacion.c,276 :: 		tramaOk = 0;                                 //Limpia la variable que indica si la trama ha llegado correctamente
	CLRF       _tramaOk+0
;MasterComunicacion.c,280 :: 		}
L_interrupt47:
;MasterComunicacion.c,282 :: 		if (banTI==1){                                  //Verifica que la bandera de inicio de trama este activa
	MOVF       _banTI+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt48
;MasterComunicacion.c,284 :: 		}
L_interrupt48:
;MasterComunicacion.c,287 :: 		if (banTC==1){                                  //Verifica que se haya completado de llenar la trama de peticion
	MOVF       _banTC+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt49
;MasterComunicacion.c,289 :: 		tramaOk = VerificarCRC(tramaRS485,t1Size);   //Calcula y verifica el CRC de la trama de peticion
	MOVLW      _tramaRS485+0
	MOVWF      FARG_VerificarCRC_trama+0
	MOVF       _t1Size+0, 0
	MOVWF      FARG_VerificarCRC_tramaPDUSize+0
	CALL       _VerificarCRC+0
	MOVF       R0+0, 0
	MOVWF      _tramaOk+0
;MasterComunicacion.c,291 :: 		if (tramaOk==1){
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt50
;MasterComunicacion.c,292 :: 		EnviarACK();                             //Si la trama llego sin errores responde con un ACK al esclavo
	CALL       _EnviarACK+0
;MasterComunicacion.c,294 :: 		} else {
	GOTO       L_interrupt51
L_interrupt50:
;MasterComunicacion.c,295 :: 		EnviarNACK();                            //Si hubo algun error en la trama se envia un ACK al H/S para que reenvie la trama
	CALL       _EnviarNACK+0
;MasterComunicacion.c,296 :: 		}
L_interrupt51:
;MasterComunicacion.c,297 :: 		banTC = 0;                                   //Limpia la bandera de trama completa
	CLRF       _banTC+0
;MasterComunicacion.c,298 :: 		i1 = 0;                                      //Limpia el subindice de trama
	CLRF       _i1+0
;MasterComunicacion.c,300 :: 		}
L_interrupt49:
;MasterComunicacion.c,302 :: 		PIR1.F5 = 0;                                    //Limpia la bandera de interrupcion de UART2
	BCF        PIR1+0, 5
;MasterComunicacion.c,303 :: 		IU1 = 0;                                        //Apaga el indicador de interrupcion por UART2
	BCF        RC4_bit+0, BitPos(RC4_bit+0)
;MasterComunicacion.c,306 :: 		}
L_interrupt36:
;MasterComunicacion.c,312 :: 		if (PIR1.TMR1IF==1){
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt52
;MasterComunicacion.c,313 :: 		TMR1IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;MasterComunicacion.c,314 :: 		T1CON.TMR1ON = 0;                               //Apaga el Timer1
	BCF        T1CON+0, 0
;MasterComunicacion.c,316 :: 		if (contadorTOD<3){
	MOVLW      3
	SUBWF      _contadorTOD+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt53
;MasterComunicacion.c,317 :: 		EnviarMensajeRS485(tramaSPI, sizeSPI);       //Reenvia la trama por el bus RS485
	MOVLW      _tramaSPI+0
	MOVWF      FARG_EnviarMensajeRS485_tramaPDU+0
	MOVF       _sizeSPI+0, 0
	MOVWF      FARG_EnviarMensajeRS485_sizePDU+0
	CALL       _EnviarMensajeRS485+0
;MasterComunicacion.c,318 :: 		contadorTOD++;                               //Incrementa el contador de Time-Out-Dispositivo en una unidad
	INCF       _contadorTOD+0, 1
;MasterComunicacion.c,319 :: 		} else {
	GOTO       L_interrupt54
L_interrupt53:
;MasterComunicacion.c,321 :: 		contadorTOD = 0;                             //Limpia el contador de Time-Out-Dispositivo
	CLRF       _contadorTOD+0
;MasterComunicacion.c,322 :: 		}
L_interrupt54:
;MasterComunicacion.c,323 :: 		}
L_interrupt52:
;MasterComunicacion.c,330 :: 		if (PIR1.TMR2IF==1){
	BTFSS      PIR1+0, 1
	GOTO       L_interrupt55
;MasterComunicacion.c,331 :: 		TMR2IF_bit = 0;                                 //Limpia la bandera de interrupcion por desbordamiento del TMR2
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;MasterComunicacion.c,332 :: 		T2CON.TMR2ON = 0;                               //Apaga el Timer2
	BCF        T2CON+0, 2
;MasterComunicacion.c,333 :: 		banTI = 0;                                      //Limpia la bandera de inicio de trama
	CLRF       _banTI+0
;MasterComunicacion.c,334 :: 		i1 = 0;                                         //Limpia el subindice de la trama de peticion
	CLRF       _i1+0
;MasterComunicacion.c,335 :: 		banTC = 0;                                      //Limpia la bandera de trama completa(Por si acaso)
	CLRF       _banTC+0
;MasterComunicacion.c,336 :: 		EnviarNACK();                                   //Envia un NACK para solicitar el reenvio de la trama
	CALL       _EnviarNACK+0
;MasterComunicacion.c,337 :: 		}
L_interrupt55:
;MasterComunicacion.c,339 :: 		}
L_end_interrupt:
L__interrupt70:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MasterComunicacion.c,343 :: 		void main() {
;MasterComunicacion.c,345 :: 		ConfiguracionPrincipal();
	CALL       _ConfiguracionPrincipal+0
;MasterComunicacion.c,346 :: 		RE_DE = 1;                                         //Establece el Max485-1 en modo de lectura;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;MasterComunicacion.c,347 :: 		i1=0;
	CLRF       _i1+0
;MasterComunicacion.c,348 :: 		contadorTOD = 0;                                   //Inicia el contador de Time-Out-Dispositivo
	CLRF       _contadorTOD+0
;MasterComunicacion.c,349 :: 		contadorNACK = 0;                                  //Inicia el contador de NACK
	CLRF       _contadorNACK+0
;MasterComunicacion.c,350 :: 		byteTrama=0;                                       //Limpia la variable del byte de la trama de peticion
	CLRF       _byteTrama+0
;MasterComunicacion.c,351 :: 		banTI=0;                                           //Limpia la bandera de inicio de trama
	CLRF       _banTI+0
;MasterComunicacion.c,352 :: 		banTC=0;                                           //Limpia la bandera de trama completa
	CLRF       _banTC+0
;MasterComunicacion.c,353 :: 		banTF=0;                                           //Limpia la bandera de final de trama
	CLRF       _banTF+0
;MasterComunicacion.c,355 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
