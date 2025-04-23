extends CharacterBody2D
class_name Unit
#Базовый класс всех существ

var unit_property : UnitOnTeam
#inner varuable
var tile_pos : Vector2i:
	get:
		return _tm.local_to_map(global_position)
var status_effects : Array[Status_effect]
var path : Array[Vector2i]
var previous_state : Node2D = null
var current_state : Node2D = null
var move_point : int : 
	set(value):
		move_point = clamp(value, 0, unit_property.speed)
#link to other node

@onready var _tm : TileMap = $"../../../TileMap"
@onready var _st : Node2D
@onready var hp_progress_bar : TextureProgressBar
@onready var will_progress_bar : TextureProgressBar



func initiation() -> void:
	if !unit_property:
		pass
	# NEED add status effect on begin of battle to Unit 
	_st = $States # FIX ME
	hp_progress_bar = $"Hp Progress bar"
	will_progress_bar = $"Will progress bar"
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

func begin_turn() -> void: 
	update_status_effect(true)

func end_turn() -> void:
	update_status_effect(false)
	recharge_skill()
## Decrease cooldown all skill on unit 
func recharge_skill() -> void:
	for skill in unit_property.skills:
		if skill.cooldown != 0:
			skill.cooldown_timer -= 1

func update_status_effect(begin_turn : bool) -> void:
	if begin_turn:
		pass
	else:
		pass

func self_destroy() -> void:
	queue_free() # FIX ME

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
		
