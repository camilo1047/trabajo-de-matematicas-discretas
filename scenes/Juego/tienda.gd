# res://Backend/scenes/Juego/tienda.gd
extends Node2D

var objeto_seleccionado: String = ""
var preview: Node2D = null

const ESCENAS = {
	"BtnCasaPe": "res://Backend/scenes/objetos/construcciones/casa_pequena.tscn"
}

const COSTOS = {
	"BtnCasaPe": {"dinero": 100, "materiales": 20}
}

@onready var tilemap = get_node("/root/juego/TileMapLayer")
@onready var objetos = get_node("/root/juego/Objetos")

func _ready() -> void:
	_posicionar_panel()
	_conectar_botones()

func _posicionar_panel() -> void:
	var panel = $PanelTienda
	var viewport_size = get_viewport().get_visible_rect().size
	panel.custom_minimum_size = Vector2(220, 400)
	panel.size = Vector2(220, 400)
	panel.position = Vector2(viewport_size.x - 230, 50)

	var textos = {
		"BtnCasaPe": "Casa Pequena",
		"BtnCasaMe": "Casa Mediana",
		"BtnCasaGr": "Casa Grande",
		"BtnParque": "Parque",
		"BtnCarreter": "Carretera"
	}

	for boton in $PanelTienda/VBoxContainer.get_children():
		if boton is Button:
			boton.custom_minimum_size = Vector2(200, 45)
			if textos.has(boton.name):
				boton.text = textos[boton.name]

func _conectar_botones() -> void:
	for boton in $PanelTienda/VBoxContainer.get_children():
		if boton is Button:
			boton.pressed.connect(Callable(self, "_on_boton_pressed").bind(boton.name))

func _on_boton_pressed(nombre: String) -> void:
	if not ESCENAS.has(nombre):
		print("Objeto no implementado: ", nombre)
		return
	objeto_seleccionado = nombre
	_crear_preview(nombre)

func _crear_preview(nombre: String) -> void:
	if preview:
		preview.queue_free()
	var escena = load(ESCENAS[nombre])
	preview = escena.instantiate()
	preview.modulate = Color(0, 1, 0, 0.5)
	add_child(preview)

func _process(_delta: float) -> void:
	if objeto_seleccionado == "" or preview == null:
		return
	var celda = tilemap.obtener_celda_en_mouse()
	var pos = tilemap.celda_a_posicion(celda)
	preview.global_position = pos
	if tilemap.celda_libre(celda):
		preview.modulate = Color(0, 1, 0, 0.5)
	else:
		preview.modulate = Color(1, 0, 0, 0.5)

func _input(event: InputEvent) -> void:
	if objeto_seleccionado == "":
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_intentar_colocar()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			deseleccionar()

func _intentar_colocar() -> void:
	var celda = tilemap.obtener_celda_en_mouse()
	if not tilemap.celda_libre(celda):
		return
	var costo = COSTOS[objeto_seleccionado]
	if SysRecursos.dinero < costo["dinero"] or SysRecursos.materiales < costo["materiales"]:
		print("Sin recursos suficientes")
		return
	SysRecursos.gastar_dinero(costo["dinero"])
	SysRecursos.gastar_materiales(costo["materiales"])
	var escena = load(ESCENAS[objeto_seleccionado])
	var objeto = escena.instantiate()
	objeto.global_position = tilemap.celda_a_posicion(celda)
	objetos.add_child(objeto)
	tilemap.ocupar_celda(celda, objeto_seleccionado)

func deseleccionar() -> void:
	objeto_seleccionado = ""
	if preview:
		preview.queue_free()
		preview = null
