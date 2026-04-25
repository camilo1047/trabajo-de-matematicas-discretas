extends Node

# ── Color de validación ───────────────────────────────
const COLOR_VALIDO = Color(1, 1, 1, 0.5)      # blanco transparente
const COLOR_INVALIDO = Color(1, 0, 0, 0.5)    # rojo transparente

var objeto_preview = null

# ── Iniciar preview del objeto ────────────────────────
func iniciar_preview(tipo: String) -> void:
	if objeto_preview:
		objeto_preview.queue_free()
	objeto_preview = cargar_objeto(tipo)
	if objeto_preview:
		get_tree().current_scene.add_child(objeto_preview)

# ── Actualizar posición del preview ───────────────────
func actualizar_preview(posicion: Vector2) -> void:
	if objeto_preview == null:
		return
	objeto_preview.position = posicion
	if posicion_valida(posicion):
		objeto_preview.modulate = COLOR_VALIDO
	else:
		objeto_preview.modulate = COLOR_INVALIDO

# ── Verificar si la posición es válida ────────────────
func posicion_valida(posicion: Vector2) -> bool:
	var todos = get_tree().get_nodes_in_group("edificios") + \
				get_tree().get_nodes_in_group("viales") + \
				get_tree().get_nodes_in_group("naturaleza")
	for objeto in todos:
		if objeto == objeto_preview:
			continue
		if objeto.position.distance_to(posicion) <= 32:
			return false
	return true

# ── Colocar objeto en el mapa ─────────────────────────
func colocar(tipo: String, posicion: Vector2) -> bool:
	if not posicion_valida(posicion):
		return false
	if not get_node("../tin_compra").comprar(tipo):
		return false
	var objeto = cargar_objeto(tipo)
	if objeto == null:
		return false
	objeto.position = posicion
	objeto.modulate = Color(1, 1, 1, 1)
	get_tree().current_scene.add_child(objeto)
	objeto.add_to_group(obtener_grupo(tipo))
	if objeto_preview:
		objeto_preview.queue_free()
		objeto_preview = null
	print("tin_colocacion — colocado: " + tipo + " en " + str(posicion))
	return true

# ── Cancelar colocación ───────────────────────────────
func cancelar_preview() -> void:
	if objeto_preview:
		objeto_preview.queue_free()
		objeto_preview = null

# ── Cargar objeto según tipo ──────────────────────────
func cargar_objeto(tipo: String) -> Node2D:
	var rutas = {
		"casa_pequeña":    "res://Backend/src/core/objectos/construcciones/obj_casas.gd",
		"casa_mediana":    "res://Backend/src/core/objectos/construcciones/obj_casas.gd",
		"casa_grande":     "res://Backend/src/core/objectos/construcciones/obj_casas.gd",
		"banco":           "res://Backend/src/core/objectos/construcciones/obj_banco.gd",
		"colegio":         "res://Backend/src/core/objectos/construcciones/obj_colegio.gd",
		"edificio_mediano":"res://Backend/src/core/objectos/construcciones/obj_edificios.gd",
		"edificio_grande": "res://Backend/src/core/objectos/construcciones/obj_edificios.gd",
		"fabrica_pequeña": "res://Backend/src/core/objectos/construcciones/obj_fabrica.gd",
		"fabrica_mediana": "res://Backend/src/core/objectos/construcciones/obj_fabrica.gd",
		"fabrica_grande":  "res://Backend/src/core/objectos/construcciones/obj_fabrica.gd",
		"carretera":       "res://Backend/src/core/objectos/viales/obj_carretera.gd",
		"semaforo":        "res://Backend/src/core/objectos/viales/obj_semaforo.gd",
		"pare":            "res://Backend/src/core/objectos/viales/obj_pare.gd",
	}
	if not rutas.has(tipo):
		return null
	var objeto = load(rutas[tipo]).new()
	if objeto.has_method("iniciar"):
		objeto.iniciar(obtener_subtipo(tipo))
	return objeto

# ── Obtener subtipo ───────────────────────────────────
func obtener_subtipo(tipo: String) -> int:
	match tipo:
		"casa_pequeña":     return 0
		"casa_mediana":     return 1
		"casa_grande":      return 2
		"edificio_mediano": return 0
		"edificio_grande":  return 1
		"fabrica_pequeña":  return 0
		"fabrica_mediana":  return 1
		"fabrica_grande":   return 2
	return 0

# ── Obtener grupo del objeto ──────────────────────────
func obtener_grupo(tipo: String) -> String:
	if tipo.begins_with("casa") or tipo in ["banco", "colegio", "edificio_mediano",
	   "edificio_grande", "fabrica_pequeña", "fabrica_mediana", "fabrica_grande",
	   "clinica", "casa_gruas", "almacen_pequeño", "almacen_mediano", "almacen_grande",
	   "parque_pequeño", "parque_mediano", "parque_grande"]:
		return "edificios"
	if tipo in ["carretera", "curva", "cruce", "carretera_t", "semaforo", "pare", "puente"]:
		return "viales"
	return "objetos"
