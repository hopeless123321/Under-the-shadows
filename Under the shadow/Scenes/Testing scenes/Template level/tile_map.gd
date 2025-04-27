extends TileMap


const SELF_TILE : Vector2i = Vector2i(0, 0)
const CHOICE_TILE : Vector2i = Vector2i(1, 0)
const SELECTED_TILE : Vector2i = Vector2i(2, 0)
const AREA_TILE : Vector2i = Vector2i(3, 0)

const FILL_SOURCE : int = 6

const CLICK_FLOOR_L : int = 2 
const FILL_FLOOR_L : int = 3


func _ready() -> void:
	clear()
	

func init(skill : Skill, init_tile_pos : Vector2i, ally : bool) -> Array[Vector2i]:
	var click_cells : Array[Vector2i] = []
	match skill.type_application:
		Skill.TypeApplication.AllWorld:
			for unit in get_tree().get_nodes_in_group(SkillManager.get_group(skill, ally)):
				set_cell(FILL_FLOOR_L, unit.tile_pos, FILL_SOURCE, SELECTED_TILE)
			# self don't effect to skill
			if skill.type_application != Skill.TypeApplication.Self:
				erase_cell(FILL_FLOOR_L, init_tile_pos)
			set_cell(CLICK_FLOOR_L, init_tile_pos, FILL_SOURCE, SELF_TILE)
			click_cells.append(init_tile_pos)
		Skill.TypeApplication.AllArea:
			for cell in SkillManager.fill_obs(init_tile_pos, skill.radius):
				if GlobalInfo.size_map.has_point(cell):
					if Grid.get_unit(cell) == null:
						set_cells_terrain_connect(FILL_FLOOR_L, [cell], 1, 0, false)
					else:
						if SkillManager.check_class(ally, Grid.get_unit(cell), skill.type_unit):
							set_cell(FILL_FLOOR_L, cell, FILL_SOURCE, SELECTED_TILE)
			if !skill.self_target:
				erase_cell(FILL_FLOOR_L, init_tile_pos)
			set_cell(CLICK_FLOOR_L, init_tile_pos, FILL_SOURCE, SELF_TILE)
			click_cells.append(init_tile_pos)
		Skill.TypeApplication.TargetsWorld:
			for unit in get_tree().get_nodes_in_group(SkillManager.get_group(skill, ally)):
				set_cell(CLICK_FLOOR_L, unit.tile_pos, FILL_SOURCE, CHOICE_TILE)
				click_cells.append(unit.tile_pos)
			if !skill.self_target:
				erase_cell(CLICK_FLOOR_L, init_tile_pos)
		Skill.TypeApplication.TargetsArea:
			for cell in SkillManager.fill_obs(init_tile_pos, skill.radius):
				if GlobalInfo.size_map.has_point(cell):
					if Grid.get_unit(cell) == null:
						set_cells_terrain_connect(FILL_FLOOR_L, [cell], 1, 0, false)
					else:
						if SkillManager.check_class(ally, Grid.get_unit(cell), skill.type_unit):
							set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, CHOICE_TILE)
							click_cells.append(cell)
			if !skill.self_target:
				erase_cell(CLICK_FLOOR_L, init_tile_pos)
		Skill.TypeApplication.DirectionalWithPreset:
			for n_cell in get_surrounding_cells(init_tile_pos):
				if GlobalInfo.size_map.has_point(n_cell):
					var dir : Vector2 = init_tile_pos - n_cell
					for cell : Vector2i in skill.vectors:
						if dir.x != 0:
							set_cells_terrain_connect(FILL_FLOOR_L, [Vector2i(cell.x * dir.x, cell.y) + init_tile_pos], 1, 0, false)
						elif dir.y != 0:
								set_cells_terrain_connect(FILL_FLOOR_L, [Vector2i(cell.y, cell.x * dir.y) + init_tile_pos], 1, 0, false)
		Skill.TypeApplication.Directional:
			for cell in SkillManager.fill_obs(init_tile_pos, skill.radius):
				if GlobalInfo.size_map.has_point(cell):
					set_cells_terrain_connect(FILL_FLOOR_L, [cell], 1, 0, false)
		Skill.TypeApplication.Self:
			set_cell(CLICK_FLOOR_L, init_tile_pos, FILL_SOURCE, SELF_TILE)
			click_cells.append(init_tile_pos)
		Skill.TypeApplication.BombLike:
			for cell in SkillManager.fill_obs(init_tile_pos, skill.length_to_target):
				set_cells_terrain_connect(FILL_FLOOR_L, [cell], 1, 0, false)
				if Grid.get_unit(cell) != null and SkillManager.check_class(true, Grid.get_unit(cell), skill.type_unit):
					set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, CHOICE_TILE)
					click_cells.append(cell)
		Skill.TypeApplication.TilesEffects:
			pass
	return click_cells

