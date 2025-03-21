extends Script_ability

@export var damage : int = 30
@export var will_dmg : int = 35

func execute(sender : Unit, repatient : Unit, _ability : Base_ability) -> void:
	var final_dmg_phys = floor(calc_dmg(damage, sender.dmg_amp, repatient.resist_mag_dmg))
	var final_dmg_will = floor(calc_dmg(will_dmg, 1, repatient.resist_will))
	repatient.hp -= final_dmg_phys
	repatient.will -= final_dmg_will
