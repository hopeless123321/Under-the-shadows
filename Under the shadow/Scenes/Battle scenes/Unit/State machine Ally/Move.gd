extends States


func start():
	# Если добавить ловушки появиться сложности :(
	Grid.update(unit.path.back(), unit.tile_pos)
	unit.move_to_target()
	if unit.path.front().x > unit.tile_pos.x:
		$"../../Store sprite/Upper".flip_h = true
		$"../../Store sprite/Under".flip_h = true
	elif unit.path.front().x < unit.tile_pos.x:
		$"../../Store sprite/Upper".flip_h = false
		$"../../Store sprite/Under".flip_h = false
func update():
	if unit.path.is_empty():
		return unit._st.wait
func end():
	pass
