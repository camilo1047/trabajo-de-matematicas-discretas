extends Node

var nombre: String = "Dañado"
var puede_operar: bool = false
var puede_generar: bool = false

func obtener_estado() -> String:
	return "DAÑADO — necesita reparación"
