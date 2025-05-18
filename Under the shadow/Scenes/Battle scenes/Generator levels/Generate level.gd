@icon("res://Global scripts/Classes/Icons/GeneratorLevel.svg")
extends Node2D
class_name GeneratorBattle

const SIZE_CELL : int = 64

const FLOOR : int = 0
const WALL : int = 1
const TRAP : int = 2
const TRIGGER : int = 3
const OBSTACLE : int = 4
const BORDER : int = 5

const PATH_TO_UNIT : String = "res://All unit/[unitname]/[unitname].tscn"
const PATH_TO_UNIT_LIST : String = "res://Unit lists/Location/[location]"
const NODE_PATH_TM : NodePath = "Template battle/Tilemaps manager"
const NODE_PATH_PL : NodePath = "Template battle/Units/Ally"
const NODE_PATH_AI : NodePath = "Template battle/Units/Enemy"
const NODE_PATH_UM : NodePath = "Template battle/Units"

const TEMPLATE_LVL : PackedScene = preload("res://Scenes/Testing scenes/template level/Template level.tscn")
const STATE_MAC_AI : PackedScene = preload("res://Scenes/Battle scenes/Unit/State machine Enemy/States AI.tscn")
const STATE_MAC_PL : PackedScene = preload("res://Scenes/Battle scenes/Unit/State machine Ally/States player.tscn")

# prelaods
var cost_dif : int 
var tm : TileMapManager
var tile_for_ally : Array[Vector2i]
var tile_for_enemy : Array[Vector2i] 
var map : String

func _ready() -> void:
	Eventbus.connect("to_main_menu", to_main_menu)
	create()
	
#func _init(map : PackedScene,) -> void:
	#pass
	
func create() -> void:
	Eventbus.connect("reveal_map", reveal_hide_map)
	Grid.clear_terrain()
	var level : Node2D = TEMPLATE_LVL.instantiate()
	add_child(level)
	generate_level()
	tm = get_node(NODE_PATH_TM)
	Grid.init_level(tm)
	add_ally()
	add_enemy(pick_rng_unit_list())
	get_node(NODE_PATH_UM).init_level()

func add_ally() -> void:
	for unit : UnitOnTeam in UnitManager.team:
		var unit_template_scene : String = PATH_TO_UNIT.replace("[unitname]", unit.forename)
		var unit_instant : CharacterBody2D = load(unit_template_scene).instantiate()
		var state_machine_pl : Node2D = STATE_MAC_PL.instantiate()
		var ally : Ally = Ally.new(unit_instant)
		ally.unit_property = unit
		ally.add_child(state_machine_pl)
		get_node(NODE_PATH_PL).add_child(unit_instant)
		unit_instant.replace_by(ally)
		set_rng_pos(ally, true)
		activate_unit(ally)

func add_enemy(unit_list : UnitList) -> void:
	for unit : UnitOnTeam in choose_char(unit_list):
		var path_to_unit_scene : String = PATH_TO_UNIT.replace("[unitname]", unit.forename)
		var unit_instant : CharacterBody2D = load(path_to_unit_scene).instantiate()
		var state_machine_ai : Node2D = STATE_MAC_AI.instantiate()
		var enemy : Enemy = Enemy.new(unit_instant)
		enemy.unit_property = unit
		enemy.add_child(state_machine_ai)
		get_node(NODE_PATH_AI).add_child(unit_instant)
		unit_instant.replace_by(enemy)
		activate_unit(enemy)
		set_rng_pos(enemy, false)

func activate_unit(unit : Unit) -> void:
	unit.input_pickable = true
	unit.creation()

func set_rng_pos(unit : Unit, PL : bool) -> void:
	pass
	#if PL:
		#var tile_pos : Vector2i = tile_for_ally.pick_random()
		#unit.global_position = tm.map_to_local(tile_pos)
		#tile_for_ally.erase(tile_pos)
	#else:
		#var tile_pos : Vector2i = tile_for_enemy.pick_random()
		#unit.global_position = tm.map_to_local(tile_pos)
		#tile_for_enemy.erase(tile_pos)

func generate_level() -> void:
	const TEST_MAP = preload("res://Maps/Test map.tscn")
	var map = TEST_MAP.instantiate()
	get_child(0).get_child(2).add_sibling(map)
	tile_for_ally = map.get_tiles(true)
	tile_for_enemy = map.get_tiles(false)

func choose_char(current_unit_list :  UnitList) -> Array[UnitOnTeam]:
	var units_prop : Array[UnitOnTeam] = []
	var rng_range : int = rng_count_enemy()
	var general_calc : int = cost_dif
	for i in rng_range:
		var rng_unit : UnitProp = current_unit_list.unit_list.pick_random()
		if rng_unit.cost - general_calc >= 0:
			units_prop.append(UnitManager.new_unit("", rng_unit))
			general_calc -= rng_unit.cost
	if cost_dif / 10 < general_calc:
		print("недостает очков придумай че нить")
	return units_prop
	
func pick_rng_unit_list() -> UnitList:
	var dir : DirAccess
	dir = DirAccess.open(PATH_TO_UNIT_LIST.replace("[location]", GlobalInfo.location) + "/")
	var files : PackedStringArray = dir.get_files()
	return load((dir.get_current_dir() + "/" + files[randi() %  files.size()]))

func rng_count_enemy() -> int:
	#return randi_range(GlobalInfo.stage / 10 + 2 , GlobalInfo.stage / 20 + 4) + 2
	return 0

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

func sort_by_cost(a : UnitProp, b : UnitProp) -> bool:
	if a.cost < b.cost:
		return false
	return true

func reveal_hide_map() -> void:
	visible = !visible

func to_main_menu() -> void:
	queue_free()
