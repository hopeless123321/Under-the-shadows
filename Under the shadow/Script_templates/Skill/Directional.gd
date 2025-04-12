extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"radius",
	"pierce",
	"type_unit"
]
@export_category("Directional madatory")
@export_enum("Ally", "Enemy", "Either") var type_unit : String
@export var radius : int
@export var pierce : bool
# //
