extends Button
class_name Room

var id
var path_to : int
var connected_room : Array[Room]
var room_coords : Vector2i
enum Type_room {Fight, Elite_fight, Shop, Tresuare, Event, Escape}
var type_room : Type_room

const EVENT = preload("res://Scenes/Dungeon generator/Rooms/Icons/Event.png")
const UNKNOWN = preload("res://Scenes/Dungeon generator/Rooms/Icons/unknown.png")
const ELITE_FIGHT = preload("res://Scenes/Dungeon generator/Rooms/Icons/Elite_fight.png")
const FIGHT = preload("res://Scenes/Dungeon generator/Rooms/Icons/Fight.png")
const SHOP = preload("res://Scenes/Dungeon generator/Rooms/Icons/Shop.png")
const TREASURE = preload("res://Scenes/Dungeon generator/Rooms/Icons/Treasure.png")
const ESCAPE = preload("res://Scenes/Dungeon generator/Rooms/Icons/Escape.png")

const PROBABILITY_ROOM = {Type_room.Fight : 40,
							Type_room.Elite_fight : 20,
							Type_room.Shop : 10,
							Type_room.Tresuare : 10,
							Type_room.Event : 10}
const CONVERT_TO_ICON = {Type_room.Fight : FIGHT,
							Type_room.Elite_fight : ELITE_FIGHT,
							Type_room.Shop : SHOP,
							Type_room.Tresuare : TREASURE,
							Type_room.Event : EVENT,
							Type_room.Escape : ESCAPE}

func _ready():
	connect("pressed", get_to)
	expand_icon = true
	flat = true
	disabled = true
	type_room = get_role()
	icon = UNKNOWN

func get_role() -> Type_room:
	var chance = PROBABILITY_ROOM.values().reduce(sum_of_chance)
	var rng_number = randi() % chance
	var culmalitive_chance := 0
	for room_type in  PROBABILITY_ROOM.keys():
		culmalitive_chance += PROBABILITY_ROOM[room_type]
		if rng_number < culmalitive_chance:
			return room_type
	return Type_room.Fight

func avaible_conn_room() -> void:
	for room in connected_room:
		room.disabled = false
		room.icon = CONVERT_TO_ICON[room.type_room]
	
func overview_room():
	icon = CONVERT_TO_ICON[type_room]
	avaible_conn_room()

func get_to() -> void:
	icon = CONVERT_TO_ICON[type_room]
	avaible_conn_room()
	Eventbus.emit_signal("next_room", type_room)

func sum_of_chance(next_value : int, accum : int) -> int:
	return next_value + accum
 
func set_escaped_room() -> String:
	type_room = Type_room.Escape
	icon = UNKNOWN
	return "to new location"
