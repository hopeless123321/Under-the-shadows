extends Button



func _on_pressed() -> void:
	GlobalInfo.party_info.clear()
	for character in get_tree().get_nodes_in_group("Ally"):
		var data : Dictionary
		data["name"] = character.forename
		data["max_hp"] = character.max_hp
		data["hp"] = character.hp
		data["dmg_amp"] = character.dmg_amp
		data["will"] = character.will
		data["speed"] = character.speed
		data["resist_mag_dmg"] = character.resist_mag_dmg
		data["resist_phys_dmg"] = character.resist_phys_dmg
		data["resist_mag_dmg"] = character.resist_mag_dmg
		data["resist_will"] = character.resist_will
		data["ability"] = character.ability
		GlobalInfo.party_info.append(data)
	Eventbus.emit_signal("new_level")
	get_tree().reload_current_scene()
	
