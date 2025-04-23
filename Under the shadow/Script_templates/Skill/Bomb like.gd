extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"radius",
	"length_to_target"
]
@export_group("Bomb like madatory")
@export var type_unit : TypeAppUnit
@export var radius : int
@export var length_to_target : int 
# //
func execute(sender : Unit, recievers : Array[Unit]) -> void:
	pass
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	return text
