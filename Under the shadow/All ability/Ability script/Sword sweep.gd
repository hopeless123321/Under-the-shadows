extends Script_ability

var dmg = 34
func execute(sender : Unit, repatient : Unit, _ability : Base_ability) -> void:
	var final_dmg := calc_dmg(dmg, sender.dmg_amp, repatient.resist_phys_dmg)
	repatient.hp -= floor(final_dmg)
