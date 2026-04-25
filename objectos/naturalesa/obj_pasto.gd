# obj_pasto.gd
extends Node2D

var nombre: String = "Pasto"

# ── Recibir choque de carro ───────────────────────────
func recibir_choque() -> void:
	print(nombre + " destruido por un carro")
	queue_free()
