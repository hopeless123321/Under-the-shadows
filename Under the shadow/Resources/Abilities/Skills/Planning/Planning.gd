extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
]

@export var buff_value : int

func execute(sender : Unit, recievers : Array[Unit]) -> void:
	pass
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	return text
