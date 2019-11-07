
import serial
print ('Iniciando...')
ser = serial.Serial ("/dev/ttyAMA0")    #Open named port
ser.baudrate = 9600                     #Set baud rate to 9600
ser.write(1)
data = ser.read(5)                     #Read ten characters from seri$
print data
ser.write(data)                         #Send back the received data
ser.close()

