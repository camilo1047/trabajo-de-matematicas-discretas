## RoadSystem.gd
## Controlador principal — adjunta a un Node2D raíz en tu escena principal.
## Orquesta el grafo (RoadNetwork) y los objetos visuales (RoadNode, RoadEdge).
##
## ESTRUCTURA DE ARCHIVOS necesaria en res://:
##   node.png          → sprite del nodo  (32x32, franjas blancas)
##   road.png          → sprite de arista (32x64, líneas amarillas)
##   RoadNode.tscn     → escena del nodo
##   RoadEdge.tscn     → escena de la arista
##
## ÁRBOL DE ESCENA en RoadNode.tscn:
##   Node2D  (RoadNode.gd)
##   └── Sprite2D  (name="Sprite", texture=node.png)
##
## ÁRBOL DE ESCENA en RoadEdge.tscn:
##   Node2D  (RoadEdge.gd)
##   └── Line2D   (name="Line")

extends Node2D

const PATH_NODE_SCENE: String = "res://RoadNode.tscn"
const PATH_EDGE_SCENE: String = "res://RoadEdge.tscn"
const PATH_ROAD_TEX:   String = "res://road.png"
const SNAP_RADIUS:     float  = 20.0

var _network:        RoadNetwork = RoadNetwork.new()
var _selected_id:    int         = -1
var _hovered_id:     int         = -1
var _mouse_pos:      Vector2     = Vector2.ZERO
var _road_tex:       Texture2D
var _node_scene:     PackedScene
var _edge_scene:     PackedScene
var _node_instances: Dictionary  = {}
var _edges_root:     Node2D

func _ready() -> void:
	_road_tex   = load(PATH_ROAD_TEX)   as Texture2D
	_node_scene = load(PATH_NODE_SCENE) as PackedScene
	_edge_scene = load(PATH_EDGE_SCENE) as PackedScene
	assert(_road_tex   != null, "No se encontró road.png en res://")
	assert(_node_scene != null, "No se encontró RoadNode.tscn en res://")
	assert(_edge_scene != null, "No se encontró RoadEdge.tscn en res://")
	_edges_root         = Node2D.new()
	_edges_root.name    = "Edges"
	_edges_root.z_index = -1
	add_child(_edges_root)
	var label: Label = Label.new()
	label.text = "Click: colocar / conectar nodos   |   Click Der: deseleccionar"
	label.position = Vector2(8, 8)
	label.add_theme_color_override("font_color", Color.WHITE)
	add_child(label)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_handle_click(mb.position)
		elif mb.button_index == MOUSE_BUTTON_RIGHT and mb.pressed:
			_selected_id = -1
			_refresh_tints()
			queue_redraw()
	elif event is InputEventMouseMotion:
		_mouse_pos  = (event as InputEventMouseMotion).position
		_hovered_id = _network.find_nearest(_mouse_pos, SNAP_RADIUS)
		_refresh_tints()
		queue_redraw()

func _handle_click(click_pos: Vector2) -> void:
	var target_id: int = _network.find_nearest(click_pos, SNAP_RADIUS)
	if target_id == -1:
		target_id = _network.add_node(click_pos)
		_spawn_node(target_id, click_pos)
	if _selected_id != -1 and _selected_id != target_id:
		_network.add_edge(_selected_id, target_id)
		_spawn_edge(_selected_id, target_id)
	_selected_id = target_id
	_refresh_tints()
	queue_redraw()

func _spawn_node(id: int, pos: Vector2) -> void:
	var node: RoadNode = _node_scene.instantiate() as RoadNode
	node.node_id  = id
	node.position = pos
	add_child(node)
	_node_instances[id] = node

func _spawn_edge(id_a: int, id_b: int) -> void:
	var edge: RoadEdge = _edge_scene.instantiate() as RoadEdge
	edge.node_id_a = id_a
	edge.node_id_b = id_b
	edge.setup(_network.nodes[id_a], _network.nodes[id_b], _road_tex)
	_edges_root.add_child(edge)

func _refresh_tints() -> void:
	for id: int in _node_instances:
		var node: RoadNode = _node_instances[id]
		if id == _selected_id:
			node.set_state("selected")
		elif id == _hovered_id:
			node.set_state("hover")
		else:
			node.set_state("normal")

func _draw() -> void:
	if _selected_id == -1 or _selected_id not in _network.nodes:
		return
	var origin: Vector2 = _network.nodes[_selected_id]
	var target: Vector2 = _network.nodes[_hovered_id] \
		if _hovered_id != -1 else _mouse_pos
	draw_dashed_line(origin, target, Color(1, 1, 1, 0.4), 2.0, 10.0)
	if _hovered_id == -1:
		draw_arc(target, 14.0, 0, TAU, 32, Color(1, 1, 1, 0.4), 1.5)
