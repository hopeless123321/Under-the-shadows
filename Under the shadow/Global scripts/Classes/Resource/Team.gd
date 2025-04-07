extends Node

var team : Array[Unit]
const FLAG_RES : int = 4102
const FLAG_RES_ANIM : int = 69638
const PATH_TO_PROP : String = "res://All unit/?/? prop.tres"

func save_resource() -> void:
	#if FileAccess.file_exists():
		pass

func load_res() -> void:
	pass

func save_team() -> void:
	pass

func load_team() -> void:
	pass

func add_unit(name : String) -> void:
	var new_member : Ally = Ally.new()
	var to_resource : String = PATH_TO_PROP.replace("?", name)
	if FileAccess.file_exists(to_resource):
		var resouce_prop : Unit_prop = load(to_resource)
		for prop in resouce_prop.get_property_list():
			if prop.usage in [FLAG_RES, FLAG_RES_ANIM]:
				new_member.set(prop.name, resouce_prop.get(prop.name))
	new_member.input_pickable = true
	team.append(new_member)
	
func set_stat_enemy(unit_prop : Unit_prop) -> Enemy:
	var new_member : Enemy = Enemy.new()
	for prop in unit_prop.get_property_list():
		if prop.usage in [FLAG_RES, FLAG_RES_ANIM]:
			new_member.set(prop.name, unit_prop.get(prop.name))
	new_member.input_pickable = true
	return new_member

func get_unit(index : int) -> Unit:
	return team[index]
