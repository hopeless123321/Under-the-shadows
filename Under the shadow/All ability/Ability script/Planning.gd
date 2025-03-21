extends Script_ability

var status = preload("res://All ability/Status/Planning.gd")

func execute(sender : Unit, _r: Unit, _ability : Base_ability) -> void:
	var instance = status.new()
	instance.duration = 1
	instance.type = 1
	instance._value = sender.dmg_amp
	sender.dmg_amp *= 2
	sender.statuses.append(instance)
	
	
	
	
