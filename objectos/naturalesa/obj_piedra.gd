# res://src/core/objetos/naturaleza/obj_piedra.gd
extends Node2D

@export var nombre: String = "Piedra"
@export var descripcion: String = "Depósito de piedra natural. Extrae materiales con una mina cercana."

var materiales_disponibles: int = 500
var materiales_por_extraccion: int = 10
var tiempo_extraccion: float = 5.0  # segundos entre extracciones
var _timer: float = 0.0
var agotada: bool = false

signal piedra_agotada
signal materiales_extraidos(cantidad: int)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if agotada:
		return
	_timer += delta
	if _timer >= tiempo_extraccion:
		_timer = 0.0
		_extraer()

func _extraer() -> void:
	if agotada:
		return
	var cantidad: int = min(materiales_por_extraccion, materiales_disponibles)
	materiales_disponibles -= cantidad
	emit_signal("materiales_extraidos", cantidad)
	if materiales_disponibles <= 0:
		agotada = true
		emit_signal("piedra_agotada")

func obtener_info() -> Dictionary:
	return {
		"nombre": nombre,
		"descripcion": descripcion,
		"materiales_disponibles": materiales_disponibles,
		"agotada": agotada
	}
