extends Node2D

# ── Variables ─────────────────────────────────────────
var nombre: String = "Autobús"
var esta_dañado: bool = false
var esta_bloqueado: bool = false
var velocidad: float = 80.0
var direccion: Vector2 = Vector2.RIGHT
var pasajeros: int = 0
var max_pasajeros: int = 50
var tarifa: int = 2
var ruta: Array = []
var indice_parada: int = 0

# ── Inicializar ruta ──────────────────────────────────
func iniciar_ruta(paradas: Array) -> void:
	ruta = paradas
	print(nombre + " — ruta iniciada con " + str(ruta.size()) + " paradas")

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	if esta_dañado or esta_bloqueado:
		return
	mover(delta)
	verificar_parada()

# ── Mover ─────────────────────────────────────────────
func mover(delta: float) -> void:
	if ruta.size() == 0:
		return
	var parada_actual = ruta[indice_parada]
	var distancia = position.distance_to(parada_actual.position)
	if distancia > 5:
		direccion = (parada_actual.position - position).normalized()
		position += direccion * velocidad * delta
	else:
		llegar_parada(parada_actual)

# ── Verificar parada ──────────────────────────────────
func verificar_parada() -> void:
	if ruta.size() == 0:
		return
	var parada_actual = ruta[indice_parada]
	if position.distance_to(parada_actual.position) <= 5:
		llegar_parada(parada_actual)

# ── Llegar a parada ───────────────────────────────────
func llegar_parada(parada) -> void:
	print(nombre + " llegó a " + parada.nombre)
	cobrar_pasajeros()
	bajar_pasajeros()
	parada.bus_llego(self)
	indice_parada = (indice_parada + 1) % ruta.size()

# ── Espacio disponible ────────────────────────────────
func espacio_disponible() -> int:
	return max_pasajeros - pasajeros

# ── Subir pasajeros ───────────────────────────────────
func subir_pasajeros(cantidad: int) -> void:
	pasajeros += cantidad
	print(nombre + " — pasajeros a bordo: " + str(pasajeros))

# ── Bajar pasajeros ───────────────────────────────────
func bajar_pasajeros() -> void:
	print(nombre + " — bajaron " + str(pasajeros) + " pasajeros")
	pasajeros = 0

# ── Cobrar pasajeros ──────────────────────────────────
func cobrar_pasajeros() -> void:
	if pasajeros == 0:
		return
	var ganancia = pasajeros * tarifa
	Jugador.agregar_recurso("dinero", ganancia)
	print(nombre + " cobró $" + str(ganancia) + " por " + str(pasajeros) + " pasajeros")

# ── Llegar a semáforo ─────────────────────────────────
func llegar_semaforo(semaforo) -> void:
	if not semaforo.puede_pasar():
		esta_bloqueado = true
		print(nombre + " esperando semáforo")
		await get_tree().create_timer(semaforo.intervalo_cambio).timeout
		esta_bloqueado = false

# ── Llegar a pare ─────────────────────────────────────
func llegar_pare(pare) -> void:
	pare.detener_carro(self)
	print(nombre + " respetó el pare")

# ── Continuar ─────────────────────────────────────────
func continuar() -> void:
	esta_bloqueado = false
	print(nombre + " continúa")

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañado = true
	print(nombre + " dañado — pasajeros varados: " + str(pasajeros))
	get_node("../../eventos/evento_daño").activar(self)
	get_node("../../../construcciones/obj_grua").reportar_accidente(self)

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañado:
		return nombre + " - DAÑADO | Pasajeros varados: " + str(pasajeros)
	return nombre + " - OK | Pasajeros: " + str(pasajeros) + "/" + str(max_pasajeros)
