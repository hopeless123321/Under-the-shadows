extends Control

@export var relic : Relic

@onready var icon: TextureRect = $Icon

func _on_gui_input(event: InputEvent) -> void:
	scale_up()
	
func _on_mouse_exited() -> void:
	scale_down()

func scale_up() -> void:
	var scale_up_tween : Tween = create_tween()
	scale_up_tween.set_ease(Tween.EASE_IN_OUT)
	scale_up_tween.set_trans(Tween.TRANS_SINE)
	scale_up_tween.tween_property(icon, "scale", Vector2(1.1, 1.1), 0.5)

func scale_down() -> void:
	var scale_up_tween : Tween = create_tween()
	scale_up_tween.set_ease(Tween.EASE_IN_OUT)
	scale_up_tween.set_trans(Tween.TRANS_SINE)
	scale_up_tween.tween_property(icon, "scale", Vector2(1, 1), 0.5)

