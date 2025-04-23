extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"targets",
	"self_target"
]

@export_group("Targets world mandatory")
@export var type_unit : TypeAppUnit
@export var targets : int 
@export var self_target : bool
# //
@export var dmg : int
func execute(sender : Unit, recievers : Array[Unit]) -> void: 
	for unit : Unit in recievers:
		unit.unit_property.hp -= dmg_with_resist(dmg, 
		calc_resist(unit, TypeDmgSkill.Magic), 
		sender.unit_property.damage)

func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	for unit : Unit in recievers:
		text += unit.unit_property.forename
	return text
