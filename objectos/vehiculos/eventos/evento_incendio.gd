extends Node

# ── Activar incendio ──────────────────────────────────
func activar(vehiculo) -> void:
	vehiculo.esta_incendiado = true
	print(vehiculo.nombre + " se incendió")
	dañar_edificios_cercanos(vehiculo)
	get_node("../../../../construcciones/obj_grua").reportar_accidente(vehiculo)

# ── Dañar edificios cercanos ──────────────────────────
func dañar_edificios_cercanos(vehiculo) -> void:
	var edificios = get_tree().get_nodes_in_group("edificios")
	for edificio in edificios:
		var distancia = vehiculo.position.distance_to(edificio.position)
		if distancia <= 80:
			edificio.recibir_daño()
			print("Incendio dañó " + edificio.nombre)
