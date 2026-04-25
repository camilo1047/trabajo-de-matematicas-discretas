extends Node2D

var nombre: String = "Carretera"
var tipo: String = "recta"

# ── Costo de construcción ─────────────────────────────
var costo_construccion = {
	"dinero": 50,
	"piedra": 5
}

# ── Consultar tipo ────────────────────────────────────
func obtener_tipo() -> String:
	return tipo
