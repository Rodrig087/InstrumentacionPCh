#line 1 "C:/Users/Ivan/Desktop/Milton Mu�oz/Proyectos/Git/Instrumentacion Presa/InstrumentacionPCh/Registro Continuo/Firmware/Acelerografo/Acelerografo.c"
#line 1 "c:/users/ivan/desktop/milton mu�oz/proyectos/git/instrumentacion presa/instrumentacionpch/registro continuo/firmware/acelerografo/adxl355_spi.c"
#line 94 "c:/users/ivan/desktop/milton mu�oz/proyectos/git/instrumentacion presa/instrumentacionpch/registro continuo/firmware/acelerografo/adxl355_spi.c"
sbit CS_ADXL355 at LATA3_bit;

void ADXL355_init();
void ADXL355_write_byte(unsigned char address, unsigned char value);
unsigned char ADXL355_read_byte(unsigned char address);
unsigned int ADXL355_read_word(unsigned char address);
void get_values(signed int *x_val, signed int *y_val, signed int *z_val);
void get_offsets(signed int *x_val, signed int *y_val, signed int *z_val);
void set_offsets(signed int *x_val, signed int *y_val, signed int *z_val);
unsigned int ADXL355_muestra(void);

void ADXL355_init(){
 delay_ms(100);
 ADXL355_write_byte( 0x2D ,  0x04 | 0x02 | 0x00 );
 ADXL355_write_byte( 0x2C ,  0x00 | 0x05 );
}


void ADXL355_write_byte(unsigned char address, unsigned char value){
 address = (address<<1)&0xFE;
 CS_ADXL355=0;
 SPI2_Write(address);
 SPI2_Write(value);
 CS_ADXL355=1;
}


unsigned char ADXL355_read_byte(unsigned char address){
 unsigned char value = 0x00;
 address=(address<<1)|0x01;
 CS_ADXL355=0;
 SPI2_Write(address);
 value=SPI2_Read(0);
 CS_ADXL355=1;
 return value;
}


unsigned int ADXL355_read_word(unsigned char address){
 unsigned char hb = 0x00;
 unsigned char lb = 0x00;
 unsigned int temp = 0x0000;
 address=(address<<1)|0x01;
 CS_ADXL355=0;
 SPI2_Write(address);
 hb = SPI_Read(1);
 lb = SPI_Read(0);
 CS_ADXL355=1;
 temp = hb;
 temp <<= 0x08;
 temp |= lb;
 return temp;
}

unsigned int ADXL355_read_data(unsigned char address){
 long *dato,auxiliar;
 unsigned char *puntero_8,bandera;
 puntero_8=&dato;
 address=(address<<1)|0x01;
 CS_ADXL355=0;
 SPI2_Write(address);
 *(puntero_8+0) = SPI_Read(2);
 *(puntero_8+1) = SPI_Read(1);
 *(puntero_8+2) = SPI_Read(0);
 CS_ADXL355=1;
 bandera=*(puntero_8+0)&0x80;
 auxiliar=*dato;
 auxiliar=auxiliar>>12;
 if(bandera!=0){
 auxiliar=auxiliar|0xFFF00000;
 }
 return auxiliar;
}


void get_values(signed int *x_val, signed int *y_val, signed int *z_val){
 *x_val = ADXL355_read_data( 0x08 );
 *y_val = ADXL355_read_data( 0x0B );
 *z_val = ADXL355_read_data( 0x0E );
}


unsigned int ADXL355_muestra( unsigned char *puntero_8){
 CS_ADXL355=0;
 SPI2_Write(0x11);
 *(puntero_8+0) = SPI_Read(8);
 *(puntero_8+1) = SPI_Read(7);
 *(puntero_8+2) = SPI_Read(6);
 *(puntero_8+3) = SPI_Read(5);
 *(puntero_8+4) = SPI_Read(4);
 *(puntero_8+5) = SPI_Read(3);
 *(puntero_8+6) = SPI_Read(2);
 *(puntero_8+7) = SPI_Read(1);
 *(puntero_8+8) = SPI_Read(0);
 CS_ADXL355=1;
 return;
}
#line 17 "C:/Users/Ivan/Desktop/Milton Mu�oz/Proyectos/Git/Instrumentacion Presa/InstrumentacionPCh/Registro Continuo/Firmware/Acelerografo/Acelerografo.c"
sbit RP1 at LATA4_bit;
sbit RP1_Direction at TRISA4_bit;
sbit RP2 at LATB4_bit;
sbit RP2_Direction at TRISB4_bit;

