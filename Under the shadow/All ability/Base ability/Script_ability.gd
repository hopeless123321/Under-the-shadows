extends Resource
class_name Script_ability



func calc_dmg(dmg : float ,d_a : int, resist : float) -> float:
	var final_dmg := dmg * d_a / resist
	return final_dmg

func calc_dmg_from_radius(dmg : float, d_a : int, resist : float, sender_tile_pos : Vector2i, repatient_tile_pos : Vector2i) -> float:
	var new_vector : Vector2i = abs(sender_tile_pos) - abs(repatient_tile_pos)
	var length = new_vector.x + new_vector.y
	var final_dmg = dmg * d_a / resist / length
	return final_dmg
#фикс
func calc_cost(_ability : Base_ability, _unit : Unit) -> void:
	pass
	
func add_status(instance : Status,
				name : String,
				text_for_tooltip : String,
				duration : int,
				type : Status.Type,
				_value : int = 0) -> void:
	instance.name = name
	instance.text_for_tooltip = text_for_tooltip
	instance.duration = duration
	instance.type = type
	instance._value = _value

func check_status_already(status : Status, name : String) -> bool:
	if status.name == name:
		return true
	return false
	
