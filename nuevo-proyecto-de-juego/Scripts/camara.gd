extends Camera2D
var arrastrando = false
var posicion_ant_mouse = Vector2.ZERO
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			arrastrando = event.pressed
			posicion_ant_mouse = event.position
	
	if event is InputEventMouseMotion:
		if arrastrando:
			var diferencia = posicion_ant_mouse - event.position
			position += diferencia
			posicion_ant_mouse = event.position
