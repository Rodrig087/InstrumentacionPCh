#!/usr/bin/env python
import paho.mqtt.client as mqtt
import time


#Configuracion del cliente MQTT:
broker_url = "m11.cloudmqtt.com"												#URL del broker remoto
broker_port = 10164																#Puerto por donde se comunica el broker

username = "cuxhjixd"															#Nombre de usuario definido en el broker remoto
password = "tFroIaJunMc6"														#Contrasena definida en el broker

client = mqtt.Client()															#Crea un instancia de Client
client.username_pw_set(username, password)										
client.connect(broker_url,broker_port)


#Variables:
contador = 0


while (True):
	contador = contador+1
	client.publish(topic="Contador", payload=contador, qos=1, retain=False)
	time.sleep(1)
	client.loop_start()
	client.loop_stop()
