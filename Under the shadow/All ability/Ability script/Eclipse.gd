extends Script_ability


func execute(sender : Unit, repatient : Unit, _ability : Base_ability) -> void:
	var damage = 100 - repatient.will
	var final_dmg = calc_dmg(damage, sender.dmg_amp, repatient.resist_mag_dmg)
	repatient.hp -= final_dmg
