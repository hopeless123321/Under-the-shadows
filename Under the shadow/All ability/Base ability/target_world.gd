extends Base_ability
class_name Target_world_ability
const Classname := "World one target"

func check_right(tile_pos : Vector2i, _unit: Ally, _tilemap : TileMap) -> bool:
	var character = Grid.get_unit(tile_pos)
	if character:
		return true
	else: 
		return false
