# obj_arbustos.gd
extends Node2D

var nombre: String = "Arbusto"

# ── Recibir choque de carro ───────────────────────────
func recibir_choque() -> void:
	print(nombre + " destruido por un carro")
	queue_free()
