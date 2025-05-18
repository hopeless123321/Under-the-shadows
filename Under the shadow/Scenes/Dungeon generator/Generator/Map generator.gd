extends Node2D
class_name MapGenerator

const CELL_SIZE := Vector2i(16, 16)
const GRID_SIZE := Rect2i(Vector2i(-128, -128), Vector2i(256, 256))
const NEIGHBORING_VECTORS : Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2.DOWN]


## Contains rooms that stored all rooms that have 3 or less connection to ither room
var open_list_room : Array[Room]
var create_loops : int = 4
var paths_to_room : AStarGrid2D = AStarGrid2D.new()
var left_time : float = GlobalInfo.turns_to_way_out
var count_rooms : int = 50
var rooms : Dictionary[Room, Vector2i]
var on_fight : bool = false:
	set(value):
		on_fight = value
		upper_ui_container.switch_button(value, left_time)
var location : Location

@onready var paths_map: TileMapLayer = $"Paths map"
@onready var room_manager : RoomManager = $"Room manager"
@onready var camera : Camera2D = $Camera2D
@onready var tree_creature : Control = $"CanvasLayer/Tree creature"
@onready var upper_ui_container : HBoxContainer = $"CanvasLayer/UI on map/Upper UI/MarginContainer/Upper UI container"



func _ready() -> void:
	location = GlobalInfo.current_location
	if GlobalInfo.load_scene:
		load_scene()
		return
	connect_signals()
	setup_grid()
	create_dungeon()
func _input(event: InputEvent)-> void: 
	if Input.is_action_just_pressed("Add info"):
		save_this_scene()
	elif Input.is_action_just_pressed("Num_1"):
		load_scene()

func load_scene() -> void:
	var upgradede : PackedScene = load("res://Save/dfgdfg.tscn")
	var new = upgradede.instantiate()
	GlobalInfo.load_scene = false
	get_tree().change_scene_to_packed(upgradede)
func save_this_scene() -> void : 
	var save_this : PackedScene = PackedScene.new()
	save_this.pack(self)
	#save_this.pack(room_manager)
	ResourceSaver.save(save_this, "res://Save/dfgdfg.tscn")

#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("Save test"):
		#save_map()
	#elif Input.is_action_just_pressed("Load test"):
		#load_map()


func connect_signals() -> void:
	Eventbus.connect("next_room", get_to_room)
	Eventbus.connect("save_all", save_map)
	Eventbus.connect("reveal_map", reveal_hide_map)
	Eventbus.connect("update_end_battle", battle_over)


func setup_grid() -> void:
	paths_to_room.region = GRID_SIZE
	paths_to_room.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	paths_to_room.cell_size = CELL_SIZE
	paths_to_room.update()


func create_dungeon() -> void:
	make_room(Vector2i.ZERO)
	while rooms.size() != count_rooms:
		var room_to_connect : Room = rooms.keys().pick_random()
		var next_coords : Vector2i = valid_space(room_to_connect)
		if !next_coords:
			continue 
		var room : Room = make_room(next_coords)
		rng_room_offset(room)
		create_path(room_to_connect, room)

	open_list_create()
	make_rng_loop()
	room_manager.set_role_rooms(location)

## Create additional path for some rooms.
func make_rng_loop() -> void:
	for iter : int in range(0, create_loops):
		var room : Room = open_list_room.pick_random()
		var neighboring = get_non_connect_neighboring(room)
		if !neighboring:
			continue
		create_path(neighboring, room)

## Create open_list_room for make loop later
func open_list_create() -> void:
	for room : Room in get_tree().get_nodes_in_group("Rooms"):
		if room.connected_room.size() <= 3: 
			open_list_room.append(room)

## Check valid space for new room
func valid_space(room : Room) -> Vector2i:
	for vector : Vector2i in NEIGHBORING_VECTORS:
		if !rooms.values().has(vector + room.room_coords):
			return vector + room.room_coords
	return Vector2i()
	
## Check having neighboring near room coords
func get_non_connect_neighboring(room : Room) -> Room: 
	for vector : Vector2i in NEIGHBORING_VECTORS:
		var neighboring_room : Room = rooms.find_key(vector + room.room_coords)
		if neighboring_room and neighboring_room not in room.connected_room:
			return neighboring_room
	return null
	
## Connect two room and visualize this via paths on path map
func create_path(next_room : Room, init_room : Room) -> void:
	next_room.connected_room.append(init_room)
	init_room.connected_room.append(next_room)
	var next_pos : Vector2i = paths_map.local_to_map(next_room.global_position) + Vector2i.ONE
	var init_pos : Vector2i = paths_map.local_to_map(init_room.global_position) + Vector2i.ONE
	paths_map.set_cells_terrain_path(paths_to_room.get_id_path(next_pos, init_pos), 0, 0, false)

## Random move room position just for cosmetic
func rng_room_offset(room : Room) -> void: 
	room.global_position += Vector2(CELL_SIZE.x * randi_range(-3, 3), CELL_SIZE.y * randi_range(-3, 3))

## Create room and add room to geneeral room pool
func make_room(tile_pos : Vector2i) -> Room:
	var room : Room = Room.new(rooms.size(), tile_pos)
	rooms[room] = room.room_coords
	room_manager.add_child(room)
	room.owner = self
	room.connect("move_to_dungeon", get_to_room)
	return room



func get_to_room(scene : PackedScene, cost_to_move : int) -> void:
	var room_scene = scene.instantiate() 
	#get_parent().add_child(room_scene)
	time_left(cost_to_move)
	
#func get_to_room(room : Room) -> void:
	#var room_i : Object
	#match room.type_room:
		#0: #fight
			#pass
			#room_i = FIGHT_ROOM.instantiate()
		#1: #elite fight
			#pass
		#2: #shop
			#pass
		#3: #tresure
			#pass
		#4: #event
			#pass
		#5: #escape
			#pass
	#if room_i != null and !on_fight:
		#get_parent().add_child(room_i)
		#reveal_hide_map()
		#room_i.map = room.map
		#room_i.cost_dif = calculate_general_diff()
		#on_fight = true
	#Eventbus.emit_signal("new_room")


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

#func get_random_map() -> String:
	#var filenames : Array[String] = []
	#var dir : DirAccess = DirAccess.open(PATH_TO_MAPS)
	#dir.list_dir_begin()
	#var file_name : String = dir.get_next()
	#while file_name != "":
		#if file_name.contains(".png") and file_name.contains(".import") == false:
			#filenames.append(file_name)
		#file_name = dir.get_next()
	#return filenames.pick_random()

func time_left(time : float) -> void:
	left_time -= time
	upper_ui_container.update_left_time(left_time)
	
func load_map() -> void:
	pass
