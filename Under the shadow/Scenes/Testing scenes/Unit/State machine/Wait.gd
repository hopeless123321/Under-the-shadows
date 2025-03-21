extends States


func start():
	unit.fill_floor()
func update():
	if Input.is_action_just_pressed("LMB") and get_viewport().is_input_handled() == false:
		unit.path = Grid.get_path_id(unit.tile_pos, unit._tm.local_to_map(get_global_mouse_position()), unit.free_move)
		if unit.path.is_empty() == false and unit.path.size() <= unit.move_point:
			return unit._st.move
	if unit.hp <= 0:
		return unit._st.dying
func end():
	unit._tm.clear_layer(2)
