## RoadNode.gd
## Script de la escena RoadNode.tscn
## Representa visualmente un nodo del grafo (intersección).
##
## Árbol de la escena RoadNode.tscn:
##   Node2D  ← este script
##   └── Sprite2D  (nombre: "Sprite")
##
## El sprite usa node.png (32x32, franjas blancas).

class_name RoadNode
extends Node2D

# Colores de tinte según el estado del nodo
const TINT_NORMAL:   Color = Color(1.0, 1.0, 1.0)          # Sin tinte
const TINT_SELECTED: Color = Color(1.0, 0.85, 0.0)         # Amarillo
const TINT_HOVER:    Color = Color(0.45, 1.0, 0.55)        # Verde

## ID que le asigna el RoadSystem al crear este nodo
var node_id: int = -1

@onready var _sprite: Sprite2D = $Sprite


## Cambia el tinte visual según el estado que indique el RoadSystem
func set_state(state: String) -> void:
	match state:
		"selected": _sprite.modulate = TINT_SELECTED
		"hover":    _sprite.modulate = TINT_HOVER
		_:          _sprite.modulate = TINT_NORMAL
