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
@export var apply_time : ApplicationTime
@export_multiline var tooltip_text : String
@export var mini_icon : Texture2D
var duration : int = -1:
	set(value):
		duration = clamp(value, -1, 9)
		if duration == 0: 
			on_remove()
var effected_unit : Unit
## Mandatory. Need for coonect status effect to signal depend of his apply_time and set duration.
func initialization(unit : Unit, duration_status : int = -1) -> void:
	duration = duration_status
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
			pass
		ApplicationTime.OnceToEndEffect:
			unit.connect("begin_turn_effects", effect)
	apply_effect()
## Optional. Reduce some property of unit until statuseffect not over and on_remove works 
func apply_effect() -> void:
	pass
## Optional. Make something every time when he called by signal
func effect() -> void:
	pass
## Optional. Do something before status effect is going on
func remove_effect() -> void:
	pass
## Mandatory. Called when duration is 0
func on_remove() -> void:
	remove_effect()
	effected_unit.free_from_status_effect(self)
## Mandatory. Return string for reveal on tooltip on effect status
func for_tooltip_text() -> String:
	return ""
func return_prop_on_label() -> String:
	return ""
