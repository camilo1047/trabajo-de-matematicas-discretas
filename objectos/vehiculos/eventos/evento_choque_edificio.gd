extends Node

# ── Verificar daño a edificio cercano ─────────────────
func verificar_daño_edificio(vehiculo) -> void:
	var edificios_cercanos = get_tree().get_nodes_in_group("edificios")
	for edificio in edificios_cercanos:
		var distancia = vehiculo.position.distance_to(edificio.position)
		if distancia <= 50:
			edificio.recibir_daño()
			print(vehiculo.nombre + " dañó " + edificio.nombre)
			get_node("../evento_daño").activar(vehiculo)
			get_node("../../../../construcciones/obj_grua").reportar_accidente(vehiculo)
			break
