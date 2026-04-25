extends Control

func _ready() -> void:
	estilizar_boton($botones/BtnJugar)
	estilizar_boton($botones/BtnOpciones)
	estilizar_boton($botones/BtnCreditos)
	estilizar_boton($botones/BtnSalir)
	$botones/BtnJugar.pressed.connect(Callable(self, "_on_jugar"))
	$botones/BtnOpciones.pressed.connect(Callable(self, "_on_opciones"))
	$botones/BtnCreditos.pressed.connect(Callable(self, "_on_creditos"))
	$botones/BtnSalir.pressed.connect(Callable(self, "_on_salir"))

func estilizar_boton(boton: Button) -> void:
	# Estilo normal — cristal transparente
	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(0.0, 0.5, 1.0, 0.15)
	estilo.border_width_left = 2
	estilo.border_width_right = 2
	estilo.border_width_top = 2
	estilo.border_width_bottom = 2
	estilo.border_color = Color(0.5, 0.9, 1.0, 0.9)
	estilo.set_corner_radius_all(10)
	boton.add_theme_stylebox_override("normal", estilo)
	# Estilo hover
	var estilo_hover = StyleBoxFlat.new()
	estilo_hover.bg_color = Color(0.0, 0.7, 1.0, 0.35)
	estilo_hover.border_width_left = 2
	estilo_hover.border_width_right = 2
	estilo_hover.border_width_top = 2
	estilo_hover.border_width_bottom = 2
	estilo_hover.border_color = Color(0.8, 1.0, 1.0, 1.0)
	estilo_hover.set_corner_radius_all(10)
	boton.add_theme_stylebox_override("hover", estilo_hover)
	# Estilo pressed
	var estilo_pressed = StyleBoxFlat.new()
	estilo_pressed.bg_color = Color(0.0, 0.9, 1.0, 0.5)
	estilo_pressed.border_width_left = 2
	estilo_pressed.border_width_right = 2
	estilo_pressed.border_width_top = 2
	estilo_pressed.border_width_bottom = 2
	estilo_pressed.border_color = Color(1.0, 1.0, 1.0, 1.0)
	estilo_pressed.set_corner_radius_all(10)
	boton.add_theme_stylebox_override("pressed", estilo_pressed)
	# Texto
	boton.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 1.0))
	boton.add_theme_color_override("font_hover_color", Color(0.8, 1.0, 1.0, 1.0))
	boton.add_theme_font_size_override("font_size", 24)

func _on_jugar() -> void:
	get_tree().change_scene_to_file("res://Backend/scenes/juego/juego.tscn")

func _on_opciones() -> void:
	print("Opciones — próximamente")

func _on_creditos() -> void:
	print("Créditos — próximamente")

func _on_salir() -> void:
	get_tree().quit()
