extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Clínica"
var esta_dañada: bool = false
var ambulancias_disponibles: int = 2
var ambulancias_totales: int = 2
var cola_accidentes: Array = []

# ── Costo de construcción ─────────────────────────────
var costo_construccion = {
	"dinero": 1000,
	"madera": 30,
	"metal": 20,
	"piedras": 25
}

# ── Costo de reparación ───────────────────────────────
var costo_reparacion = {
	"dinero": 200,
	"madera": 20,
	"metal": 10,
	"piedras": 15
}

# ── Reportar accidente ────────────────────────────────
func reportar_accidente(accidente) -> void:
	if esta_dañada:
		print(nombre + " está dañada — no puede atender accidentes")
		return
	if ambulancias_disponibles > 0:
		atender_accidente(accidente)
	else:
		cola_accidentes.append(accidente)
		print(nombre + " — accidente en cola, esperando ambulancia")

# ── Atender accidente ─────────────────────────────────
func atender_accidente(accidente) -> void:
	ambulancias_disponibles -= 1
	print(nombre + " envió ambulancia — ambulancias disponibles: " + str(ambulancias_disponibles))
	# La ambulancia tarda según distancia
	var distancia = position.distance_to(accidente.position)
	var tiempo_viaje = distancia / 100.0
	await get_tree().create_timer(tiempo_viaje).timeout
	print("Ambulancia llegó al accidente")
	await get_tree().create_timer(10.0).timeout
	print("Accidente atendido — ambulancia regresando")
	await get_tree().create_timer(tiempo_viaje).timeout
	ambulancia_regreso()

# ── Ambulancia regresó ────────────────────────────────
func ambulancia_regreso() -> void:
	ambulancias_disponibles += 1
	print(nombre + " — ambulancia regresó | disponibles: " + str(ambulancias_disponibles))
	if cola_accidentes.size() > 0:
		var siguiente = cola_accidentes.pop_front()
		atender_accidente(siguiente)

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañada = true
	print(nombre + " ha sido dañada — no puede enviar ambulancias")

# ── Reparar ───────────────────────────────────────────
func reparar() -> bool:
	if not esta_dañada:
		return false
	if Jugador.gastar_recurso("dinero", costo_reparacion["dinero"]):
		Jugador.gastar_recurso("madera", costo_reparacion["madera"])
		Jugador.gastar_recurso("metal", costo_reparacion["metal"])
		Jugador.gastar_recurso("piedras", costo_reparacion["piedras"])
		esta_dañada = false
		print(nombre + " ha sido reparada")
		return true
	return false

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañada:
		return nombre + " - DAÑADA"
	return nombre + " - OK | Ambulancias: " + str(ambulancias_disponibles) + "/" + str(ambulancias_totales)
