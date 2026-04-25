extends Node2D

# ── Tipos de almacén ──────────────────────────────────
enum Tipo {PEQUEÑO, MEDIANO, GRANDE}

# ── Variables ─────────────────────────────────────────
var tipo: int = Tipo.PEQUEÑO
var nombre: String = ""
var esta_dañado: bool = false

# ── Capacidad por tipo ────────────────────────────────
var capacidad_por_tipo = {
	Tipo.PEQUEÑO: 1000,
	Tipo.MEDIANO: 5000,
	Tipo.GRANDE:  10000
}

# ── Inventario ────────────────────────────────────────
var inventario = {
	"madera":  0,
	"piedras": 0,
	"metal":   0,
	"agua":    0,
	"comida":  0
}

# ── Costos de construcción ────────────────────────────
var costo_construccion = {
	Tipo.PEQUEÑO: {"dinero": 500,  "madera": 20},
	Tipo.MEDIANO: {"dinero": 1000, "madera": 40, "piedras": 20},
	Tipo.GRANDE:  {"dinero": 2000, "madera": 60, "piedras": 40, "metal": 20}
}

# ── Costos de reparación ──────────────────────────────
var costo_reparacion = {
	Tipo.PEQUEÑO: {"dinero": 100, "madera": 10},
	Tipo.MEDIANO: {"dinero": 200, "madera": 20, "piedras": 10},
	Tipo.GRANDE:  {"dinero": 500, "madera": 30, "piedras": 20, "metal": 10}
}

# ── Inicializar ───────────────────────────────────────
func iniciar(tipo_almacen: int) -> void:
	tipo = tipo_almacen
	match tipo:
		Tipo.PEQUEÑO: nombre = "Almacén Pequeño"
		Tipo.MEDIANO: nombre = "Almacén Mediano"
		Tipo.GRANDE:  nombre = "Almacén Grande"

# ── Guardar recurso ───────────────────────────────────
func guardar(recurso: String, cantidad: int) -> int:
	if esta_dañado:
		print(nombre + " dañado — no puede guardar recursos")
		return 0
	var capacidad = capacidad_por_tipo[tipo]
	var espacio = capacidad - inventario[recurso]
	if espacio <= 0:
		print(nombre + " lleno — se perdieron " + str(cantidad) + " " + recurso)
		return 0
	var guardado = min(cantidad, espacio)
	var perdido = cantidad - guardado
	inventario[recurso] += guardado
	if perdido > 0:
		print(nombre + " — guardó " + str(guardado) + " " + recurso + " | perdido: " + str(perdido))
	else:
		print(nombre + " — guardó " + str(guardado) + " " + recurso)
	return guardado

# ── Retirar recurso ───────────────────────────────────
func retirar(recurso: String, cantidad: int) -> bool:
	if inventario[recurso] >= cantidad:
		inventario[recurso] -= cantidad
		return true
	print(nombre + " — no hay suficiente " + recurso)
	return false

# ── Consultar espacio ─────────────────────────────────
func espacio_disponible(recurso: String) -> int:
	return capacidad_por_tipo[tipo] - inventario[recurso]

# ── Recibir daño ──────────────────────────────────────
func recibir_daño() -> void:
	esta_dañado = true
	print(nombre + " dañado — no puede operar")

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
	return nombre + " - OK | Madera: " + str(inventario["madera"]) + "/" + str(capacidad) + \
		   " | Piedras: " + str(inventario["piedras"]) + "/" + str(capacidad) + \
		   " | Metal: " + str(inventario["metal"]) + "/" + str(capacidad)
