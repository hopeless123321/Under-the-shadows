extends Script_ability

@export var damage : int = 30

func execute(sender : Unit, repatient : Unit, _ability : Base_ability) -> void:
	var value = floor(calc_dmg(damage, sender.dmg_amp, repatient.resist_phys_dmg))
	repatient.hp -= value
	sender.hp -= 10
	sender.hp += value * 2
	sender.select()
