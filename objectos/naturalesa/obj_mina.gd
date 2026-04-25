extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Mina"
var esta_agotada: bool = false
var tiempo_acumulado: float = 0.0
var intervalo_produccion: float = 300.0
var metal_por_ciclo: int = 10

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	if esta_agotada:
		return
	tiempo_acumulado += delta
	if tiempo_acumulado >= intervalo_produccion:
		tiempo_acumulado = 0.0
		producir()

# ── Producir metal ────────────────────────────────────
func producir() -> void:
	Jugador.agregar_recurso("metal", metal_por_ciclo)
	print(nombre + " produjo " + str(metal_por_ciclo) + " metal")

# ── Recibir choque de carro ───────────────────────────
func recibir_choque() -> void:
	esta_agotada = true
	print(nombre + " dañada por un carro — producción detenida")
