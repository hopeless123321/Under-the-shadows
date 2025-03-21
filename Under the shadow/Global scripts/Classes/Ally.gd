extends Unit
class_name Ally
const Classname := "Ally"

func _ready() -> void:
	_initiation()
	add_to_group("Ally")
	z_index = round(global_position.y / 64)

func fill_floor() -> void:
	for y in range(-move_point, move_point+1):
		for x in range(-move_point, move_point+1):
			var right_tile_pos = Vector2i(x,y) + tile_pos
			if Grid.check_point_in_grid(right_tile_pos) and abs(x) + abs(y) <= move_point:
				if Grid.is_point_solid(right_tile_pos) == false:
					if Grid.get_path_id(tile_pos, right_tile_pos, free_move).size() <= move_point:
						_tm.set_cell(2,right_tile_pos,6,Vector2i(0,2))

func move_to_target() -> void:
	pointer_curve += get_physics_process_delta_time()
	z_index = round(global_position.y / 64)
	var target_position = _tm.map_to_local(path.front())
	if target_position.x < global_position.x:
		$Sprite2D.flip_h = false
	elif target_position.x > global_position.x:
		$Sprite2D.flip_h = true
	global_position = global_position.move_toward(target_position,
												  move_curve.sample_baked(pointer_curve))
	if global_position == target_position:
		move_point -= 1
		pointer_curve = 0
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
