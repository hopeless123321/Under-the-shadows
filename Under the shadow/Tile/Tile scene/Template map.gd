@icon("res://Global scripts/Classes/Icons/Single class/TileMapManager.svg")
extends Node2D
class_name TileMapManager

const PORT:= "Port"
const RECIVER:= "Reciever"

const SOURCE_ASYNC_PORTAL := 2
const SOURCE_SYNC_PORTAL := 3

@onready var floor_and_wall: TileMapLayer = $"Floor and wall"
@onready var lower_fill_floor: TileMapLayer = $"Fill floor"
@onready var higher_fill_floor: TileMapLayer = $"Fill floor 2"
@onready var decorations: TileMapLayer = $Decorations
@onready var object_layer: TileMapLayer = $"Traps, Portals, TileStatus"
@onready var spawn_layer: TileMapLayer = $"Spawn regions"


func _ready() -> void:
	set_portals()
	spawn_layer.visible = false
	GlobalInfo.size_map = floor_and_wall.get_used_rect()
	GlobalInfo.size_map.size *= 64
# 
func set_portals() -> void:
	for cell : Vector2i in object_layer.get_used_cells():
		var data : TileData = object_layer.get_cell_tile_data(cell)
		if object_layer.get_cell_source_id(cell) == SOURCE_ASYNC_PORTAL:
			var new_portal : AsymPortals = AsymPortals.new(data.get_custom_data(PORT), data.get_custom_data(RECIVER))
			object_layer.add_child(new_portal)
		elif object_layer.get_cell_source_id(cell) == SOURCE_SYNC_PORTAL:
			var new_portal : SymPortals = SymPortals.new(data.get_custom_data(PORT))
			object_layer.add_child(new_portal)

func get_tiles(ally : bool) -> Array[Vector2i]:
	if ally:
		return spawn_layer.get_used_cells_by_id(0, Vector2i(0, 2))
	return spawn_layer.get_used_cells_by_id(0, Vector2i(3, 2))

func set_fill_floor(cells : Array[Vector2i]) -> void:
	pass
