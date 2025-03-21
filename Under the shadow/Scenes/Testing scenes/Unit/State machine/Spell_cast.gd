extends States

const AREA_TILE = Vector2i(1, 2)
const CHOICE_TILE = Vector2i(2, 2)
const SELECTED_TILE =  Vector2i(3, 2)
const SELF_TILE = Vector2i(2, 3)

var ability :  Base_ability
var ability_points : Array[Vector2i] #переменная принимающая все тайлы на кого действует способность
var tile_pos_mouse : Vector2i:
	set(value):
		if value != tile_pos_mouse:
			# удаление
			if ["Bomb like", "Directional"].has(ability.Classname):
				unit._tm.clear_layer(2)
			if unit._tm.get_cell_atlas_coords(2, tile_pos_mouse) == SELECTED_TILE:
				if ["All in world"].has(ability.Classname) or ["Several targets"].has(ability.Classname) and tile_pos_mouse in ability_points:
					unit._tm.set_cell(2, tile_pos_mouse, 6, SELECTED_TILE)
				else:
					unit._tm.set_cell(2, tile_pos_mouse, 6, CHOICE_TILE)
			if ["All in area", "All in world", "Self", "Several targets"].has(ability.Classname) == false:
				ability_points.clear()
			tile_pos_mouse = value 
			# появление
			if ability.check_right(tile_pos_mouse, unit, unit._tm):
				match ability.Classname:
					"Self":
						unit._tm.set_cell(2, unit.tile_pos, 6, SELECTED_TILE)
					"All in area", "All in world":
						if tile_pos_mouse == unit.tile_pos:
							unit._tm.set_cell(2, unit.tile_pos, 6, SELF_TILE)
					"Bomb like":
						if Grid.is_point_solid(tile_pos_mouse):
							for tile in ability.fill(tile_pos_mouse):
								if Grid.is_point_solid(tile) == false:
									unit._tm.set_cell(2, tile, 6, AREA_TILE)
								elif ability.check_unit(tile):
									if tile == tile_pos_mouse:
										ability_points.insert(0, tile)
									ability_points.append(tile)
									unit._tm.set_cell(2, tile, 6, SELECTED_TILE)
					"Directional": 
						for tile in ability.fill(unit.tile_pos, tile_pos_mouse):
							if Grid.is_point_solid(tile):
								unit._tm.set_cell(2, tile, 6, SELECTED_TILE)
								ability_points.append(tile)
							else:
								unit._tm.set_cell(2, tile, 6, CHOICE_TILE)
					"target in area", "World one target":
						if Grid.get_unit(tile_pos_mouse) != unit:
							if Grid.is_point_solid(tile_pos_mouse) and ability.check_unit(tile_pos_mouse):
								ability_points.append(tile_pos_mouse)
								unit._tm.set_cell(2, tile_pos_mouse, 6, SELECTED_TILE)
					"Several targets":
						if Grid.is_point_solid(tile_pos_mouse) and ability.check_unit(tile_pos_mouse):
							unit._tm.set_cell(2, tile_pos_mouse, 6, SELECTED_TILE)
var characters : Array[Unit]

func start():
	GlobalInfo.select_ability_anybody = true
	ability_points.clear()
	if ["All in area", "Several targets", "target in area"].has(ability.Classname):
		#окрашивание в зеленный тайлов возможности
		for tile in ability.fill(unit.tile_pos):
			if unit._tm.get_cell_tile_data(3, tile) == null:
				if ability.Classname == "All in area":
					if ability.check_unit(tile):
						ability_points.append(tile)
						unit._tm.set_cell(2, tile, 6, CHOICE_TILE)
					else:
						unit._tm.set_cell(2, tile, 6, AREA_TILE)
				else: 
					if ability.check_unit(tile):
						unit._tm.set_cell(2, tile, 6, CHOICE_TILE)
					else:
						unit._tm.set_cell(2, tile, 6, AREA_TILE)
	if ["All in world", "World one target"].has(ability.Classname):
		#окрашивание в оранжевый всех противников в красный если выбрано все, иначе в оранжевый с последующим перерашиванием в красный
		for character in get_tree().get_nodes_in_group("Units"):
			if ability.check_unit(character.tile_pos) and character != unit:
				if ability.Classname == "All in world":
					ability_points.append(character.tile_pos)
					unit._tm.set_cell(2, character.tile_pos, 6, SELECTED_TILE)
				else:
					unit._tm.set_cell(2, character.tile_pos, 6, CHOICE_TILE)
	if ["All in world", "All in area"].has(ability.Classname):
		# окрашивание в красный себя
		unit._tm.set_cell(2, unit.tile_pos, 6, SELF_TILE)
	if ability.Classname == "Self":
		ability_points.append(unit.tile_pos)
		unit._tm.set_cell(2, unit.tile_pos, 6, CHOICE_TILE)

func update():
	tile_pos_mouse = floor(get_global_mouse_position() / 64)
	var al_scr = ability.give_scp()
	if Input.is_action_just_pressed("LMB"):
		if ability.self_target == false:
			ability_points.erase(unit.tile_pos)
		if ability.Classname == "Several targets":
			if ability.check(tile_pos_mouse) and ability_points.has(tile_pos_mouse) == false:
				ability_points.append(tile_pos_mouse)
				characters.append(Grid.find_unit(tile_pos_mouse))
				unit._tm.set_cell(2, unit.tile_pos, 6, Vector2i(2, 3))
				if characters.size() == ability.targets:
					al_scr.execute(unit, characters, ability)
					if ability.cooldown != 0:
						ability.cooldown_timer = ability.cooldown
					characters.clear()
					if unit.move_after_skill:
						return unit._st.wait
					else:
						return unit._st.end_turn
		else:
			for tile in ability_points:
				al_scr.execute(unit, Grid.get_unit(tile), ability)
				if ability.cooldown != 0:
					ability.cooldown_timer = ability.cooldown
			if unit.move_after_skill:
				return unit._st.wait
			else:
				return unit._st.end_turn
	if Input.is_action_just_pressed("ESC"):
		return unit._st.wait

func end():
	ability_points.clear()
	Eventbus.emit_signal("update_prop_ui")
	unit._tm.clear_layer(2)
	GlobalInfo.select_ability_anybody = false
