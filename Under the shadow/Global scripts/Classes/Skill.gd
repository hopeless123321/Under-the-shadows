extends Resource
class_name Skill


@export_category("Main")
@export var id : int
@export var forename : String
@export var cost_hp : int
@export var cost_will : int
@export var cooldown : int
@export var active : bool
@export_multiline var description : String
@export var icon : Texture2D
@export var skill_prop_in_evolve_tree : Dictionary
@export_enum ("No type", "Lunar", "Blood", "Suicide") var class_spell : String = "No type"
@export_enum ("All world", "All area", "Targets world", "Targets area", "Directional", "Directional with preset", "Self", "Bomb like", "Tiles effects", "Spawn") var type_application : String
@export_flags("Heal", "Dmg", "Status", "Spawn", "Move", "Push") var type : int
var cooldown_timer : int:
	set(value):
		cooldown_timer = clamp(value, 0, 99)

const TYPE_SKILL : Dictionary = {
		1 << 0: "Heal",
		1 << 1: "Dmg",
		1 << 2: "Status",
		1 << 3: "Spawn",
		1 << 4: "Move",
		1 << 5: "Push"
		}
const TYPE_DMG_FLAGS : Dictionary = {
		1 << 0: "Pure",
		1 << 1: "Magic",
		1 << 2: "Physical",
		1 << 3: "Will"}

func get_type_array() -> Array[String]:
	var enabled_flags : Array[String] = []
	for flag in TYPE_SKILL.keys():
		print(typeof(flag))
		if (type & flag) == flag:
			enabled_flags.append(TYPE_SKILL[flag])
	return enabled_flags

func get_type_dmg() -> Array[String]:
	var enabled_flags : Array[String] = []
	for flag in TYPE_DMG_FLAGS.keys():
		if (type & flag) == flag:
			enabled_flags.append(TYPE_DMG_FLAGS[flag])
	return enabled_flags

