## Car.gd
## Script de la escena Car.tscn
## Árbol de Car.tscn:
##   Node2D  ← este script
##   └── Sprite2D  (el nombre no importa, texture=car.png orientado hacia ARRIBA)

class_name Car
extends Node2D

const SPEED     : float = 80.0
const CELL_SIZE : int   = 32

var road_cells : Dictionary = {}
var _dir       : Vector2i   = Vector2i(0, -1)
var _target    : Vector2i   = Vector2i.ZERO
var _current   : Vector2i   = Vector2i.ZERO
var _moving    : bool       = false
var _sprite    : Sprite2D   = null

func _ready() -> void:
	# Busca el Sprite2D por tipo, sin depender del nombre
	for child in get_children():
		if child is Sprite2D:
			_sprite = child
			break
	if _sprite == null:
		push_error("[Car] No se encontró un hijo Sprite2D en Car.tscn")

func setup(start_cell: Vector2i, start_dir: Vector2i, cells: Dictionary) -> void:
	# setup() puede llamarse antes de _ready() — espera si hace falta
	if _sprite == null:
		await ready
	road_cells = cells
	_current   = start_cell
	_dir       = start_dir
	position   = _cell_to_world(start_cell)
	if _sprite:
		_sprite.rotation = _dir_to_angle(_dir)
	_pick_next()

func _process(delta: float) -> void:
	if not _moving:
		return
	var target_world : Vector2 = _cell_to_world(_target)
	var step         : float   = SPEED * delta
	var dist         : float   = position.distance_to(target_world)
	if dist <= step:
		position  = target_world
		_current  = _target
		_moving   = false
		_pick_next()
	else:
		position = position.move_toward(target_world, step)

func _pick_next() -> void:
	var dirs : Array[Vector2i] = [
		Vector2i( 0, -1), Vector2i( 1,  0),
		Vector2i( 0,  1), Vector2i(-1,  0),
	]
	var back    : Vector2i       = Vector2i(-_dir.x, -_dir.y)
	var options : Array[Vector2i] = []
	for d: Vector2i in dirs:
		if d == back:
			continue
		if (_current + d) in road_cells:
			options.append(d)

	if options.is_empty():
		# Sin opciones hacia adelante → intenta dar vuelta
		if (_current + back) in road_cells:
			_dir    = back
			_target = _current + back
			_moving = true
			if _sprite: _sprite.rotation = _dir_to_angle(_dir)
		return

	_dir    = options[randi() % options.size()]
	_target = _current + _dir
	_moving = true
	if _sprite: _sprite.rotation = _dir_to_angle(_dir)

func _cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(
		cell.x * CELL_SIZE + CELL_SIZE * 0.5,
		cell.y * CELL_SIZE + CELL_SIZE * 0.5
	)

func _dir_to_angle(dir: Vector2i) -> float:
	match dir:
		Vector2i( 0, -1): return 0.0
		Vector2i( 1,  0): return PI * 0.5
		Vector2i( 0,  1): return PI
		Vector2i(-1,  0): return PI * 1.5
	return 0.0
