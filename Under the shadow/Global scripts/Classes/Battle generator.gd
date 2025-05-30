extends Node
class_name BattleGenerator 

const TEMPLATE_LVL : PackedScene = preload("res://Scenes/Testing scenes/template level/Template level.tscn")

func _init() -> void:
	pass
	
	
	
#extends Node2D
#
#const OFFSET : Vector2i = Vector2i(32, 32)
#const SIZE_CELL : int = 64
#const PATH_TO_MAPS : String = "res://Maps/"
#
#const FLOOR : int = 0
#const WALL : int = 1
#const TRAP : int = 2
#const TRIGGER : int = 3
#const OBSTACLE : int = 4
#const BORDER : int = 5
#
#const PATH_TO_UNIT : String = "res://All unit/[unitname]/[unitname].tscn"
#const PATH_TO_UNIT_LIST : String = "res://Unit lists/Location/[location]"
#const NODE_PATH_TM : NodePath = "Template_level_node/TileMap"
#const NODE_PATH_PL : NodePath = "Template_level_node/Units/Ally"
#const NODE_PATH_AI : NodePath = "Template_level_node/Units/Enemy"
#const NODE_PATH_UM : NodePath = "Template_level_node/Units"
#
#const PATH_TO_LIGHT : PackedScene = preload("res://Tile/Tile 64x64/Adding stuff/lighting/lighting.tscn")
#const PATH_TO_ALTAR : PackedScene = preload("res://Things on map/Temples/altar.tscn")
#
#const STATE_MAC_AI : PackedScene = preload("res://Scenes/Main scenes/Units/States AI.tscn")
#const STATE_MAC_PL : PackedScene = preload("res://Scenes/Main scenes/Units/States player.tscn")
#
#
#const POINT_LIGHT_2D = preload("res://Test/point_light_2d.tscn")
## color mean:
#const ALLY_ZONE : Color = ("GREEN")
#const ENEMY_ZONE : Color = ("AQUA")
#const NOTHING : Color = ("OLIVE_DRAB")
#const WALLS : Color = ("DARK_SLATE_GRAY")
#const ALTARS : Color = ("ORANGE")
#const TRAPS : Color = ("MAROON")
#const OBSTACLES : Color = ("LIGHT_PINK")
#const TRIGGERS : Color = ("NAVAJO_WHITE")
#
## prelaods
#var cost_dif : int 
#var tm : TileMap
#var tile_for_ally : Array[Vector2i]
#var tile_for_enemy : Array[Vector2i] 
#var map : String
#
#func _ready() -> void:
	#Eventbus.connect("to_main_menu", to_main_menu)
#
#func create() -> void:
	#Eventbus.connect("reveal_map", reveal_hide_map)
	#Grid.clear_terrain()
	#var level : Node2D = TEMPLATE_LVL.instantiate()
	#add_child(level)
	#tm = get_node(NODE_PATH_TM)
	#generate_level()
	#Grid.init_level(tm)
	#add_ally()
	#add_enemy(pick_rng_unit_list())
	#get_node(NODE_PATH_UM).init_level()
#
#func add_ally() -> void:
	#for unit : UnitOnTeam in UnitManager.team:
		#var unit_template_scene : String = PATH_TO_UNIT.replace("[unitname]", unit.forename)
		#var unit_instant : CharacterBody2D = load(unit_template_scene).instantiate()
		#var state_machine_pl : Node2D = STATE_MAC_PL.instantiate()
		#var ally : Ally = Ally.new()
		#ally.unit_property = unit
		#ally.add_child(state_machine_pl)
		#get_node(NODE_PATH_PL).add_child(unit_instant)
		#unit_instant.replace_by(ally)
		#set_rng_pos(ally, true)
		#activate_unit(ally)
#
#func add_enemy(unit_list : UnitList) -> void:
	#for unit : UnitOnTeam in choose_char(unit_list):
		#var path_to_unit_scene : String = PATH_TO_UNIT.replace("[unitname]", unit.forename)
		#var unit_instant : CharacterBody2D = load(path_to_unit_scene).instantiate()
		#var state_machine_ai : Node2D = STATE_MAC_AI.instantiate()
		#var enemy : Enemy = Enemy.new()
		#enemy.unit_property = unit
		#enemy.add_child(state_machine_ai)
		#get_node(NODE_PATH_AI).add_child(unit_instant)
		#unit_instant.replace_by(enemy)
		#print(enemy.name)
		#set_rng_pos(enemy, false)
		#activate_unit(enemy)
#
#func activate_unit(unit : Unit) -> void:
	#unit.input_pickable = true
	#unit.creation()
#
#func set_rng_pos(unit : Unit, PL : bool) -> void:
	#if PL:
		#var tile_pos : Vector2i = tile_for_ally.pick_random()
		#unit.global_position = tm.map_to_local(tile_pos)
		#
		#tile_for_ally.erase(tile_pos)
	#else:
		#var tile_pos : Vector2i = tile_for_enemy.pick_random()
		#unit.global_position = tm.map_to_local(tile_pos)
		#tile_for_enemy.erase(tile_pos)
