extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"area",
	"self_target"
]

@export_group("All in area mandatory")
@export var type_unit : TypeAppUnit
@export var area : int 
@export var self_target : bool
# //
func execute(sender : Unit, recievers : Array[Unit]) -> void:
	pass
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	return text
