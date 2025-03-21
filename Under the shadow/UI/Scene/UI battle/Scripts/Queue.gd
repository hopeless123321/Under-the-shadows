extends NinePatchRect

var to_hide := false
var queue : Array[Unit]
var icon_scene := preload("res://UI/Scene/UI battle/Scene/Icon.tscn")
@onready var container = $"../Stash queue"
@onready var h_box_container = $"../Stash queue/HBoxContainer"


func _input(_event):
	if Input.is_action_just_pressed("Queue"):
		to_hide = !to_hide
		if to_hide:
			reveal()
		else: 
			hiding()

func reveal() -> void:
	for icon in h_box_container.get_children():
		icon.queue_free()
	Eventbus.emit_signal("give_queue", self)
	for character in queue:
		var icon_queue = icon_scene.instantiate()
		icon_queue.unit = character
		icon_queue.texture = character.icon_select
		h_box_container.add_child(icon_queue)
	var tween_reveal = create_tween()
	tween_reveal.set_ease(Tween.EASE_IN_OUT)
	tween_reveal.set_trans(Tween.TRANS_CUBIC)
	tween_reveal.set_parallel()
	tween_reveal.tween_property(self, "custom_minimum_size", Vector2(96 + queue.size() * 64, 64), 1)
	tween_reveal.tween_property(self, "modulate", Color(1,1,1,1), 1)
	tween_reveal.tween_property(container,"custom_minimum_size", Vector2(queue.size() * 64, 64), 1)
	tween_reveal.tween_property(container, "modulate", Color(1,1,1,1), 1)

func hiding() -> void:
	var tween_reveal = create_tween()
	tween_reveal.set_parallel()
	tween_reveal.set_ease(Tween.EASE_IN_OUT)
	tween_reveal.set_trans(Tween.TRANS_CUBIC)
	tween_reveal.tween_property(self, "custom_minimum_size", Vector2(96, 64), 1)
	tween_reveal.tween_property(self, "modulate", Color(1,1,1,0), 1)
	tween_reveal.tween_property(container, "custom_minimum_size", Vector2(0,64), 1)
	tween_reveal.tween_property(container, "modulate", Color(1,1,1,0), 1)

