extends CanvasLayer

@onready var boton: Button = $Boton_Diario
@onready var panel: Panel = $Panel_Diario
@onready var lista: RichTextLabel = $Panel_Diario/MarginContainer/Lista

func _ready():
	panel.hide()
	boton.pressed.connect(_alternar)
	Diario.palabra_agregada.connect(_refrescar)
	_refrescar()

func _alternar():
	panel.visible = not panel.visible

func _refrescar(_palabra = ""):
	var lineas: Array[String] = []
	for p in Diario.palabras:
		lineas.append("• " + p)
	lista.text = "\n".join(lineas)
