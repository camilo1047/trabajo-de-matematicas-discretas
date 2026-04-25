extends Node

# ── Catálogo de objetos ───────────────────────────────
var catalogo = {
	# Construcciones
	"casa_pequeña":    {"dinero": 100, "energia": 10},
	"casa_mediana":    {"dinero": 300, "energia": 20},
	"casa_grande":     {"dinero": 600, "energia": 30},
	"banco":           {"dinero": 800, "energia": 50},
	"colegio":         {"dinero": 500, "madera": 20, "piedras": 15, "energia": 40},
	"edificio_mediano":{"dinero": 1000,"madera": 30, "metal": 20, "piedras": 25, "energia": 50},
	"edificio_grande": {"dinero": 2000,"madera": 50, "metal": 35, "piedras": 40, "energia": 100},
	"fabrica_pequeña": {"dinero": 500, "madera": 20, "energia": 30},
	"fabrica_mediana": {"dinero": 1000,"madera": 30, "piedras": 20, "energia": 50},
	"fabrica_grande":  {"dinero": 2000,"madera": 40, "piedras": 30, "metal": 20, "energia": 100},
	"almacen_pequeño": {"dinero": 500, "madera": 20, "energia": 20},
	"almacen_mediano": {"dinero": 1000,"madera": 40, "piedras": 20, "energia": 40},
	"almacen_grande":  {"dinero": 2000,"madera": 60, "piedras": 40, "metal": 20, "energia": 80},
	"clinica":         {"dinero": 1000,"madera": 30, "metal": 20, "piedras": 25, "energia": 50},
	"casa_gruas":      {"dinero": 1000,"madera": 30, "metal": 20, "piedras": 25, "energia": 50},
	"parque_pequeño":  {"dinero": 500, "madera": 20, "energia": 20},
	"parque_mediano":  {"dinero": 1000,"madera": 30, "piedras": 20, "energia": 40},
	"parque_grande":   {"dinero": 2000,"madera": 50, "piedras": 30, "metal": 20, "energia": 80},
	# Viales
	"carretera":       {"dinero": 50,  "piedra": 5,  "energia": 5},
	"curva":           {"dinero": 50,  "piedra": 5,  "energia": 5},
	"cruce":           {"dinero": 100, "piedra": 10, "energia": 10},
	"carretera_t":     {"dinero": 100, "piedra": 10, "energia": 10},
	"semaforo":        {"dinero": 200, "metal": 10,  "energia": 10},
	"pare":            {"dinero": 100, "metal": 5,   "energia": 5},
	"puente":          {"dinero": 500, "madera": 30, "metal": 20, "energia": 20},
	"parada_bus":      {"dinero": 200, "metal": 15,  "energia": 10},
	# Vehículos
	"auto_viejo":      {"dinero": 100, "energia": 10},
	"auto_normal":     {"dinero": 200, "energia": 10},
	"taxi":            {"dinero": 300, "energia": 10},
	"auto_moderno":    {"dinero": 500, "energia": 10},
	"auto_deportivo":  {"dinero": 1000,"energia": 10},
}

# ── Obtener costo ─────────────────────────────────────
func obtener_costo(tipo: String) -> Dictionary:
	if catalogo.has(tipo):
		return catalogo[tipo]
	return {}

# ── Verificar si existe ───────────────────────────────
func existe(tipo: String) -> bool:
	return catalogo.has(tipo)
