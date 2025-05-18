extends Node

const PATH_TO_PROP : String = "res://Resources/Units/[name unit]/[name unit] prop.tres"
const TRANSLATE_PROP_NAME : Array[String] = [
	"forename",
	"max_hp",
	"damage",
	"resist_phys_dmg",
	"resist_mag_dmg",
	"resist_will",
	"speed",
	"reaction",
	"move_after_skill",
	"free_move",
	"icon",
	"icon_minimap",
	"cost",
	"class_unit",
	"initial_status",
	"animation_trans",
	"animation_ease",
	"duration",
	"distance",
	"enemy_move_to"]

var team : Array[UnitOnTeam]

func _ready() -> void:
	team.append(new_unit("King"))

func get_unit_prop(forename : String) -> UnitProp:
	var path_unit_prop : String = PATH_TO_PROP.replace("[name unit]", forename)
	if FileAccess.file_exists(path_unit_prop):
		return load(path_unit_prop)
	return null

func new_unit(forename : String, property_for_unit : UnitProp = null) -> UnitOnTeam:
	var unit : UnitOnTeam = UnitOnTeam.new()
	if property_for_unit == null: 
		property_for_unit = get_unit_prop(forename)
	for prop : String in TRANSLATE_PROP_NAME:
		unit.set(prop, property_for_unit.get(prop))
	unit.hp = unit.max_hp
	unit.skills = unique_skill(property_for_unit.skills)
	return unit
	
func upgrade_unit(upgrade_to : UnitProp, upgrade_from : UnitOnTeam = null) -> UnitOnTeam:
	var new_ally : UnitOnTeam = new_unit(upgrade_to.forename)
	if upgrade_from != null:
		team.erase(upgrade_from)
	new_ally.hp = upgrade_to.max_hp
	team.append(new_ally)
	return new_ally

func unique_skill(skills : Array[Skill]) -> Array[Skill]:
	return skills.duplicate(true)
