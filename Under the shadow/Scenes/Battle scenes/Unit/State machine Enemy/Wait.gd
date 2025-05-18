extends States


func start() -> void:
	pass
func update():
	if unit.find_path().size() >= 1:
		unit.path = unit.find_path()
		return unit._st.move
	else:
		return unit._st.spell_cast
func end() -> void:
	pass
	
