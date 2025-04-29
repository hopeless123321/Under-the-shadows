extends StatusEffect

@export_group("Skill dependecy skills")
@export var absorbed_skill : bool = false
# Optional condition to application skill
@export var type_application_skill : Skill.TypeApplication
@export var type_skill : Skill.TypeSpell

func apply_effect() -> void:
	pass # Here apply all mandatory properties

func absorb_skill(skill : Skill) -> bool:
	return true
	
func effect(skill : Skill = null, sender : Unit = null) -> void:
	time_effected -= 1
	emit_signal("update_signal_ui", self, str(time_effected))

func remove_effect() -> void:
	pass # Duplicate here negative apply effect
	
func for_tooltip_text() -> String:
	return ""

