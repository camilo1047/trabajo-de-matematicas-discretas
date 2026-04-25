extends Node

# ── Activar choque entre autos ────────────────────────
func activar(auto1, auto2) -> void:
	print(auto1.nombre + " chocó con " + auto2.nombre)
	auto1.esta_dañado = true
	auto2.esta_dañado = true
	auto1.esta_bloqueado = true
	auto2.esta_bloqueado = true
	get_node("../evento_daño").activar(auto1)
	get_node("../evento_daño").activar(auto2)
	get_node("../evento_bloqueo").activar(auto1)
	get_node("../evento_bloqueo").activar(auto2)
	# Llamar grúa para ambos
	get_node("../../../../construcciones/obj_grua").reportar_accidente(auto1)
	get_node("../../../../construcciones/obj_grua").reportar_accidente(auto2)
