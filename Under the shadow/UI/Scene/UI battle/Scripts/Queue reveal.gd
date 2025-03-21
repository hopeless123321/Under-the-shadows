extends Panel

var queue : Array[Unit]
var icon_text = preload("res://UI/Scene/UI battle/Scene/Icon.tscn")

func _on_texture_rect_mouse_entered():
	if $HBoxContainer.get_child_count() > 1:
		return
	Eventbus.emit_signal("give_queue", self)
	var tween_reveal = create_tween()
	tween_reveal.set_trans(Tween.TRANS_QUART)
	tween_reveal.set_ease(Tween.EASE_IN_OUT)
	tween_reveal.tween_property(self,"custom_minimum_size", Vector2(64 * (queue.size() + 1), 64), 1)
	for unit in queue:
		var queue_icon = icon_text.instantiate()
		$HBoxContainer.add_child(queue_icon)
		queue_icon.texture = unit.icon_select
		queue_icon.unit = unit
		


func _on_mouse_exited():
	await get_tree().create_timer(0.5).timeout
	var tween_reveal = create_tween()
	tween_reveal.set_trans(Tween.TRANS_QUART)
	tween_reveal.set_ease(Tween.EASE_IN_OUT)
	tween_reveal.tween_property(self,"custom_minimum_size", Vector2(64, 64), 1)
	await get_tree().create_timer(1).timeout
	for icon_select in $HBoxContainer.get_children():
		icon_select.queue_free()
