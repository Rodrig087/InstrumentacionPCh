import V3

Medicion=0
cont=0

#try:
while True:
	print "Intoduzca tipo de medicion:"
        tm = input()
        Medicion = V3.Peticion(18,1,tm)
        print Medicion
        cont = cont + 1

#except KeyboardInterrupt:
#        GPIO.cleanup()
#        ser.close()
