extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"self_target",
	"type_unit"
]

@export_category("All in world madatory")
@export_enum("Ally", "Enemy", "Either") var type_unit : String
@export var self_target : bool
# //

