extends Unit
## Unit that controlled by AI
class_name Enemy
const CLASSUNIT := Skill.TypeAppUnit.Enemy
## 	Move to that target until he died
var target : Unit

## First func to create Enemy
func creation() -> void:
	connect("input_event", pressed)
	initiation()
	add_to_group("Enemy")
	z_index = int(global_position.y / 64)

func pressed(viewport : Node, event : InputEvent, idx : int) -> void:
	if event is InputEventMouseButton and event.pressed and GlobalInfo.select_ability_anybody == false:
		select()

func find_path() -> Array[Vector2i]:
	var path_id : Array[Vector2i] = []
	var units := get_tree().get_nodes_in_group("Ally")
	match unit_property.enemy_move_to:
		UnitProp.EnemyTarget.Close:
			for character : Ally in units:
				Grid.temp_set_solid(character.tile_pos, false)
				if path_id.is_empty():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, unit_property.free_move)
				elif Grid.get_path_id(tile_pos ,character.tile_pos, unit_property.free_move).size() < path_id.size():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, unit_property.free_move)
				Grid.temp_set_solid(character.tile_pos, true)
		UnitProp.EnemyTarget.Far:
			for character : Ally in units:
				Grid.temp_set_solid(character.tile_pos, false)
				if Grid.get_path_id(tile_pos ,character.tile_pos, unit_property.free_move).size() > path_id.size():
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, unit_property.free_move)
				Grid.temp_set_solid(character.tile_pos, true)
		UnitProp.EnemyTarget.LowHp:
			while path_id.is_empty():
				units.sort_custom(sort_by_hp.bind(true))
				for character in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, unit_property.free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		UnitProp.EnemyTarget.HighHp:
			while path_id.is_empty():
				units.sort_custom(sort_by_hp.bind(false))
				for character : Ally in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, unit_property.free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		UnitProp.EnemyTarget.King:
			pass
		UnitProp.EnemyTarget.LowWill:
			while path_id.is_empty():
				units.sort_custom(sort_by_will.bind(false))
				for character : Ally in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, unit_property.free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		UnitProp.EnemyTarget.HighWill:
			while path_id.is_empty():
				units.sort_custom(sort_by_will.bind(false))
				for character : Ally in units:
					Grid.temp_set_solid(character.tile_pos, false)
					path_id = Grid.get_path_id(tile_pos, character.tile_pos, unit_property.free_move)
					Grid.temp_set_solid(character.tile_pos, true)
		UnitProp.EnemyTarget.Random:
			units.shuffle()
			for character : Ally in units:
				if path_id.is_empty():
					break
				Grid.temp_set_solid(character.tile_pos, false)
				path_id = Grid.get_path_id(tile_pos, character.tile_pos, unit_property.free_move)
				Grid.temp_set_solid(character.tile_pos, true)
	for i in unit_property.distance + 1:
		path_id.pop_back()
	if path_id.size() > unit_property.speed:
		path_id.resize(unit_property.speed)
	return path_id

func move_to_target() -> void:
	$"AnimationPlayer".play("walk")
	var move_tween : Tween = create_tween()
	move_tween.set_ease(unit_property.animation_ease)
	move_tween.set_trans(unit_property.animation_trans)
	for cell in path:
		if cell.x < tile_pos.x:
			$"Store sprite/Under".flip_h = false
			$"Store sprite/Upper".flip_h = false
		elif cell.x > tile_pos.x:
			$"Store sprite/Under".flip_h = true
			$"Store sprite/Upper".flip_h = true
		move_tween.tween_property(self, "global_position", _tm.map_to_local(cell), unit_property.duration)
		move_point -= 1
	await move_tween.finished
	path.clear()
	$"AnimationPlayer".play("stay")

func select() -> void:
	Eventbus.emit_signal('select_char', self)
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

