extends Node

const CELL_SIZE : Vector2i = Vector2i(64, 64)
const DIFFICULT : Dictionary = {"radiant" : 15, "twilight" : 20 , "eclipse" : 30}
const CONVERT_LOCATION_TO_STRING : Dictionary = {
	Location.Forest : "Forest",
	Location.Near_throne : "Near throne",
	Location.Lab : "Lab",
	Location.Outside_demension : "Outside demension"}
#Enums
enum Location {Forest, Near_throne, Lab, Torture, Outside_demension}


# gamechanger varuables
var probabality_room : Dictionary = {Room.TypeRoom.Fight : 40,
							Room.TypeRoom.EliteFight : 20,
							Room.TypeRoom.Shop : 10,
							Room.TypeRoom.Tresuare : 10,
							Room.TypeRoom.Event : 10}
var difficult_on_battle : int = 15 
var dungeon_size : int = 16
var speed_scale : float = 1
var max_team_size : int = 5
var range_skill_mod : int = 0
var cost_evolve_mult : int = 0
var cost_buy_speel_mult : int = 0
var quantity_enemy_mult : int = 0
var effecient_altar : int = 0
var initial_multiply_hp_evolve : int = 0
var enemy_hp_mult : int = 0
var enemy_souls_mult : int = 0
var enemy_dmg_get_mult : int = 0
var enemy_dmg_send_mult : int = 0
var ally_hp_mult : int = 0
var ally_dmg_get_mult : int = 0
var ally_dmg_send_mult : int = 0
var add_radius : int = 0
var turns_to_way_out : int = 30
var chance_to_ambush : int = 5
var add_push_power : int = 0
var heal_multiplayer : int = 0

# quality of life
var location : String
var win_size : Vector2: # for Control animations
	get:
		return DisplayServer.window_get_size()
var stage : int = 1
var can_choose_init : bool = false
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
var souls : int = 200:
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
