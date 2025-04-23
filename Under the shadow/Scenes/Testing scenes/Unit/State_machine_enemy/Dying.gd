extends States


func start():
	GlobalInfo.add_souls(unit.unit_property.cost)
	print("die enemy")
	Eventbus.emit_signal("dying", unit)
	unit.self_destroy()
func update():
	pass
func end():
	pass

