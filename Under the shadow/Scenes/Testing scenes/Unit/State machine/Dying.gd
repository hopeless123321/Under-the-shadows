extends States


func start():
	Eventbus.emit_signal("dying", unit)
	unit.self_destroy()
func update():
	pass
func end():
	pass
