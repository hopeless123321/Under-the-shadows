extends Unit
class_name Enemy
const CLASSNAME := "Enemy"


func creation() -> void:
	connect("input_event", pressed)
	hp = max_hp
	initiation()
	add_to_group("Enemy")
	z_index = int(global_position.y / 64)

func pressed(viewport : Node, event : InputEvent, idx : int) -> void:
	if event is InputEventMouseButton and event.pressed and GlobalInfo.select_ability_anybody == false:
		select()

func find_path() -> Array[Vector2i]:
	var path_id : Array[Vector2i] = []
	var units := get_tree().get_nodes_in_group("Ally")
	match move_to:
		"Close":
			for character : Ally in units:
				Grid.temp_set_solid(character.tile_pos, false)
				if path_id.is_empty():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
				elif Grid.get_path_id(tile_pos ,character.tile_pos, free_move).size() < path_id.size():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
				Grid.temp_set_solid(character.tile_pos, true)
		"Far":
			for character : Ally in units:
				Grid.temp_set_solid(character.tile_pos, false)
				if Grid.get_path_id(tile_pos ,character.tile_pos, free_move).size() > path_id.size():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
				Grid.temp_set_solid(character.tile_pos, true)
		"Low hp":
			while path_id.is_empty():
				units.sort_custom(sort_by_hp.bind(true))
				for character in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		"High hp":
			while path_id.is_empty():
				units.sort_custom(sort_by_hp.bind(false))
				for character : Ally in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		"King":
			pass
		"Low will":
			while path_id.is_empty():
				units.sort_custom(sort_by_will.bind(false))
				for character : Ally in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		"High will":
			while path_id.is_empty():
				units.sort_custom(sort_by_will.bind(false))
				for character : Ally in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		"Random":
			units.shuffle()
			for character : Ally in units:
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
	$"AnimationPlayer".play("walk")
	var move_tween : Tween = create_tween()
	move_tween.set_ease(animation_ease)
	move_tween.set_trans(animation_trans)
	for cell in path:
		if cell.x < tile_pos.x:
			$"Store sprite/Under".flip_h = false
			$"Store sprite/Upper".flip_h = false
		elif cell.x > tile_pos.x:
			$"Store sprite/Under".flip_h = true
			$"Store sprite/Upper".flip_h = true
		move_tween.tween_property(self, "global_position", _tm.map_to_local(cell), duration)
		move_point -= 1
	await move_tween.finished
	path.clear()
	$"AnimationPlayer".play("stay")
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

