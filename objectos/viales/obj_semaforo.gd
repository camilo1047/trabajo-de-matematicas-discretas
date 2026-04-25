extends Node2D

var nombre: String = "Semáforo"
var en_verde: bool = true
var tiempo_acumulado: float = 0.0
var intervalo_cambio: float = 15.0

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	tiempo_acumulado += delta
	if tiempo_acumulado >= intervalo_cambio:
		tiempo_acumulado = 0.0
		cambiar_luz()

# ── Cambiar luz ───────────────────────────────────────
func cambiar_luz() -> void:
	en_verde = !en_verde
	if en_verde:
		print(nombre + " — VERDE, carros pueden pasar")
	else:
		print(nombre + " — ROJO, carros deben detenerse")

# ── Consultar si puede pasar ──────────────────────────
func puede_pasar() -> bool:
	return en_verde
