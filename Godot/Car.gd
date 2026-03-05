## Car.gd
## Script de la escena Car.tscn
## El carro se mueve por las celdas de carretera hacia adelante
## y en cruces/T elige una dirección aleatoria válida.
##
## Árbol de Car.tscn:
##   Node2D  ← este script
##   └── Sprite2D  (name="Sprite", texture=car.png, orientado hacia ARRIBA)

class_name Car
extends Node2D

const SPEED       : float = 80.0   # Píxeles por segundo
const CELL_SIZE   : int   = 32

## Referencia al diccionario de celdas del RoadSystem (se asigna al spawnear)
var road_cells : Dictionary = {}

## Dirección actual de movimiento como Vector2i (0,-1)=arriba, (1,0)=derecha...
var _dir      : Vector2i = Vector2i(0, -1)
## Celda destino hacia la que se mueve ahora mismo
var _target   : Vector2i = Vector2i.ZERO
## Celda actual
var _current  : Vector2i = Vector2i.ZERO
## true mientras viaja entre dos celdas
var _moving   : bool     = false

@onready var _sprite: Sprite2D = $Sprite


# ==============================================================================
# INICIALIZACIÓN — llamado por RoadSystem al crear el carro
# ==============================================================================
func setup(start_cell: Vector2i, start_dir: Vector2i, cells: Dictionary) -> void:
	road_cells = cells
	_current   = start_cell
	_dir       = start_dir
	position   = _cell_to_world(start_cell)
	_sprite.rotation = _dir_to_angle(start_dir)
	_pick_next()


# ==============================================================================
# PROCESO — mueve el carro hacia _target cada frame
# ==============================================================================
func _process(delta: float) -> void:
	if not _moving:
		return

	var target_world : Vector2 = _cell_to_world(_target)
	var step         : float   = SPEED * delta
	var dist         : float   = position.distance_to(target_world)

	if dist <= step:
		# Llegó a la celda destino — elige la siguiente
		position = target_world
		_current  = _target
		_moving   = false
		_pick_next()
	else:
		position = position.move_toward(target_world, step)


# ==============================================================================
# LÓGICA DE NAVEGACIÓN
# Busca todas las celdas vecinas válidas excepto de donde vine,
# elige una aleatoriamente (comportamiento de IA simple).
# ==============================================================================
func _pick_next() -> void:
	var dirs : Array[Vector2i] = [
		Vector2i( 0, -1),   # arriba
		Vector2i( 1,  0),   # derecha
		Vector2i( 0,  1),   # abajo
		Vector2i(-1,  0),   # izquierda
	]

	# Dirección de donde venimos (no queremos ir para atrás)
	var back : Vector2i = Vector2i(-_dir.x, -_dir.y)

	# Filtra: debe ser carretera y no ser la dirección de retorno
	var options : Array[Vector2i] = []
	for d: Vector2i in dirs:
		if d == back:
			continue
		var neighbor : Vector2i = _current + d
		if neighbor in road_cells:
			options.append(d)

	if options.is_empty():
		# Sin opciones → intenta dar la vuelta
		var reverse : Vector2i = _current + back
		if reverse in road_cells:
			_dir    = back
			_target = reverse
			_moving = true
			_sprite.rotation = _dir_to_angle(_dir)
		# Si no hay vuelta posible (celda aislada), el carro se queda quieto
		return

	# Elige dirección aleatoria entre las opciones válidas
	_dir    = options[randi() % options.size()]
	_target = _current + _dir
	_moving = true

	# Rota el sprite hacia la nueva dirección
	_sprite.rotation = _dir_to_angle(_dir)


# ==============================================================================
# UTILIDADES
# ==============================================================================

## Centro en pantalla de una celda de cuadrícula
func _cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(
		cell.x * CELL_SIZE + CELL_SIZE * 0.5,
		cell.y * CELL_SIZE + CELL_SIZE * 0.5
	)

## Convierte una dirección Vector2i al ángulo de rotación del sprite.
## El sprite base apunta hacia ARRIBA (0°).
func _dir_to_angle(dir: Vector2i) -> float:
	match dir:
		Vector2i( 0, -1): return 0.0              # Arriba
		Vector2i( 1,  0): return PI * 0.5         # Derecha
		Vector2i( 0,  1): return PI               # Abajo
		Vector2i(-1,  0): return PI * 1.5         # Izquierda
	return 0.0
