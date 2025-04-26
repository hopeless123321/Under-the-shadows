extends States


func start():
	pass
func update():
	if unit.unit_property.hp <= 0:
		return unit._st.dying
func end():
	unit.begin_turn()
	unit.move_point = unit.unit_property.speed
