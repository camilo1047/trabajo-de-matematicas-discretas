## RoadNetwork.gd
## Lógica pura del grafo — sin nada de Godot visual.
## Adjunta a un Autoload o úsalo como dependencia del RoadSystem.
## Estructura: Grafo No Dirigido con Lista de Adyacencia.

class_name RoadNetwork
extends RefCounted

# { id:int → Vector2 }  — posición de cada nodo en el mundo
var nodes: Dictionary = {}

# { id:int → [id, id, ...] }  — vecinos de cada nodo (lista de adyacencia)
var adjacency: Dictionary = {}

var _next_id: int = 0


## Registra un nuevo nodo en la posición dada y devuelve su ID único
func add_node(pos: Vector2) -> int:
	var id: int   = _next_id
	nodes[id]     = pos
	adjacency[id] = []
	_next_id     += 1
	return id


## Crea una arista no dirigida A↔B (ignora duplicados y auto-loops)
func add_edge(id_a: int, id_b: int) -> void:
	if id_a == id_b:
		return
	if id_b not in adjacency[id_a]:
		adjacency[id_a].append(id_b)
		adjacency[id_b].append(id_a)


## Devuelve el ID del nodo más cercano a `pos` dentro de `radius`.
## Retorna -1 si no hay ninguno en ese radio.
func find_nearest(pos: Vector2, radius: float) -> int:
	var best_id:   int   = -1
	var best_dist: float = radius
	for id: int in nodes:
		var d: float = nodes[id].distance_to(pos)
		if d < best_dist:
			best_dist = d
			best_id   = id
	return best_id


## Lista de aristas únicas como pares [[id_a, id_b], ...]
func get_edges() -> Array:
	var result:  Array      = []
	var visited: Dictionary = {}
	for id_a: int in adjacency:
		for id_b: int in adjacency[id_a]:
			var key: String = "%d_%d" % [min(id_a, id_b), max(id_a, id_b)]
			if key not in visited:
				visited[key] = true
				result.append([id_a, id_b])
	return result
