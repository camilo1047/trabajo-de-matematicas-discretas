extends Node

# ── Recursos del jugador ──────────────────────────────
var dinero: int = 1000
var madera: int = 0
var metal: int = 0
var piedras: int = 0
var agua: int = 0
var comida: int = 0

# ── Inicializar ───────────────────────────────────────
func _ready() -> void:
	cargar_partida()

# ── Guardar al salir ──────────────────────────────────
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		guardar_partida()

# ── Agregar recursos ──────────────────────────────────
func agregar_recurso(tipo: String, cantidad: int) -> void:
	match tipo:
		"dinero":  dinero  += cantidad
		"madera":  madera  += cantidad
		"metal":   metal   += cantidad
		"piedras": piedras += cantidad
		"agua":    agua    += cantidad
		"comida":  comida  += cantidad
	guardar_partida()

# ── Gastar recursos ───────────────────────────────────
func gastar_recurso(tipo: String, cantidad: int) -> bool:
	match tipo:
		"dinero":
			if dinero >= cantidad:
				dinero -= cantidad
				guardar_partida()
				return true
		"madera":
			if madera >= cantidad:
				madera -= cantidad
				guardar_partida()
				return true
		"metal":
			if metal >= cantidad:
				metal -= cantidad
				guardar_partida()
				return true
		"piedras":
			if piedras >= cantidad:
				piedras -= cantidad
				guardar_partida()
				return true
	return false

# ── Consultar recursos ────────────────────────────────
func obtener_recurso(tipo: String) -> int:
	match tipo:
		"dinero":  return dinero
		"madera":  return madera
		"metal":   return metal
		"piedras": return piedras
		"agua":    return agua
		"comida":  return comida
	return 0

# ── Guardar partida ───────────────────────────────────
func guardar_partida() -> void:
	var archivo = FileAccess.open("user://partida.dat", FileAccess.WRITE)
	if not archivo:
		return

	# Guardar recursos
	archivo.store_var({
		"dinero":  dinero,
		"madera":  madera,
		"metal":   metal,
		"piedras": piedras,
		"agua":    agua,
		"comida":  comida
	})

	# Guardar objetos del mapa
	var objetos = []
	for grupo in ["edificios", "viales", "naturaleza"]:
		for objeto in get_tree().get_nodes_in_group(grupo):
			objetos.append({
				"nombre": objeto.nombre,
				"grupo": grupo,
				"x": objeto.position.x,
				"y": objeto.position.y,
				"dañado": objeto.get("esta_dañado") or objeto.get("esta_dañada") or false
			})
	archivo.store_var(objetos)

	# Guardar tiempo de salida para energía offline
	archivo.store_var(Time.get_unix_time_from_system())

	archivo.close()
	print("Jugador — partida guardada")

# ── Cargar partida ────────────────────────────────────
func cargar_partida() -> void:
	if not FileAccess.file_exists("user://partida.dat"):
		return
	var archivo = FileAccess.open("user://partida.dat", FileAccess.READ)
	if not archivo:
		return

	# Cargar recursos
	var recursos = archivo.get_var()
	dinero  = recursos["dinero"]
	madera  = recursos["madera"]
	metal   = recursos["metal"]
	piedras = recursos["piedras"]
	agua    = recursos["agua"]
	comida  = recursos["comida"]

	# Cargar objetos del mapa
	var objetos = archivo.get_var()
	for datos in objetos:
		restaurar_objeto(datos)

	# Calcular energía offline
	var ultima_vez = archivo.get_var()
	calcular_energia_offline(ultima_vez)

	archivo.close()
	print("Jugador — partida cargada")

# ── Restaurar objeto en el mapa ───────────────────────
func restaurar_objeto(datos: Dictionary) -> void:
	get_node("/root/tin_colocacion").colocar(datos["nombre"], Vector2(datos["x"], datos["y"]))

# ── Calcular energía offline ──────────────────────────
func calcular_energia_offline(ultima_vez: int) -> void:
	var ahora = Time.get_unix_time_from_system()
	var minutos = int((ahora - ultima_vez) / 60)
	if minutos > 0:
		SysEnergia.energia = min(
			SysEnergia.energia + (minutos * 10),
			SysEnergia.energia_maxima
		)
		print("Jugador — energía recargada offline: +" + str(minutos * 10))
