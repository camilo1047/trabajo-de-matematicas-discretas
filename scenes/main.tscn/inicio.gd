extends Node2D

func _ready() -> void:
	print("=== Juego iniciado ===")
	print("Dinero: " + str(Jugador.dinero))
	print("Energía: " + SysEnergia.obtener_estado())
	print("Tráfico: " + SysTrafico.obtener_estado())
	print("Reparación: " + SysReparacion.obtener_estado())
