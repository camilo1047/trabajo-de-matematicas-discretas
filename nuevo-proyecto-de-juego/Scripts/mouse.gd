extends Node2D

var mouse = preload("res://Sprites/mouse/mouse.png")
var mouse_click = preload("res://Sprites/mouse/mouse_click.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(mouse, Input.CURSOR_ARROW, Vector2(16, 16), )

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.button_index == MOUSE_BUTTON_WHEEL_UP and not event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Input.set_custom_mouse_cursor(mouse_click, Input.CURSOR_ARROW, Vector2(16, 16))
	else:
		Input.set_custom_mouse_cursor(mouse, Input.CURSOR_ARROW, Vector2(16, 16))

func _process(delta: float) -> void:
	pass
