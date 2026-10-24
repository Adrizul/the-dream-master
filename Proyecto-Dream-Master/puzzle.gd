extends CanvasLayer

signal resuelto

@export var pregunta := "El aura de luz que resalta esta habitación es de color ___."
@export var respuesta := "morado"

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
	if Diario.palabras.is_empty():
		resultado.text = "Todavía no tienes palabras en tu diario."
	for p in Diario.palabras:
		var boton = Button.new()
		boton.text = p
		boton.pressed.connect(_elegir.bind(p))
		opciones.add_child(boton)
	panel.show()

func _elegir(palabra: String):
	if palabra == respuesta:
		ya_resuelto = true
		resultado.text = "¡Correcto!"
		resuelto.emit()
		await get_tree().create_timer(1.2).timeout
		panel.hide()
	else:
		resultado.text = "Mmm... no es esa."

func _input(event):
	if panel.visible and event.is_action_pressed("ui_cancel"):
		panel.hide()
