import RPi.GPIO as GPIO
import time

EE=18
GPIO.setmode(GPIO.BCM)
GPIO.setup(EE, GPIO.OUT, initial=0) ## GPIO 18 como salida

iteracion = 1

try:
	while iteracion < 11:
		GPIO.output(EE,1)
      		time.sleep(1)
		GPIO.output(EE,0)
		time.sleep(1)
      		print (iteracion)
      		iteracion=iteracion+1
      	
	print "Termino"
	GPIO.cleanup()

except KeyboardInterrupt:
	GPIO.cleanup()
