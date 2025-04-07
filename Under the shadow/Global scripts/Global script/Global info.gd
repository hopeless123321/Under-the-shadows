extends Node

const CELL_SIZE : Vector2i = Vector2i(64, 64)
const DIFFICULT : Dictionary = {"radiant" : 15, "twilight" : 20 , "eclipse" : 30}
# gamechanger varuables
var dungeon_size : int = 16
var speed_scale : float = 1
var max_team_size : int = 5
var range_skill_mod : int = 0
var enemy_souls_mult : int = 100
var cost_evolve_mult : int = 100
var cost_buy_speel_mult : int = 100
var enemy_hp_mult : int = 100
var ally_hp_mult : int = 100
var quantity_enemy_mult : int = 100
var enemy_dmg_get_mult : int = 100
var enemy_dmg_send_mult : int = 100
var ally_dmg_get_mult : int = 100
var ally_dmg_send_mult : int = 100
var effecient_altar : int = 100

# quality of life
var win_size : Vector2: # for Control animations
	get:
		return DisplayServer.window_get_size()
# Global varuable for save run
var diffucult : String
var stage : int = 1
var can_choose_init : bool = false
var relics : Array #[relics class]
var current_location : String
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

func set_party_info() -> void:
	pass
	
func add_souls(cost : int) -> void:
	souls += cost
