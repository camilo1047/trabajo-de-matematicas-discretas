extends Node

var categoria_actual: String = "construcciones"

# ── Cambiar categoría ─────────────────────────────────
func cambiar_categoria(categoria: String) -> void:
	categoria_actual = categoria
	print("tin_menu — categoría: " + categoria)

# ── Obtener objetos de categoría ──────────────────────
func obtener_categoria() -> Array:
	match categoria_actual:
		"construcciones":
			return ["casa_pequeña", "casa_mediana", "casa_grande",
					"banco", "colegio", "edificio_mediano", "edificio_grande",
					"fabrica_pequeña", "fabrica_mediana", "fabrica_grande",
					"almacen_pequeño", "almacen_mediano", "almacen_grande",
					"clinica", "casa_gruas", "parque_pequeño", "parque_mediano", "parque_grande"]
		"viales":
			return ["carretera", "curva", "cruce", "carretera_t",
					"semaforo", "pare", "puente", "parada_bus"]
		"vehiculos":
			return ["auto_viejo", "auto_normal", "taxi", "auto_moderno", "auto_deportivo"]
	return []
