extends CanvasLayer

@onready var boton_diario: TextureButton = %Boton_Diario
@onready var boton_ajustes: TextureButton = %Boton_Ajustes
@onready var panel: Panel = $Panel_Diario
@onready var lista: RichTextLabel = $Panel_Diario/ColorRect/ColorRect/MarginContainer/Lista

func _ready():
	panel.hide()
	boton_diario.pressed.connect(_alternar)
	boton_ajustes.pressed.connect(_on_ajustes)
	Diario.palabra_agregada.connect(_refrescar)
	_refrescar()

func _alternar():
	panel.visible = not panel.visible

func _on_ajustes():
	print("Menú de ajustes: pendiente")

func _refrescar(_palabra = ""):
	var lineas: Array[String] = []
	for p in Diario.palabras:
		lineas.append("• " + p)
	lista.text = "\n".join(lineas)
