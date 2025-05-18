@icon("res://Global scripts/Classes/Icons/Room .svg")
extends Button
## Class represent 
class_name Room

signal move_to_dungeon(room : PackedScene, time_left : float)

enum StatusRoom {
	HIDDEN, ## Player don't know what type of room until get to the room
	OPEN, ## Player know about type of room only when he arrive near room
}
enum TypeRoom {
	FIGHT, 
	ELITE_FIGHT, 
	SHOP, 
	TREASURE, 
	EVENT, 
	ESCAPE, 
	CLEARED,
	}
## Number Sequence number of room creation

const ROOM_SPACE := Vector2i(256, 256)
const ROOMS_THEME = preload("res://UI/Themes/Button/Rooms.tres")
const ROOMS_BUTTON_GROUP = preload("res://UI/UI assets/Buttongroup/Button group rooms.tres")

const UNKNOWN := preload("res://Scenes/Dungeon generator/Rooms/Icons/unknown.png")
const HIDDEN := preload("res://Scenes/Dungeon generator/Rooms/Icons/Hidden.png")
## Сorrelates data{image and scene} with types room 
const DATA_TO_TYPE_ROOM := { 
	TypeRoom.FIGHT : {"image" : preload("res://Scenes/Dungeon generator/Rooms/Icons/Fight.png") , "scene" : null, "cost" : 1.0},
	TypeRoom.ELITE_FIGHT : {"image" : preload("res://Scenes/Dungeon generator/Rooms/Icons/Elite fight.png"), "scene" : null, "cost" : 1.0},
	TypeRoom.SHOP : {"image" : preload("res://Scenes/Dungeon generator/Rooms/Icons/Shop.png"), "scene" : "res://Scenes/Dungeon generator/Rooms/Rooms/Shop/Shop.tscn", "cost" : 1.0},
	TypeRoom.TREASURE : {"image" : preload("res://Scenes/Dungeon generator/Rooms/Icons/Treasure.png"), "scene" : null, "cost" : 1.0},
	TypeRoom.EVENT : {"image" : preload("res://Scenes/Dungeon generator/Rooms/Icons/Event.png"), "scene" : null, "cost" : 1.0},
	TypeRoom.ESCAPE : {"image" : preload("res://Scenes/Dungeon generator/Rooms/Icons/Escape.png"), "scene" : null, "cost" : 1.0},
	TypeRoom.CLEARED : {"image" :  preload("res://Scenes/Dungeon generator/Rooms/Icons/Completed.png"), "scene" : null, "cost" : 0.5}
	}

var status : StatusRoom
var id : int
var connected_room : Array[Room]
## Coords room relative other room. When room initialize first of all room given tile position and furher real position on map
var room_coords : Vector2i:
	set(value):
		room_coords = value
		global_position = value * ROOM_SPACE
var type_room : TypeRoom
## Change this part 
var map : String
 

func _init(id_v : int, tile_pos : Vector2i) -> void:
	expand_icon = true
	disabled = true
	custom_minimum_size = Vector2i(48, 48)
	toggle_mode = true
	theme = ROOMS_THEME
	icon = UNKNOWN
	add_to_group("Rooms")
	button_group = ROOMS_BUTTON_GROUP
	id = id_v
	room_coords = tile_pos
	status = StatusRoom.OPEN
	

func reveal() -> void:
	if status == StatusRoom.HIDDEN and type_room != TypeRoom.CLEARED:
		icon = HIDDEN
		return
	
	icon = DATA_TO_TYPE_ROOM[type_room]["image"]

 
func team_exit() -> void:
	type_room = TypeRoom.CLEARED
	
	for room : Room in connected_room:
		room.disabled = true
		
	
func team_enter() -> void:
	for room : Room in connected_room:
		room.disabled = false
		room.reveal()
		
	self.disabled = true
	if DATA_TO_TYPE_ROOM[type_room]["scene"] != null:
		var room_trans = load(DATA_TO_TYPE_ROOM[type_room]["scene"])
		emit_signal("move_to_dungeon", room_trans, DATA_TO_TYPE_ROOM[type_room]["cost"])
		
