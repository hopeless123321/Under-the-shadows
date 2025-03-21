extends Script_ability


func execute(_sender : Unit, repatients : Array[Unit], _ability : Base_ability) -> void:
	var general_hp : int = 0
	for character in repatients:
		general_hp += character.hp
	for character in repatients:
		character.hp = general_hp / repatients.size()
