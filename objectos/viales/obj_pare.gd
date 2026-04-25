extends Node2D

var nombre: String = "Pare"
var tiempo_detencion: float = 3.0

# ── Detener carro ─────────────────────────────────────
func detener_carro(carro) -> void:
	print(nombre + " — carro detenido por " + str(tiempo_detencion) + " segundos")
	await get_tree().create_timer(tiempo_detencion).timeout
	print(nombre + " — carro puede continuar")
	carro.continuar()
