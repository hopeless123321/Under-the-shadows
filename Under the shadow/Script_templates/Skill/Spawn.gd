extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"radius",
	"spawn",
]
@export_category("spawn mandatory")
@export var radius : int
@export var spawn : Unit_prop
# //
