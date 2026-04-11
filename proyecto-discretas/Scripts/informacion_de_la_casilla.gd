extends Node2D


class_name Informacion_Casilla_Terreno

enum Superficie_tipo{
	vacio,
	pasto,
	agua,
	arbol,
	roca
}

enum Subterraneo_tipo{
	none,
	petroleo,
	metal
}

var superficie: Superficie_tipo
var subterraneo: Subterraneo_tipo


func _init() -> void:
	var defaul_superficie:Superficie_tipo= Superficie_tipo.pasto
	var defaul_subterraneo:Subterraneo_tipo= Subterraneo_tipo.none
	
	superficie = defaul_superficie
	subterraneo = defaul_subterraneo
