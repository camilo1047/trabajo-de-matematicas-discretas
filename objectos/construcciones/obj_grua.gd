extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Casa de Grúas"
var esta_dañada: bool = false
var gruas_disponibles: int = 2
var gruas_totales: int = 2
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
func reportar_accidente(auto_accidentado) -> void:
	if esta_dañada:
		print(nombre + " dañada — no puede enviar grúas")
		return
	if gruas_disponibles > 0:
		enviar_grua(auto_accidentado)
	else:
		cola_accidentes.append(auto_accidentado)
		print(nombre + " — auto en cola, causando trancón mientras espera")

# ── Enviar grúa ───────────────────────────────────────
func enviar_grua(auto_accidentado) -> void:
	gruas_disponibles -= 1
	print(nombre + " envió grúa — disponibles: " + str(gruas_disponibles))
	var distancia = position.distance_to(auto_accidentado.position)
	var tiempo_viaje = distancia / 80.0
	await get_tree().create_timer(tiempo_viaje).timeout
	print("Grúa llegó al accidente — causando trancón")
	await get_tree().create_timer(15.0).timeout
	auto_accidentado.queue_free()
	print("Auto retirado — grúa regresando")
	await get_tree().create_timer(tiempo_viaje).timeout
	grua_regreso()

# ── Grúa regresó ──────────────────────────────────────
func grua_regreso() -> void:
	gruas_disponibles += 1
	print(nombre + " — grúa regresó | disponibles: " + str(gruas_disponibles))
	if cola_accidentes.size() > 0:
		var siguiente = cola_accidentes.pop_front()
		enviar_grua(siguiente)

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañada = true
	print(nombre + " dañada — no puede enviar grúas")

# ── Reparar ───────────────────────────────────────────
func reparar() -> bool:
	if not esta_dañada:
		return false
	if Jugador.gastar_recurso("dinero", costo_reparacion["dinero"]):
		Jugador.gastar_recurso("madera", costo_reparacion["madera"])
		Jugador.gastar_recurso("metal", costo_reparacion["metal"])
		Jugador.gastar_recurso("piedras", costo_reparacion["piedras"])
		esta_dañada = false
		print(nombre + " reparada")
		return true
	return false

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañada:
		return nombre + " - DAÑADA"
	return nombre + " - OK | Grúas: " + str(gruas_disponibles) + "/" + str(gruas_totales) + \
		   " | En cola: " + str(cola_accidentes.size())
