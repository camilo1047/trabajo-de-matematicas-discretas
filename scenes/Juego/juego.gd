# res://Backend/scenes/juego/juego.gd
extends Node2D

# Velocidad de movimiento de la cámara
const VELOCIDAD_CAMARA: float = 400.0
const ZOOM_MIN: float = 0.5
const ZOOM_MAX: float = 2.0
const VELOCIDAD_ZOOM: float = 0.1

@onready var camara: Camera2D = $Camera2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_mover_camara(delta)

# ── Cámara ─────────────────────────────────────────────────────────
func _mover_camara(delta: float) -> void:
	var direccion := Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direccion.x -= 1
	if Input.is_action_pressed("ui_right"):
		direccion.x += 1
	if Input.is_action_pressed("ui_up"):
		direccion.y -= 1
	if Input.is_action_pressed("ui_down"):
		direccion.y += 1
	camara.position += direccion * VELOCIDAD_CAMARA * delta

func _unhandled_input(event: InputEvent) -> void:
	# Zoom con rueda del mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camara.zoom = (camara.zoom + Vector2(VELOCIDAD_ZOOM, VELOCIDAD_ZOOM)).clamp(Vector2(ZOOM_MIN, ZOOM_MIN), Vector2(ZOOM_MAX, ZOOM_MAX))
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camara.zoom = (camara.zoom - Vector2(VELOCIDAD_ZOOM, VELOCIDAD_ZOOM)).clamp(Vector2(ZOOM_MIN, ZOOM_MIN), Vector2(ZOOM_MAX, ZOOM_MAX))
