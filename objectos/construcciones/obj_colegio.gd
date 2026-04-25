extends Node

# ── Variables ─────────────────────────────────────────
var nombre: String = "Colegio"
var esta_dañado: bool = false
var tiempo_acumulado: float = 0.0
var intervalo_generacion: float = 60.0
var dinero_por_intervalo: int = 10

# ── Costo de construcción ─────────────────────────────
var costo_construccion = {
	"dinero": 500,
	"madera": 20,
	"piedras": 15
}

# ── Costo de reparación ───────────────────────────────
var costo_reparacion = {
	"dinero": 200,
	"madera": 20,
	"piedras": 10
}

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
	Jugador.agregar_recurso("dinero", dinero_por_intervalo)
	print(nombre + " generó $" + str(dinero_por_intervalo))

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañado = true
	print(nombre + " ha sido dañado — dejó de generar dinero")

# ── Reparar ───────────────────────────────────────────
func reparar() -> bool:
	if not esta_dañado:
		return false
	if Jugador.gastar_recurso("dinero", costo_reparacion["dinero"]):
		Jugador.gastar_recurso("madera", costo_reparacion["madera"])
		Jugador.gastar_recurso("piedras", costo_reparacion["piedras"])
		esta_dañado = false
		tiempo_acumulado = 0.0
		print(nombre + " ha sido reparado")
		return true
	return false

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_dañado:
		return nombre + " - DAÑADO"
	return nombre + " - OK | Genera $" + str(dinero_por_intervalo) + " cada 60s"
