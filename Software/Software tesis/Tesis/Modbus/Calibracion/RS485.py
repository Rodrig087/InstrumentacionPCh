import serial
import binascii
import RPi.GPIO as GPIO
import time


#Funcion para realizar una peticion y obtener el dato de la trama de respuesta
#Parametros de entrada: pin EE del RS485, Id del esclavo, funcion, dato
def Peticion(EE, Id, Fcn, DatoP):


    # Configuracion del GPIO y el serial:
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(EE, GPIO.OUT, initial=0)     #Establece el GPIO 18 $
    GPIO.setup(23, GPIO.OUT, initial=0)
    ser = serial.Serial("/dev/ttyAMA0", baudrate=9600, timeout=3.5)


# Prepara los datos de la trama de peticion:
    GPIO.output(23,1)        # Encendido senal luminosa
    if Fcn == 1:
	D1 = chr(0)
        D2 = chr(DatoP)
    elif Fcn == 2:
        D1 = chr(0)
        D2 = chr(DatoP)
    elif Fcn == 3:
        if DatoP <= 255:
            D1 = chr(0)
            D2 = chr(DatoP)
        else:
            D1 = chr(1)
            D2 = chr(DatoP - 256)
    elif Fcn == 4:
        if DatoP < 0:
            D1 = chr(17)
            D2 = chr(abs(DatoP))
        else:
            D1 = chr(0)
            D2 = chr(DatoP)

    Hdr = chr(58)            # Delimitador de inicio de trama (0x3A)
    Id = chr(Id)             # Identificador de esclavo (0x01)
    Fcn = chr(Fcn)           # Tipo de funcion
    End = chr(13)            # Delimitador de fin de trama (0x0D)
    Ptcn = [Hdr, Id, Fcn, D1, D2, End]

    #Envia la trama de peticion:
    GPIO.output(EE,1)        # Establece el max485 en modo de escritura
    for i in range(6):
        ser.write(Ptcn[i])
#        print((Ptcn[i]))
    time.sleep(0.005)
    GPIO.output(EE,0)        # Establece el max485 en modo de lectura
    GPIO.output(23,0)        # Apagado senal luminosa
    time.sleep(0.1)

    #Recibe la trama de respuesta:
    Rspt = ser.read(6)
    if len(Rspt)>1:
        if Rspt[1] == chr(58):
	    if Rspt[3] == chr(238):
		if Rspt[5] == chr(225):
		    print('--------------------------------------------')
		    print ('Funcion no disponible')
		    DatoR = 0
                elif Rpst[5] == chr(226):
		    print('--------------------------------------------')
		    print ('Registro no diponible')
		    DatoR = 0
		elif Rpst[5] == chr(227):
		    print('--------------------------------------------')
		    print ('Cantidad fuera de rango')
		    DatoR = 0
	    else:
                R1 = binascii.hexlify(Rspt[4])
                R2 = binascii.hexlify(Rspt[5])
                DatoR = int(R1, 16)*256 + int(R2, 16)
        else:
            DatoR = 0
	    print('--------------------------------------------')
	    print ('Problema en la trama de datos de respuesta')
    else:
        DatoR = 0
	print('--------------------------------------------')
	print ('El dispositivo no responde')
    ser.flushInput()
    ser.flushOutput()
    GPIO.cleanup()
    ser.close()
    return DatoR
