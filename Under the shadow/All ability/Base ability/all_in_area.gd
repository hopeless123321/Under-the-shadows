extends Base_ability 
class_name All_area_ability
const Classname := "All in area"

@export var radius : int


func check_right(tile_pos : Vector2i, unit: Ally, _tilemap : TileMap) -> bool:
	if tile_pos == unit.tile_pos:
		return true
	else:
		return false

func fill(tile_pos_char : Vector2i) -> Array[Vector2i]:
	var points : Array[Vector2i] = []
	for edge_tile in Utility.get_edge_cell(radius, tile_pos_char):
		points.append_array(Grid.valid_line_skill(tile_pos_char, edge_tile))
	return points
