extends Node

var nombre: String = "Reparando"
var puede_operar: bool = false
var puede_generar: bool = false
var tiempo_reparacion: float = 30.0
var tiempo_acumulado: float = 0.0

func _process(delta: float) -> void:
	tiempo_acumulado += delta
	if tiempo_acumulado >= tiempo_reparacion:
		print("Reparación completada")

func obtener_estado() -> String:
	var restante = int(tiempo_reparacion - tiempo_acumulado)
	return "REPARANDO — faltan " + str(restante) + " segundos"
