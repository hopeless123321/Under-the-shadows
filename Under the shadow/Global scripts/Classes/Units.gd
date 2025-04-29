extends CharacterBody2D


## Base class that represent every unit on battle 
class_name Unit

## Signal emit when unit begin his turn for status effects
signal begin_turn_effects

## Signal emit when unit begin his turn for status effects
signal end_turn_effects 

## Signal emit when someone cast skill to this unit. Need for some statuseffect that depend to skill
signal cast_skill_to_unit(skill : Skill, sender : Unit)

var unit_property : UnitOnTeam
#inner varuable
var tile_pos : Vector2i:
	get:
		return _tm.local_to_map(global_position)
var status_effects : Array[StatusEffect]
var path : Array[Vector2i]
var previous_state : Node2D = null
var current_state : Node2D = null
var move_point : int : 
	set(value):
		move_point = clamp(value, 0, unit_property.speed)

@onready var _tm : TileMap = $"../../../TileMap"

var _st : Node2D
var hp_progress_bar : TextureProgressBar
var will_progress_bar : TextureProgressBar
var status_effect_handler : HBoxContainer


func initiation() -> void:
	if !unit_property:
		pass
	# NEED add status effect on begin of battle to Unit 
	_st = $States # FIX ME
	hp_progress_bar = $"Hp Progress bar"
	will_progress_bar = $"Will progress bar"
	status_effect_handler =  $"Status effect handler"
	unit_property.connect("update_hp_will",update_progress_bars)
	add_to_group("Units")
	for states in _st.get_children():
		states.state_machine = _st
	previous_state = _st.idle
	current_state = _st.idle

func _physics_process(_delta : float) -> void:
	if current_state != null:
		change_state(current_state.update())

## Change Unit status dependency of input
func change_state(input : Node2D) -> void:
	if input != null:
		previous_state = current_state
		current_state = input
		previous_state.end()
		current_state.start()

## Like signal just emit begin turn 
func begin_turn() -> void:
	emit_signal('begin_turn_effects')
	
## Like signal just emit end turn
func end_turn() -> void:
	emit_signal('end_turn_effects')
	recharge_skill()

## Decrease cooldown all skill on unit 
func recharge_skill() -> void:
	for skill in unit_property.skills:
		if skill.cooldown != 0:
			skill.cooldown_timer -= 1

## Safety kill self
func self_destroy() -> void:
	queue_free() # FIX ME

## Smothly change value on progress bar when bars visible
func update_progress_bars(hp_prop : bool, value : int) -> void:
	if !hp_progress_bar.visible:
		return
	var tween_change : Tween = create_tween()
	tween_change.set_ease(Tween.EASE_IN_OUT)
	tween_change.set_trans(Tween.TRANS_SINE)
	tween_change.set_parallel()
	if hp_prop: 
		tween_change.tween_property(hp_progress_bar, "value", value, 0.5)
	else: 
		tween_change.tween_property(will_progress_bar, "value", value, 0.5)

## On Alt make bars visible
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Add info"):
		hp_progress_bar.visible = true
		will_progress_bar.visible = true
		hp_progress_bar.max_value = unit_property.max_hp
		hp_progress_bar.value = unit_property.hp
		will_progress_bar.value = unit_property.will
	elif Input.is_action_just_released("Add info"):
		hp_progress_bar.visible = false
		will_progress_bar.visible = false

##Apply status effect to unit and conncet signal to StatusEffect bar
func apply_status_effect(status : StatusEffect) -> void:
	status_effects.append(status)
	status_effect_handler.add_status(status)
	status.connect("update_signal_ui",  update_status_effect)

## Update info about skill status on unit 
func update_status_effect(status : StatusEffect) -> void:
	status_effect_handler.update_status_ui(status_effects.find(status), status)

## Delete status from status effect and status bar
func free_from_status_effect(status : StatusEffect) -> void:
	status_effects.erase(status)
	status_effect_handler.delete_excess(status_effects.find(status)) 

func absorb_skill(skill : Skill, sender : Unit) -> bool:
	emit_signal("cast_skill_to_unit", skill, sender)
	for status_effect : StatusEffect in status_effects:
		if status_effect.absorb_skill(skill, sender):
			return true
	return false

