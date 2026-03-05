## RoadEdge.gd
## Script de la escena RoadEdge.tscn
## Representa visualmente una arista del grafo (segmento de carretera).
##
## Árbol de la escena RoadEdge.tscn:
##   Node2D  ← este script
##   └── Line2D  (el nombre no importa)

class_name RoadEdge
extends Node2D

var node_id_a: int = -1
var node_id_b: int = -1

# Busca el Line2D por tipo en vez de por nombre — evita errores si lo renombraste
var _line: Line2D

func _ready() -> void:
	# Busca el primer hijo que sea Line2D, sin importar su nombre
	for child in get_children():
		if child is Line2D:
			_line = child
			break
	if _line == null:
		push_error("[RoadEdge] No se encontró un hijo Line2D en esta escena.")

## Configura la carretera entre dos posiciones con la textura tileada
func setup(pos_a: Vector2, pos_b: Vector2, texture: Texture2D) -> void:
	# Espera a que _ready() haya corrido antes de usar _line
	if _line == null:
		await ready

	var atlas: AtlasTexture = AtlasTexture.new()
	atlas.atlas             = texture
	atlas.region            = Rect2(0, 32, 32, 32)

	_line.texture        = atlas
	_line.texture_mode   = Line2D.LINE_TEXTURE_TILE
	_line.width          = 32.0
	_line.begin_cap_mode = Line2D.LINE_CAP_BOX
	_line.end_cap_mode   = Line2D.LINE_CAP_BOX
	_line.clear_points()
	_line.add_point(pos_a)
	_line.add_point(pos_b)
