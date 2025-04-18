extends Control

@export var timer : float

var main_menu : PackedScene = load("res://UI/Scene/Main menu/Scene/Main menu.tscn")
var hide_setting : bool = true

@onready var template_level_node : Node2D = $"../.."
@onready var setting : Control = $Setting
@onready var menu : PanelContainer = $Menu
@onready var blur_screen : ColorRect = $"Blur screen"


func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("ESC"):
		hide_reveal_menu()
	if Input.is_action_just_pressed("Map"):
		Eventbus.emit_signal("reveal_map")

func hide_reveal_menu() -> void:
	hide_setting = !hide_setting
	if hide_setting:
		hiding()
	else:
		reveal()
		
func hiding() -> void:
	var blur_tween : Tween = create_tween()
	blur_tween.set_parallel()
	blur_tween.set_ease(Tween.EASE_IN_OUT)
	blur_tween.set_trans(Tween.TRANS_SINE)
	blur_tween.tween_property(blur_screen, "material:shader_parameter/blur_amount", 0, timer)
	blur_tween.tween_property(blur_screen, "material:shader_parameter/mix_amount", 0, timer)
	blur_tween.tween_property(menu, "modulate", Color(1, 1, 1, 0), timer)
	await blur_tween.finished
	visible = false

func reveal() -> void:
	visible = true
	var blur_tween : Tween = create_tween()
	blur_tween.set_parallel()
	blur_tween.set_ease(Tween.EASE_IN_OUT)
	blur_tween.set_trans(Tween.TRANS_SINE)
	blur_tween.tween_property(blur_screen, "material:shader_parameter/blur_amount", 2, timer)
	blur_tween.tween_property(blur_screen, "material:shader_parameter/mix_amount", 0.2, timer)
	blur_tween.tween_property(menu, "modulate", Color(1, 1, 1, 1), timer)

func _on_resume_pressed() -> void:
	hiding()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_diary_pressed() -> void:
	pass # Replace with function body.

func _on_setting_pressed() -> void:
	Eventbus.emit_signal("call_setting")

func _on_exit_pressed() -> void:
	Eventbus.emit_signal("save_all")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	Eventbus.emit_signal("to_main_menu")
	hiding()
	get_tree().change_scene_to_packed(main_menu)

