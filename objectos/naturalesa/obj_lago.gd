extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Lago"
var tiempo_acumulado: float = 0.0
var intervalo_produccion: float = 180.0
var agua_por_ciclo: int = 20

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	tiempo_acumulado += delta
	if tiempo_acumulado >= intervalo_produccion:
		tiempo_acumulado = 0.0
		producir()

# ── Producir agua ─────────────────────────────────────
func producir() -> void:
	Jugador.agregar_recurso("agua", agua_por_ciclo)
	print(nombre + " produjo " + str(agua_por_ciclo) + " agua")
