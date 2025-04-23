extends States


func start() -> void:
	pass
func update():
	if unit.unit_property.hp <= 0:
		return unit._st.dying
func end() -> void:
	pass
