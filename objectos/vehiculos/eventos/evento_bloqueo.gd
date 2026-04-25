extends Node

# ── Activar bloqueo ───────────────────────────────────
func activar(vehiculo) -> void:
	vehiculo.esta_bloqueado = true
	print(vehiculo.nombre + " bloqueó la vía — causando trancón")
	verificar_choque_cadena(vehiculo)

# ── Verificar choque en cadena ────────────────────────
func verificar_choque_cadena(vehiculo) -> void:
	var vehiculos_cercanos = get_tree().get_nodes_in_group("vehiculos")
	for otro in vehiculos_cercanos:
		if otro == vehiculo:
			continue
		var distancia = otro.position.distance_to(vehiculo.position)
		if distancia <= 30:
			otro.verificar_choque_cadena(vehiculo)
