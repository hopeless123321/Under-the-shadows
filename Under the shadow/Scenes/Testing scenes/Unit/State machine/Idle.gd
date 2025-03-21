extends States


func start():
	pass
func update():
	if unit.hp <= 0:
		return unit._st.dying
func end():
	unit.move_point = unit.speed
