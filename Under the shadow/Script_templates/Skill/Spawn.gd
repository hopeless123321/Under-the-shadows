extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"radius",
	"spawn",
]
@export_group("spawn mandatory")
@export var radius : int
@export var spawn : UnitProp
# //
func execute(sender : Unit, recievers : Array[Unit]) -> void:
	pass
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	return text
