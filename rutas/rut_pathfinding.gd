extends Node

# ── Variables ─────────────────────────────────────────
var nodos: Array = []

# ── Registrar nodo ────────────────────────────────────
func registrar_nodo(nodo) -> void:
	if not nodos.has(nodo):
		nodos.append(nodo)
		print("rut_pathfinding — nodo registrado: " + nodo.nombre)

# ── Obtener ruta aleatoria ────────────────────────────
func obtener_siguiente_nodo(nodo_actual) -> Node2D:
	if nodo_actual == null:
		return null
	var siguiente = nodo_actual.elegir_direccion_aleatoria()
	if siguiente:
		print("rut_pathfinding — siguiente nodo: " + siguiente.nombre)
	return siguiente

# ── Verificar si hay carretera entre 2 puntos ─────────
func hay_carretera(origen: Vector2, destino: Vector2) -> bool:
	for nodo in nodos:
		if nodo.position.distance_to(origen) <= 10:
			for conexion in nodo.conexiones:
				if conexion.position.distance_to(destino) <= 10:
					return true
	return false

# ── Obtener nodo más cercano ──────────────────────────
func nodo_mas_cercano(pos: Vector2) -> Node2D:
	var mas_cercano = null
	var menor_distancia = INF
	for nodo in nodos:
		var distancia = nodo.position.distance_to(pos)
		if distancia < menor_distancia:
			menor_distancia = distancia
			mas_cercano = nodo
	return mas_cercano

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	return "Pathfinding — Nodos: " + str(nodos.size())
