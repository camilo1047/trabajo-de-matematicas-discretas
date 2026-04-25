extends Node2D

var nombre: String = "Cruce"
var tipo: String = "cruce"
var direcciones: Array = ["norte", "sur", "este", "oeste"]

var costo_construccion = {
	"dinero": 100,
	"piedra": 10
}

# ── Elegir dirección aleatoria ────────────────────────
func elegir_direccion() -> String:
	var direccion = direcciones[randi() % direcciones.size()]
	print(nombre + " — carro eligió: " + direccion)
	return direccion
