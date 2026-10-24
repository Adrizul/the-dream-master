extends Area2D

signal observado(objeto: Area2D)
signal interactuado(objeto: Area2D)

@export var id_objeto: String = ""
@export_multiline var descripcion: String = ""
@export_file("*.tscn") var escena_destino: String = ""

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if escena_destino != "":
				get_tree().change_scene_to_file(escena_destino)
			else:
				interactuado.emit(self)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			observado.emit(self)
