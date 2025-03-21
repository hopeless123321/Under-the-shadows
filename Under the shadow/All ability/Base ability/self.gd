extends Base_ability
class_name Self_ability
const Classname := "Self"

func check_right(tile_pos : Vector2i, unit: Ally, _tilemap : TileMap) -> bool:
	if tile_pos == unit.tile_pos:
		return true
	else:
		return false



