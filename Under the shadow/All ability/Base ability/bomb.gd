extends Base_ability
class_name Bomb_ability
const Classname := "Bomb like"

@export var radius_to_target : int
@export var radius : int

func check_right(tile_pos : Vector2i, unit: Ally, tilemap : TileMap) -> bool:
	var length = abs(tile_pos.x - unit.tile_pos.x) + abs(tile_pos.y - unit.tile_pos.y)
	if length <= radius_to_target and tilemap.get_cell_tile_data(3, tile_pos) == null:
		return true
	else:
		return false

func fill(mouse_tile_pos : Vector2i) -> Array[Vector2i]:
	var right_tile_pos : Vector2i
	var points : Array[Vector2i] = []
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius +1):
			right_tile_pos = mouse_tile_pos + Vector2i(x,y)
			if abs(x) + abs(y) <= radius and Grid.check_point_in_grid(right_tile_pos):
				points.append(right_tile_pos)
	return points

