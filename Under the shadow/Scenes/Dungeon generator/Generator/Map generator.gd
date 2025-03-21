extends Node2D

const CELL_SIZE := Vector2i(16, 16)
const ROOM_SPACE := Vector2i(256, 256)
const GRID_SIZE := Rect2i(Vector2i(-128, -128), Vector2i(256, 256))
const ROOMS_THEME = preload("res://UI/All theme/Button/Rooms.tres")
const FIGHT_ROOM = preload("res://Scenes/Testing scenes/Generator levels/Generate level.tscn")


@onready var tile_map_path = $Paths
@onready var stash_room = $"Stash room"


var create_room := 0
var count_rooms := 50
var real_size : Vector2i
var rooms : Dictionary
var escaped_rooms : Dictionary
var paths_to_room = AStarGrid2D.new()
var counts_escaped : int = 4


func _ready():
	Eventbus.connect("next_room", get_to_room)
	Eventbus.connect("save_all", save_map)
	paths_to_room.region = GRID_SIZE
	paths_to_room.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	paths_to_room.cell_size = CELL_SIZE
	paths_to_room.update()
	create_dungeon()

func create_dungeon() -> void:
	var init_pos := Vector2i(0, 0)
	make_room(init_pos)
	while create_room != count_rooms:
		if create_room != 0:
			init_pos = rooms.values().pick_random()
		var next_pos = get_next_coords() + init_pos
		if rooms.values().has(next_pos) == false:
			create_room += 1
			var room = make_room(next_pos)
			room.connected_room.append(rooms.find_key(init_pos))
			rooms.find_key(init_pos).connected_room.append(room)
			rng_room_offset(room)
			create_path(room.global_position,rooms.find_key(init_pos).global_position)
	pick_rng_room() 
	escaped_room()

func create_path(next_pos : Vector2i , init_pos : Vector2i) -> void:
	next_pos = tile_map_path.local_to_map(next_pos) + Vector2i.ONE
	init_pos = tile_map_path.local_to_map(init_pos) + Vector2i.ONE
	tile_map_path.set_cells_terrain_path(0, paths_to_room.get_id_path(next_pos, init_pos), 0, 0, false)

func get_next_coords() -> Vector2i:
	var rng_number := randi() % 4
	if rng_number < 1:
		return Vector2i.UP
	elif rng_number < 2: 
		return Vector2i.RIGHT
	elif rng_number < 3: 
		return Vector2i.DOWN
	return Vector2i.LEFT

func rng_room_offset(room : Room) -> void:
	room.global_position += Vector2(CELL_SIZE.x * randi_range(-3, 3), CELL_SIZE.y * randi_range(-3, 3))
	
func make_room(tile_pos : Vector2i) -> Room:
	var room = Room.new()
	room.id = create_room
	room.room_coords = tile_pos
	room.global_position = tile_pos * ROOM_SPACE
	room.custom_minimum_size = Vector2i(48, 48)
	rooms[room] = room.room_coords
	room.theme = ROOMS_THEME
	stash_room.add_child(room)
	return room
	
func pick_rng_room() -> void:
	var room : Room = rooms.keys().front()
	room.disabled = false
	room.overview_room()

func escaped_room() -> void: 
	var only_rooms = rooms.keys()
	only_rooms.shuffle()
	for room in only_rooms:
		if escaped_rooms.size() == counts_escaped:
			break
		if room.connected_room.size() == 1 and room.id > count_rooms / 2:
			escaped_rooms[room] = room.set_escaped_room()

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("Map"):
		visible = !visible

func get_to_room(room_type : Room.Type_room) -> void:
	var room_i : Object
	match room_type:
		0: #fight
			room_i = FIGHT_ROOM.instantiate()
		1: #elite fight
			pass
		2: #shop
			pass
		3: #tresure
			pass
		4: #event
			pass
		5: #escape
			pass
	add_child(room_i)
	if room_i != null:
		room_i.create()

func save_map() -> void:
	pass
