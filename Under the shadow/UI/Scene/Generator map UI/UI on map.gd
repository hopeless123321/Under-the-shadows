extends Control

@onready var spells : Control = $Spells
@onready var tree_creature : Control = $"../Tree creature"

const TIMER : float = 1.5
var to_main_enable : bool = true
var to_evolve_enable : bool = true

func _on_to_spell_mouse_entered() -> void:
	var reveal_tween : Tween = create_tween()
	reveal_tween.set_trans(Tween.TRANS_SINE)
	reveal_tween.set_ease(Tween.EASE_IN_OUT)
	reveal_tween.tween_property(spells, "position", Vector2(GlobalInfo.win_size.x - 480, spells.position.y), TIMER)

func _on_panel_mouse_exited() -> void:
	var reveal_tween : Tween = create_tween()
	reveal_tween.set_trans(Tween.TRANS_SINE)
	reveal_tween.set_ease(Tween.EASE_IN_OUT)
	reveal_tween.tween_property(spells, "position", Vector2(GlobalInfo.win_size.x, spells.position.y), TIMER)

func _on_to_evolution_mouse_entered() -> void:
	if to_evolve_enable:
		to_main_enable = false
		var move_tween = create_tween()
		move_tween.set_parallel()
		move_tween.set_ease(Tween.EASE_OUT)
		move_tween.set_trans(Tween.TRANS_BOUNCE)
		move_tween.tween_property(tree_creature, "position", Vector2(0,0), TIMER)
		await move_tween.finished
		to_main_enable = true

func _on_to_main_mouse_entered() -> void:
	if to_main_enable:
		to_evolve_enable = false
		var move_tween : Tween = create_tween()
		move_tween.set_parallel()
		move_tween.set_ease(Tween.EASE_IN_OUT)
		move_tween.set_trans(Tween.TRANS_SINE)
		move_tween.tween_property(tree_creature, "position", Vector2(0, -GlobalInfo.win_size.y), TIMER)
		await move_tween.finished
		to_evolve_enable = true
