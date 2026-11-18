extends CanvasLayer

@onready var boton_diario: TextureButton = %Boton_Diario
@onready var boton_ajustes: TextureButton = %Boton_Ajustes
@onready var panel: Panel = $Panel_Diario
@onready var lista: RichTextLabel = %Lista
@onready var grid_comic: GridContainer = %GridComic

var visor_vineta: ColorRect
var imagen_ampliada: TextureRect
var reproductor_sfx: AudioStreamPlayer

func _ready():
	panel.hide()
	boton_diario.pressed.connect(_alternar)
	boton_ajustes.pressed.connect(_on_ajustes)
	
	lista.bbcode_enabled = true
	
	Diario.palabra_agregada.connect(_refrescar)
	if Diario.has_signal("palabra_usada"):
		Diario.palabra_usada.connect(_refrescar)
	if Diario.has_signal("puzzle_completado"):
		Diario.puzzle_completado.connect(_on_puzzle_completado)
	
	_crear_visor_vineta()
	_crear_reproductor_sfx()
	_inicializar_vinetas()
	_refrescar()

func _alternar():
	panel.visible = not panel.visible
	if not panel.visible and visor_vineta:
		visor_vineta.hide()

func _on_ajustes():
	print("Menú de ajustes: pendiente")

func _refrescar(_palabra = ""):
	lista.clear()
	if Diario.palabras.is_empty():
		return
		
	var texto_completo: String = ""
	for p in Diario.palabras:
		if Diario.palabras_usadas.has(p):
			texto_completo += "• [color=#A9A9A9]" + str(p) + "[/color]\n"
		else:
			texto_completo += "• [color=#1a1a1a]" + str(p) + "[/color]\n"
			
	lista.text = texto_completo

func _inicializar_vinetas():
	for vineta in grid_comic.get_children():
		if vineta is TextureRect:
			vineta.visible = true
			vineta.modulate.a = 0.0
			vineta.mouse_filter = Control.MOUSE_FILTER_STOP
			vineta.gui_input.connect(_on_vineta_gui_input.bind(vineta))

func abrir_diario():
	if panel and not panel.visible:
		panel.show()

func _on_puzzle_completado(numero_puzzle: int):
	_reproducir_sonido_puzzle()
	abrir_diario()
	desbloquear_vineta(numero_puzzle)

func desbloquear_vineta(numero_vineta: int):
	_refrescar()
	var vinetas = grid_comic.get_children()
	var indice: int = numero_vineta - 1
	
	if indice >= 0 and indice < vinetas.size():
		var vineta = vinetas[indice]
		vineta.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		var tween = create_tween()
		tween.tween_property(vineta, "modulate:a", 1.0, 1.5)

# --- AMPLIACIÓN DE VIÑETAS AL HACER CLIC ---

func _crear_visor_vineta():
	visor_vineta = ColorRect.new()
	visor_vineta.color = Color(0.05, 0.03, 0.1, 0.85)
	visor_vineta.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visor_vineta.mouse_filter = Control.MOUSE_FILTER_STOP
	visor_vineta.hide()
	visor_vineta.gui_input.connect(_on_visor_gui_input)
	
	imagen_ampliada = TextureRect.new()
	imagen_ampliada.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	imagen_ampliada.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	imagen_ampliada.anchor_left = 0.15
	imagen_ampliada.anchor_top = 0.1
	imagen_ampliada.anchor_right = 0.85
	imagen_ampliada.anchor_bottom = 0.9
	imagen_ampliada.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	visor_vineta.add_child(imagen_ampliada)
	add_child(visor_vineta)

func _on_vineta_gui_input(event: InputEvent, vineta: TextureRect):
	# Evita abrir viñetas que todavía están ocultas/bloqueadas
	if vineta.modulate.a < 0.8:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_abrir_vineta_grande(vineta.texture)

func _abrir_vineta_grande(textura: Texture2D):
	if not textura:
		return
	imagen_ampliada.texture = textura
	visor_vineta.modulate.a = 0.0
	visor_vineta.show()
	var tween = create_tween()
	tween.tween_property(visor_vineta, "modulate:a", 1.0, 0.2)

func _on_visor_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		visor_vineta.hide()

func _input(event):
	if visor_vineta and visor_vineta.visible and event.is_action_pressed("ui_cancel"):
		visor_vineta.hide()
		get_viewport().set_input_as_handled()

# --- EFECTO SONORO SINTETIZADO AL RESOLVER PUZZLE ---

func _crear_reproductor_sfx():
	reproductor_sfx = AudioStreamPlayer.new()
	add_child(reproductor_sfx)

func _reproducir_sonido_puzzle():
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = 22050.0
	gen.buffer_length = 0.6
	reproductor_sfx.stream = gen
	reproductor_sfx.play()
	
	var playback := reproductor_sfx.get_stream_playback() as AudioStreamGeneratorPlayback
	if not playback:
		return
	
	# Arpegio ascendente (Do5 - Mi5 - Sol5 - Do6)
	var notas := [523.25, 659.25, 783.99, 1046.50]
	var frames_por_nota := int(gen.mix_rate * 0.11)
	var fase := 0.0
	
	for nota in notas:
		var incremento: float = nota / gen.mix_rate
		for i in range(frames_por_nota):
			var envolvente := 1.0 - (float(i) / float(frames_por_nota))
			var muestra := sin(fase * TAU) * 0.25 * envolvente
			playback.push_frame(Vector2(muestra, muestra))
			fase = fmod(fase + incremento, 1.0)
