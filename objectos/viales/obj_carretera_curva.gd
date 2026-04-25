extends Node2D

var nombre: String = "Curva"
var tipo: String = "curva"

var costo_construccion = {
	"dinero": 50,
	"piedra": 5
}

func obtener_tipo() -> String:
	return tipo
