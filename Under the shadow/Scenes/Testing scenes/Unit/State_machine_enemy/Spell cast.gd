extends States

var abilities : Array[Base_ability]

func start():
	abilities = unit.ability
	abilities.shuffle()
	for ability in abilities:
		if ability.cooldown_timer == 0:
			var al_scr = ability.give_scp()
			match ability.Classname:
				"All in world":
					for character in get_tree().get_nodes_in_group("Unit"):
						if ability.check_unit_enemy(character):
							al_scr.execute(unit, character, ability)
				"World one target":
					match ability.type_unit:
						"Enemy":
							al_scr.execute(unit, get_tree().get_nodes_in_group("Ally").pick_random(), ability)
						"Ally":
							al_scr.execute(unit, get_tree().get_nodes_in_group("Enemy").pick_random(), ability)
						"Either":
							al_scr.execute(unit, get_tree().get_nodes_in_group("Unit").pick_random(), ability)
				"Self":
					al_scr.execute(unit, null, ability)
				"Several targets":
					var characters : Array[Unit] = []
					for character in get_tree().get_nodes_in_group("Unit"):
						if Utility.calc_length(ability.radius, unit.tile_pos, character.tile_pos) and characters.size() < ability.targets:
							#возможно добавить для стен препятствие
							if ability.check_unit_enemy(character):
								characters.append(character)
					al_scr.execute(unit, characters, ability)
				"target in area":
					for character in get_tree().get_nodes_in_group("Unit"):
						if Utility.calc_length(ability.radius, unit.tile_pos, character.tile_pos):
							if ability.check_unit_enemy(character):
								al_scr.execute(unit, character, ability)
								break
				"All in area":
					for character in get_tree().get_nodes_in_group("Unit"):
						if Utility.calc_length(ability.radius, unit.tile_pos, character.tile_pos):
							if ability.check_unit_enemy(character):
								al_scr.execute(unit, character, ability)
				"Directional":
					var have_unit := false
					if ability.points.is_empty():
						for edge_cell in Utility.get_edge_cell(ability.radius, unit.tile_pos):
							for cell in ability.fill(unit.tile_pos, edge_cell):
								if Grid.get_unit(cell):
									have_unit = true
									al_scr.execute(unit, Grid.get_unit(cell), ability)
							if have_unit:
								break
					else:
						for direction in unit._tm.get_surrounding_cells(unit.tile_pos):
							for cell in ability.fill(unit.tile_pos, direction):
								if Grid.get_unit(cell):
									al_scr.execute(unit, Grid.get_unit(cell), ability)
									have_unit = true
							if have_unit:
								break
				"Bomb like":
					pass
func update():
	return unit._st.end_turn
func end():
	pass
