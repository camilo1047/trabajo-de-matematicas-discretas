extends Node

# ── Tipos de edificio ─────────────────────────────────
enum Tipo {MEDIANO, GRANDE}

# ── Variables ─────────────────────────────────────────
var tipo: int = Tipo.MEDIANO
var nombre: String = ""
var esta_dañado: bool = false
var tiempo_acumulado: float = 0.0
var intervalo_generacion: float = 300.0

# ── Ganancias por tipo ────────────────────────────────
var ganancia_por_tipo = {
	Tipo.MEDIANO: 50,
	Tipo.GRANDE:  100
}

# ── Costos de construcción ────────────────────────────
var costo_construccion = {
	Tipo.MEDIANO: {"dinero": 1000, "madera": 30, "metal": 20, "piedras": 25},
	Tipo.GRANDE:  {"dinero": 2000, "madera": 50, "metal": 35, "piedras": 40}
}

# ── Costos de reparación ──────────────────────────────
var costo_reparacion = {
	Tipo.MEDIANO: {"dinero": 200, "madera": 20, "metal": 10, "piedras": 15},
	Tipo.GRANDE:  {"dinero": 500, "madera": 35, "metal": 20, "piedras": 25}
}

# ── Inicializar ───────────────────────────────────────
func iniciar(tipo_edificio: int) -> void:
	tipo = tipo_edificio
	match tipo:
		Tipo.MEDIANO: nombre = "Edificio Mediano"
		Tipo.GRANDE:  nombre = "Edificio Grande"

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	if esta_dañado:
		return
	tiempo_acumulado += delta
	if tiempo_acumulado >= intervalo_generacion:
		tiempo_acumulado = 0.0
		generar_dinero()

# ── Generar dinero ────────────────────────────────────
func generar_dinero() -> void:
	var ganancia = ganancia_por_tipo[tipo]
	Jugador.agregar_recurso("dinero", ganancia)
	print(nombre + " generó $" + str(ganancia))

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañado = true
	print(nombre + " ha sido dañado — dejó de generar dinero")

# ── Reparar ───────────────────────────────────────────
func reparar() -> bool:
	if not esta_dañado:
		return false
	var costo = costo_reparacion[tipo]
	if Jugador.gastar_recurso("dinero", costo["dinero"]):
		Jugador.gastar_recurso("madera", costo["madera"])
		Jugador.gastar_recurso("metal", costo["metal"])
		Jugador.gastar_recurso("piedras", costo["piedras"])
		esta_dañado = false
		tiempo_acumulado = 0.0
		print(nombre + " ha sido reparado")
		return true
	return false

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañado:
		return nombre + " - DAÑADO"
	return nombre + " - OK | Genera $" + str(ganancia_por_tipo[tipo]) + " cada 5 min"
