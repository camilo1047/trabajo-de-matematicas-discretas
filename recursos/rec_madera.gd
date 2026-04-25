extends Node

# ── Variables ─────────────────────────────────────────
var cantidad: int = 0
var produccion_por_turno: int = 0
var capacidad_maxima: int = 500

# ── Agregar madera ────────────────────────────────────
func agregar(valor: int) -> void:
	cantidad = min(cantidad + valor, capacidad_maxima)

# ── Gastar madera ─────────────────────────────────────
func gastar(valor: int) -> bool:
	if cantidad >= valor:
		cantidad -= valor
		return true
	return false

# ── Actualizar por turno ──────────────────────────────
func actualizar_turno() -> void:
	cantidad = min(cantidad + produccion_por_turno, capacidad_maxima)

# ── Consultar ─────────────────────────────────────────
func obtener() -> int:
	return cantidad
