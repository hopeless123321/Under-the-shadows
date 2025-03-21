extends Base_ability
class_name Directional_abiltiy
const Classname := "Directional"

@export var points : Array[Vector2i]

@export var radius : int
@export var piercing : bool

func check_right(tile_pos : Vector2i, unit: Ally, _tilemap : TileMap) -> bool:
	var length = abs(tile_pos.x - unit.tile_pos.x) + abs(tile_pos.y - unit.tile_pos.y)
	if length <= radius:
		return true
	else: 
		return false

func fill(start_point : Vector2i, end_point : Vector2i) -> Array[Vector2i]:
	var vectors : Array[Vector2i] = []
	vectors.clear()
	if points == []:
		if start_point != end_point:
			var dx = start_point.x - end_point.x
			var dy = start_point.y - end_point.y
			var step = max(abs(dx),abs(dy))
			var inc_x = float(dx) / float(step)
			var inc_y = float(dy) / float(step)
			if end_point != start_point:
				for steps in step + 1:
					vectors.append(start_point - Vector2i(round(Vector2(inc_x*steps, inc_y*steps))))
		return vectors
	else:
		if end_point.x == start_point.x or end_point.y == start_point.y:
			if end_point.x < start_point.x:
				for point in points:
					vectors.append(Vector2i(-point.x, point.y) + start_point)
			elif end_point.x > start_point.x:
				for point in points:
					vectors.append(Vector2i(point.x, point.y) + start_point)
			elif end_point.y < start_point.y:
				for point in points:
					vectors.append(Vector2i(point.y, -point.x) + start_point)
			elif end_point.y > start_point.y:
				for point in points:
					vectors.append(Vector2i(point.y, point.x) + start_point)
		return vectors
