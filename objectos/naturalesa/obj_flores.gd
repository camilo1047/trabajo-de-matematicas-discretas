# obj_flores.gd
extends Node2D

var nombre: String = "Flores"

# ── Recibir choque de carro ───────────────────────────
func recibir_choque() -> void:
	print(nombre + " destruidas por un carro")
	queue_free()
