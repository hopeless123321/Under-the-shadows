extends StatusEffect



func apply_effect() -> void:
	pass # Here apply all mandatory properties

func effect() -> void:
	duration -= 1
	emit_signal("update_signal_ui", self, str(duration))

func remove_effect() -> void:
	pass # Duplicate here negative apply effect
	
func for_tooltip_text() -> String:
	return ""
