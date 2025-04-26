extends HBoxContainer

const STATUS_EFFECT_ICON = preload("res://UI/Scene/UI battle/Scene/Status effect icon.tscn")


func add_status(status_effect : StatusEffect) -> void:
	var icon = STATUS_EFFECT_ICON.instantiate()
	icon.texture = status_effect.mini_icon
	icon.get_child(0).text = status_effect.prop_on_label()
	add_child(icon)
	
func update_status_ui(idx : int, status_effect : StatusEffect) -> void:
	get_child(idx).get_child(0).text = status_effect.prop_on_label()
	
func delete_excess(idx : int) -> void:
	get_child(idx).queue_free()
