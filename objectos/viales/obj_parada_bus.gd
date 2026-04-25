extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Parada de Bus"
var pasajeros_esperando: int = 0
var max_pasajeros_espera: int = 20

# ── Costo de construcción ─────────────────────────────
var costo_construccion = {
	"dinero": 200,
	"metal": 15
}

# ── Agregar pasajero ──────────────────────────────────
func agregar_pasajero() -> void:
	if pasajeros_esperando < max_pasajeros_espera:
		pasajeros_esperando += 1
		print(nombre + " — pasajeros esperando: " + str(pasajeros_esperando))

# ── Bus llegó a parada ────────────────────────────────
func bus_llego(bus) -> void:
	var subieron = min(pasajeros_esperando, bus.espacio_disponible())
	pasajeros_esperando -= subieron
	bus.subir_pasajeros(subieron)
	print(nombre + " — subieron " + str(subieron) + " pasajeros al bus")

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	return nombre + " | Esperando: " + str(pasajeros_esperando)
