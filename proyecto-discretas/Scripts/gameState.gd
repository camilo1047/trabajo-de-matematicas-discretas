extends Node

var nombre_de_la_ciudad: String
var semilla: int = 0
var dinero: int = 5000
var poblacion: int = 0
var tiempo_de_juego: float = 0
var tamaño_del_grid: int = 250


var informacion_grid: Array = []

var guardado_partida: String:
	get:
		return "user://save_"+ nombre_de_la_ciudad +".json"



func serialize_grid(grid:Array):
	var informacion = []
	for y in range(grid.size()):
		var row = []
		for x in range(grid[y].size()):
			var tile = grid[y][x]
			
			var tile_dicc = {
				"superficie": tile.superficie,
				"subterraneo": tile.subterraneo
			}
			row.append(tile_dicc)
		informacion.append(row)
	return informacion



func deserialize_grid(informacion:Array):
	
	var grid = []
	
	for y in range(informacion.size()):
		
		var row = []
		var raw_row = []
		
		for x in range(raw_row[y].size()):
			
			var tile_dicc = raw_row[x]
			var d = Dictionary(tile_dicc)
			
			var tile = TileData.new()
			tile.superficie = int(d["superficie"])
			tile.subterraneo = int (d["subterraneo"])
			
			row.append(tile)
			
		grid.append(row)
	
	return grid



func guardado(grid:Array):
	informacion_grid = serialize_grid(grid)
	var diccionario_de_guardado  = {
		"nombre_de_la_ciudad": nombre_de_la_ciudad,
		"semilla": semilla,
		"dinero": dinero,
		"poblacion": poblacion,
		"tiempo_de_juego": tiempo_de_juego,
		"tamaño_del_grid": tamaño_del_grid,
		"informacion_grid": informacion_grid
	}
	var json_string = JSON.stringify(diccionario_de_guardado, "\t")
	var archivo = FileAccess.open(guardado_partida, FileAccess.WRITE)
	
	if archivo == null:
		push_error("por putito no te guardo la partida")
		return
	archivo.store_string(json_string)
	archivo.close()



func cargar():
	var archivo = FileAccess.open(guardado_partida, FileAccess.READ)
	if archivo == null:
		push_error("Nelson diria jaaaajaaa")
		return false
	var json_string = archivo.get_as_text()
	archivo.close()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("por pendejo")
		return false
	var guardar_dicc = json.get_data()
	nombre_de_la_ciudad = guardar_dicc["nombre_de_la_ciudad"]
	semilla = guardar_dicc["semilla"]
	dinero = guardar_dicc["dinero"]
	poblacion = guardar_dicc["poblacion"]
	tiempo_de_juego = guardar_dicc["tiempo_de_juego"]
	tamaño_del_grid = guardar_dicc["tamaño_del_grid"]
	informacion_grid = guardar_dicc["informacion_grid"]


func reseteo():
	semilla = 0
	dinero = 5000
	poblacion = 0
	tiempo_de_juego = 0
	tamaño_del_grid = 250
