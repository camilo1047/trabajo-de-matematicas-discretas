extends Node

# ── Variables ─────────────────────────────────────────
var cantidad: int = 0
var ingreso_por_turno: int = 0

# ── Agregar dinero ────────────────────────────────────
func agregar(valor: int) -> void:
	cantidad += valor

# ── Gastar dinero ─────────────────────────────────────
func gastar(valor: int) -> bool:
	if cantidad >= valor:
		cantidad -= valor
		return true
	return false

# ── Actualizar por turno ──────────────────────────────
func actualizar_turno() -> void:
	cantidad += ingreso_por_turno

# ── Consultar ─────────────────────────────────────────
func obtener() -> int:
	return cantidad
