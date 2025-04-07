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

