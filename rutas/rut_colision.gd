extends Node

# ── Verificar colisión entre vehículos ────────────────
func verificar_colision(vehiculo1, vehiculo2) -> void:
	var distancia = vehiculo1.position.distance_to(vehiculo2.position)
	if distancia <= 20:
		print("rut_colision — colisión entre " + vehiculo1.nombre + " y " + vehiculo2.nombre)
		get_node("../../../objectos/vehiculos/eventos/eventos_choque").activar(vehiculo1, vehiculo2)

# ── Verificar colisión con edificio ───────────────────
func verificar_colision_edificio(vehiculo) -> void:
	var edificios = get_tree().get_nodes_in_group("edificios")
	for edificio in edificios:
		var distancia = vehiculo.position.distance_to(edificio.position)
		if distancia <= 30:
			print("rut_colision — " + vehiculo.nombre + " chocó con " + edificio.nombre)
			get_node("../../../objectos/vehiculos/eventos/evento_choque_edificio").verificar_daño_edificio(vehiculo)
			break

# ── Verificar colisión con naturaleza ─────────────────
func verificar_colision_naturaleza(vehiculo) -> void:
	var naturaleza = get_tree().get_nodes_in_group("naturaleza")
	for objeto in naturaleza:
		var distancia = vehiculo.position.distance_to(objeto.position)
		if distancia <= 20:
			print("rut_colision — " + vehiculo.nombre + " chocó con " + objeto.nombre)
			if objeto.has_method("recibir_choque"):
				objeto.recibir_choque()
			vehiculo.recibir_daño()
			break
