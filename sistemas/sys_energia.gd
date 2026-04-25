extends Node

# ── Variables ─────────────────────────────────────────
var energia: int = 1000
var energia_maxima: int = 1000
var recarga_por_minuto: int = 10
var tiempo_acumulado: float = 0.0
var ultima_vez: int = 0

# ── Costos de construcción ────────────────────────────
var costo_construccion = {
	"casa_pequeña": 10,
	"casa_mediana": 20,
	"casa_grande": 30,
	"banco": 50,
	"colegio": 40,
	"edificio_mediano": 50,
	"edificio_grande": 100,
	"fabrica_pequeña": 30,
	"fabrica_mediana": 50,
	"fabrica_grande": 100,
	"clinica": 50,
	"casa_gruas": 50,
	"parque_pequeño": 20,
	"parque_mediano": 40,
	"parque_grande": 80
}

# ── Costos de reparación (mitad del costo) ────────────
var costo_reparacion = {}

# ── Inicializar ───────────────────────────────────────
func _ready() -> void:
	# Calcular costos de reparación automáticamente
	for edificio in costo_construccion:
		costo_reparacion[edificio] = costo_construccion[edificio] / 2
	# Cargar tiempo guardado
	cargar_energia()

# ── Actualizar cada frame ─────────────────────────────
func _process(delta: float) -> void:
	tiempo_acumulado += delta
	if tiempo_acumulado >= 60.0:
		tiempo_acumulado = 0.0
		recargar()

# ── Recargar energía ──────────────────────────────────
func recargar() -> void:
	energia = min(energia + recarga_por_minuto, energia_maxima)
	guardar_energia()
	print("sys_energia — recargó " + str(recarga_por_minuto) + " | total: " + str(energia))

# ── Gastar energía al construir ───────────────────────
func gastar_construccion(tipo: String) -> bool:
	if not costo_construccion.has(tipo):
		return true
	var costo = costo_construccion[tipo]
	if energia >= costo:
		energia -= costo
		guardar_energia()
		print("sys_energia — construcción " + tipo + " costó " + str(costo) + " | restante: " + str(energia))
		return true
	print("sys_energia — energía insuficiente para construir " + tipo)
	return false

# ── Gastar energía al reparar ─────────────────────────
func gastar_reparacion(tipo: String) -> bool:
	if not costo_reparacion.has(tipo):
		return true
	var costo = costo_reparacion[tipo]
	if energia >= costo:
		energia -= costo
		guardar_energia()
		print("sys_energia — reparación " + tipo + " costó " + str(costo) + " | restante: " + str(energia))
		return true
	print("sys_energia — energía insuficiente para reparar " + tipo)
	return false

# ── Guardar energía ───────────────────────────────────
func guardar_energia() -> void:
	var archivo = FileAccess.open("user://energia.dat", FileAccess.WRITE)
	if archivo:
		archivo.store_var(energia)
		archivo.store_var(Time.get_unix_time_from_system())
		archivo.close()

# ── Cargar energía ────────────────────────────────────
func cargar_energia() -> void:
	if not FileAccess.file_exists("user://energia.dat"):
		return
	var archivo = FileAccess.open("user://energia.dat", FileAccess.READ)
	if archivo:
		energia = archivo.get_var()
		ultima_vez = archivo.get_var()
		archivo.close()
		calcular_recarga_offline()

# ── Calcular recarga mientras estuvo cerrado ──────────
func calcular_recarga_offline() -> void:
	var ahora = Time.get_unix_time_from_system()
	var segundos_pasados = ahora - ultima_vez
	var minutos_pasados = int(segundos_pasados / 60)
	if minutos_pasados > 0:
		var recarga = minutos_pasados * recarga_por_minuto
		energia = min(energia + recarga, energia_maxima)
		print("sys_energia — recargó " + str(recarga) + " offline | total: " + str(energia))

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	return "Energía — " + str(energia) + "/" + str(energia_maxima)
