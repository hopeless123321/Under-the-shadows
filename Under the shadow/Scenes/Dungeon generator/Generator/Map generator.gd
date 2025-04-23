extends Node2D

const CELL_SIZE := Vector2i(16, 16)
const ROOM_SPACE := Vector2i(256, 256)
const GRID_SIZE := Rect2i(Vector2i(-128, -128), Vector2i(256, 256))
const ROOMS_THEME = preload("res://UI/All theme/Button/Rooms.tres")
const FIGHT_ROOM = preload("res://Scenes/Testing scenes/Generator levels/Generate level.tscn")
const VECTORS_TO_LOOP : Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2.RIGHT]
const PATH_TO_MAPS : String = "res://Maps/"

@onready var tile_map_path : TileMap = $Paths
@onready var room_manager : Node2D = $"Room manager"
@onready var camera : Camera2D = $Camera2D
@onready var tree_creature : Control = $"CanvasLayer/Tree creature"
@onready var upper_ui_container : HBoxContainer = $"CanvasLayer/UI on map/Upper UI/MarginContainer/Upper UI container"


var left_time : float = GlobalInfo.turns_to_way_out
var create_room : int = 0
var count_rooms : int = 50
var real_size : Vector2i
var rooms : Dictionary
var escaped_rooms : Dictionary
var paths_to_room : AStarGrid2D = AStarGrid2D.new()
var counts_escaped : int = 4
var on_fight : bool = false:
	set(value):
		on_fight = value
		upper_ui_container.switch_button(value, left_time)

func _ready() -> void:
	Eventbus.connect("next_room", get_to_room)
	Eventbus.connect("save_all", save_map)
	Eventbus.connect("reveal_map", reveal_hide_map)
	Eventbus.connect("update_end_battle", battle_over)
	paths_to_room.region = GRID_SIZE
	paths_to_room.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	paths_to_room.cell_size = CELL_SIZE
	paths_to_room.update()
	create_dungeon()

func create_dungeon() -> void: # создает данж
	var init_pos : Vector2i = Vector2i(0, 0)
	make_room(init_pos)
	while create_room != count_rooms:
		if create_room != 0:
			init_pos = rooms.values().pick_random()
		var next_pos : Vector2i = get_next_coords() + init_pos
		if rooms.values().has(next_pos) == false:
			create_room += 1
			var room : Room = make_room(next_pos)
			room.connected_room.append(rooms.find_key(init_pos))
			rooms.find_key(init_pos).connected_room.append(room)
			rng_room_offset(room)
			create_path(room.global_position,rooms.find_key(init_pos).global_position)
	escaped_room()
	make_rng_loop()
	for room : Room in rooms.keys():
		room.create()
	set_initial_room(rooms.keys().pick_random())

func make_rng_loop() -> void: # создает лупы в данже
	for room : Room in rooms.keys():
		if room.connected_room.size() >= 3 and randi() % 5 < 2:
			for vector : Vector2i in VECTORS_TO_LOOP:
				var room_to_coon : Room = rooms.find_key(room.room_coords + vector)
				if room_to_coon != null and room.connected_room.has(room_to_coon) == false:
					room.connected_room.append(room_to_coon)
					room_to_coon.connected_room.append(room)
					create_path(room_to_coon.global_position, room.global_position)

func create_path(next_pos : Vector2i , init_pos : Vector2i) -> void: # создает пути между
	next_pos = tile_map_path.local_to_map(next_pos) + Vector2i.ONE
	init_pos = tile_map_path.local_to_map(init_pos) + Vector2i.ONE
	tile_map_path.set_cells_terrain_path(0, paths_to_room.get_id_path(next_pos, init_pos), 0, 0, false)

func get_next_coords() -> Vector2i:
	var rng_number : int = randi() % 4
	if rng_number < 1:
		return Vector2i.UP
	elif rng_number < 2: 
		return Vector2i.RIGHT
	elif rng_number < 3: 
		return Vector2i.DOWN
	return Vector2i.LEFT

func rng_room_offset(room : Room) -> void: # Случайно перемещает комнаты для не создания строгой сетки
	room.global_position += Vector2(CELL_SIZE.x * randi_range(-3, 3), CELL_SIZE.y * randi_range(-3, 3))
	
func make_room(tile_pos : Vector2i) -> Room:
	var room : Room = Room.new()
	room.expand_icon = true
	room.flat = true
	room.disabled = true
	room.connect("move_dungeon", time_left)
	room.id = create_room
	room.room_coords = tile_pos
	room.global_position = tile_pos * ROOM_SPACE
	room.custom_minimum_size = Vector2i(48, 48)
	rooms[room] = room.room_coords
	room.theme = ROOMS_THEME
	room_manager.add_child(room)
	room.map = get_random_map()
	return room
	
func escaped_room() -> void:  #set escpaed rooms
	var only_rooms := rooms.keys()
	only_rooms.shuffle()
	for room : Room in only_rooms:
		if escaped_rooms.size() == counts_escaped:
			break
		if room.connected_room.size() == 1 and room.id > count_rooms / 2:
			escaped_rooms[room] = room.set_escaped_room()

func set_initial_room(room : Room) -> void:
	room.disabled = false
	room.overview_room()
	camera.position = room.global_position
	room_manager.current_location_team = room

func get_to_room(room : Room) -> void:
	var room_i : Object
	match room.type_room:
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
	if room_i != null and !on_fight:
		get_parent().add_child(room_i)
		reveal_hide_map()
		room_i.map = room.map
		room_i.create()
		room_i.cost_dif = calculate_general_diff()
		on_fight = true

func calculate_general_diff() -> int:
	return GlobalInfo.stage * 3\
	+ GlobalInfo.stage * GlobalInfo.difficult_on_battle\
	* randf_range(0.9, 1.1)

func reveal_hide_map() -> void:
	visible = !visible
	camera.enabled = !camera.enabled

func save_map() -> void:
	pass

func battle_over() -> void:
	on_fight = false

func _switch_button() -> void:
	if on_fight:
		Eventbus.emit_signal("reveal_map")
	else:
		tree_creature.reveal_hide_tree()

func get_random_map() -> String:
	var filenames : Array[String] = []
	var dir : DirAccess = DirAccess.open(PATH_TO_MAPS)
	dir.list_dir_begin()
	var file_name : String = dir.get_next()
	while file_name != "":
		if file_name.contains(".png") and file_name.contains(".import") == false:
			filenames.append(file_name)
		file_name = dir.get_next()
	return filenames.pick_random()

func time_left(time : float) -> void:
	left_time -= time
	upper_ui_container.update_left_time(left_time)
	
