extends Control

var reveal : bool = false
@export var timer : float = 1.0
@onready var team_container : GridContainer = $"UI Evolve/PanelContainer/Teaminfo/Team container"

func reveal_hide_tree() -> void:
	reveal = !reveal
	if reveal:
		reveal_tree()
		team_container.update()
	else:
		hide_tree()
		
func reveal_tree() -> void:
	var move_tween := create_tween()
	move_tween.set_parallel()
	move_tween.set_ease(Tween.EASE_IN_OUT)
	move_tween.set_trans(Tween.TRANS_SINE)
	move_tween.tween_property(self, "position", Vector2(0,0), timer)

	
func hide_tree() -> void:
	var move_tween := create_tween()
	move_tween.set_parallel()
	move_tween.set_ease(Tween.EASE_IN_OUT)
	move_tween.set_trans(Tween.TRANS_SINE)
	move_tween.tween_property(self, "position", Vector2(0, -GlobalInfo.win_size.y), timer)
