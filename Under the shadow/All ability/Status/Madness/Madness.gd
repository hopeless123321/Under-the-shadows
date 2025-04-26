extends StatusEffect


@export_multiline var description : String

var will_per_turn : int
var reduce_will_resist : int 

func apply_effect() -> void:
	effected_unit.unit_property.resist_will -= reduce_will_resist

func effect() -> void:
	effected_unit.unit_property.will += will_per_turn
	duration -= 1
	emit_signal("update_signal_ui", self)

func remove_effect() -> void:
	effected_unit.unit_property.resist_will += reduce_will_resist
	
func for_tooltip_text() -> String:
	return ""

func prop_on_label() -> String:
	return str(duration)
