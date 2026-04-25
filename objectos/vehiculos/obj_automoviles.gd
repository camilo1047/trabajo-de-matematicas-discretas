extends Node2D

# ── Tipos de auto ─────────────────────────────────────
enum Tipo {VIEJO, NORMAL, TAXI, MODERNO, DEPORTIVO}

# ── Variables ─────────────────────────────────────────
var tipo: int = Tipo.VIEJO
var nombre: String = ""
var esta_dañado: bool = false
var esta_incendiado: bool = false
var esta_bloqueado: bool = false
var en_carretera: bool = true
var velocidad: float = 100.0
var direccion: Vector2 = Vector2.RIGHT

# ── Probabilidades por tipo (sobre 100) ───────────────
var probabilidades = {
	Tipo.VIEJO:      {"respetar": 10, "chocar": 40, "incendio": 30, "bloqueo": 35, "salirse": 25},
	Tipo.NORMAL:     {"respetar": 20, "chocar": 30, "incendio": 20, "bloqueo": 25, "salirse": 15},
	Tipo.TAXI:       {"respetar": 25, "chocar": 25, "incendio": 15, "bloqueo": 20, "salirse": 10},
	Tipo.MODERNO:    {"respetar": 35, "chocar": 20, "incendio": 10, "bloqueo": 15, "salirse": 10},
	Tipo.DEPORTIVO:  {"respetar": 15, "chocar": 45, "incendio": 25, "bloqueo": 10, "salirse": 30}
}

# ── Inicializar ───────────────────────────────────────
func iniciar(tipo_auto: int) -> void:
	tipo = tipo_auto
	match tipo:
		Tipo.VIEJO:     nombre = "Auto Viejo"
		Tipo.NORMAL:    nombre = "Auto Normal"
		Tipo.TAXI:      nombre = "Taxi"
		Tipo.MODERNO:   nombre = "Auto Moderno"
		Tipo.DEPORTIVO: nombre = "Auto Deportivo"

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	if esta_dañado or esta_bloqueado or esta_incendiado:
		return
	mover(delta)
	verificar_salida_carretera()

# ── Mover ─────────────────────────────────────────────
func mover(delta: float) -> void:
	position += direccion * velocidad * delta

# ── Verificar si se sale de carretera ─────────────────
func verificar_salida_carretera() -> void:
	var prob = probabilidades[tipo]["salirse"]
	if randi() % 100 < prob:
		salirse_carretera()

# ── Salirse de carretera ──────────────────────────────
func salirse_carretera() -> void:
	en_carretera = false
	esta_dañado = true
	print(nombre + " se salió de la carretera")
	get_node("../../eventos/evento_choque_edificio").verificar_daño_edificio(self)

# ── Llegar a semáforo ─────────────────────────────────
func llegar_semaforo(semaforo) -> void:
	var prob = probabilidades[tipo]["respetar"]
	if randi() % 100 < prob:
		semaforo.puede_pasar()
		print(nombre + " respetó el semáforo")
	else:
		print(nombre + " se saltó el semáforo")

# ── Llegar a pare ─────────────────────────────────────
func llegar_pare(pare) -> void:
	var prob = probabilidades[tipo]["respetar"]
	if randi() % 100 < prob:
		pare.detener_carro(self)
		print(nombre + " respetó el pare")
	else:
		print(nombre + " se saltó el pare")

# ── Continuar después de pare ─────────────────────────
func continuar() -> void:
	esta_bloqueado = false
	print(nombre + " continúa")

# ── Verificar choque en cadena ────────────────────────
func verificar_choque_cadena(auto_delante) -> void:
	var prob = probabilidades[tipo]["chocar"]
	if randi() % 100 < prob:
		print(nombre + " chocó con " + auto_delante.nombre)
		get_node("../../eventos/eventos_choque").activar(self, auto_delante)

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañado = true
	print(nombre + " ha sido dañado")
	get_node("../../eventos/evento_daño").activar(self)

# ── Verificar incendio ────────────────────────────────
func verificar_incendio() -> void:
	var prob = probabilidades[tipo]["incendio"]
	if randi() % 100 < prob:
		esta_incendiado = true
		print(nombre + " se incendió")
		get_node("../../eventos/evento_incendio").activar(self)

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_incendiado:
		return nombre + " - INCENDIADO"
	if esta_dañado:
		return nombre + " - DAÑADO"
	if esta_bloqueado:
		return nombre + " - BLOQUEADO"
	return nombre + " - OK"
