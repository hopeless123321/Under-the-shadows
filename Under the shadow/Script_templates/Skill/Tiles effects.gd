extends Skill
const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"kind_of_tile",
	"radius",
	"targets"
]

@export_group("Tiles effect mandatory")
@export var kind_of_tile : String
@export var radius : int
@export var targets : int
# //
func execute(sender : Unit, recievers : Array[Unit]) -> void:
	pass
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	return text
