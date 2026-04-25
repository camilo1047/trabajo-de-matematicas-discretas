extends Node

# ── Tipos de casa ─────────────────────────────────────
enum Tipo {PEQUEÑA, MEDIANA, GRANDE}

# ── Variables ─────────────────────────────────────────
var tipo: int = Tipo.PEQUEÑA
var nombre: String = ""
var esta_dañada: bool = false

# ── Costos de construcción ────────────────────────────
var costo_construccion = {
	Tipo.PEQUEÑA: {"dinero": 100},
	Tipo.MEDIANA:  {"dinero": 300},
	Tipo.GRANDE:   {"dinero": 600}
}

# ── Costos de reparación ──────────────────────────────
var costo_reparacion = {
	Tipo.PEQUEÑA: {"dinero": 50,  "madera": 10},
	Tipo.MEDIANA:  {"dinero": 150, "madera": 20, "piedras": 10},
	Tipo.GRANDE:   {"dinero": 300, "madera": 30, "metal": 15, "piedras": 20}
}

# ── Inicializar casa ──────────────────────────────────
func iniciar(tipo_casa: int) -> void:
	tipo = tipo_casa
	match tipo:
		Tipo.PEQUEÑA: nombre = "Casa Pequeña"
		Tipo.MEDIANA:  nombre = "Casa Mediana"
		Tipo.GRANDE:   nombre = "Casa Grande"

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañada = true
	print(nombre + " ha sido dañada")

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
		print(nombre + " ha sido reparada")
		return true
	return false

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañada:
		return nombre + " - DAÑADA"
	return nombre + " - OK"
