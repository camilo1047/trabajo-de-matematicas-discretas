extends Node2D

# ── Tipos de bicicleta ────────────────────────────────
enum Tipo {VIEJA, NORMAL, MONTAÑERA, DEPORTIVA, ELECTRICA}

# ── Variables ─────────────────────────────────────────
var tipo: int = Tipo.VIEJA
var nombre: String = ""
var esta_dañada: bool = false
var velocidad: float = 50.0
var direccion: Vector2 = Vector2.RIGHT

# ── Probabilidades por tipo ───────────────────────────
var probabilidades = {
	Tipo.VIEJA:      {"semaforo": 40, "esquivar": 10},
	Tipo.NORMAL:     {"semaforo": 30, "esquivar": 20},
	Tipo.MONTAÑERA:  {"semaforo": 25, "esquivar": 35},
	Tipo.DEPORTIVA:  {"semaforo": 35, "esquivar": 45},
	Tipo.ELECTRICA:  {"semaforo": 15, "esquivar": 30}
}

# ── Inicializar ───────────────────────────────────────
func iniciar(tipo_bici: int) -> void:
	tipo = tipo_bici
	match tipo:
		Tipo.VIEJA:     nombre = "Bicicleta Vieja"
		Tipo.NORMAL:    nombre = "Bicicleta Normal"
		Tipo.MONTAÑERA: nombre = "Bicicleta Montañera"
		Tipo.DEPORTIVA: nombre = "Bicicleta Deportiva"
		Tipo.ELECTRICA: nombre = "Bicicleta Eléctrica"

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	if esta_dañada:
		return
	mover(delta)

# ── Mover ─────────────────────────────────────────────
func mover(delta: float) -> void:
	position += direccion * velocidad * delta

# ── Llegar a semáforo ─────────────────────────────────
func llegar_semaforo(semaforo) -> void:
	var prob = probabilidades[tipo]["semaforo"]
	if randi() % 100 < prob:
		print(nombre + " se saltó el semáforo")
	else:
		semaforo.puede_pasar()
		print(nombre + " respetó el semáforo")

# ── Llegar a pare ─────────────────────────────────────
func llegar_pare(pare) -> void:
	var prob = probabilidades[tipo]["semaforo"]
	if randi() % 100 < prob:
		print(nombre + " se saltó el pare")
	else:
		pare.detener_carro(self)
		print(nombre + " respetó el pare")

# ── Continuar después de pare ─────────────────────────
func continuar() -> void:
	print(nombre + " continúa")

# ── Esquivar auto ─────────────────────────────────────
func intentar_esquivar() -> bool:
	var prob = probabilidades[tipo]["esquivar"]
	if randi() % 100 < prob:
		print(nombre + " esquivó el auto")
		return true
	print(nombre + " no pudo esquivar")
	return false

# ── Recibir atropello ─────────────────────────────────
func recibir_atropello(auto) -> void:
	if intentar_esquivar():
		return
	esta_dañada = true
	print(nombre + " fue atropellada por " + auto.nombre)
	auto.esta_bloqueado = true
	print(auto.nombre + " se detuvo — causando trancón")
	get_node("../../eventos/evento_daño").activar(self)
	queue_free()

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañada:
		return nombre + " - DAÑADA"
	return nombre + " - OK"
