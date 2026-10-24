class_name EscenaBase
extends Node2D

@onready var caja_texto = $Caja_Texto

func _ready():
	for hijo in get_children():
		if hijo is Area2D and hijo.has_signal("observado"):
			hijo.observado.connect(_on_observado)
			hijo.interactuado.connect(_on_interactuado)

func _on_observado(objeto):
	var descripcion = objeto.descripcion if objeto.descripcion != "" else "No hay nada interesante aquí."
	caja_texto.mostrar(descripcion)

func _on_interactuado(_objeto):
	pass
