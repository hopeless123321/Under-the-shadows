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
enum Type_room {Fight, Elite_fight, Shop, Tresuare, Event, Escape}


# gamechanger varuables
var probabality_room : Dictionary = {Type_room.Fight : 40,
							Type_room.Elite_fight : 20,
							Type_room.Shop : 10,
							Type_room.Tresuare : 10,
							Type_room.Event : 10}
var difficult_on_battle : int = 15 
var dungeon_size : int = 16
var speed_scale : float = 1
var max_team_size : int = 5
var range_skill_mod : int = 0
var cost_evolve_mult : int = 100
var cost_buy_speel_mult : int = 100
var quantity_enemy_mult : int = 100
var effecient_altar : int = 100
var initial_multiply_hp_evolve : int = 100
var turns_to_way_out : int = 30
var chance_to_ambush : int = 5
var enemy_hp_mult : int = 100
var enemy_souls_mult : int = 100
var enemy_dmg_get_mult : int = 100
var enemy_dmg_send_mult : int = 100
var ally_hp_mult : int = 100
var ally_dmg_get_mult : int = 100
var ally_dmg_send_mult : int = 100
# quality of life
var location : String
var win_size : Vector2: # for Control animations
	get:
		return DisplayServer.window_get_size()
var stage : int = 1
var can_choose_init : bool = false
var relics : Array[Relic]
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
