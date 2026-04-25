extends Node

# ── Comprar objeto ────────────────────────────────────
func comprar(tipo: String) -> bool:
	var costo = get_node("../tin_catalogo").obtener_costo(tipo)
	if costo.is_empty():
		print("tin_compra — objeto no encontrado: " + tipo)
		return false
	# Verificar energía
	if not get_node("../../sistemas/sys_energia").gastar_construccion(tipo):
		print("tin_compra — energía insuficiente")
		return false
	# Verificar y gastar recursos
	if costo.has("dinero"):
		if not Jugador.gastar_recurso("dinero", costo["dinero"]):
			print("tin_compra — dinero insuficiente")
			return false
	if costo.has("madera"):
		if not Jugador.gastar_recurso("madera", costo["madera"]):
			print("tin_compra — madera insuficiente")
			return false
	if costo.has("metal"):
		if not Jugador.gastar_recurso("metal", costo["metal"]):
			print("tin_compra — metal insuficiente")
			return false
	if costo.has("piedras"):
		if not Jugador.gastar_recurso("piedras", costo["piedras"]):
			print("tin_compra — piedras insuficientes")
			return false
	print("tin_compra — comprado: " + tipo)
	return true
