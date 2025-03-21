extends CharacterBody2D
class_name Unit
#Базовый класс всех существ
var pointer_curve : float = 0
@export var forename : String
@export var max_hp : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - max_hp, "max_hp", global_position)
		max_hp = value
@export var hp : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - hp, "hp", global_position)
		if value < hp:
			hitting()
		hp = clamp(value,0, max_hp)
@export var will : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - will, "will", global_position)
		will = clamp(value, 0, 100)
@export var dmg_amp: float:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - dmg_amp, "dmg_amp", global_position)
		dmg_amp = Utility.round_place(clamp(value, 0 , 100), 2)
@export var resist_phys_dmg : float:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - resist_phys_dmg, "resist_phys_dmg", global_position)
		if resist_phys_dmg == 0:
			resist_phys_dmg = value
		elif resist_phys_dmg < 1:
			resist_phys_dmg += value * resist_phys_dmg
		else:
			resist_phys_dmg += value / resist_phys_dmg
@export var resist_mag_dmg : float:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - resist_mag_dmg, "resist_mag_dmg", global_position)
		if resist_mag_dmg == 0:
			resist_mag_dmg = value
		elif resist_mag_dmg < 1:
			resist_mag_dmg += value * resist_mag_dmg
		else:
			resist_mag_dmg += value / resist_mag_dmg
@export var resist_will : float:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - resist_will, "resist_will", global_position)
		if resist_will == 0:
			resist_will = value
		elif resist_will < 1:
			resist_will += value * resist_will
		else:
			resist_will += value / resist_will
@export var speed : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - speed, "speed", global_position)
		speed = value
@export var move_point : int:
	set(value):
		move_point = clamp(value,0,speed)
@export var reaction : int:
	set(value):
		Eventbus.emit_signal("prop_char_change", value - speed, "speed", global_position)
		reaction = value
@export var ability : Array[Base_ability]
@export var icon_select : Texture2D
@export var move_after_skill : bool = false
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
@export var free_move : bool = true
@export var cost : int
@export var move_curve : Curve

#inner varuable
var tile_pos : Vector2i:
	get:
		return _tm.local_to_map(global_position)
var statuses : Array[Status]
var path : Array[Vector2i]
var previous_state = null
var current_state = null
#link to other node
@onready var _tm : TileMap = $"../../../TileMap"
@onready var _st : Node2D = $States


func _initiation() -> void:
	add_to_group("Units")
	for states in _st.get_children():
		states.state_machine = _st
	previous_state = _st.idle 
	current_state = _st.idle
	#make ability unique
	ability.assign(ability.map(unique_ability))
func _physics_process(_delta) -> void:
	change_state(current_state.update())
	%Label.text = str(current_state, previous_state)
func change_state(input) -> void:
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

func unique_ability(skill : Base_ability) -> Base_ability:
	return skill.duplicate() as Base_ability
	
func self_destroy() -> void:
	queue_free()

