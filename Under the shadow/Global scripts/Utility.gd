extends RefCounted
class_name Utility


static func fill_floor(radius : int, init_pos : Vector2i) -> Array[Vector2i]:
	var points : Array[Vector2i] = []
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			if abs(x) + abs(y) <= radius:
				points.append(Vector2i(x, y) + init_pos)
	return points

static func round_place(num,places) -> float:
	return (round(num*pow(10,places))/pow(10,places))

static func calc_length(length : int, sender_tile_pos : Vector2i, repatient_tile_pos : Vector2i) -> bool:
	if sender_tile_pos.x - repatient_tile_pos.x + sender_tile_pos.y - repatient_tile_pos.y <= length:
		return true
	return false

static func get_edge_cell(length : int, init_pos : Vector2i) -> Array[Vector2i]:
	var points : Array[Vector2i] = []
	for x in range(-length, length + 1):
		for y in range(-length, length + 1):
			if abs(x) + abs(y) == length or abs(x) == abs(y) and abs(x) + abs(y) == length - 1 :
				points.append(Vector2i(x, y) + init_pos)
	return points
