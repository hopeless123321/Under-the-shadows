extends States

var begin_moving : bool = false

func start():
	# Если добавить ловушки появиться сложности :(
	Grid.update(unit.path.back(), unit.tile_pos)
	
	if unit.path.front().x > unit.tile_pos.x:
		$"../../Sprite2D".flip_h = true
	elif unit.path.front().x < unit.tile_pos.x:
		$"../../Sprite2D".flip_h = false
	begin_moving = false
	am_c.move_anima()
	await get_tree().create_timer(0.5).timeout
	begin_moving = true
func update():
	if begin_moving:
		unit.move_to_target()
	if unit.path.is_empty():
		return unit._st.wait
func end():
	am_c.stop_anima()
