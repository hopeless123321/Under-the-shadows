extends Unit
class_name Enemy
const Classname := "Enemy"

@export_enum ("Close", 
			"Far", 
			"Low hp", 
			"High hp", 
			"King", 
			"Low will", 
			"High will", 
			"Random") var move_to : String
@export var distance : int

func _ready() -> void:
	_initiation()
	add_to_group("Enemy")
	z_index = int(global_position.y / 64)

func find_path() -> Array[Vector2i]:
	var path_id : Array[Vector2i] = []
	match move_to:
		"Close":
			for character in get_tree().get_nodes_in_group("Ally"):
				Grid.temp_set_solid(character.tile_pos, false)
				if path_id.is_empty():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
				elif Grid.get_path_id(tile_pos ,character.tile_pos, free_move).size() < path_id.size():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
				Grid.temp_set_solid(character.tile_pos, true)
		"Far":
			for character in get_tree().get_nodes_in_group("Ally"):
				Grid.temp_set_solid(character.tile_pos, false)
				if Grid.get_path_id(tile_pos ,character.tile_pos, free_move).size() > path_id.size():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
				Grid.temp_set_solid(character.tile_pos, true)
		"Low hp":
			while path_id.is_empty():
				var units = get_tree().get_nodes_in_group("Ally")
				units.sort_custom(sort_by_hp.bind(true))
				for character in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		"High hp":
			while path_id.is_empty():
				var units = get_tree().get_nodes_in_group("Ally")
				units.sort_custom(sort_by_hp.bind(false))
				for character in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		"King":
			pass
		"Low will":
			while path_id.is_empty():
				var units = get_tree().get_nodes_in_group("Ally")
				units.sort_custom(sort_by_will.bind(false))
				for character in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		"High will":
			while path_id.is_empty():
				var units = get_tree().get_nodes_in_group("Ally")
				units.sort_custom(sort_by_will.bind(false))
				for character in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		"Random":
			var units = get_tree().get_nodes_in_group("Ally")
			units.shuffle()
			for character in units:
				if path_id.is_empty():
					break
				Grid.temp_set_solid(character.tile_pos, false)
				path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
				Grid.temp_set_solid(character.tile_pos, true)
	for i in distance + 1:
		path_id.pop_back()
	if path_id.size() > speed:
		path_id.resize(speed)
	return path_id

func move_to_target() -> void:
	var target_position = _tm.map_to_local(path.front())
	global_position = global_position.move_toward(target_position, 6)
	if global_position == target_position:
		path.pop_front()

func _on_input_event(_viewport, _event, _shape_idx) -> void:
	if Input.is_action_just_pressed("LMB") and GlobalInfo.select_ability_anybody == false:
		select()

func select() -> void:
	var data := {
			"unit" : self,
			"hp" : hp,
			"max_hp" : max_hp,
			"will" : will,
			"resist_mag_dmg" : resist_mag_dmg,
			"resist_phys_dmg" : resist_phys_dmg,
			"resist_will" : resist_will,
			"speed" : speed,
			"reaction" : reaction,
			"ability" : ability,
			"dmg_amp" : dmg_amp,
			"type" : type,
			"name" : forename,
			"icon" : icon_select
		}
	Eventbus.emit_signal('select_char', data)
	Eventbus.emit_signal("target_camera_to", global_position)

func sort_by_hp(a : Unit, b : Unit, reverse : bool) -> bool:
	match reverse:
		true:
			if a.hp > b.hp:
				return true
			return false
		false:
			if a.hp <= b.hp:
				return true
			return false
	return true

func sort_by_will(a : Unit, b : Unit, reverse : bool) -> bool:
	match reverse:
		true:
			if a.will > b.will:
				return true
			return false
		false:
			if a.will <= b.will:
				return true
			return false
	return true