const short HDR = 0x3A;
const short END1 = 0x0D;
const short END2 = 0x0A;
const unsigned short NUM_MUESTRAS = 199;


unsigned char tiempo[5];
unsigned char datos[10];
unsigned char pduSPI[15];

unsigned short i, x;
unsigned short buffer;
unsigned short contMuestras;
unsigned short contCiclos;

unsigned short banTC, banTI, banTF;

unsigned short banResp, banSPI, banLec, banEsc;








void ConfiguracionPrincipal(){


 CLKDIVbits.FRCDIV = 0;
 CLKDIVbits.PLLPOST = 0;
 CLKDIVbits.PLLPRE = 5;
 PLLFBDbits.PLLDIV = 150;

 ANSELA = 0;
 ANSELB = 0;
 TRISA3_bit = 0;
 TRISA4_bit = 0;
 TRISB4_bit = 0;
 TRISB13_bit = 1;

 INTCON2.GIE = 1;






 SPI1STAT.SPIEN = 1;
 SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
 SPI1IE_bit = 1;
 SPI1IF_bit = 0;


 RPINR22 = 0x0021;
 RPOR2bits.RP38R = 0x08;
 RPOR1bits.RP37R = 0x09;
 SPI2STAT.SPIEN = 1;
 SPI2_Init();


 RPINR0 = 0x2E00;
 INT1IE_bit = 1;
 INT1IF_bit = 0;
 IPC0 = 0x0001;


 T1CON = 0x0010;
 T1CON.TON = 0;
 T1IE_bit = 1;
 T1IF_bit = 0;
 IPC0 = 0x1000;
 PR1 = 25000;

 Delay_ms(100);

}







void int_1() org IVT_ADDR_INT1INTERRUPT {
 INT1IF_bit = 0;
 contMuestras = 0;
 datos[0] = contCiclos;
 for (x=0;x<10;x++){
 pduSPI[x]=datos[x];
 }
 banTI = 1;
 RP1 = 1;
 Delay_us(20);
 RP1 = 0;
 T1CON.TON = 1;
 contCiclos++;
}


void spi_1() org IVT_ADDR_SPI1INTERRUPT {
 SPI1IF_bit = 0;
 buffer = SPI1BUF;

 if ((banTI==1)){
 banLec = 1;
 banTI = 0;
 i = 0;
 SPI1BUF = pduSPI[i];
 }
 if ((banLec==1)&&(buffer!=0xB1)){
 SPI1BUF = pduSPI[i];
 i++;
 }
 if ((banLec==1)&&(buffer==0xB1)){
 banLec = 0;
 banTI = 0;
 SPI1BUF = 0xFF;
 }
}

void Timer1Int() org IVT_ADDR_T1INTERRUPT{
 T1IF_bit = 0;
 contMuestras++;
 datos[0] = contMuestras;
 for (x=0;x<10;x++){
 pduSPI[x]=datos[x];
 }
 if (contMuestras==NUM_MUESTRAS){
 T1CON.TON = 0;
 for (x=1;x<10;x++){
 pduSPI[x]=66;
 }
 for (x=10;x<15;x++){
 pduSPI[x]=tiempo[x-10];
 }
 }
 banTI = 1;
 RP2 = 1;
 Delay_us(20);
 RP2 = 0;



}






void main() {

 ConfiguracionPrincipal();

 tiempo[0] = 19;
 tiempo[1] = 49;
 tiempo[2] = 9;
 tiempo[3] = 30;
 tiempo[4] = 0;

 datos[1] = 11;
 datos[2] = 12;
 datos[3] = 13;
 datos[4] = 21;
 datos[5] = 22;
 datos[6] = 23;
 datos[7] = 31;
 datos[8] = 32;
 datos[9] = 33;

 banTI = 0;
 banLec = 0;
 i = 0;
 x = 0;

 contMuestras = 0;
 contCiclos = 0;
 RP1 = 0;
 RP2 = 0;

 SPI1BUF = 0x00;

 while(1){

 Delay_ms(500);

 }

}