extends Node

const CELL_SIZE = Vector2i(64, 64)
const DIFFICULT :={"radiant" : 15, "twilight" : 20 , "eclipse" : 30}


# quality of life
var win_size : Vector2: # for Control animations
	get:
		return DisplayServer.window_get_size_with_decorations()



# Global varuable for save run
var diffucult : String
var stage := 1
var can_choose_init := false
var party_info : Array[Dictionary]
var relics : Array #[relics class]
var current_location : String

# Local varuable for map
var size_map : Rect2i
var max_enemy_unit : int = 5: 
	set(value):
		max_enemy_unit = clamp(value, 1,10)
var select_ability_anybody := false
var souls : int:
	set(value):
		souls = value
		Eventbus.emit_signal("souls_changed", souls)


func _ready():
	Eventbus.connect("new_level", next_stage)
	
func next_stage() -> void:
	stage += 1

func set_party_info() -> void:
	pass
	
func add_souls(cost : int) -> void:
	souls += cost
