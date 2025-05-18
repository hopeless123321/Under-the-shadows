@icon("res://Global scripts/Classes/Icons/Single class/RoomManagerIcon.svg")
extends Node2D
## Logic node that set initial node, 
class_name RoomManager


const BUTTONG_GROUP_ROOM := preload("res://UI/UI assets/Buttongroup/Button group rooms.tres")



var current_location_team : Room:
	set(value):
		if current_location_team != null:
			current_location_team.team_exit()
		current_location_team = value
		current_location_team.team_enter()

func _init() -> void:
	BUTTONG_GROUP_ROOM.connect("pressed", button_pressed)


func available_room(target_room : Room) -> bool:
	if target_room in current_location_team.connected_room:
		return true
	return false

## Choose random (number next location) room and set that room like escaped room.
func set_role_rooms(current_location : Location) -> void:
	set_initial_room()
	for room : Room in get_tree().get_nodes_in_group("Rooms"):
		if room == current_location_team:
			continue
		room.type_room = set_role(current_location.probabality_rooms)
	set_rng_unknown_room(current_location.percent_hidden_room)


func set_initial_room() -> void:
	current_location_team = get_tree().get_first_node_in_group("Rooms")
	current_location_team.team_enter()
	
	
func set_role(probabality_room : ProbabiltyRoomSpawn) -> Room.TypeRoom: 
	var sum_of_percent : int = probabality_room.general_probabilty
	var rng_number : int = randi() % sum_of_percent
	var culmalitive_chance : int = 0
	for room_type : Room.TypeRoom in probabality_room.probabality_room.keys():
		culmalitive_chance += probabality_room.probabality_room[room_type]
		if rng_number < culmalitive_chance:
			return room_type
	return Room.TypeRoom.FIGHT

## Set with some percent 
func set_rng_unknown_room(percent : int) -> void: 
	var hidden_room : Array[Node] = get_tree().get_nodes_in_group("Rooms")
	hidden_room.shuffle()
	hidden_room.assign(hidden_room as Array[Room])
	for room : Room in hidden_room.slice(0, round(hidden_room.size() * percent / 100)):
		room.status = Room.StatusRoom.HIDDEN
		
		
func button_pressed(room_pressed : Room) -> void:
	current_location_team = room_pressed
