extends Resource
class_name Unit_prop

@export_category("In game property")
@export var forename : String
@export var max_hp : int
@export var dmg_amp: int
@export var resist_phys_dmg : int
@export var resist_mag_dmg : int
@export var resist_will : int
@export var speed : int
@export var reaction : int
@export var move_after_skill : bool = false
@export var free_move : bool = true
@export var ability : Array[Skill]

@export_category("Other info")
@export var icon_select : Texture2D
@export_flags("No class", "Skelet", "Lunar", "Dead", "Ghost") var type
@export var cost : int
@export_category("Move")
@export var animation_trans : Tween.TransitionType
@export var animation_ease : Tween.EaseType
@export var duration : int = 1
@export_category("Enemy")
@export_enum ("Close", 
			"Far", 
			"Low hp", 
			"High hp", 
			"King", 
			"Low will", 
			"High will", 
			"Random") var move_to : String
@export var distance : int


const CLASS_UNIT : Dictionary = {
		1 << 0: "No class",
		1 << 1: "Skelet",
		1 << 2: "Lunar",
		1 << 3: "Dead",
		1 << 4: "Ghost",
}

func get_class_flags() -> Array[String]:
	var enabled_flags : Array[String] = []
	for flag in CLASS_UNIT.keys():
			if (type & flag) == flag:
				enabled_flags.append(CLASS_UNIT[flag])
	return enabled_flags
