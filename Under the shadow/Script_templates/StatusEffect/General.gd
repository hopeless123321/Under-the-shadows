extends StatusEffect



func apply_effect() -> void:
	pass # Here apply all mandatory properties

func effect(skill : Skill = null, sender : Unit = null) -> void:
	time_effected -= 1
	emit_signal("update_signal_ui", self, str(time_effected))

func remove_effect() -> void:
	pass # Duplicate here negative apply effect
	
func for_tooltip_text() -> String:
	return ""
