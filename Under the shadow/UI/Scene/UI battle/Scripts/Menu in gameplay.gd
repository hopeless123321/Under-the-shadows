extends Control

@onready var blur_screen : ColorRect = $"Blur screen"
@onready var panel_container: PanelContainer = $PanelContainer
@onready var setting : Control = $Setting
@export var timer : float
var dodos : bool = true
var hide_setting : bool = true
func _input(_event):
	if Input.is_action_just_pressed("ESC") and dodos:
		hide_setting = !hide_setting
		dodos = false
		if hide_setting:
			hiding()
		else:
			reveal()
		await get_tree().create_timer(timer).timeout
		dodos = true
	if Input.is_action_just_pressed("Map"):
		Eventbus.emit_signal("reveal_map")
		
func hiding() -> void:
	var blur_tween = create_tween()
	blur_tween.set_parallel()
	blur_tween.set_ease(Tween.EASE_IN_OUT)
	blur_tween.set_trans(Tween.TRANS_SINE)
	blur_tween.tween_property(blur_screen, "material:shader_parameter/blur_amount", 0, timer)
	blur_tween.tween_property(blur_screen, "material:shader_parameter/mix_amount", 0, timer)
	blur_tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 0), timer)
	await blur_tween.finished
	visible = false

func reveal() -> void:
	visible = true
	var blur_tween = create_tween()
	blur_tween.set_parallel()
	blur_tween.set_ease(Tween.EASE_IN_OUT)
	blur_tween.set_trans(Tween.TRANS_SINE)
	blur_tween.tween_property(blur_screen, "material:shader_parameter/blur_amount", 2, timer)
	blur_tween.tween_property(blur_screen, "material:shader_parameter/mix_amount", 0.2, timer)
	blur_tween.tween_property(panel_container, "modulate", Color(1, 1, 1, 1), timer)

func _on_resume_pressed():
	hiding()

func _on_restart_pressed():
	pass # Replace with function body.


func _on_diary_pressed():
	pass # Replace with function body.


func _on_setting_pressed() -> void:
	Eventbus.emit_signal("call_setting")

func _on_exit_pressed():
	Eventbus.emit_signal("save_all")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_main_menu_pressed():
	Eventbus.emit_signal("reveal_map")
