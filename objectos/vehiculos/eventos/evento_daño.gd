extends Node

# ── Activar daño ──────────────────────────────────────
func activar(vehiculo) -> void:
	vehiculo.esta_dañado = true
	print(vehiculo.nombre + " registró daño")
	verificar_incendio(vehiculo)

# ── Verificar si se incendia ──────────────────────────
func verificar_incendio(vehiculo) -> void:
	if vehiculo.get("probabilidades") == null:
		return
	var prob = vehiculo.probabilidades[vehiculo.tipo]["incendio"]
	if randi() % 100 < prob:
		get_node("../evento_incendio").activar(vehiculo)
