extends Node2D

const SIZE_CELL = 64
const PATH_TO_MAPS = "res://Maps/"

const FLOOR = 0
const WALL = 1
const TRAPS = 2
const TRIGGERS = 3
const OBSTACLE = 4
const BORDER = 5

const PATH_TO_ALLY = "Template_level_node/Units/Ally"
const PATH_TO_ENEMY = "Template_level_node/Units/Enemy"

var unitlist = preload("res://Unit lists/Unit lists/test.tres")
var preload_template = preload("res://Scenes/Testing scenes/template level/template_level_node.tscn")
var lighting = preload("res://Tile/Tile 64x64/Adding stuff/lighting/lighting.tscn")
var altars = preload("res://Things on map/Temples/altar.tscn")

var tm : TileMap
var path_to_char : String
var path_to_unit_list : String = "test"
var tile_for_ally : Array[Vector2i]
var tile_for_enemy : Array[Vector2i] 

func create() -> void:
	tile_for_ally.clear()
	tile_for_enemy.clear()
	Grid.clear_terrain()
	var level = preload_template.instantiate()
	add_child(level)
	tm = get_node("Template_level_node/TileMap")
	generate_level()
	Grid.init_level(tm)
	if GlobalInfo.stage == 1:
		add_king()
	add_ally()
	add_enemy()
	#if GlobalInformation.party_info.is_empty():
		#for character in choose_char():
			#path_to_char = "res://All unit/" + character + "/" + character + ".tscn"
			#var preload_character = load(path_to_char).instantiate()
			#var rng_position = tile_for_ally.pick_random()
			#get_node("Template_level_node/Units/Ally").add_child(preload_character)
			#preload_character.position = tm.map_to_local(rng_position)
			#tile_for_ally.erase(rng_position)
	#else:
		#for character in GlobalInformation.party_info:
			#path_to_char = "res://All unit/" + character["name"] + "/" + character["name"] + ".tscn"
			#var preload_character = load(path_to_char).instantiate()
			#var rng_position = tile_for_ally.pick_random()
			#get_node("Template_level_node/Units/Ally").add_child(preload_character)
			#for data in character:
				#preload_character.set(data, character.get(data))
			#preload_character.position = tm.map_to_local(rng_position)
			#tile_for_ally.erase(rng_position)
		#for character in choose_char():
			#path_to_char = "res://All unit/" + character + "/" + character + ".tscn"
			#var preload_character = load(path_to_char).instantiate()
			#var rng_position = tile_for_enemy.pick_random()
			#get_node("Template_level_node/Units/Enemy").add_child(preload_character)
			#preload_character.position = tm.map_to_local(rng_position)
			#tile_for_enemy.erase(rng_position)
	#get_node("Template_level_node/Units").init_level()
func add_king() -> void:
	const PATH_TO_KING = "res://All unit/King/King.tscn"
	var preload_king = load(PATH_TO_KING).instantiate()
	preload_king.position = get_rng_position("Ally")
	get_node(PATH_TO_ALLY).add_child(preload_king)
	
func add_ally() -> void:
	pass
func add_enemy() -> void:
	pass
