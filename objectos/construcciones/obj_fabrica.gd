extends Node2D

# ── Tipos de fábrica ──────────────────────────────────
enum Tipo {PEQUEÑA, MEDIANA, GRANDE}

# ── Variables ─────────────────────────────────────────
var tipo: int = Tipo.PEQUEÑA
var nombre: String = ""
var esta_dañada: bool = false
var tiempo_acumulado: float = 0.0

# ── Configuración por tipo ────────────────────────────
var config = {
	Tipo.PEQUEÑA: {"recurso": "madera",  "cantidad": 20, "intervalo": 60.0},
	Tipo.MEDIANA: {"recurso": "piedras", "cantidad": 20, "intervalo": 180.0},
	Tipo.GRANDE:  {"recurso": "metal",   "cantidad": 10, "intervalo": 300.0}
}

# ── Costos de construcción ────────────────────────────
var costo_construccion = {
	Tipo.PEQUEÑA: {"dinero": 500,  "madera": 20},
	Tipo.MEDIANA: {"dinero": 1000, "madera": 30, "piedras": 20},
	Tipo.GRANDE:  {"dinero": 2000, "madera": 40, "piedras": 30, "metal": 20}
}

# ── Costos de reparación ──────────────────────────────
var costo_reparacion = {
	Tipo.PEQUEÑA: {"dinero": 100, "madera": 10},
	Tipo.MEDIANA: {"dinero": 200, "madera": 20, "piedras": 10},
	Tipo.GRANDE:  {"dinero": 500, "madera": 30, "piedras": 20, "metal": 10}
}

# ── Inicializar ───────────────────────────────────────
func iniciar(tipo_fabrica: int) -> void:
	tipo = tipo_fabrica
	match tipo:
		Tipo.PEQUEÑA: nombre = "Fábrica de Madera"
		Tipo.MEDIANA: nombre = "Fábrica de Piedras"
		Tipo.GRANDE:  nombre = "Fábrica de Metal"

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	if esta_dañada:
		return
	tiempo_acumulado += delta
	if tiempo_acumulado >= config[tipo]["intervalo"]:
		tiempo_acumulado = 0.0
		producir()

# ── Producir recurso ──────────────────────────────────
func producir() -> void:
	var recurso = config[tipo]["recurso"]
	var cantidad = config[tipo]["cantidad"]
	Jugador.agregar_recurso(recurso, cantidad)
	print(nombre + " produjo " + str(cantidad) + " " + recurso)

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañada = true
	print(nombre + " dañada — producción detenida")

# ── Reparar ───────────────────────────────────────────
func reparar() -> bool:
	if not esta_dañada:
		return false
	var costo = costo_reparacion[tipo]
	if Jugador.gastar_recurso("dinero", costo["dinero"]):
		if costo.has("madera"):
			Jugador.gastar_recurso("madera", costo["madera"])
		if costo.has("piedras"):
			Jugador.gastar_recurso("piedras", costo["piedras"])
		if costo.has("metal"):
			Jugador.gastar_recurso("metal", costo["metal"])
		esta_dañada = false
		tiempo_acumulado = 0.0
		print(nombre + " reparada — producción reanudada")
		return true
	return false

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañada:
		return nombre + " - DAÑADA"
	var recurso = config[tipo]["recurso"]
	var cantidad = config[tipo]["cantidad"]
	var intervalo = int(config[tipo]["intervalo"] / 60)
	return nombre + " - OK | Produce " + str(cantidad) + " " + recurso + " cada " + str(intervalo) + " min"
