extends AStarGrid2D
class_name ModifiedAstarGrid2D


const DIRECTION_FILL_FLOOR : Array[Vector2i] = [Vector2i.DOWN, Vector2.UP, Vector2i.LEFT, Vector2i.RIGHT]

## Units can teleport between portals. 
var portals : Dictionary[Vector2i, Vector2i]
## Map have obstacle between some two cells
var fence : Dictionary[Vector2i, Vector2i]

func _init() -> void:
	cell_size = GlobalInfo.CELL_SIZE
	diagonal_mode = DIAGONAL_MODE_NEVER
	update()
	
func _estimate_cost(from_id: Vector2i, end_id: Vector2i) -> float:
	print("estimate", from_id, end_id)
	return  0.1
	
func _compute_cost(from_id: Vector2i, to_id: Vector2i) -> float:
	print("compute", from_id, to_id)
	return  0.1

## Return all coords on radius include real capability to reach point. Mostly need for unit to reveal all possible paths the player can reach
func fill_floor(init_position : Vector2i, move_point : int) -> Array[Vector2i]: 
	var selectable_cells : Array[Vector2i] = []
	var stack : Array[Vector2i] = [init_position]
	for steps in range(0, move_point):
		var cells_in_cycles : Array[Vector2i] = stack.duplicate()
		stack.clear()
		while !cells_in_cycles.is_empty(): 
			var current_cell : Vector2i = cells_in_cycles.pop_back()
			if selectable_cells.has(current_cell):
				continue
			if !is_in_boundsv(current_cell):
				continue
			selectable_cells.append(current_cell)
			for cell_dir in DIRECTION_FILL_FLOOR:
				var new_cell : Vector2i = cell_dir + current_cell
				if !is_in_boundsv(new_cell):
					continue
				if selectable_cells.has(new_cell):
					continue
				if is_point_solid(new_cell):
					continue
				stack.append(new_cell)
	print("selectable_cells")
	return selectable_cells