func generate_level() -> void:
	tm.clear()
	var random_map = get_random_map()
	var path_to_file = "res://Maps/" + random_map
	var sprite = load(path_to_file)
	GlobalInfo.size_map = Rect2(0, 0, sprite.get_width() * SIZE_CELL, sprite.get_height() * SIZE_CELL)
	for x in range(sprite.get_width()):
		for y in range(sprite.get_height()):
			var color = sprite.get_pixel(x,y)
			if color == Color('GREEN'): 
				tm.set_cell(0, Vector2i(x,y), FLOOR, Vector2i(0,0))
				tile_for_ally.append(Vector2i(x,y))
			if color == Color('AQUA'):
				tm.set_cell(0, Vector2i(x,y), FLOOR, Vector2i(0,0))
				tile_for_enemy.append(Vector2i(x,y))
			if color == Color('DARK_SLATE_GRAY'):
				if sprite.get_pixel(x, y+1) == Color("DARK_SLATE_GRAY"):
					tm.set_cell(3, Vector2i(x, y), WALL, Vector2i(4, 0))
				else:
					tm.set_cells_terrain_connect(3, [Vector2i(x, y)],0, 0, false)
					if randi_range(0, 20) < 2: 
						var light = lighting.instantiate()
						add_child(light)
						light.global_position = Vector2i(x, y) * GlobalInfo.CELL_SIZE + Vector2i(32, 32)
			if color == Color('LIGHT_PINK'):
				tm.set_cell(1, Vector2i(x,y), OBSTACLE, Vector2i(0,0))
				tm.set_cell(0, Vector2i(x,y), FLOOR, Vector2i(0,0))
			if color == Color('ORANGE'):
				tm.set_cell(0, Vector2i(x,y), FLOOR, Vector2i(0,0))
				var altar = altars.instantiate()
				add_child(altar)
				altar.global_position = Vector2i(x,y) * GlobalInfo.CELL_SIZE + Vector2i(32, 0)
			if color == Color('MAROON'):
				tm.set_cell(0, Vector2i(x,y), TRAPS, Vector2i(0,0))
			if color == Color('NAVAJO_WHITE'):
				tm.set_cell(0, Vector2i(x,y), TRIGGERS, Vector2i(0,0))
			if color == Color('OLIVE_DRAB'):
				var tile_coords = get_random_tile(FLOOR)
				tm.set_cell(0, Vector2i(x,y), FLOOR, tile_coords)
		#generate edging
		if tm.get_cell_source_id(3, Vector2i(x, 0)) == -1:
			tm.set_cell(3, Vector2i(x, -1), WALL, Vector2i(0,1))

func choose_char() -> Array[String]:
	var name_units : Array[String] = []
	var rng_range = randi_range(3, 4)
	var general_calc = calculate_general_diff()
	for i in rng_range:
		var current_unit = unitlist.unit_list[randi_range(0, unitlist.unit_list.size() - 1)]
		if current_unit.weight <= general_calc:
			general_calc -= current_unit.weight
			name_units.append(current_unit.name_unit)
		if i == rng_range - 1 and general_calc >= calculate_general_diff() / 5:
			for x in range(unitlist.unit_list.size()):
				if unitlist.unit_list[x].weight <= calculate_general_diff() - general_calc:
					name_units.append(unitlist.unit_list[x].name_unit)
					break
	return name_units

func calculate_general_diff() -> int:
	var common_diff = (GlobalInfo.stage + 10 + 
						GlobalInfo.DIFFICULT.get(GlobalInfo.diffucult)) * randf_range(0.9, 1.1) * 6
	return common_diff

func get_random_map() -> String:
	var filenames : Array[String] = []
	var dir = DirAccess.open(PATH_TO_MAPS)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.contains(".png") and file_name.contains(".import") == false:
			filenames.append(file_name)
		file_name = dir.get_next()
	return filenames.pick_random()

func get_random_tile(source_id : int) -> Vector2i:
	var general_count_tiles : int = tm.tile_set.get_source(source_id).get_tiles_count()
	if randi_range(0, 30) < 2:
		return tm.tile_set.get_source(source_id).get_tile_id(randi_range(1, general_count_tiles - 1))
	return Vector2i(0, 0)
	
func get_rng_position(type : String) -> Vector2i:
	var rng_position : Vector2i
	if type == "Ally":
		rng_position = tile_for_ally.pick_random()
		tile_for_ally.erase(rng_position)
	elif type == "Enemy":
		rng_position = tile_for_ally.pick_random()
		tile_for_ally.erase(rng_position)
	return tm.map_to_local(rng_position)

func get_random_unit_list() -> Unit_list:
	return 
