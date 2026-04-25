extends Node2D

var nombre: String = "Señal"
var mensaje: String = ""

var costo_construccion = {
	"dinero": 20
}

func establecer_mensaje(texto: String) -> void:
	mensaje = texto
	print(nombre + " — " + mensaje)
