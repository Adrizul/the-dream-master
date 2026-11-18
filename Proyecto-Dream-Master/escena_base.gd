class_name EscenaBase
extends Node2D

@onready var caja_texto = $Caja_Texto

func _ready():
	for area in find_children("*", "Area2D", true, false):
		if area.has_signal("interactuado") and not area.interactuado.is_connected(_on_interactuado):
			area.interactuado.connect(_on_interactuado)
		if area.has_signal("observado") and not area.observado.is_connected(_on_observado):
			area.observado.connect(_on_observado)

func _on_observado(objeto):
	var descripcion = objeto.descripcion if objeto.descripcion != "" else "No hay nada interesante aquí."
	caja_texto.mostrar(descripcion)

func _on_interactuado(_objeto):
	pass
