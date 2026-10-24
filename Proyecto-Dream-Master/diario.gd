extends Node

signal palabra_agregada(palabra)

var palabras: Array[String] = []
var banderas: Dictionary = {}

func agregar(palabra: String):
	if palabra not in palabras:
		palabras.append(palabra)
		palabra_agregada.emit(palabra)
