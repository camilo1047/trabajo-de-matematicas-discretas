extends Control



func _on_nueva_partida_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/crear_nueva_partida.tscn")


func _on_cargar_partida_pressed() -> void:
	pass # Replace with function body.


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu_de_inicio.tscn")
