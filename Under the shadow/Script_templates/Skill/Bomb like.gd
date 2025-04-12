extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"radius",
	"length_to_target",
	"type_unit"
]
@export_category("Bomb like madatory")
@export_enum("Ally", "Enemy", "Either") var type_unit : String
@export var radius : int
@export var length_to_target : int 
# //
