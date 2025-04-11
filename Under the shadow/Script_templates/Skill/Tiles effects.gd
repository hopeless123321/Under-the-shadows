extends Skill
const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"type_application",
	"kind",
	"radius",
	"targets"
]

@export_category("Tiles effect mandatory")
@export var kind_of_tile : String
@export var radius : int
@export var targets : int
# //
