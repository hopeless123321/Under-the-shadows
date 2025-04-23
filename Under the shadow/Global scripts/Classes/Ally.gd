extends Unit
## Class represent additional funtional for players-controlled unit on game 
class_name Ally
const CLASSUNIT := Skill.TypeAppUnit.Ally
## First function to create ally on scene
func creation() -> void:
	initiation()
	connect("input_event", pressed)
	add_to_group("Ally")
	z_index = round(global_position.y / 64)
## Create area around character that represent possible cells for move on that turn
func fill_floor() -> void:
	for y in range(-move_point, move_point+1):
		for x in range(-move_point, move_point+1):
			var right_tile_pos : Vector2i = Vector2i(x,y) + tile_pos
			if Grid.check_point_in_grid(right_tile_pos) and abs(x) + abs(y) <= move_point:
				if Grid.is_point_solid(right_tile_pos) == false:
					if Grid.get_path_id(tile_pos, right_tile_pos, unit_property.free_move).size() <= move_point:
						_tm.set_cell(2, right_tile_pos, 6, Vector2i(3, 0))
## Move align path
func move_to_target() -> void:
	$"AnimationPlayer".play("walk")
	var move_tween : Tween = create_tween()
	move_tween.set_ease(unit_property.animation_ease)
	move_tween.set_trans(unit_property.animation_trans)
	for cell : Vector2i in path:
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
## Input for emit signal select
func pressed(viewport : Node, event : InputEvent, idx : int) -> void:
	if event is InputEventMouseButton and event.pressed and GlobalInfo.select_ability_anybody == false:
		select()
## Target camera and reveal information on UI about Unit 
func select() -> void: 
	Eventbus.emit_signal('select_char', self)
	Eventbus.emit_signal("target_camera_to", global_position)
