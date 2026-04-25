# res://Backend/scenes/Juego/HUD.gd
extends Node2D

var lbl_dinero: Label
var lbl_energia: Label
var lbl_materiales: Label
var lbl_poblacion: Label

func _ready() -> void:
	lbl_dinero     = get_node("HBoxContainer/LblDinero")
	lbl_energia    = get_node("HBoxContainer/LblEnergia")
	lbl_materiales = get_node("HBoxContainer/LblMateriales")
	lbl_poblacion  = get_node("HBoxContainer/LblPoblacion")
	_aplicar_estilo()
	_conectar_senales()
	_actualizar_ui()

func _aplicar_estilo() -> void:
	var hbox = get_node("HBoxContainer")

	# Fondo full ancho con ColorRect
	var fondo = ColorRect.new()
	fondo.color = Color(0.08, 0.08, 0.15, 0.92)
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(fondo)
	move_child(fondo, 0)  # que quede detrás del HBoxContainer

	# Línea azul inferior
	var linea = ColorRect.new()
	linea.color = Color(0.31, 0.76, 0.97, 1.0)
	linea.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	linea.custom_minimum_size = Vector2(0, 2)
	add_child(linea)

	# Estilo de los labels
	for lbl in [lbl_dinero, lbl_energia, lbl_materiales, lbl_poblacion]:
		lbl.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95, 1.0))
		lbl.add_theme_font_size_override("font_size", 15)

	# Separación entre labels
	hbox.add_theme_constant_override("separation", 40)
func _process(_delta: float) -> void:
	lbl_energia.text = "⚡ %s / %s" % [SysEnergia.energia, SysEnergia.energia_maxima]

func _actualizar_ui() -> void:
	lbl_dinero.text     = "💰 $%s" % SysRecursos.dinero
	lbl_energia.text    = "⚡ %s / %s" % [SysEnergia.energia, SysEnergia.energia_maxima]
	lbl_materiales.text = "🪨 %s" % SysRecursos.materiales
	lbl_poblacion.text  = "👥 %s / %s" % [SysRecursos.poblacion, SysRecursos.poblacion_maxima]

func _conectar_senales() -> void:
	SysRecursos.connect("dinero_cambiado",     Callable(self, "_on_dinero_cambiado"))
	SysRecursos.connect("materiales_cambiado", Callable(self, "_on_materiales_cambiado"))
	SysRecursos.connect("poblacion_cambiada",  Callable(self, "_on_poblacion_cambiada"))

func _on_dinero_cambiado(_nuevo: int) -> void:
	_actualizar_ui()

func _on_materiales_cambiado(_nuevo: int) -> void:
	_actualizar_ui()

func _on_poblacion_cambiada(_nueva: int) -> void:
	_actualizar_ui()
