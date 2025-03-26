extends States

func start():
	# Если добавить ловушки появиться сложности :(
	Grid.update(unit.path.back(), unit.tile_pos)
	unit.move_to_target()
	if unit.path.front().x > unit.tile_pos.x:
		$"../../Sprite sheet".flip_h = true
	elif unit.path.front().x < unit.tile_pos.x:
		$"../../Sprite sheet".flip_h = false
func update():
	if unit.path.is_empty():
		return unit._st.wait
func end():
	pass
