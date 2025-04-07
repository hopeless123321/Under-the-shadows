extends Script
class_name Skill_script

static func get_type_res(unit : Unit, type_dmg : String = "Pure") -> int:
	match type_dmg:
		"Magic":
			return unit.resist_mag_dmg
		"Physical":
			return  unit.resist_phys_dmg
		"Will":
			return unit.resist_will
	return 0

static func dmg_calc(dmg : int, unit_resist : int, dmg_amp : int) -> int:
	return dmg + (dmg * (unit_resist / 100)) + (dmg * (dmg_amp / 100))
	
static func part_of_dmg(dmg : int, resists_and_percent : Dictionary) -> int:
	return 0
