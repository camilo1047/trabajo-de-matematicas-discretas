extends Node

# ── Variables ─────────────────────────────────────────
var nombre: String = "Banco"
var esta_dañado: bool = false
var esta_destruido: bool = false
var dinero_guardado: int = 0

# ── Costo de construcción ─────────────────────────────
var costo_construccion = {
	"dinero": 800
}

# ── Costo de reparación ───────────────────────────────
var costo_reparacion = {
	"dinero": 300,
	"madera": 30,
	"metal": 15,
	"piedras": 20
}

# ── Guardar dinero ────────────────────────────────────
func guardar_dinero(cantidad: int) -> void:
	if not esta_dañado and not esta_destruido:
		dinero_guardado += cantidad
		print("Banco guardó: $" + str(cantidad) + " | Total: $" + str(dinero_guardado))

# ── Retirar dinero ────────────────────────────────────
func retirar_dinero(cantidad: int) -> bool:
	if dinero_guardado >= cantidad:
		dinero_guardado -= cantidad
		Jugador.agregar_recurso("dinero", cantidad)
		return true
	return false

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañado = true
	var perdida = min(10, dinero_guardado)
	dinero_guardado -= perdida
	print(nombre + " dañado — perdiste $" + str(perdida))

# ── Destruir ──────────────────────────────────────────
func destruir() -> void:
	esta_destruido = true
	var perdida = int(dinero_guardado * 0.25)
	dinero_guardado -= perdida
	Jugador.agregar_recurso("dinero", dinero_guardado)
	dinero_guardado = 0
	print(nombre + " destruido — perdiste 25% del dinero guardado")

# ── Reparar ───────────────────────────────────────────
func reparar() -> bool:
	if not esta_dañado:
		return false
	if Jugador.gastar_recurso("dinero", costo_reparacion["dinero"]):
		Jugador.gastar_recurso("madera", costo_reparacion["madera"])
		Jugador.gastar_recurso("metal", costo_reparacion["metal"])
		Jugador.gastar_recurso("piedras", costo_reparacion["piedras"])
		esta_dañado = false
		esta_destruido = false
		print(nombre + " ha sido reparado")
		return true
	return false

# ── Consultar estado ──────────────────────────────────
func obtener_estado() -> String:
	if esta_destruido:
		return nombre + " - DESTRUIDO"
	if esta_dañado:
		return nombre + " - DAÑADO"
	return nombre + " - OK | Guardado: $" + str(dinero_guardado)
