extends Button

@onready var template_level_node : Node2D = $"../.."

func _on_pressed() -> void:
	Eventbus.emit_signal("reveal_map")
	Eventbus.emit_signal("update_end_battle")
	template_level_node.get_parent().queue_free()
	
