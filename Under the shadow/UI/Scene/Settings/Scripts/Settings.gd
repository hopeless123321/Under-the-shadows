extends Control

var reveal := false

func _ready() -> void:
	Eventbus.connect("call_setting", change)
	position = Vector2(0, -GlobalInfo.win_size.y)
	
func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("ESC") and reveal:
		change()

func change() -> void:
	reveal = !reveal
	if reveal:
		var tween_setting : Tween = create_tween()
		tween_setting.set_trans(Tween.TRANS_BACK)
		tween_setting.set_ease(Tween.EASE_IN_OUT)
		tween_setting.tween_property(self, "position", Vector2(0, 0), 1)
	else:
		var tween_setting : Tween = create_tween()
		tween_setting.set_trans(Tween.TRANS_BACK)
		tween_setting.set_ease(Tween.EASE_IN_OUT)
		tween_setting.tween_property(self, "position", Vector2(0, size.y), 1)


func _on_return_pressed() -> void:
	change()
