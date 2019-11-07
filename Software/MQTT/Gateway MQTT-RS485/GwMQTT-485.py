#!/usr/bin/env python
import paho.mqtt.client as mqtt
import time


#Credenciales del Broker MQTT:
#broker_url = "m11.cloudmqtt.com"												#URL del broker remoto
#broker_port = 10164															#Puerto por donde se comunica el broker
#username = "cuxhjixd"															#Nombre de usuario definido en el broker remoto
#password = "tFroIaJunMc6"														#Contrasena definida en el broker
broker_url = "172.16.145.60"												    #URL del broker remoto
broker_port = 1883																#Puerto por donde se comunica el broker
username = "gateway1"															#Nombre de usuario definido en el broker remoto
password = "smapfcgw1"															#Contrasena de usuario
topicoPeticion = "chanlud/lectura/gateway/1"									#Topico de peticion
topicoRespuesta = "chanlud/respuesta/gateway/1"									#Topico de respuesta

#Variables:
contador = 0

#Metodos:
def on_connect(client, userdata, flags, rc):
   print("Coneccion con codigo de resultado "+rc)
   
def on_disconnect(client, userdata, rc):
   print("Cliente desconectado")

def on_message(client, userdata, message):
   print("Solicitud recibida")
   peticion = message.payload.decode()
   if peticion == chr(64):
      print("Solicitud de peticion")
      responder(topicoRespuesta,"hola")
   else:
      print("Mensaje recibido: "+str(peticion))
      responder(topicoRespuesta,peticion)

def responder(topico, dato):
   client.publish(topic=topico, payload=dato, qos=1, retain=False)   
   
 
   

client = mqtt.Client()															#Crea un instancia de Client
client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_message = on_message

client.username_pw_set(username, password)										
client.connect(broker_url,broker_port)

client.subscribe(topicoPeticion, qos=1)											#Se suscribe al topico de peticion

client.loop_forever()




