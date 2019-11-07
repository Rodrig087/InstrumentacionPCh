#Envia una trama de peticion por medio de RS485, recibe la respuesta e imprime el dato de medicion

import serial
import binascii
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
ser = serial.Serial("/dev/ttyAMA0", baudrate=9600, timeout=3.0)
ser.close()
ser.open()
ser.flushInput()
ser.flushOutput()
time.sleep(1)

Hdr = chr(58)	#Delimitador de inicio de trama (0x3A)
End = chr(13)	#Delimitador de fin de trama (0x0D)
Id = chr(1)	#Identificador de esclavo (0x01)
Fcn = chr(2)	#Tipo de funcion
D1 = chr(0)	#0x01
D2 = chr(1)	#0x0E
#D1 = chr(72)
#D2 = chr(73)

Ptcn = [Hdr, Id, Fcn, D1, D2, End]	#Trama de peticion

EE=18
GPIO.setup(EE, GPIO.OUT, initial=0)	#Establece el GPIO 18 como salida

cont=0
H=270

#Funcion para recuperar y contenar datos de la trama de respuesta
def makeValue(highbyte, lowbyte):
	Dst = int(highbyte, 16)*256 + int(lowbyte, 16)
	print Dst
	print H-Dst

try:
	while cont<5:

		#Envia la trama de peticion
		GPIO.output(EE,1)	#Establece el max485 en modo de escritura
		for i in range(6):
			ser.write(Ptcn[i])
		time.sleep(0.005)
		GPIO.output(EE,0)	#Establece el max485 en modo de lectura
		time.sleep(0.1)
		print "Medicion: %d" %cont
		#Recibe la trama de respuesta
		Rspt = ser.read(6)		
		if len(Rspt)>1:
			if Rspt[1]==chr(58):
				R1=Rspt[4]
	        		R2=Rspt[5]			
				one = binascii.hexlify(R1)
		       		two = binascii.hexlify(R2)
				makeValue(one,two)
		else:
			print "Esclavo no responde"
		ser.flushInput()
		ser.flushOutput()	
		cont = cont+1

	GPIO.cleanup()
	ser.close()

except KeyboardInterrupt:
        GPIO.cleanup()
	ser.close()
	
