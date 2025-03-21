extends Base_ability
class_name Targets_ability
const Classname := "Several targets"

@export var radius : int
@export var targets : int



func check_right(tile_pos : Vector2i, _unit: Ally, _tilemap : TileMap) -> bool:
	if tile_pos in GlobalInfo.dirty_tile_for_everyone.values():
		return true
	else:
		return false

func fill(tile_pos_char : Vector2i) -> Array[Vector2i]:
	var points : Array[Vector2i] = []
	for edge_tile in Utility.get_edge_cell(radius, tile_pos_char):
		points.append_array(Grid.valid_line_skill(tile_pos_char, edge_tile))
	return points

func check(tile_pos : Vector2i) -> bool:
	if GlobalInfo.dirty_tile_for_everyone.find_key(tile_pos) and check_unit(tile_pos):
			return true
	return false
