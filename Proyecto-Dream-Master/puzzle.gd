extends CanvasLayer

signal resuelto(id_puzzle: String)

@onready var panel: Panel = $Panel_Puzzle
@onready var etiqueta: Label = $Panel_Puzzle/MarginContainer/VBoxContainer/Pregunta
@onready var opciones: HBoxContainer = $Panel_Puzzle/MarginContainer/VBoxContainer/Opciones
@onready var resultado: Label = $Panel_Puzzle/MarginContainer/VBoxContainer/Resultado

# Configuración de los puzzles de esta habitación
const PUZZLES := {
	"pergamino": {
		"pregunta": "El pergamino antiguo tiene un sello rúnico: 'Solo quien rompa la ___ podrá cruzar el umbral.'",
		"respuesta": "maldicion",
		"vineta": 1
	},
	"cofre": {
		"pregunta": "La cerradura del baúl tiene letras grabadas: 'Ni el oro ni la fuerza me abren, solo el paso del ___.'",
		"respuesta": "tiempo",
		"vineta": 2
	}
}

var puzzle_actual: String = ""

func _ready():
	panel.hide()

func abrir(id_puzzle: String):
	if not PUZZLES.has(id_puzzle):
		return
	
	# Evita abrirse de nuevo si ya está resuelto en el Diario (arregla Issue #2)
	if Diario.banderas.get(id_puzzle, false):
		return
	
	puzzle_actual = id_puzzle
	var datos = PUZZLES[id_puzzle]
	
	etiqueta.text = datos["pregunta"]
	resultado.text = ""
	
	for b in opciones.get_children():
		b.queue_free()
		
	# Filtrar palabras disponibles (no usadas)
	var palabras_disponibles = Diario.palabras.filter(func(p): return not Diario.palabras_usadas.has(p))
	
	if palabras_disponibles.is_empty():
		resultado.text = "Aún no tienes palabras clave para resolver esto."
		
	for p in palabras_disponibles:
		var boton = Button.new()
		boton.text = p
		boton.pressed.connect(_elegir.bind(p))
		opciones.add_child(boton)
		
	panel.show()

func _elegir(palabra: String):
	var datos = PUZZLES[puzzle_actual]
	
	if palabra == datos["respuesta"]:
		resultado.text = "¡Correcto!"
		
		# Guardar estado persistente y marcar palabra como usada
		Diario.banderas[puzzle_actual] = true
		Diario.marcar_palabra_usada(palabra)
		
		await get_tree().create_timer(0.5).timeout
		
		Diario.puzzle_completado.emit(datos["vineta"])
		resuelto.emit(puzzle_actual)
		panel.hide()
	else:
		resultado.text = "Mmm... esa palabra no encaja aquí."

func _input(event):
	if panel.visible and event.is_action_pressed("ui_cancel"):
		panel.hide()
