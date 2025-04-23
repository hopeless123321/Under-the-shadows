extends States

func start() -> void:
	Grid.update(unit.path.back(), unit.tile_pos)
	unit.move_to_target()
func update():
	if unit.path.is_empty():
		return unit._st.spell_cast
func end() -> void:
	pass
