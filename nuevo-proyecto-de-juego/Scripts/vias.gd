extends Node2D

@onready var Sprite: Sprite2D = $Sprite2D

#son los raycast para poder detectar las vias a su al rededor
@onready var abajo: RayCast2D = $abajo
@onready var derecha: RayCast2D = $derecha
@onready var izquierda: RayCast2D = $izquierda
@onready var arriba: RayCast2D = $arriba

var atlas = {
	"recta" : preload("res://Sprites/esprie pedorro 2.png"),
	"curva" : preload("res://Sprites/esquina pedorra.png"),
	"cruce t" : preload("res://Sprites/t pedorra.png"),
	"cruce +" : preload("res://Sprites/+ pedorro.png"),
	"ta' solo" : preload("res://Sprites/esprite pedorro1.png")
}

#estas variables son para poder contar cuantos raycast estan activados
var Abajo: int = 0
var Derecha: int = 0
var Izquierda: int = 0
var Arriba: int = 0

func rotacionSprite(grados: int):
	Sprite.rotation_degrees = grados
	
func Suma_direc():
	return Abajo + Derecha + Izquierda + Arriba

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match Suma_direc():
		1:
			if abajo.is_colliding() or arriba.is_colliding():
				Sprite.texture = atlas["recta"]
				rotacionSprite(0)
			elif derecha.is_colliding() or izquierda.is_colliding():
				Sprite.texture = atlas["recta"]
				rotacionSprite(90)
		2:
			if abajo.is_colliding() and arriba.is_colliding():
				Sprite.texture = atlas["recta"]
				rotacionSprite(0)
			elif derecha.is_colliding() and izquierda.is_colliding():
				Sprite.texture = atlas["recta"]
				rotacionSprite(90)
			elif abajo.is_colliding() and derecha.is_colliding():
				Sprite.texture = atlas["curva"]
				rotacionSprite(0)
			elif abajo.is_colliding() and izquierda.is_colliding():
				Sprite.texture = atlas["curva"]
				rotacionSprite(90)
			elif izquierda.is_colliding() and arriba.is_colliding():
				Sprite.texture = atlas["curva"]
				rotacionSprite(180)
			elif arriba.is_colliding() and derecha.is_colliding():
				Sprite.texture = atlas["curva"]
				rotacionSprite(-90)
		3:
			if izquierda.is_colliding() and abajo.is_colliding() and derecha.is_colliding():
				Sprite.texture = atlas["cruce t"]
				rotacionSprite(0)
			elif arriba.is_colliding() and izquierda.is_colliding() and abajo.is_colliding():
				Sprite.texture = atlas["cruce t"]
				rotacionSprite(90)
			elif izquierda.is_colliding() and arriba.is_colliding() and derecha.is_colliding():
				Sprite.texture = atlas["cruce t"]
				rotacionSprite(180)
			elif arriba.is_colliding() and derecha.is_colliding() and abajo.is_colliding():
				Sprite.texture = atlas["cruce t"]
				rotacionSprite(-90)
		4:
			Sprite.texture = atlas["cruce +"]
		_:
			Sprite.texture = atlas["ta' solo"]

func _physics_process(delta: float) -> void:
	if abajo.is_colliding():
		Abajo = 1
	else:
		Abajo = 0
	if derecha.is_colliding():
		Derecha = 1
	else:
		Derecha = 0
	if izquierda.is_colliding():
		Izquierda = 1
	else:
		Izquierda = 0
	if arriba.is_colliding():
		Arriba = 1 
	else:
		Arriba = 0
