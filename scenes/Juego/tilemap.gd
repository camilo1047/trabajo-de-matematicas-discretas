# res://
extends TileMapLayer

# Celdas ocupadas por objetos
var celdas_ocupadas: Dictionary = {}

func _ready() -> void:
	pass

# Convierte posición del mouse a celda del mapa
func obtener_celda_en_mouse() -> Vector2i:
	var pos_mouse = get_global_mouse_position()
	return local_to_map(to_local(pos_mouse))

# Verifica si una celda está libre
func celda_libre(celda: Vector2i) -> bool:
	return not celdas_ocupadas.has(celda)

# Ocupa una celda con un objeto
func ocupar_celda(celda: Vector2i, objeto: String) -> void:
	celdas_ocupadas[celda] = objeto

# Libera una celda
func liberar_celda(celda: Vector2i) -> void:
	celdas_ocupadas.erase(celda)

# Convierte celda a posición en el mundo
func celda_a_posicion(celda: Vector2i) -> Vector2:
	return to_global(map_to_local(celda))
