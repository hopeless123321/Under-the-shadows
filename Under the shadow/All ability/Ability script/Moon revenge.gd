extends Script_ability

@export var damage := 10


func execute(sender : Unit, repatient : Unit, ability : Base_ability) -> void:
	if sender != repatient:
		var dmg = calc_dmg_from_radius(damage, sender.dmg_amp, repatient.resist_mag_dmg, sender.tile_pos, repatient.tile_pos)
		repatient.hp -= dmg
