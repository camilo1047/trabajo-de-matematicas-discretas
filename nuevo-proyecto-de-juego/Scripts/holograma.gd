extends Node2D
@onready var Mundo_Principal: Node2D = $".."
var holograma

func _ready() -> void:
	holograma = Mundo_Principal.Esce_Ins.instantiate()
	holograma.modulate = Color(1, 1, 1, 0.5)
	holograma.z_index = 10 #esto hace que se dibuje por encima de lo demas(lo que tanga un z index menor)
	add_child(holograma)


func _process(delta: float) -> void:
	holograma.position = GLOBAL.organizar_tile(get_global_mouse_position())
	if GLOBAL.organizar_tile(get_global_mouse_position()) in GLOBAL.ocupado:
		holograma.modulate = Color(1, 0, 0, 0.5)
	else:
		holograma.modulate = Color(0, 1, 0, 0.5)
