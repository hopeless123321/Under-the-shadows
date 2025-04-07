extends Control

@onready var tree_creature = $"CanvasLayer/Tree creature"
@onready var ui_unit_prop = $"CanvasLayer/UI on map/UI unit prop"



const TIMER : float = 1.5

func _physics_process(delta):
	print(ui_unit_prop.position)
func _on_to_evolution_mouse_entered():
	var move_tween = create_tween()
	move_tween.set_parallel()
	move_tween.set_ease(Tween.EASE_OUT)
	move_tween.set_trans(Tween.TRANS_BOUNCE)
	move_tween.tween_property(tree_creature, "position", Vector2(0,0), TIMER)
	move_tween.tween_property(ui_unit_prop, "position", Vector2(0,0), TIMER)

