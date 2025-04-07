extends Node

func get_group(skill : Skill, ally : bool) -> String:
	if ally:
		match skill.type_unit:
			"Ally":
				return "Ally"
			"Enemy":
				return "Enemy"
	match skill.type_unit:
		"Ally":
			return "Ally"
		"Enemy":
			return "Enemy"
	return "Units"

func check_class(ally : bool , receiver : Unit, type_rec : String) -> bool:
	if ally:
		if type_rec == "Either" or receiver.CLASSNAME == type_rec:
			return true
		return false
	if type_rec == "Either" or receiver.CLASSNAME != type_rec:
		return true
	return false

func fill_obs(init_pos : Vector2i, radius : int) -> Array[Vector2i]:
	var vectors : Array[Vector2i] = []
	for cell in get_edge_cell(init_pos, radius):
		vectors.append_array(Grid.valid_line_skill(init_pos, cell))
	return vectors

func calc_length(length : int, sender_tile_pos : Vector2i, reciever_tile_pos : Vector2i) -> bool:
	if sender_tile_pos.x - reciever_tile_pos.x + sender_tile_pos.y - reciever_tile_pos.y <= length:
		return true
	return false

func get_edge_cell(init_pos : Vector2i, radius : int) -> Array[Vector2i]:
	var points : Array[Vector2i] = []
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			if abs(x) + abs(y) == radius or abs(x) == abs(y) and abs(x) + abs(y) == radius - 1:
				points.append(Vector2i(x, y) + init_pos)
	return points

func dir_with_vec(vectors : Array[Vector2i], dir : Vector2i, init_pos : Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell in vectors:
		if dir.x != 0:
			cells.append(Vector2i(cell.x * dir.x, cell.y) + init_pos)
		elif dir.y != 0:
			cells.append(Vector2i(cell.y, cell.x * dir.y) + init_pos)
	return cells

func dir_without_vec(length : int, start_point : Vector2i, end_point : Vector2i) -> Array[Vector2i]:
	var cells : Array[Vector2i] = []
	if start_point != end_point:
		var dx = start_point.x - end_point.x
		var dy = start_point.y - end_point.y
		var step = max(abs(dx),abs(dy))
		var inc_x = float(dx) / float(step)
		var inc_y = float(dy) / float(step)
		for steps in step + 1:
			cells.append(start_point - Vector2i(round(Vector2(inc_x*steps, inc_y*steps))))
	return cells.slice(0, length)

func execute(skill : Skill, units : Array[Unit], sender : Unit) -> void:
	var typed : Array[String] = skill.get_type_array()
	sender.hp -= skill.cost_hp
	sender.will -= skill.cost_will
	if "Heal" in typed:
		skill.skill_script.heal(skill, units, sender)
	if "Dmg" in typed:
		skill.skill_script.dmg(skill, units, sender)
	if "Status" in typed:
		skill.skill_script.set_status(skill, units, sender)
	if "Spawn" in typed:
		skill.skill_script.spawn(skill, units, sender)
	if "Move" in typed:
		skill.skill_script.move(skill, units, sender)
	if "Push" in typed:
		skill.skill_script.push(skill, units, sender)
	