func clear_cells(selectable_cells : Array[Vector2i]) -> void:
	for cell in selectable_cells:
		set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, CHOICE_TILE)

func update(skill : Skill, mouse_tile_pos : Vector2i, selectable_cells : Array[Vector2i], ally : bool, unit_tile_pos : Vector2i) -> Array[Unit]:
	var effected_unit : Array[Unit] = []
	match skill.type_application:
		Skill.TypeApplication.AllWorld:
			if mouse_tile_pos in selectable_cells:
				set_cell(CLICK_FLOOR_L, mouse_tile_pos, FILL_SOURCE, SELECTED_TILE)
		Skill.TypeApplication.AllArea:
			if mouse_tile_pos in selectable_cells:
				set_cell(CLICK_FLOOR_L, mouse_tile_pos, FILL_SOURCE, SELECTED_TILE)
		Skill.TypeApplication.TargetsWorld:
			if mouse_tile_pos in selectable_cells:
				set_cell(CLICK_FLOOR_L, mouse_tile_pos, FILL_SOURCE, SELECTED_TILE)
		Skill.TypeApplication.TargetsArea:
			if mouse_tile_pos in selectable_cells:
				set_cell(CLICK_FLOOR_L, mouse_tile_pos, FILL_SOURCE, SELECTED_TILE)
		Skill.TypeApplication.DirectionalWithPreset:
			clear_layer(CLICK_FLOOR_L)
			var dir : Vector2i = Vector2i(mouse_tile_pos - unit_tile_pos).sign()
			for cell in SkillManager.dir_with_vec(skill.vectors, dir, unit_tile_pos):
				if Grid.get_unit(cell) == null:
					set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, AREA_TILE)
				else:
					if SkillManager.check_class(ally, Grid.get_unit(cell), skill.type_unit):
						set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, SELECTED_TILE)
		Skill.TypeApplication.Directional:
			clear_layer(CLICK_FLOOR_L)
			for cell in SkillManager.dir_without_vec(skill.radius, unit_tile_pos, mouse_tile_pos):
				if cell in get_used_cells(FILL_FLOOR_L):
					if Grid.get_unit(cell) == null:
						set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, AREA_TILE)
					else:
						if SkillManager.check_class(ally, Grid.get_unit(cell), skill.type_unit):
							set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, SELECTED_TILE)
					if skill.pierce:
						break
		Skill.TypeApplication.Self:
			if mouse_tile_pos in selectable_cells:
				set_cell(CLICK_FLOOR_L, mouse_tile_pos, FILL_SOURCE, SELECTED_TILE)
		Skill.TypeApplication.BombLike:
			if mouse_tile_pos not in get_used_cells_by_id(CLICK_FLOOR_L, FILL_SOURCE, SELF_TILE):
				clear_layer(CLICK_FLOOR_L)
				for cell in selectable_cells:
					set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, CHOICE_TILE)
			if mouse_tile_pos in selectable_cells:
				set_cell(CLICK_FLOOR_L, mouse_tile_pos, FILL_SOURCE, SELF_TILE)
				effected_unit.append(Grid.get_unit(mouse_tile_pos))
				for cell in SkillManager.fill_obs(mouse_tile_pos, skill.radius):
					if GlobalInfo.size_map.has_point(cell):
						if Grid.get_unit(cell) == null:
							set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, AREA_TILE)
						else:
							if SkillManager.check_class(ally, Grid.get_unit(cell), skill.type_unit):
								set_cell(CLICK_FLOOR_L, cell, FILL_SOURCE, SELECTED_TILE)
		Skill.TypeApplication.TilesEffects:
			pass
	if skill.type_application != Skill.TypeApplication.TargetsArea and skill.type_application != Skill.TypeApplication.TargetsWorld:
		for cell in get_used_cells_by_id(CLICK_FLOOR_L, FILL_SOURCE, SELECTED_TILE):
			effected_unit.append(Grid.get_unit(cell))
	return effected_unit

func add_unit_exec(tile_pos : Vector2i, old_tile_pos : Vector2i = Vector2(-1, -1)) -> Unit:
	if old_tile_pos != -Vector2i.ONE:
		erase_cell(FILL_FLOOR_L, old_tile_pos)
	set_cell(FILL_FLOOR_L, tile_pos, FILL_SOURCE, SELECTED_TILE)
	return Grid.get_unit(tile_pos)
