extends Base_ability
class_name Tiles_ability
const Classname := "tiles"

@export var count : int
@export var radius : int
@export var vectors_effect : Array[Vector2i]

func check_right(tile_pos : Vector2i, unit: Ally, tilemap : TileMap) -> bool:
	var length = abs(tile_pos.x - unit.tile_pos.x) + abs(tile_pos.y - unit.tile_pos.y)
	if length <= radius and tilemap.get_cell_tile_data(3, tile_pos) == null:
		return true
	return false
