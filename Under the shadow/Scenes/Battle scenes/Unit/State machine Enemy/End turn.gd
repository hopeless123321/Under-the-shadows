extends States

func start():
	pass
func update():
	return unit._st.idle
func end():
	unit.end_turn()
