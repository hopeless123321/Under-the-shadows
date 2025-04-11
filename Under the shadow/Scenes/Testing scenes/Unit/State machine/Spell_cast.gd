extends States

var skill : Skill
var varuable_mouse_pos : Array[Vector2i]
var effect_unit : Array[Unit]
var tile_pos_mouse : Vector2i:
	set(value):
		if value != tile_pos_mouse:
			unit._tm.clear_cells(varuable_mouse_pos)
			tile_pos_mouse = value
			if skill.type_application == "Targets area":
				unit._tm.update(skill, tile_pos_mouse, varuable_mouse_pos, true, unit.tile_pos)
			else:
				effect_unit = unit._tm.update(skill, tile_pos_mouse, varuable_mouse_pos, true, unit.tile_pos)

const EXCEPTION : Array[String] = ["Targets area", "Targets in world"]

func start():
	GlobalInfo.select_ability_anybody = true
	varuable_mouse_pos.append_array(unit._tm.init(skill, unit.tile_pos, true))

func update():
	tile_pos_mouse = floor(get_global_mouse_position() / 64)
	if Input.is_action_just_pressed("RMB"):
		if EXCEPTION.has(skill.type_application) and tile_pos_mouse in varuable_mouse_pos:
			if effect_unit.size() < skill.targets:
				effect_unit.append(unit._tm.add_unit_exec(tile_pos_mouse))
			else:
				effect_unit.append(unit._tm.add_unit_exec(tile_pos_mouse, effect_unit.front().tile_pos))
				effect_unit.pop_front()
	if Input.is_action_just_pressed("LMB"):
		skill.cooldown_timer = skill.cooldown
		SkillManager.execute(skill, effect_unit, unit)
		return unit._st.end_turn
	if Input.is_action_just_pressed("ESC"):
		return unit._st.wait

func end():
	Eventbus.emit_signal("update_prop_ui")
	unit._tm.clear_layer(2)
	unit._tm.clear_layer(3)
	GlobalInfo.select_ability_anybody = false
