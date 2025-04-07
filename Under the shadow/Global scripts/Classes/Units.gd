extends CharacterBody2D
class_name Unit
#Базовый класс всех существ

var forename : String
var max_hp : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - max_hp, "max_hp", global_position)
		max_hp = value
var hp : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - hp, "hp", global_position)
		if value < hp:
			hitting()
		hp = clamp(value,0, max_hp)
var will : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - will, "will", global_position)
		will = clamp(value, 0, 100)
var dmg_amp: float:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - dmg_amp, "dmg_amp", global_position)
		dmg_amp = Utility.round_place(clamp(value, 0 , 100), 2)
var resist_phys_dmg : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - resist_phys_dmg, "resist_phys_dmg", global_position)
var resist_mag_dmg : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - resist_mag_dmg, "resist_mag_dmg", global_position)
var resist_will : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - resist_will, "resist_will", global_position)
var speed : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - speed, "speed", global_position)
		speed = value
var move_point : int:
	set(value):
		move_point = clamp(value,0,speed)
var reaction : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - speed, "speed", global_position)
		reaction = value
var move_after_skill : bool = false
var free_move : bool = true
var ability : Array[Skill]
var icon_select : Texture2D
@export_flags("No class", "Skelet", "Lunar", "Dead", "Ghost") var type :
	get:
		var flag_names = {
		1 << 0: "No class",
		1 << 1: "Skelet",
		1 << 2: "Lunar",
		1 << 3: "Dead",
		1 << 4: "Ghost"
		}
		var enabled_flags: Array = []
		for flag in flag_names.keys():
			if (type & flag) == flag:
				enabled_flags.append(flag_names[flag])
		return enabled_flags
var cost : int
var animation_trans : Tween.TransitionType
var animation_ease : Tween.EaseType
var duration : int
var move_to : String
var distance : int

#inner varuable
var pointer_curve : float = 0
var tile_pos : Vector2i:
	get:
		return _tm.local_to_map(global_position)
var statuses : Array[Status]
var path : Array[Vector2i]
var previous_state = null
var current_state = null
#link to other node

@onready var _tm : TileMap = $"../../../TileMap"
@onready var _st : Node2D


func initiation() -> void:
	_st = $States
	add_to_group("Units")
	for states in _st.get_children():
		states.state_machine = _st
	previous_state = _st.idle
	current_state = _st.idle
	#make ability unique
	ability.assign(ability.map(unique_ability))

func _physics_process(_delta : float) -> void:
	if current_state != null:
		change_state(current_state.update())
		#%Label.text = str(current_state, previous_state)
		
func change_state(input : Node2D) -> void:
	if input != null:
		previous_state = current_state
		current_state = input
		previous_state.end()
		current_state.start()

func pushing() -> void:
	pass
func hitting() -> void:
	pass
func end_turn() -> void:
	recharge_skill()
	for status in statuses:
		# cюда particle
		match status.type:
			0: #Constant
				status.execute(self)
				if status.duration == 0:
					status.ending(self)
					statuses.erase(status)
				status.duration -= 1
			1: #Once
				if status.duration == 0:
					status.ending(self)
					statuses.erase(status)
				status.duration -= 1
			2: #Changing
				status.execute(self)
				if status._value == 0 or status.duration == 0:
					status.ending(self)
					statuses.erase(status)
				if status.duration != 0:
					status.duration -= 1

func recharge_skill() -> void:
	for skill in ability:
		if skill.cooldown != 0:
			skill.cooldown_timer -= 1

func unique_ability(skill : Skill) -> Skill:
	return skill.duplicate() as Skill

func self_destroy() -> void:
	queue_free()

