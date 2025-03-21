extends TextureRect


var unit : Unit

func _on_gui_input(_event):
	if Input.is_action_just_pressed("LMB"):
		unit.select()
