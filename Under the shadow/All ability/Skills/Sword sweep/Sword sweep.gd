extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"type_application",
	#"scema_cast",
	"type_unit"
]

@export_category("Directional with preset madatory")
@export_enum("Ally", "Enemy", "Either") var type_unit : String
@export var preset : Array[Vector2i]
# //

