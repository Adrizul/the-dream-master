extends Area2D

var ya_desbloqueado: bool = false

func _ready() -> void:
	input_pickable = true

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if ya_desbloqueado:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		ya_desbloqueado = true
		
		# Opcional: agrega las palabras clave por si quieres mostrar el tachado/lista
		for p in ["maldicion", "tiempo", "morado"]:
			Diario.agregar_palabra(p)
		
		# Desbloquea las 4 viñetas del cómic
		for i in range(1, 5):
			Diario.puzzle_completado.emit(i)
			
		
		var caja = get_parent().get_node_or_null("Caja_Texto")
		if caja and caja.has_method("mostrar"):
			caja.mostrar("¡Cómic completo desbloqueado!")
