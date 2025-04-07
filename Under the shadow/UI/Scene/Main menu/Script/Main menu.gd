extends Control

const PATH_TO_SAVE_FILE = "res://Save.ini"


@onready var setting = $Setting
@onready var choose_difficult = $"Choose difficult"
@onready var initial = $Initial
@onready var continue_b = $Initial/Continue

var MapGenerator : PackedScene = preload("res://Scenes/Dungeon generator/Generator/Map generator.tscn")

func _ready() -> void:
	if FileAccess.file_exists(PATH_TO_SAVE_FILE):
		continue_b.visible = true
	else:
		continue_b.visible = false

func _input(event) -> void:
	if Input.is_action_just_pressed("ESC"):
		back()
		
func back() -> void:
	choose_difficult.visible = false
	initial.visible = true

func _on_continue_pressed() -> void:
	print("211")
func _on_new_game_pressed() -> void:
	print("12")
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
	Teaminfo.add_unit("King")
	GlobalInfo.current_location = "Chambers"
	get_tree().change_scene_to_packed(MapGenerator)
