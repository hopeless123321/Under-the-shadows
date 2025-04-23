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
@export var dmg : float
@export var type_dmg : TypeDmgSkill
func execute(sender : Unit, recievers : Array[Unit]) -> void: 
	for unit : Unit in recievers:
		unit.unit_property.hp -= dmg_with_resist(dmg, 
		calc_resist(unit, TypeDmgSkill.Magic), 
		sender.unit_property.damage)

func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	for unit : Unit in recievers:
		var damage_deal : Vector2i = reveal_dmg_with_resist(dmg,
															calc_resist(unit, type_dmg), 
															sender.unit_property.damage)
		text += "[b]" + unit.unit_property.forename + "[/b]\n"
		text += "Damage deal:" + str(damage_deal.x) + "-" + str(damage_deal.y) + "\n"
		text += "Change hp: " + str(unit.unit_property.hp) + "->"
		text += "[" + str(unit.unit_property.hp - damage_deal.x) + "-" + str(unit.unit_property.hp - damage_deal.y) + "]\n"
	return text
