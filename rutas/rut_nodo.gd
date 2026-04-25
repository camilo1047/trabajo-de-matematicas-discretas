extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Nodo"
var conexiones: Array = []
var tipo: String = "normal"

# ── Agregar conexión ──────────────────────────────────
func agregar_conexion(nodo) -> void:
	if not conexiones.has(nodo):
		conexiones.append(nodo)
		print(nombre + " conectado a " + nodo.nombre)

# ── Obtener direcciones disponibles ───────────────────
func obtener_direcciones() -> Array:
	return conexiones

# ── Elegir dirección aleatoria ────────────────────────
func elegir_direccion_aleatoria() -> Node2D:
	if conexiones.size() == 0:
		return null
	return conexiones[randi() % conexiones.size()]

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	return nombre + " | Conexiones: " + str(conexiones.size())
