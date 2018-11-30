#line 1 "C:/Users/Ivan/Desktop/Milton Mu�oz/Proyectos/Git/Instrumentacion Presa/InstrumentacionPCh/Firmware/EsclavoSensor/EsclavoSensor.c"
#line 10 "C:/Users/Ivan/Desktop/Milton Mu�oz/Proyectos/Git/Instrumentacion Presa/InstrumentacionPCh/Firmware/EsclavoSensor/EsclavoSensor.c"
sbit AUX at RB3_bit;
sbit AUX_Direction at TRISB3_bit;
sbit ECINT at RC2_bit;
sbit ECINT_Direction at TRISC2_bit;

const short idEsclavo = 0x09;

unsigned char tramaSPI[15];
unsigned char petSPI[15];
unsigned char resSPI[15];
unsigned short sizeSPI;
unsigned short direccionRpi;
unsigned short funcionRpi;
unsigned short i, x;
unsigned short respSPI, buffer, registro, numBytesSPI;
unsigned short banPet, banResp, banSPI, banMed, banId;









void ConfiguracionPrincipal(){

 TRISC2_bit = 0;
 TRISB3_bit = 0;
 TRISA5_bit = 1;

 INTCON.GIE = 1;
 INTCON.PEIE = 1;


 SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE,_SPI_DATA_SAMPLE_MIDDLE,_SPI_CLK_IDLE_HIGH,_SPI_LOW_2_HIGH);
 PIE1.SSPIE = 1;

 Delay_ms(100);

}








void interrupt(){


 if (PIR1.SSPIF){

 PIR1.SSPIF = 0;
 AUX = 1;
 AUX = 0;

 buffer = SSPBUF;


 if (buffer==0xA0){
 banMed = 1;
 SSPBUF = 0xA0;
 Delay_us(50);
 }
 if ((banMed==1)&&(buffer!=0xA0)){
 registro = buffer;
 switch (registro){
 case 1:
 numBytesSPI = 0x02;
 SSPBUF = numBytesSPI;
 break;
 case 2:
 numBytesSPI = 0x04;
 SSPBUF = numBytesSPI;
 break;
 default:
 SSPBUF = 0;
 }
 }
 if (buffer==0xA1){
 banPet = 1;
 banMed = 0;
 banResp = 0;
 SSPBUF = 0xB0;
 }


 if (buffer==0xC0){
 banId = 1;
 SSPBUF = 0xC0;
 Delay_us(50);
 }
 if ((banId==1)&&(buffer==0xC1)){
 SSPBUF = idEsclavo;
 }
 if (buffer==0xC2){
 banId = 0;
 SSPBUF = 0xA0;
 }


 if (banResp==1){
 if (i<numBytesSPI){
 SSPBUF = resSPI[i];
 i++;
 }
 }


 }

}


void main() {

 ConfiguracionPrincipal();
 ECINT = 1;
 AUX = 0;
 i = 0;
 x = 0;
 banPet = 0;
 banResp = 0;
 banSPI = 0;
 banMed = 0;
 banId = 0;

 respSPI = 0xC0;
 SSPBUF = 0xC0;


 while(1){

 if (banPet==1){
 Delay_ms(1000);
 resSPI[0] = 0x83;
 resSPI[1] = 0x58;
 resSPI[2] = 0x8F;
 resSPI[3] = 0x5C;
 i=0;

 ECINT = 0;
 Delay_ms(1);
 ECINT = 1;
 banPet = 0;
 banResp = 1;

 }

 }

}