#
#func generate_level() -> void:
	#var path_to_file : String = "res://Maps/" + map
	#var sprite : Image = load(path_to_file)
	#GlobalInfo.size_map = Rect2(0, 0, sprite.get_width() * SIZE_CELL, sprite.get_height() * SIZE_CELL)
	#for x : int in range(sprite.get_width()):
		#for y : int in range(sprite.get_height()):
			#var color : Color = sprite.get_pixel(x,y)
			#match color:
				#Color('GREEN'):
					#tm.set_cell(0, Vector2i(x,y), FLOOR, Vector2i(0,0))
					#tile_for_ally.append(Vector2i(x,y))
				#Color('AQUA'):
					#tm.set_cell(0, Vector2i(x,y), FLOOR, Vector2i(0,0))
					#tile_for_enemy.append(Vector2i(x,y))
				#Color('DARK_SLATE_GRAY'):
					#if sprite.get_pixel(x, y+1) == Color("DARK_SLATE_GRAY"):
						#tm.set_cell(4, Vector2i(x, y), WALL, Vector2i(4, 0))
					#else:
						#tm.set_cells_terrain_connect(4, [Vector2i(x, y)],0, 0, false)
						#if randi_range(0, 20) < 2: 
							#var light : Sprite2D = PATH_TO_LIGHT.instantiate()
							#tm.add_child(light)
							#light.global_position = tm.map_to_local(Vector2i(x, y))
				#Color('LIGHT_PINK'):
					#tm.set_cell(1, Vector2i(x,y), OBSTACLE, Vector2i(0,0))
					#tm.set_cell(0, Vector2i(x,y), FLOOR, Vector2i(0,0))
				#Color('ORANGE'):
					#tm.set_cell(0, Vector2i(x,y), FLOOR, Vector2i(0,0))
					#var altar = PATH_TO_ALTAR.instantiate()
					#tm.add_child(altar)
					#altar.global_position = tm.map_to_local(Vector2i(x,y))
				#Color('MAROON'):
					#tm.set_cell(0, Vector2i(x,y), TRAP, Vector2i(0,0))
				#Color('NAVAJO_WHITE'):
					#tm.set_cell(0, Vector2i(x,y), TRIGGER, Vector2i(0,0))
				#Color('OLIVE_DRAB'):
					#var tile_coords : Vector2i = get_random_tile(FLOOR)
					#tm.set_cell(0, Vector2i(x,y), FLOOR, tile_coords)
		##generate edging
		#if tm.get_cell_source_id(4, Vector2i(x, 0)) == -1:
			#tm.set_cell(4, Vector2i(x, -1), WALL, Vector2i(0,1))
#
#func choose_char(current_unit_list :  UnitList) -> Array[UnitOnTeam]:
	#var units_prop : Array[UnitOnTeam] = []
	#var rng_range : int = rng_count_enemy()
	#var general_calc : int = cost_dif
	#for i in rng_range:
		#var rng_unit : UnitProp = current_unit_list.unit_list.pick_random()
		#if rng_unit.cost - general_calc >= 0:
			#units_prop.append(UnitManager.new_unit("", rng_unit))
			#general_calc -= rng_unit.cost
	#if cost_dif / 10 < general_calc:
		#print("недостает очков придумай че нить")
	#return units_prop
	#
#func pick_rng_unit_list() -> UnitList:
	#var dir : DirAccess
	#dir = DirAccess.open(PATH_TO_UNIT_LIST.replace("[location]", GlobalInfo.location) + "/")
	#var files : PackedStringArray = dir.get_files()
	#return load((dir.get_current_dir() + "/" + files[randi() %  files.size()]))
#
#func rng_count_enemy() -> int:
	#return randi_range(GlobalInfo.stage / 10 + 2 , GlobalInfo.stage / 20 + 4) + 2
#
#func get_random_tile(source_id : int) -> Vector2i:
	#var general_count_tiles : int = tm.tile_set.get_source(source_id).get_tiles_count()
	#if randi_range(0, 30) < 2:
		#return tm.tile_set.get_source(source_id).get_tile_id(randi_range(1, general_count_tiles - 1))
	#return Vector2i(0, 0)
	#
#func get_rng_position(type : String) -> Vector2i:
	#var rng_position : Vector2i
	#if type == "Ally":
		#rng_position = tile_for_ally.pick_random()
		#tile_for_ally.erase(rng_position)
	#elif type == "Enemy":
		#rng_position = tile_for_ally.pick_random()
		#tile_for_ally.erase(rng_position)
	#return tm.map_to_local(rng_position)
#
#func sort_by_cost(a : UnitProp, b : UnitProp) -> bool:
	#if a.cost < b.cost:
		#return false
	#return true
#
#func reveal_hide_map() -> void:
	#visible = !visible
#
#func to_main_menu() -> void:
	#queue_free()
