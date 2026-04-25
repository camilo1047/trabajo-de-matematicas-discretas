# res://src/core/sistemas/sys_guardado.gd
extends Node

const RUTA_GUARDADO: String = "user://partida.json"

signal partida_guardada
signal partida_cargada
signal sin_partida_guardada

# ── Guardar ────────────────────────────────────────────────────────
func guardar() -> void:
	var datos: Dictionary = {
		"recursos":  SysRecursos.obtener_datos(),
		"energia":   SysEnergia.obtener_datos(),
		"timestamp": Time.get_unix_time_from_system()
	}

	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.WRITE)
	if archivo == null:
		push_error("SysGuardado: no se pudo abrir el archivo para guardar.")
		return
	archivo.store_string(JSON.stringify(datos))
	archivo.close()
	emit_signal("partida_guardada")
	print("💾 Partida guardada correctamente.")

# ── Cargar ─────────────────────────────────────────────────────────
func cargar() -> void:
	if not FileAccess.file_exists(RUTA_GUARDADO):
		emit_signal("sin_partida_guardada")
		print("⚠️ No hay partida guardada.")
		return

	var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.READ)
	if archivo == null:
		push_error("SysGuardado: no se pudo abrir el archivo para cargar.")
		return

	var contenido: String = archivo.get_as_text()
	archivo.close()

	var resultado = JSON.parse_string(contenido)
	if resultado == null:
		push_error("SysGuardado: error al parsear el archivo JSON.")
		return

	# Calcular tiempo offline para energía
	var timestamp_anterior: float = resultado.get("timestamp", 0.0)
	var tiempo_offline: float = Time.get_unix_time_from_system() - timestamp_anterior

	SysRecursos.cargar_datos(resultado.get("recursos", {}))
	SysEnergia.cargar_datos(resultado.get("energia", {}), tiempo_offline)

	emit_signal("partida_cargada")
	print("✅ Partida cargada. Tiempo offline: %.0f segundos." % tiempo_offline)

# ── Autosave al salir ──────────────────────────────────────────────
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		guardar()
