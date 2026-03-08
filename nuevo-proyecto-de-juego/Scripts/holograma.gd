extends Node2D
@onready var Instanciar: Node2D = $"../Instanciar"

var holograma


func _ready() -> void:
	holograma = Instanciar.via.instantiate()
	holograma.modulate = Color(1, 1, 1, 0.5)
	holograma.z_index = 10 #esto hace que se dibuje por encima de lo demas 
	add_child(holograma)


func _process(delta: float) -> void:
	var grid_pos = GLOBAL.organizar_tile(get_global_mouse_position()) / GLOBAL.Tamaño_tile
	
	holograma.position = grid_pos * GLOBAL.Tamaño_tile
	if GLOBAL.ocupado.get(grid_pos) == "via" or GLOBAL.ocupado.get(grid_pos) == "arbol":
		holograma.modulate = Color(1, 0, 0, 0.5)
	else:
		holograma.modulate = Color(0, 1, 0, 0.5)
