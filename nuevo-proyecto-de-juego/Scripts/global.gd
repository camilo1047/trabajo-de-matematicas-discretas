extends Node
const Tamaño_tile = 32
var ocupado = {} 

#esta funcion redondea la posicion exacta del mouse para que sea dibisible entre el tamaño de tile
func organizar_tile(pos: Vector2):
	return (pos / Tamaño_tile).round() * Tamaño_tile
