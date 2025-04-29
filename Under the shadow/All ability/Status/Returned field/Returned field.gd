extends StatusEffect

@export_group("Skill dependecy skills")
@export var type_skill : Skill.TypeSpell

func apply_effect() -> void:
	pass # Here apply all mandatory properties

func effect(skill : Skill = null, sender : Unit = null) -> void:
	time_effected -= 1
	skill.execute(effected_unit, [sender])
	emit_signal("update_signal_ui", self)

func absorb_skill(skill : Skill, sender : Unit) -> bool:
	if skill.type_spell == type_skill:
		return true
	return false

func remove_effect() -> void:
	pass # Duplicate here negative apply effect
	
func for_tooltip_text() -> String:
	return ""
func prop_on_label() -> String:
	return str(time_effected)
