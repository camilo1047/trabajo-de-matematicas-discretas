extends Node2D
var via = preload("res://Escenas/vias.tscn")

#esta funcion es la que crea la instancia en las casillas y comprueba que no alla una instancia antes para que no alla mas de dos en el mismo sitio
func Instanciar(ins, pos):
	var instanciando = ins.instantiate()
	var grid_pos = GLOBAL.organizar_tile(pos) / GLOBAL.Tamaño_tile
	
	if GLOBAL.ocupado.get(grid_pos) == "via" or GLOBAL.ocupado.get(grid_pos) == "arbol":
		return
	
	elif GLOBAL.ocupado.get(grid_pos) == "pasto":
		for nodo in get_children():
			if nodo.position == grid_pos and nodo.is_in_group("pasto") and not nodo.is_in_group("arbol"):
				nodo.queue_free()
	
	
	GLOBAL.ocupado[grid_pos] =  "via"
	instanciando.position = grid_pos * GLOBAL.Tamaño_tile
	instanciando.z_index = 9
	add_child(instanciando)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Mouse izq"):
		Instanciar(via, get_global_mouse_position())
		
