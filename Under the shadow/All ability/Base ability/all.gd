extends Base_ability
class_name All_ability
const Classname := "All in world"


func check_right(tile_pos : Vector2i, unit: Ally, _tilemap : TileMap) -> bool:
	if tile_pos == unit.tile_pos:
		return true
	else:
		return false
