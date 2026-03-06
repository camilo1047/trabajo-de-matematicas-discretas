extends Node2D
var Esce_Ins = preload("res://Escenas/vias.tscn")

#esta funcion es la que crea la instancia en las casillas y comprueba que no alla una instancia antes para que no alla mas de dos en el mismo sitio
func Instanciar(ins, pos):
	var instanciando = ins.instantiate()
	if GLOBAL.organizar_tile(pos) in GLOBAL.ocupado:
		return
	GLOBAL.ocupado[GLOBAL.organizar_tile(pos)] = true
	instanciando.position = GLOBAL.organizar_tile(pos)
	add_child(instanciando)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Mouse izq"):
		Instanciar(Esce_Ins, get_global_mouse_position())
		
