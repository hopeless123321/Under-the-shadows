extends Resource
class_name Relic

@export var icon : Texture2D
@export_flags("Heal", "Dmg", "Status", "Spawn", "Move", "Push", "Global Varuable") var type
const flag_names : Dictionary = {
		1 << 0: "Heal",
		1 << 1: "Dmg",
		1 << 2: "Status",
		1 << 3: "Spawn",
		1 << 4: "Move",
		1 << 5: "Push",
		1 << 6: "Global Varuable"
}
func get_type_flags() -> Array[String]:
	var enabled_flags : Array[String]
	for flag in flag_names.keys():
			if (type & flag) == flag:
				enabled_flags.append(flag_names[flag])
	return enabled_flags
