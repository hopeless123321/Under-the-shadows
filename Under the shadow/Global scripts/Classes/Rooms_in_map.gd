extends Button
class_name Room

var id : int
var path_to : int
var connected_room : Array[Room]
var room_coords : Vector2i
var type_room : GlobalInfo.Type_room

const EVENT := preload("res://Scenes/Dungeon generator/Rooms/Icons/Event.png")
const UNKNOWN := preload("res://Scenes/Dungeon generator/Rooms/Icons/unknown.png")
const ELITE_FIGHT := preload("res://Scenes/Dungeon generator/Rooms/Icons/Elite_fight.png")
const FIGHT := preload("res://Scenes/Dungeon generator/Rooms/Icons/Fight.png")
const SHOP := preload("res://Scenes/Dungeon generator/Rooms/Icons/Shop.png")
const TREASURE := preload("res://Scenes/Dungeon generator/Rooms/Icons/Treasure.png")
const ESCAPE := preload("res://Scenes/Dungeon generator/Rooms/Icons/Escape.png")

const CONVERT_TO_ICON := {GlobalInfo.Type_room.Fight : FIGHT,
							GlobalInfo.Type_room.Elite_fight : ELITE_FIGHT,
							GlobalInfo.Type_room.Shop : SHOP,
							GlobalInfo.Type_room.Tresuare : TREASURE,
							GlobalInfo.Type_room.Event : EVENT,
							GlobalInfo.Type_room.Escape : ESCAPE}

func create() -> void:
	connect("pressed", get_to)
	expand_icon = true
	flat = true
	disabled = true
	type_room = get_role()
	icon = UNKNOWN

func get_role() -> GlobalInfo.Type_room:
	var chance : int = GlobalInfo.probabality_room.values().reduce(sum_of_chance)
	var rng_number : int = randi() % chance
	var culmalitive_chance : int = 0
	for room_type : GlobalInfo.Type_room in GlobalInfo.probabality_room.keys():
		culmalitive_chance += GlobalInfo.probabality_room[room_type]
		if rng_number < culmalitive_chance:
			return room_type
	return GlobalInfo.Type_room.Fight

func avaible_conn_room() -> void:
	for room in connected_room:
		room.disabled = false
		room.icon = CONVERT_TO_ICON[room.type_room]
	
func overview_room() -> void:
	icon = CONVERT_TO_ICON[type_room]
	avaible_conn_room()

func get_to() -> void:
	icon = CONVERT_TO_ICON[type_room]
	avaible_conn_room()
	Eventbus.emit_signal("next_room", type_room)

func sum_of_chance(next_value : int, accum : int) -> int:
	return next_value + accum
 
func set_escaped_room() -> String:
	type_room = GlobalInfo.Type_room.Escape
	icon = UNKNOWN
	return "to new location"
