extends TextureRect


var unit : Unit

func _on_gui_input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("LMB"):
		unit.select()
