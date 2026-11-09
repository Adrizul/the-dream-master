extends Node

signal palabra_agregada(palabra: String)
signal palabra_usada(palabra: String)
signal puzzle_completado(numero_puzzle: int)

var palabras: Array[String] = []
var palabras_usadas: Array[String] = []

# Diccionario para guardar estados/flags del juego (ej: puzzle_1_resuelto, etc.)
var banderas: Dictionary = {}

func agregar_palabra(palabra: String) -> void:
	if not palabras.has(palabra):
		palabras.append(palabra)
		palabra_agregada.emit(palabra)

func marcar_palabra_usada(palabra: String) -> void:
	if not palabras_usadas.has(palabra):
		palabras_usadas.append(palabra)
		palabra_usada.emit(palabra)

# Funciones auxiliares para consultar y modificar banderas de forma segura
func establecer_bandera(clave: String, valor: bool = true) -> void:
	banderas[clave] = valor

func obtener_bandera(clave: String) -> bool:
	return banderas.get(clave, false)
