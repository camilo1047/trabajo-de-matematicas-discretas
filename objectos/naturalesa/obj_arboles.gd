extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Árbol"
var esta_destruido: bool = false
var madera_al_talar: int = 20

# ── Talar árbol ───────────────────────────────────────
func talar() -> void:
	if esta_destruido:
		return
	Jugador.agregar_recurso("madera", madera_al_talar)
	print(nombre + " talado — +" + str(madera_al_talar) + " madera")
	queue_free()

# ── Recibir choque de carro ───────────────────────────
func recibir_choque() -> void:
	if esta_destruido:
		return
	esta_destruido = true
	print(nombre + " destruido por un carro")
	queue_free()
