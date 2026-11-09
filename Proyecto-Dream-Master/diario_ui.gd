extends CanvasLayer

@onready var boton_diario: TextureButton = %Boton_Diario
@onready var boton_ajustes: TextureButton = %Boton_Ajustes
@onready var panel: Panel = $Panel_Diario
@onready var lista: RichTextLabel = %Lista

@onready var grid_comic: GridContainer = %GridComic

func _ready():
	panel.hide()
	boton_diario.pressed.connect(_alternar)
	boton_ajustes.pressed.connect(_on_ajustes)
	
	# Asegura que BBCode esté activo por código
	lista.bbcode_enabled = true
	
	Diario.palabra_agregada.connect(_refrescar)
	if Diario.has_signal("palabra_usada"):
		Diario.palabra_usada.connect(_refrescar)
	if Diario.has_signal("puzzle_completado"):
		Diario.puzzle_completado.connect(_on_puzzle_completado)
	
	_inicializar_vinetas()
	_refrescar()

func _alternar():
	panel.visible = not panel.visible

func _on_ajustes():
	print("Menú de ajustes: pendiente")

func _refrescar(_palabra = ""):
	lista.clear()
	if Diario.palabras.is_empty():
		return
		
	var texto_completo: String = ""
	for p in Diario.palabras:
		if Diario.palabras_usadas.has(p):
			# Línea de tachado en rojo con el texto interno en negro
			texto_completo += "• [color=red][s][color=#1a1a1a]" + str(p) + "[/color][/s][/color]\n"
		else:
			# Texto normal en color oscuro legible
			texto_completo += "• [color=#1a1a1a]" + str(p) + "[/color]\n"
			
	lista.append_text(texto_completo)
			
	# En Godot 4, basta con asignar la propiedad text si BBCode está habilitado
	lista.text = texto_completo

func _inicializar_vinetas():
	for vineta in grid_comic.get_children():
		vineta.visible = true
		vineta.modulate.a = 0.0

func abrir_diario():
	if panel and not panel.visible:
		panel.show()

func _on_puzzle_completado(numero_puzzle: int):
	abrir_diario()
	desbloquear_vineta(numero_puzzle)

func desbloquear_vineta(numero_vineta: int):
	_refrescar() 
	var vinetas = grid_comic.get_children()
	var indice: int = numero_vineta - 1
	
	if indice >= 0 and indice < vinetas.size():
		var tween = create_tween()
		tween.tween_property(vinetas[indice], "modulate:a", 1.0, 1.5)
