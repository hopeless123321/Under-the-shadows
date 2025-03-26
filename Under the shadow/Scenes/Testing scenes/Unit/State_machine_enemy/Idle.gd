extends States


func start() -> void:
	pass
func update():
	if unit.hp <= 0:
		return unit._st.dying
func end() -> void:
	pass
