extends Control

func _ready() -> void:
	$"VBoxContainer/Insertar Semilla".get_meta("numeric_only", true)



func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/crear_nueva_partida.tscn")


func _on_iniciar_partida_pressed() -> void:
	var nombre_ciudad = $"VBoxContainer/Insertar Nombre".text.strip_edges()
	var semilla = int($"VBoxContainer/Insertar Semilla".text.strip_edges())
	var tamaño = int($"VBoxContainer/Insertar Tamaño del Mundo".text.strip_edges())
	if nombre_ciudad == "":
		print("a si putito")
		return
	if semilla == "":
		semilla = 0
	if tamaño == "":
		tamaño = 250


func _on_insertar_semilla_text_changed(new_text: String) -> void:
	if not new_text.is_valid_int():
		$"VBoxContainer/Insertar Semilla".text = new_text.left(new_text.length()-1)
		$"VBoxContainer/Insertar Semilla".caret_column = new_text.length()


func _on_insertar_tamaño_del_mundo_text_changed(new_text: String) -> void:
	if not new_text.is_valid_int():
		$"VBoxContainer/Insertar Tamaño del Mundo".text = new_text.left(new_text.length()-1)
		$"VBoxContainer/Insertar Tamaño del Mundo".caret_column = new_text.length()
