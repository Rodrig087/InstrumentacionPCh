import serial
import binascii
import RPi.GPIO as GPIO
import time


#Funcion para realizar una peticion y obtener el dato de la trama de respuesta
#Parametros de entrada: pin EE del RS485, el Id del esclavo, el numero de registro a leer
def Peticion(EE, Id, Reg):

        #Configuracion del GPIO y el serial
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(EE, GPIO.OUT, initial=0)     #Establece el GPIO 18 como salida       
        GPIO.setup(23, GPIO.OUT, initial=0)
	ser = serial.Serial("/dev/ttyAMA0", baudrate=9600, timeout=2.5)

        #Rellena la trama de peticion
	GPIO.output(23,1)
        Hdr = chr(58)           #Delimitador de inicio de trama (0x3A)
        Id = chr(Id)            #Identificador de esclavo (0x01)
        Fcn = chr(2)            #Tipo de funcion: 2
        D1 = chr(0)             #0x00
        D2 = chr(Reg)           #Numero de registro a leer
        End = chr(13)           #Delimitador de fin de trama (0x0D)
        Ptcn = [Hdr, Id, Fcn, D1, D2, End]

        #Envia la trama de peticion
        GPIO.output(EE,1)       #Establece el max485 en modo d$
        for i in range(6):
                ser.write(Ptcn[i])
        time.sleep(0.005)
        GPIO.output(EE,0)       #Establece el max485 en modo d$
	GPIO.output(23,0)
        time.sleep(0.1)

	#Recibe la trama de respuesta
	Rspt = ser.read(6)
        if len(Rspt)>1:
                if Rspt[1]==chr(58):
                        R1 = binascii.hexlify(Rspt[4])
                        R2 = binascii.hexlify(Rspt[5])
                        Dato = int(R1, 16)*256 + int(R2, 16)
                else:
                        Dato = 0
        else:
                Dato = 0

        ser.flushInput()
        ser.flushOutput()
        GPIO.cleanup()
        ser.close()
        return Dato

