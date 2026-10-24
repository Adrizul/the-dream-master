extends CanvasLayer

const COLOR_CLAVE = "#ffd54a"
const COLOR_GUARDADA = "#A9A9A9"
const PLANTILLA_PALABRA = "[url=%s][color=%s]%s[/color][/url]"
const SEGUNDOS_POR_LETRA = 0.03

var _regex := RegEx.create_from_string("\\{(.+?)\\}")
var _texto_actual := ""
var _tween: Tween

@onready var panel: Panel = $Panel_Texto
@onready var texto: RichTextLabel = $Panel_Texto/MarginContainer/Texto

func _ready():
	panel.hide()
	texto.meta_clicked.connect(_on_palabra_clicada)

func mostrar(crudo: String, animar := true):
	_texto_actual = crudo
	texto.text = _formatear(crudo)
	panel.show()
	if _tween:
		_tween.kill()
	if animar:
		texto.visible_ratio = 0.0
		_tween = create_tween()
		_tween.tween_property(texto, "visible_ratio", 1.0, texto.get_total_character_count() * SEGUNDOS_POR_LETRA)
	else:
		texto.visible_ratio = 1.0

func _formatear(crudo: String) -> String:
	var resultado = crudo
	for m in _regex.search_all(crudo):
		var palabra = m.get_string(1)
		var color = COLOR_GUARDADA if palabra in Diario.palabras else COLOR_CLAVE
		resultado = resultado.replace(m.get_string(0), PLANTILLA_PALABRA % [palabra, color, palabra])
	return resultado

func _on_palabra_clicada(meta):
	Diario.agregar(str(meta))
	texto.text = _formatear(_texto_actual)

func _input(event):
	if panel.visible and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not panel.get_global_rect().has_point(event.position):
			panel.hide()
