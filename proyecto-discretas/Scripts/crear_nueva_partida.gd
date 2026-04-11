extends Control


 
func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/seleccion_de_partidas.tscn")


func _on_iniciar_partida_pressed() -> void:
	pass # Replace with function body.


func _on_opciones_de_partida_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/opciones_de_partida.tscn")
