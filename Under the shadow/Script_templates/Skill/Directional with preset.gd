extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	#"scema_cast",
	
]
@export_group("Directional with preset madatory")

@export var type_unit : TypeAppUnit
@export var preset : Array[Vector2i]
@export var schema_cast : Texture2D
# //
func execute(sender : Unit, recievers : Array[Unit]) -> void:
	pass
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	return text
