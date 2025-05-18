extends States

const EXCEPTION : Array[Skill.TypeApplication] = [Skill.TypeApplication.TargetsArea, Skill.TypeApplication.TargetsWorld]
const NO_CHANGE_SKILL_TYPE : Array[Skill.TypeApplication] = [Skill.TypeApplication.AllArea, Skill.TypeApplication.AllWorld]

var skill : Skill
var varuable_mouse_pos : Array[Vector2i]
var effect_unit : Array[Unit]:
	set(value):
		if !value.is_empty():
			Eventbus.emit_signal("reveal_result_skill", skill.reveal_result_action(unit, value))
		else: 
			Eventbus.emit_signal("reveal_result_skill", "No target")
		effect_unit = value
var tile_pos_mouse : Vector2i:
	set(value):
		if value != tile_pos_mouse:
			unit._tm.clear_cells(varuable_mouse_pos)
			tile_pos_mouse = value
			if skill.type_application in [Skill.TypeApplication.TargetsArea, Skill.TypeApplication.TargetsWorld]:
				unit._tm.update(skill, tile_pos_mouse, varuable_mouse_pos, true, unit.tile_pos)
			else:
				if effect_unit != unit._tm.update(skill, tile_pos_mouse, varuable_mouse_pos, true, unit.tile_pos):
					effect_unit = unit._tm.update(skill, tile_pos_mouse, varuable_mouse_pos, true, unit.tile_pos)

func start():
	GlobalInfo.select_ability_anybody = true
	varuable_mouse_pos.append_array(unit._tm.init(skill, unit.tile_pos, true))
	if skill.TypeApplication in NO_CHANGE_SKILL_TYPE:
		Eventbus.emit_signal("reveal_result_skill", skill.reveal_result_action(unit, effect_unit))

func update():
	tile_pos_mouse = floor(get_global_mouse_position() / 64)
	if Input.is_action_just_pressed("RMB"):
		if EXCEPTION.has(skill.type_application) and tile_pos_mouse in varuable_mouse_pos:
			if effect_unit.size() < skill.targets:
				effect_unit.append(unit._tm.add_unit_exec(tile_pos_mouse))
			else:
				effect_unit.append(unit._tm.add_unit_exec(tile_pos_mouse, effect_unit.front().tile_pos))
				effect_unit.pop_front()
	if Input.is_action_just_pressed("LMB") and !effect_unit.is_empty():
		skill.cooldown_timer = skill.cooldown
		SkillManager.execute(skill, effect_unit, unit)
		return unit._st.end_turn
	if Input.is_action_just_pressed("ESC"):
		return unit._st.wait

func end():
	Eventbus.emit_signal("select_char", unit)
	Eventbus.emit_signal("update_prop_ui")
	unit._tm.clear_layer(2)
	unit._tm.clear_layer(3)
	GlobalInfo.select_ability_anybody = false
