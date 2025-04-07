extends Skill_script

const damage : int = 10	
static func dmg(skill : Skill, units : Array[Unit], sender : Unit) -> void:
	for unit in units: 
		unit.hp -= dmg_calc(damage, get_type_res(unit), sender.dmg_amp)

static func heal(skill : Skill, units : Array[Unit], sender : Unit) -> void:
	for unit in units:
		sender.hp += dmg_calc(damage, get_type_res(unit), sender.dmg_amp) / 4
	
