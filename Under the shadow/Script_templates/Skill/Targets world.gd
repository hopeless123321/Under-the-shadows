extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"type_application",
	"targets",
	"self_target",
	"type_unit"
]

@export_category("Targets world mandatory")
@export_enum("Ally", "Enemy", "Either") var type_unit : String
@export var targets : int 
@export var self_target : bool
# //
