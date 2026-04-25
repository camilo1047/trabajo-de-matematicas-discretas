extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Tronco"
var madera_al_recoger: int = 10

# ── Recoger tronco ────────────────────────────────────
func recoger() -> void:
	Jugador.agregar_recurso("madera", madera_al_recoger)
	print(nombre + " recogido — +" + str(madera_al_recoger) + " madera")
	queue_free()

# ── Recibir choque de carro ───────────────────────────
func recibir_choque() -> void:
	print("Carro chocó contra tronco — tronco queda intacto")
