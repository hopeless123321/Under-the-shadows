extends Resource
## Represent status that applied by outer factor (skill, altar, relic).
class_name StatusEffect
## Emit when skill effect and connect to unit status effect handler
signal update_signal_ui(status : StatusEffect)

enum ApplicationTime {BeginTurn, ## Apply every turn time then unit start turn
EndTurn, ## Apply every turn time then unit end turn
OtherSkill, ## When someone cast specific skill something happend with Status effect 
OnceToEndEffect, ## Just add or reduce some properties of unit and returned when duration over
EveryTurn ## Do something actually every turn. When anybody start new turn
}

@export var name : String

## Trigger to effecent skill
@export var apply_time : ApplicationTime

## Texts that reveals on tooltips
@export_multiline var tooltip_text : String

## Icons on skill effect bar 
@export var mini_icon : Texture2D

## Can't duplicate skill more than once. For example some effect with unique effect 
@export var max_stack_one : bool = false

## Actual for Skilldependecy skills. Over time they duration reduce in begin turn without any effect 
@export var dissipation_over_time : bool = false

var time_effected : int = -1:
	set(value):
		time_effected = clamp(value, -1, 99)
		if time_effected == 0: 
			on_remove()
var effected_unit : Unit
## Mandatory. Need for coonect status effect to signal depend of his apply_time and set duration.
func initialization(unit : Unit, duration_status : int = -1) -> void:
	time_effected = duration_status
	effected_unit = unit
	unit.status_effects.append(self)
	unit.apply_status_effect(self)
	match apply_time:
		ApplicationTime.BeginTurn:
			unit.connect("begin_turn_effects", effect)
		ApplicationTime.EndTurn:
			unit.connect("end_turn_effects", effect)
		ApplicationTime.EveryTurn:
			Eventbus.connect("begin_turn_all", effect)
		ApplicationTime.OtherSkill:
			unit.connect("cast_skill_to_unit", effect)
			unit.connect("cast_skill_to_unit", absorb_skill)
		ApplicationTime.OnceToEndEffect:
			unit.connect("begin_turn_effects", effect)
	apply_effect()

## Optional. Reduce some property of unit until statuseffect not over and on_remove works 
func apply_effect() -> void:
	pass

## Optional. Make something every time when he called by signal. Need skill and sender for some skill that effect to skill.
func effect(skill : Skill = null, sender : Unit = null) -> void:
	pass

## Optional. Do something before status effect is going on
func remove_effect() -> void:
	pass

## Mandatory. Called when duration is 0
func on_remove() -> void:
	remove_effect()
	effected_unit.free_from_status_effect(self)

func absorb_skill(skill : Skill, sender : Unit) -> bool:
	return false

## Mandatory. Return string for reveal on tooltip on effect status
func for_tooltip_text() -> String:
	return ""

func prop_on_label() -> String:
	return ""

