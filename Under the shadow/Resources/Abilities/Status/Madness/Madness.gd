extends StatusEffect


@export_multiline var description : String

var will_per_turn : int
var reduce_will_resist : int 

func apply_effect() -> void:
	effected_unit.unit_property.resist_will -= reduce_will_resist

func effect(skill : Skill = null, sender : Unit = null) -> void:
	effected_unit.unit_property.will += will_per_turn
	time_effected -= 1
	emit_signal("update_signal_ui", self)

func remove_effect() -> void:
	effected_unit.unit_property.resist_will += reduce_will_resist
	
func for_tooltip_text() -> String:
	var text : String = description
	text = text.replace("[reduce_will_resist]", str(reduce_will_resist))
	text = text.replace("[will_per_turn]", str(will_per_turn))
	text = text.replace("[duration]", str(time_effected))
	return text

func prop_on_label() -> String:
	return str(time_effected)
