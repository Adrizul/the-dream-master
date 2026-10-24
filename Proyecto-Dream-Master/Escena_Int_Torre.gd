extends EscenaBase

@onready var puzzle = $Puzzle_Libro

func _ready():
	super()
	puzzle.resuelto.connect(_on_puzzle_resuelto)

func _on_interactuado(objeto):
	if objeto.id_objeto == "Libros":
		puzzle.abrir()

func _on_puzzle_resuelto():
	Diario.banderas["libros"] = true
	caja_texto.mostrar("La luz brilla con fuerza. Algo se ilumina en la habitación.")
