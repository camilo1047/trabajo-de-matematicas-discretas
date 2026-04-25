extends Node2D

# ── Tipos de parque ───────────────────────────────────
enum Tipo {PEQUEÑO, MEDIANO, GRANDE}

# ── Variables ─────────────────────────────────────────
var tipo: int = Tipo.PEQUEÑO
var nombre: String = ""
var esta_dañado: bool = false
var tiempo_acumulado: float = 0.0
var intervalo_generacion: float = 120.0
var autos_estacionados: int = 0

# ── Capacidad por tipo ────────────────────────────────
var capacidad_por_tipo = {
	Tipo.PEQUEÑO: 10,
	Tipo.MEDIANO: 25,
	Tipo.GRANDE:  50
}

# ── Ganancia por auto ─────────────────────────────────
var ganancia_por_auto: int = 2

# ── Costos de construcción ────────────────────────────
var costo_construccion = {
	Tipo.PEQUEÑO: {"dinero": 500,  "madera": 20},
	Tipo.MEDIANO: {"dinero": 1000, "madera": 30, "piedras": 20},
	Tipo.GRANDE:  {"dinero": 2000, "madera": 50, "piedras": 30, "metal": 20}
}

# ── Costos de reparación ──────────────────────────────
var costo_reparacion = {
	Tipo.PEQUEÑO: {"dinero": 100, "madera": 10},
	Tipo.MEDIANO: {"dinero": 200, "madera": 20, "piedras": 10},
	Tipo.GRANDE:  {"dinero": 500, "madera": 30, "piedras": 20, "metal": 10}
}

# ── Inicializar ───────────────────────────────────────
func iniciar(tipo_parque: int) -> void:
	tipo = tipo_parque
	match tipo:
		Tipo.PEQUEÑO: nombre = "Parque Pequeño"
		Tipo.MEDIANO: nombre = "Parque Mediano"
		Tipo.GRANDE:  nombre = "Parque Grande"

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
	if autos_estacionados == 0:
		print(nombre + " — sin autos estacionados")
		return
	var ganancia = autos_estacionados * ganancia_por_auto
	Jugador.agregar_recurso("dinero", ganancia)
	print(nombre + " generó $" + str(ganancia) + " — " + str(autos_estacionados) + " autos")

# ── Entrar auto ───────────────────────────────────────
func entrar_auto() -> bool:
	if esta_dañado:
		print(nombre + " dañado — no acepta autos")
		return false
	var capacidad = capacidad_por_tipo[tipo]
	if autos_estacionados >= capacidad:
		print(nombre + " lleno — capacidad: " + str(capacidad))
		return false
	autos_estacionados += 1
	print(nombre + " — auto entró | estacionados: " + str(autos_estacionados) + "/" + str(capacidad))
	return true

# ── Salir auto ────────────────────────────────────────
func salir_auto() -> void:
	if autos_estacionados > 0:
		autos_estacionados -= 1
		print(nombre + " — auto salió | estacionados: " + str(autos_estacionados))

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañado = true
	autos_estacionados = 0
	print(nombre + " dañado — autos evacuados")

# ── Reparar ───────────────────────────────────────────
func reparar() -> bool:
	if not esta_dañado:
		return false
	var costo = costo_reparacion[tipo]
	if Jugador.gastar_recurso("dinero", costo["dinero"]):
		if costo.has("madera"):
			Jugador.gastar_recurso("madera", costo["madera"])
		if costo.has("piedras"):
			Jugador.gastar_recurso("piedras", costo["piedras"])
		if costo.has("metal"):
			Jugador.gastar_recurso("metal", costo["metal"])
		esta_dañado = false
		print(nombre + " reparado")
		return true
	return false

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañado:
		return nombre + " - DAÑADO"
	var capacidad = capacidad_por_tipo[tipo]
	return nombre + " - OK | Autos: " + str(autos_estacionados) + "/" + str(capacidad) + \
		   " | Ganancia: $" + str(autos_estacionados * ganancia_por_auto) + " cada 2 min"
