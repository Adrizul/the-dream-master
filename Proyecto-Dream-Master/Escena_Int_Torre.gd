extends EscenaBase

@onready var puzzle = $Puzzle_Libro

func _ready():
	super()
	puzzle.resuelto.connect(_on_puzzle_resuelto)

func _on_interactuado(objeto):
	match objeto.id_objeto:
		# --- PUZZLES (MORADOS) ---
		"Pergamino":
			if Diario.banderas.get("pergamino", false):
				caja_texto.mostrar("El pergamino ya ha revelado su secreto.")
			else:
				puzzle.abrir("pergamino")
				
		"Cofre":
			if Diario.banderas.get("cofre", false):
				caja_texto.mostrar("El baúl ya está abierto y vacío.")
			else:
				puzzle.abrir("cofre")
		
		# --- PISTAS CON PALABRA CLAVE CLICABLE (AZULES) ---
		"Cuadro":
			caja_texto.mostrar("Un retrato oscuro del mago frente al portal. En el marco dice: 'Nadie escapa de la {maldicion} sin antes comprenderla.'")
			
		"Reloj_Arena":
			caja_texto.mostrar("La arena púrpura cae en cámara lenta dentro del cristal. En la base de bronce está tallada la palabra: '{tiempo}'.")
			
		# --- EXPLORACIÓN AMBIENTAL (ROJOS) ---
		"Planta":
			caja_texto.mostrar("Una planta de hojas oscuras que sobrevive sin recibir luz del sol.")
		"Vela":
			caja_texto.mostrar("La llama no parpadea y la cera parece no consumirse nunca.")
		"Libros_Viejos":
			caja_texto.mostrar("Tomos polvorientos sobre arquitectura dimensional y portales antiguos.")
		"Libros_Estantes":
			caja_texto.mostrar("Grimorios antiguos ordenados por el color de sus runas.")
		"Frasco_Pocion":
			caja_texto.mostrar("Un frasco con un líquido violeta que brilla tenuemente en la sombra.")

func _on_puzzle_resuelto(id_puzzle: String):
	if id_puzzle == "pergamino":
		caja_texto.mostrar("Las runas del pergamino se iluminan y se desvanece el sello.")
	elif id_puzzle == "cofre":
		caja_texto.mostrar("¡Clic! El mecanismo interno del baúl cede y se abre.")
