extends Node

var team : Array[Unit_res]

const PATH_TO_PROP : String = "res://All unit/[name unit]/[name unit] prop.tres"
const TRANSLATE_PROP_NAME : Array[String] = [
	"forename",
	"max_hp",
	"hp",
	"dmg_amp",
	"resist_phys_dmg",
	"resist_mag_dmg",
	"resist_will",
	"speed",
	"reaction",
	"move_after_skill",
	"free_move",
	"skills",
	"icon",
	"icon_select",
	"type",
	"cost",
	"initial_status",
	"animation_trans",
	"animation_ease",
	"duration",
	"distance",
	"move_to"]

func save_resource() -> void:
	#if FileAccess.file_exists():
		pass

func load_res() -> void:
	pass

func save_team() -> void:
	pass

func load_team() -> void:
	pass

func update_team(allies : Array) -> void:
	team.clear()
	for unit : Ally in allies:
		var unit_to_update : Unit_res = Unit_res.new()
		copy_property(unit_to_update, unit)
		team.append(unit_to_update)

func add_ally_to_team(forename : String) -> void:
	var new_ally : Unit_res = Unit_res.new()
	var to_resource : String = PATH_TO_PROP.replace("[name unit]", forename)
	if FileAccess.file_exists(to_resource):
		var resouce_prop : Unit_prop = load(to_resource)
		copy_property(new_ally, resouce_prop)
		new_ally.hp = resouce_prop.max_hp
	team.append(new_ally)

func inst_ally() -> Array:
	return team.map(team_to_ally)

func set_stat_enemy(unit_prop : Unit_prop) -> Enemy:
	var new_enemy : Enemy = Enemy.new()
	copy_property(new_enemy, unit_prop)
	new_enemy.input_pickable = true
	return new_enemy

func update_whole_party(allies : Array) -> void:
	team.clear()
	#print(typeof(allies[0]))
	team.append_array(allies)

func upgrade_unit(upgrade_to : Unit_prop, upgrade_from : Unit_res = null) -> Unit_res:
	if upgrade_from != null:
		team.erase(upgrade_from)
	var new_ally : Unit_res = Unit_res.new()
	copy_property(new_ally, upgrade_to)
	new_ally.hp = upgrade_to.max_hp
	team.append(new_ally)
	return new_ally

func team_to_ally(ally_res : Unit_res) -> Ally:
	var ins_ally : Ally = Ally.new()
	copy_property(ins_ally, ally_res)
	ins_ally.input_pickable = true
	return ins_ally

func copy_property(unit : Object, res : Object) -> void:
	for prop in TRANSLATE_PROP_NAME:
		if res is Unit_prop:
			print(unit.type)
		unit.set(prop, res.get(prop))
