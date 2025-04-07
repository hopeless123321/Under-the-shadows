extends Resource
class_name Skill


@export_category("Mandatory information")
@export var id : int
@export var name : String
@export var cost_hp : int = 0
@export var cost_will : int = 0
@export var cooldown : int = 0
@export var active : bool
@export var self_target : bool = false
@export_multiline var description : String
@export var icon : Texture2D
@export var skill_script : Script
@export var skill_prop : Dictionary
@export_enum ("Enemy", "Ally", "Either") var type_unit : String
@export_enum ("No type", "Lunar", "Blood", "Suicide") var class_spell : String = "No type"
@export_enum ("All world", "All area", "Target world", "Targets area", "Target area", "Directional", "Self", "Bomb like", "Tiles effects") var type_application : String
@export_flags("Pure", "Magic", "Physical", "Will") var type_dmg : int
@export_flags("Heal", "Dmg", "Status", "Spawn", "Move", "Push") var type : int
@export_category("Optianal properties")
@export var radius : int = 0
@export var length_to_target : int = 0
@export var spawn_name : Unit_prop
@export var add_if_condition : Script
@export_category("Directional")
@export var pierce : bool = false
@export var with_vectors : bool = false
@export var vectors : Array[Vector2i] = []
@export_category("Targets")
@export var count_targets : int = 0
@export var multiple : bool = false
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
		1 << 3: "Will"
}

func get_type_array() -> Array[String]:
	var enabled_flags : Array[String] = []
	for flag in TYPE_SKILL.keys():
			if (type & flag) == flag:
				enabled_flags.append(TYPE_SKILL[flag])
	return enabled_flags

func get_type_dmg() -> Array[String]:
	var enabled_flags : Array[String] = []
	for flag in TYPE_DMG_FLAGS.keys():
			if (type & flag) == flag:
				enabled_flags.append(TYPE_DMG_FLAGS[flag])
	return enabled_flags
