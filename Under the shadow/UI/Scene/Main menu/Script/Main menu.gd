extends Control

const PATH_TO_SAVE_FILE = "res://Save.ini"


@onready var setting : Control = $Setting
@onready var choose_difficult : VBoxContainer = $"Choose difficult"
@onready var initial : VBoxContainer = $Initial
@onready var continue_b : Button = $Initial/Continue


var MapGenerator : PackedScene = preload("res://Scenes/Dungeon generator/Generator/Map generator.tscn")

func _ready() -> void:
	if FileAccess.file_exists(PATH_TO_SAVE_FILE):
		continue_b.visible = true
	else:
		continue_b.visible = false

func _input(event : InputEvent) -> void:
	if Input.is_action_just_pressed("ESC"):
		back()
		
func back() -> void:
	choose_difficult.visible = false
	initial.visible = true

func _on_continue_pressed() -> void:
	pass

func _on_new_game_pressed() -> void:
	choose_difficult.visible = true
	initial.visible = false
	
func _on_options_pressed() -> void:
	Eventbus.emit_signal("call_setting")

func _on_about_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	Eventbus.emit_signal("save_all")
	get_tree().quit()

func _on_radiant_pressed() -> void:
	GlobalInfo.diffucult = "radiant"
	map_generated()

func _on_twilight_pressed() -> void:
	GlobalInfo.diffucult = "twilight"
	map_generated()

func _on_eclipse_pressed() -> void:
	GlobalInfo.diffucult = "eclipse"
	map_generated()
	
func map_generated() -> void:
	Teaminfo.add_ally_to_team("King")
	Teaminfo.add_ally_to_team("Skeleton spear")
	GlobalInfo.current_location = "Chambers"
	get_tree().change_scene_to_packed(MapGenerator)
