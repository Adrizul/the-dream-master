extends CanvasLayer

signal resuelto

@export var pregunta := "El aura de luz que resalta esta habitación es de color ___."
@export var respuesta := "morado"
@export var numero_puzzle: int = 1 # Define el número de viñeta a desbloquear (1 a 4)

@onready var panel: Panel = $Panel_Puzzle
@onready var etiqueta: Label = $Panel_Puzzle/MarginContainer/VBoxContainer/Pregunta
@onready var opciones: HBoxContainer = $Panel_Puzzle/MarginContainer/VBoxContainer/Opciones
@onready var resultado: Label = $Panel_Puzzle/MarginContainer/VBoxContainer/Resultado

var ya_resuelto := false

func _ready():
	panel.hide()

func abrir():
	if ya_resuelto:
		return
	etiqueta.text = pregunta
	resultado.text = ""
	
	for b in opciones.get_children():
		b.queue_free()
		
	# Filtrar palabras disponibles (no usadas)
	var palabras_disponibles = Diario.palabras.filter(func(p): return not Diario.palabras_usadas.has(p))
	
	if palabras_disponibles.is_empty():
		resultado.text = "No tienes palabras disponibles para este acertijo."
		
	for p in palabras_disponibles:
		var boton = Button.new()
		boton.text = p
		boton.pressed.connect(_elegir.bind(p))
		opciones.add_child(boton)
		
	panel.show()

func _elegir(palabra: String):
	if palabra == respuesta:
		ya_resuelto = true
		resultado.text = "¡Correcto!"
		
		# Marca la palabra clave como usada globalmente
		Diario.marcar_palabra_usada(palabra)
		
		await get_tree().create_timer(0.5).timeout
		
		Diario.puzzle_completado.emit(numero_puzzle)
		resuelto.emit()
		panel.hide()
	else:
		resultado.text = "Mmm... no es esa."

func _input(event):
	if panel.visible and event.is_action_pressed("ui_cancel"):
		panel.hide()
