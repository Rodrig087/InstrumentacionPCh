#Configuracion inicial
import serial
import binascii
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
ser = serial.Serial("/dev/ttyAMA0", baudrate=9600, timeout=3.0)
#ser.close()
#ser.open()
#ser.flushInput()
#ser.flushOutput()
#time.sleep(1)

#Configuracion del GPIO
EE=18
GPIO.setup(EE, GPIO.OUT, initial=0)     #Establece el GPIO 18 como sal$

#Variables
cont=0
Medicion=0

#Funcion para realizar una peticion y obtener el dato de la trama de respuesta
def Peticion(Identificador,Funcion,Dato):
	#Rellena la trama de peticion
	Hdr = chr(58)   	#Delimitador de inicio de trama (0x3A)
	Id = chr(Identificador) #Identificador de esclavo (0x01)
	Fcn = chr(Funcion)    	#Tipo de funcion
	D1 = chr(0)     	#0x00
	D2 = chr(Dato)     	#0x00
	End = chr(13)           #Delimitador de fin de trama (0x0D)
	Ptcn = [Hdr, Id, Fcn, D1, D2, End]    
	#Envia la trama de peticion
	GPIO.output(EE,1)       #Establece el max485 en modo d$
        for i in range(6):
        	ser.write(Ptcn[i])
        time.sleep(0.005)
        GPIO.output(EE,0)       #Establece el max485 en modo d$
        time.sleep(0.1)
	#Recibe la trama de respuesta
	Rspt = ser.read(6)
	if len(Rspt)>1:
		if Rspt[1]==chr(58):
			R1 = binascii.hexlify(Rspt[4])
			R2 = binascii.hexlify(Rspt[5])
			Dst = int(R1, 16)*256 + int(R2, 16)
		else:
			Dst = 0
	else:
		Dst = 0
 
	ser.flushInput()
	ser.flushOutput()
	return Dst

#Bucle del sistema
try: 
	while True:
		print "Intoduzca tipo de medicion:"
		tm = input()
		Medicion = Peticion(1,5,tm)
		print Medicion
		cont = cont + 1
	
	GPIO.cleanup()
        ser.close()

except KeyboardInterrupt:
        GPIO.cleanup()
        ser.close()
