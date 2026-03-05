## RoadSystem.gd
## Adjunta a un Node2D raíz en tu escena principal.
## Detecta automáticamente: recta, esquina, T y cruce según los vecinos.
##
## ARCHIVOS necesarios en res://:
##   road.png    → recta HORIZONTAL  (─)  base 0°
##   corner.png  → curva arriba-izquierda (╝) base 0°
##   t.png       → T abierta abajo   (┬)  base 0°
##   cross.png   → cruce 4 dirs      (+)  base 0°

extends Node2D

const ROAD_PATH   : String = "res://road.png"
const CORNER_PATH : String = "res://corner.png"
const T_PATH      : String = "res://t.png"
const CROSS_PATH  : String = "res://cross.png"
const CELL_SIZE   : int    = 32

var _cells     : Dictionary = {}
var _painting  : bool       = false
var _erasing   : bool       = false
var _tex_road  : Texture2D
var _tex_corner: Texture2D
var _tex_t     : Texture2D
var _tex_cross : Texture2D

func _ready() -> void:
	_tex_road   = load(ROAD_PATH)   as Texture2D
	_tex_corner = load(CORNER_PATH) as Texture2D
	_tex_t      = load(T_PATH)      as Texture2D
	_tex_cross  = load(CROSS_PATH)  as Texture2D
	if _tex_road   == null: push_error("[RoadSystem] No se encontró road.png")
	if _tex_corner == null: push_error("[RoadSystem] No se encontró corner.png")
	if _tex_t      == null: push_error("[RoadSystem] No se encontró t.png")
	if _tex_cross  == null: push_error("[RoadSystem] No se encontró cross.png")

	# ── FONDO ─────────────────────────────────────────────────────────────────
	# Carga background.png y lo estira para cubrir toda la ventana del juego.
	# z_index = -10 garantiza que quede detrás de las carreteras y la UI.
	var bg_tex := load("res://background.png") as Texture2D
	if bg_tex != null:
		var bg := Sprite2D.new()
		bg.texture          = bg_tex
		bg.centered         = false        # Origen en esquina superior izquierda
		bg.z_index          = -10
		# Escala el sprite para que cubra exactamente el tamaño de la ventana
		var vp := get_viewport_rect().size
		bg.scale = Vector2(vp.x / bg_tex.get_width(), vp.y / bg_tex.get_height())
		add_child(bg)
	else:
		push_error("[RoadSystem] No se encontró background.png")

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

func _erase_at(pos: Vector2) -> void:
	var cell := _world_to_cell(pos)
	if cell in _cells:
		_cells.erase(cell)
		queue_redraw()

# ==============================================================================
# LÓGICA DE TILE
#
# Orientaciones BASE de cada sprite:
#   road.png   → horizontal (─)         necesita 90° para ser vertical
#   corner.png → conecta U+L (╝)        arriba-izquierda
#   t.png      → abierta abajo (┬)      tiene U, L, R — falta D
#   cross.png  → simétrico (+)          sin rotación
# ==============================================================================
func _get_tile(cell: Vector2i) -> Array:   # [Texture2D, angulo_grados]
	var u : bool = (cell + Vector2i( 0, -1)) in _cells
	var r : bool = (cell + Vector2i( 1,  0)) in _cells
	var d : bool = (cell + Vector2i( 0,  1)) in _cells
	var l : bool = (cell + Vector2i(-1,  0)) in _cells
	var n : int  = (1 if u else 0) + (1 if r else 0) + (1 if d else 0) + (1 if l else 0)

	# ── CRUCE ────────────────────────────────────────────────────────────────
	if n == 4:
		return [_tex_cross, 0.0]

	# ── T ────────────────────────────────────────────────────────────────────
	# Base: tiene U+L+R, falta D  →  abierta abajo (┬)
	if n == 3:
		if not d: return [_tex_t,   180.0]   # ┬ abierta abajo   → base
		if not u: return [_tex_t, 0.0]   # ┴ abierta arriba  → 180°
		if not r: return [_tex_t,  90.0]   # ├ abierta derecha → 90°
		if not l: return [_tex_t, 270.0]   # ┤ abierta izquierda → 270°

	# ── ESQUINAS ─────────────────────────────────────────────────────────────
	# Base: conecta U+L (╝) — viene de arriba y de la izquierda
	if n == 2:
		if u and l: return [_tex_corner,   270.0]   # ╝ arriba-izquierda → base
		if u and r: return [_tex_corner,  0.0]   # ╚ arriba-derecha
		if d and r: return [_tex_corner, 90.0]   # ╔ abajo-derecha
		if d and l: return [_tex_corner, 180.0]   # ╗ abajo-izquierda

	# ── RECTAS ───────────────────────────────────────────────────────────────
	# Base: horizontal (─) → 0°  |  vertical (│) → 90°
	if (u or d) and not (l or r):
		return [_tex_road, 90.0]   # Vertical
	return [_tex_road, 0.0]        # Horizontal (defecto)

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

		if tex == null:
			continue

		draw_set_transform(center, angle, Vector2.ONE)
		draw_texture_rect(tex, Rect2(-half, Vector2(CELL_SIZE, CELL_SIZE)), false)

	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
