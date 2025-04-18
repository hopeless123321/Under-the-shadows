extends Button
class_name Room
signal move_dungeon(time : float)

enum TypeRoom {Fight, EliteFight, Shop, Tresuare, Event, Escape}

var id : int
var connected_room : Array[Room]
var room_coords : Vector2i
var type_room :  TypeRoom
var map : String
var team_arrive : bool = false
 

const EVENT := preload("res://Scenes/Dungeon generator/Rooms/Icons/Event.png")
const UNKNOWN := preload("res://Scenes/Dungeon generator/Rooms/Icons/unknown.png")
const ELITE_FIGHT := preload("res://Scenes/Dungeon generator/Rooms/Icons/Elite_fight.png")
const FIGHT := preload("res://Scenes/Dungeon generator/Rooms/Icons/Fight.png")
const SHOP := preload("res://Scenes/Dungeon generator/Rooms/Icons/Shop.png")
const TREASURE := preload("res://Scenes/Dungeon generator/Rooms/Icons/Treasure.png")
const ESCAPE := preload("res://Scenes/Dungeon generator/Rooms/Icons/Escape.png")
const COMPLETED = preload("res://Scenes/Dungeon generator/Rooms/Icons/Completed.png")

const CONVERT_TO_ICON := { TypeRoom.Fight : FIGHT,
							 TypeRoom.EliteFight : ELITE_FIGHT,
							 TypeRoom.Shop : SHOP,
							 TypeRoom.Tresuare : TREASURE,
							 TypeRoom.Event : EVENT,
							 TypeRoom.Escape : ESCAPE}

func create() -> void:
	connect("pressed", get_to)
	type_room = get_role()
	icon = UNKNOWN

func get_role() ->  TypeRoom:
	var chance : int = GlobalInfo.probabality_room.values().reduce(sum_of_chance)
	var rng_number : int = randi() % chance
	var culmalitive_chance : int = 0
	for room_type :  TypeRoom in GlobalInfo.probabality_room.keys():
		culmalitive_chance += GlobalInfo.probabality_room[room_type]
		if rng_number < culmalitive_chance:
			return room_type
	return TypeRoom.Fight

func avaible_conn_room() -> void:
	for room in connected_room:
		if !room.team_arrive:
			room.disabled = false
			room.reveal_self()
	
func reveal_self() -> void:
	icon = CONVERT_TO_ICON[type_room]
	
func overview_room() -> void:
	reveal_self()
	avaible_conn_room()

func get_to() -> void:
	
	if in_near_room_team():
		get_parent().current_location_team = self
		if !team_arrive:
			emit_signal("move_dungeon", 1)
			icon = CONVERT_TO_ICON[type_room]
			avaible_conn_room()
			Eventbus.emit_signal("next_room", self)
			
		else:
			emit_signal("move_dungeon", 0.25)

func sum_of_chance(next_value : int, accum : int) -> int:
	return next_value + accum
 
func set_escaped_room() -> String:
	type_room = TypeRoom.Escape
	icon = UNKNOWN
	return "to new location"
	
func in_near_room_team() -> bool:
	if get_parent().current_location_team in connected_room:
		return true
	return false
	
func team_exit() -> void:
	team_arrive = true
	icon = COMPLETED

func team_enter() -> void:
	pass
