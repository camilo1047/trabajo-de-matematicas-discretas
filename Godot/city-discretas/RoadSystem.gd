## RoadSystem.gd
## Adjunta a un Node2D raíz en tu escena principal.
## Pinta carreteras y spawnea carros automáticamente al pintar.
##
## ARCHIVOS necesarios en res://:
##   road.png, corner.png, t.png, cross.png, background.png
##   car.png       → sprite del carro orientado hacia ARRIBA (32x32)
##   Car.tscn      → escena del carro (Node2D + Sprite2D llamado "Sprite")

extends Node2D

const ROAD_PATH   : String = "res://road.png"
const CORNER_PATH : String = "res://corner.png"
const T_PATH      : String = "res://t.png"
const CROSS_PATH  : String = "res://cross.png"
const CAR_SCENE   : String = "res://Car.tscn"
const CELL_SIZE   : int    = 32

## Cada cuántas celdas nuevas aparece un carro
const CELLS_PER_CAR : int = 5

var _cells        : Dictionary  = {}
var _painting     : bool        = false
var _erasing      : bool        = false
var _tex_road     : Texture2D
var _tex_corner   : Texture2D
var _tex_t        : Texture2D
var _tex_cross    : Texture2D
var _car_scene    : PackedScene
var _cars_root    : Node2D
var _cells_since_spawn : int = 0   # Contador para espaciar los spawns

func _ready() -> void:
	_tex_road   = load(ROAD_PATH)   as Texture2D
	_tex_corner = load(CORNER_PATH) as Texture2D
	_tex_t      = load(T_PATH)      as Texture2D
	_tex_cross  = load(CROSS_PATH)  as Texture2D
	_car_scene  = load(CAR_SCENE)   as PackedScene
	if _tex_road  == null: push_error("[RoadSystem] No se encontró road.png")
	if _tex_corner == null: push_error("[RoadSystem] No se encontró corner.png")
	if _tex_t     == null: push_error("[RoadSystem] No se encontró t.png")
	if _tex_cross == null: push_error("[RoadSystem] No se encontró cross.png")
	if _car_scene == null: push_error("[RoadSystem] No se encontró Car.tscn")

	# Fondo
	var bg_tex := load("res://background.png") as Texture2D
	if bg_tex != null:
		var bg       := Sprite2D.new()
		bg.texture    = bg_tex
		bg.centered   = false
		bg.z_index    = -10
		var vp        := get_viewport_rect().size
		bg.scale      = Vector2(vp.x / bg_tex.get_width(), vp.y / bg_tex.get_height())
		add_child(bg)

	# Contenedor de carros (encima de carreteras, debajo de UI)
	_cars_root         = Node2D.new()
	_cars_root.name    = "Cars"
	_cars_root.z_index = 1
	add_child(_cars_root)

	var label := Label.new()
	label.text = "Click Izq + arrastrar: pintar   |   Click Der + arrastrar: borrar"
	label.position = Vector2(8, 8)
	label.add_theme_color_override("font_color", Color.WHITE)
	add_child(label)

# ==============================================================================
# INPUT
# ==============================================================================
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			_painting = mb.pressed
			_erasing  = false
			if mb.pressed: _paint_at(mb.position)
		elif mb.button_index == MOUSE_BUTTON_RIGHT:
			_erasing  = mb.pressed
			_painting = false
			if mb.pressed: _erase_at(mb.position)
	elif event is InputEventMouseMotion:
		if _painting: _paint_at((event as InputEventMouseMotion).position)
		elif _erasing: _erase_at((event as InputEventMouseMotion).position)

func _world_to_cell(pos: Vector2) -> Vector2i:
	return Vector2i(floori(pos.x / CELL_SIZE), floori(pos.y / CELL_SIZE))

func _paint_at(pos: Vector2) -> void:
	var cell := _world_to_cell(pos)
	if cell not in _cells:
		_cells[cell] = true
		queue_redraw()
		# Intenta spawnear un carro cada CELLS_PER_CAR celdas nuevas
		_cells_since_spawn += 1
		if _cells_since_spawn >= CELLS_PER_CAR:
			_cells_since_spawn = 0
			_try_spawn_car(cell)

func _erase_at(pos: Vector2) -> void:
	var cell := _world_to_cell(pos)
	if cell in _cells:
		_cells.erase(cell)
		queue_redraw()

# ==============================================================================
# SPAWN DE CARROS
# Busca una dirección válida desde la celda dada y crea el carro
# ==============================================================================
func _try_spawn_car(cell: Vector2i) -> void:
	if _car_scene == null:
		return

	# Busca vecinos con carretera para saber hacia dónde mandar el carro
	var dirs : Array = [
		Vector2i( 0, -1), Vector2i( 1, 0),
		Vector2i( 0,  1), Vector2i(-1, 0)
	]
	var valid_dirs : Array = []
	for d: Vector2i in dirs:
		if (cell + d) in _cells:
			valid_dirs.append(d)

	# Necesita al menos una dirección válida para moverse
	if valid_dirs.is_empty():
		return

	var start_dir : Vector2i = valid_dirs[randi() % valid_dirs.size()]

	var car : Car = _car_scene.instantiate() as Car
	car.setup(cell, start_dir, _cells)
	_cars_root.add_child(car)

# ==============================================================================
# LÓGICA DE TILE
# ==============================================================================
func _get_tile(cell: Vector2i) -> Array:
	var u : bool = (cell + Vector2i( 0, -1)) in _cells
	var r : bool = (cell + Vector2i( 1,  0)) in _cells
	var d : bool = (cell + Vector2i( 0,  1)) in _cells
	var l : bool = (cell + Vector2i(-1,  0)) in _cells
	var n : int  = (1 if u else 0)+(1 if r else 0)+(1 if d else 0)+(1 if l else 0)

	if n == 4:
		return [_tex_cross, 0.0]

	if n == 3:
		if not d: return [_tex_t,   180.0]
		if not u: return [_tex_t, 0.0]
		if not r: return [_tex_t,  90.0]
		if not l: return [_tex_t, 270.0]

	if n == 2:
		if u and l: return [_tex_corner,   270.0]
		if u and r: return [_tex_corner,  0.0]
		if d and r: return [_tex_corner, 90.0]
		if d and l: return [_tex_corner, 180.0]

	if (u or d) and not (l or r):
		return [_tex_road, 90.0]
	return [_tex_road, 0.0]

# ==============================================================================
# DRAW
# ==============================================================================
func _draw() -> void:
	var half := Vector2(CELL_SIZE * 0.5, CELL_SIZE * 0.5)
	for cell: Vector2i in _cells:
		var center := Vector2(cell.x * CELL_SIZE, cell.y * CELL_SIZE) + half
		var tile   := _get_tile(cell)
		var tex    := tile[0] as Texture2D
		var angle  := deg_to_rad(tile[1] as float)
		if tex == null: continue
		draw_set_transform(center, angle, Vector2.ONE)
		draw_texture_rect(tex, Rect2(-half, Vector2(CELL_SIZE, CELL_SIZE)), false)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
