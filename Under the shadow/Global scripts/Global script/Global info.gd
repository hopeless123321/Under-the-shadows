extends Node

const CELL_SIZE : Vector2i = Vector2i(64, 64)
#Enums
var current_location : Location

var load_scene : bool = true

# gamechanger varuables
var probabality_room : Dictionary[Room.TypeRoom, int] = {Room.TypeRoom.FIGHT : 40,
							Room.TypeRoom.ELITE_FIGHT : 20,
							Room.TypeRoom.SHOP : 10,
							Room.TypeRoom.TREASURE : 10,
							Room.TypeRoom.EVENT : 10}
							
# dungeon varuable
var dungeon_mult : float = 1.0
var cost_evolve_mult : float = 1.0
var cost_buy_in_shop : float = 1.2
var initial_multiply_hp_evolve : float = 1.0
var turns_to_way_out : int = 30
var chance_to_ambush : float = 1.0

# battle varuable
var max_team_size : int = 5
var quantity_enemy_mult : float = 1.0
var effecient_altar : float = 1.0
var enemy_hp_mult : float = 1.0
var enemy_souls_mult : float = 1.0
var ally_max_hp_mult : float = 1.0
var add_push_power : int = 0
var heal_multiplayer : float = 1.0

# skill varuable
var range_skill_mod : int = 0

# setinng varuable
var speed_scale : float = 1.0

var difficult_on_battle : int = 15 
var add_radius : int = 0

var disscount_chance : float = 0.2:
	set(value):
		disscount_chance = clamp(value, 0, 1.0)
# quality of life

var win_size : Vector2:
	get:
		return DisplayServer.window_get_size()
var stage : int = 1

var relics : Array[Relic]:
	set(value):
		relics.append(value)
		value.back().initiation()
# Local varuable for map
var size_map : Rect2i
var max_enemy_unit : int = 5: 
	set(value):
		max_enemy_unit = clamp(value, 1,10)
var select_ability_anybody : bool = false
var souls : int = 20:
	set(value):
		souls = value
		Eventbus.emit_signal("souls_changed", souls)

func _ready() -> void:
	Eventbus.connect("update_end_battle", next_stage)

func next_stage() -> void:
	stage += 1

func check_price(cost : int) -> bool:
	if cost > souls:
		return false
	else:
		return true

func add_souls(cost : int) -> void:
	souls += cost

func change_location_to(location : Location) -> void:
	current_location = location
