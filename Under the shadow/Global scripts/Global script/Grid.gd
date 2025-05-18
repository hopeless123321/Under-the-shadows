extends Node2D

var grid_ghosts : ModifiedAstarGrid2D = ModifiedAstarGrid2D.new()
var grid_normals : ModifiedAstarGrid2D = ModifiedAstarGrid2D.new()

func _ready() -> void:
	Eventbus.connect("dying", char_die)

func init_level(tm : TileMapManager) -> void:
	grid_ghosts.clear()
	grid_normals.clear()

	#grid_normals.cell_size = GlobalInfo.CELL_SIZE
	grid_normals.region = GlobalInfo.size_map
	#grid_normals.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid_normals.update()
	#for cell : Vector2i in tm.get_used_cells(1):
		#grid_normals.set_point_solid(cell)
	#await get_tree().create_timer(0.1).timeout
#
	#grid_ghosts.cell_size = GlobalInfo.CELL_SIZE
	#grid_ghosts.region = tm.get_used_rect()
	#grid_ghosts.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	#grid_ghosts.update()
	#for cell : Vector2i in tm.get_used_cells(4):
		#grid_ghosts.set_point_solid(cell)
		#grid_normals.set_point_solid(cell)
	#for unit : Unit in get_tree().get_nodes_in_group("Units"):
		#grid_ghosts.set_point_solid(unit.tile_pos)
		#grid_normals.set_point_solid(unit.tile_pos)
	#for altars : Node in get_tree().get_nodes_in_group("Altars"):
		#grid_ghosts.set_point_solid(altars.global_position / 64)
		#grid_normals.set_point_solid(altars.global_position / 64)

func clear_terrain() -> void:
	grid_normals.clear()
	grid_ghosts.clear()

func char_die(unit : Unit) -> void:
	grid_ghosts.set_point_solid(unit.tile_pos, false)
	grid_normals.set_point_solid(unit.tile_pos, false)

func temp_set_solid(tile_pos : Vector2i, solid : bool) -> void:
	grid_ghosts.set_point_solid(tile_pos, solid)
	grid_normals.set_point_solid(tile_pos, solid)

func update(new_solid : Vector2i, old_solid : Vector2i) -> void:
	grid_normals.set_point_solid(new_solid)
	grid_normals.set_point_solid(old_solid, false)

	grid_ghosts.set_point_solid(new_solid)
	grid_ghosts.set_point_solid(old_solid, false)

func check_point_in_grid(tile_pos : Vector2i) -> bool:
	if grid_ghosts.is_in_boundsv(tile_pos):
		return true
	return false

func get_path_id(initial_tile_pos : Vector2i, end_tile_pos : Vector2i, free_move : bool) -> Array[Vector2i]:
	if check_point_in_grid(end_tile_pos):
		if free_move:
			return grid_normals.get_id_path(initial_tile_pos, end_tile_pos).slice(1)
		else:
			return grid_ghosts.get_id_path(initial_tile_pos, end_tile_pos).slice(1)
	return []

func get_unit(tile_pos : Vector2i) -> Unit:
	for unit : Unit in get_tree().get_nodes_in_group("Units"):
		if unit.tile_pos == tile_pos:
			return unit
	return null

func is_point_solid(tile_pos : Vector2i) -> bool:
	if grid_ghosts.is_point_solid(tile_pos):
		return true
	return false

func valid_line_skill(start_point : Vector2i, end_point : Vector2i) -> Array[Vector2i]:
	var vectors : Array[Vector2i] = []
	var valid_points : Array[Vector2i] = []
	if start_point != end_point:
		var dx : int = start_point.x - end_point.x
		var dy : int = start_point.y - end_point.y
		var step : int = max(abs(dx),abs(dy))
		var inc_x : float = float(dx) / float(step)
		var inc_y  : float = float(dy) / float(step)
		if end_point != start_point:
			for steps in step + 1:
				vectors.append(start_point - Vector2i(round(Vector2(inc_x*steps, inc_y*steps))))
		vectors.pop_front()
		for point : Vector2i in vectors:
			if GlobalInfo.size_map.has_point(point) == false or (grid_ghosts.is_point_solid(point) and get_unit(point) == null):
				break
			valid_points.append(point)
	return valid_points
