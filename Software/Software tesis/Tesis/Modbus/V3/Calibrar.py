#!/usr/bin/env python

#---------------------------------------------------------------------------#
# importa las librerias necesarias
#---------------------------------------------------------------------------#
import RS485
import sys
import os


#---------------------------------------------------------------------------#
# Define el loop del programa
#---------------------------------------------------------------------------#

print(' ')
print('--------------------------------------------------')
print(' ')
print(' Software para la calibracion del Sensor de Nivel')
print(' ')
print('--------------------------------------------------')
print(' ')
print('Introduzca el id del dispositivo:')
ide = int(input())

while True:

    print('--------------------------------------------')
    print('Menu:')
    print('      1>Calcular y leer registro principal')
    print('      2>Leer registro especifico')
    print('      3>Establecer altura de instalacion')
    print('      4>Calibrar sensor de distancia')
    print('      5>Salir')
    print('--------------------------------------------')

    try:

        opcion = input()
	
	if opcion == 1:
	    Respuesta = RS485.Peticion(18, ide, 1, 1)
	    if Respuesta == 0:
               print('***Advertencia***')
            else:
               print(Respuesta)


        if opcion == 2:
            print('Introduzca el numero del registro requerido:')
	    print('      1>Nivel')
	    print('      2>Caudal')
	    print('      3>Distancia')
	    print('      4>TOF')
	    print('      5>Temperatura')
	    print('      6>Altura de instalacion')					              					
            registro = int(input())
            if (registro > 0) and (registro < 7):
                Respuesta = RS485.Peticion(18, ide, 2, registro)
		if Respuesta == 0:
		   print('***Advertencia***')
		else:
		   print(Respuesta)
            else:
                print('Error: Registro inexistente')


        if opcion == 3:
            print('Introduzca la altura de instalacion:')
            altura = int(input())
            if (altura >= 200) and (altura <= 500):
                Respuesta = RS485.Peticion(18, ide, 3, altura)
                if Respuesta == 0:
                   print('***Advertencia***')
                else:
                   print(Respuesta)
            else:
                print('Error: La altura de instalacion debe estar entre 200 y 500mm')


        elif opcion == 4:
            print('Introduzca el factor de calibracion:')
            factor = int(input())
            if (abs(factor)<=255):
                Respuesta = RS485.Peticion(18, ide, 4, factor)
                if Respuesta == 0:
                   print('***Advertencia***')
                else:
                   print(Respuesta)
            else:
                print('Error: El factor de calibracion debe estar en -255 y +255mm')


        elif opcion == 5:
            print('....')
            sys.exit()


    except NameError:

        print('Opcion invalida')
