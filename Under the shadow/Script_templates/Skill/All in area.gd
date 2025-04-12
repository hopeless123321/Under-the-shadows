extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"area",
	"self_target",
	"type_unit"
]

@export_category("All in area mandatory")
@export_enum("Ally", "Enemy", "Either") var type_unit : String
@export var area : int 
@export var self_target : bool
# //
