extends Skill

const PROP_TO_REVEAL : Array[String] = [
	"cost_hp",
	"cost_will",
	"active",
	"class_spell",
	"type_application",
	"radius",
	"length_to_target"
]
@export_group("Bomb like madatory")
@export var type_unit : TypeAppUnit
@export var radius : int
@export var length_to_target : int 
# //
@export var status_effect_apply : StatusEffect
@export var duration : int 
@export var will_per_turn : int
@export var reduce_will_resist : int
@export var reduce_will_non_target : int 

func execute(sender : Unit, recievers : Array[Unit]) -> void:
	var status_effect_dupl : StatusEffect = status_effect_apply.duplicate()
	status_effect_dupl.will_per_turn = will_per_turn
	status_effect_dupl.reduce_will_resist = reduce_will_resist
	status_effect_dupl.initialization(recievers.front(), duration)
	for unit : Unit in recievers.slice(1):
		unit.unit_property.will += will_dmg_resist(reduce_will_non_target, calc_resist(unit, TypeDmgSkill.Will))
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String
	text += recievers.front().unit_property.forename + " Status apply: [img]" + status_effect_apply.mini_icon.resource_path + "[/img] for " + str(duration) + " turn(s)\n"
	for unit : Unit in recievers.slice(1):
		text += unit.unit_property.forename + " Will change" + str(unit.unit_property.will) + "-> [" + str(unit.unit_property.will - will_dmg_resist(reduce_will_non_target, calc_resist(unit, TypeDmgSkill.Will)))+ "]\n"
	return text
