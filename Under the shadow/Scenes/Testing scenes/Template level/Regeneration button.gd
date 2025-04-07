extends Button

@onready var template_level_node = $"../.."

func _on_pressed() -> void:
	Eventbus.emit_signal("reveal_map", false)
	Eventbus.emit_signal("update_end_battle")
	for unit in get_tree().get_nodes_in_group("Ally"):
		Teaminfo.team.append(unit)
	template_level_node.queue_free()
	
