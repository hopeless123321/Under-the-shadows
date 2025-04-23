extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"self_target"
]

@export_group("All in world madatory")
@export var type_unit : TypeAppUnit
@export var self_target : bool
# //
func execute(sender : Unit, recievers : Array[Unit]) -> void:
	pass
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	return text
