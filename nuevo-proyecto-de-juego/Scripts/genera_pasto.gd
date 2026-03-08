extends Node2D

var pasto_esce = preload("res://Escenas/pasto.tscn")
var arbol_esce = preload("res://Escenas/arbol.tscn")

@onready var camara: Camera2D = $"../Camera2D"

var celda_camara
var rango = 25
var celda
var mundo_pos
var noise = FastNoiseLite.new()
var valor_noise
var distancia
var prob_distancia
var probabilidad
var ultima_celda_camara = Vector2.ZERO


func debe_generar_arbol():
	valor_noise = (noise.get_noise_2d(mundo_pos.x, mundo_pos.y) + 1 )/ 2
	
	distancia = mundo_pos.length()/ 1000
	prob_distancia = clamp(distancia, 0.0, 1.0)
	
	probabilidad = valor_noise * 0.5 + prob_distancia * 0.5
	return probabilidad > 0.82
	

func generar_alrededor(pos: Vector2) -> void:
	celda_camara = (pos / GLOBAL.Tamaño_tile).round()
	rango = 30
	for x in range(-rango, rango):
		for y in range(-rango, rango):
			celda = (celda_camara + Vector2(x, y))
			mundo_pos = celda * GLOBAL.Tamaño_tile
			if celda not in GLOBAL.ocupado:
				if debe_generar_arbol():
					GLOBAL.ocupado[celda] = "arbol"
					var aparece_arbol = arbol_esce.instantiate()
					aparece_arbol.position = mundo_pos
					add_child(aparece_arbol)
				else:
					GLOBAL.ocupado[celda] = "pasto"
					var aparece_pasto = pasto_esce.instantiate()
					aparece_pasto.position = mundo_pos
					add_child(aparece_pasto)


func _ready() -> void:
	noise.seed = randi()
	noise.frequency = 0.01
	generar_alrededor(camara.global_position)
func _process(delta: float) -> void:
	var celda_actual = (camara.global_position / GLOBAL.Tamaño_tile).round()
	if celda_actual != ultima_celda_camara:
		ultima_celda_camara = celda_actual
		generar_alrededor(camara.global_position)
