extends Node


var config : ConfigFile = ConfigFile.new()
var PATH_TO_CONFIG : String = "res://Config.ini"

func _ready() -> void:
	if !FileAccess.file_exists(PATH_TO_CONFIG):
		config.set_value("video", "resolution", 0)
		config.set_value("video", "vsync", 1.0)
		config.set_value("video", "fullscreen", 1.0)
		
		config.set_value("overlay", "vineete_intensity", 0.1)
		config.set_value("overlay", "vineete_opacity", 0.5)
		config.set_value("overlay", "abberation", 0.1)
		config.set_value("overlay", "brithness", 1.0)
		config.set_value("overlay", "curve_screen", 0)
		
		config.set_value("game", "enable_timer", 1.1)
		config.set_value("game", "language", 0)
		
		config.set_value("audio", "master", 100)
		config.set_value("audio", "sfx", 100)
		config.set_value("audio", "music", 100)
		config.save(PATH_TO_CONFIG)
	else:
		config.load(PATH_TO_CONFIG)

func save_video(key : String, value : float) -> void:
	config.set_value("video", key, value)
	config.save(PATH_TO_CONFIG)
	
func load_video() -> Dictionary[String, float]:
	var settings : Dictionary[String, float] = {}
	for key in config.get_section_keys("video"):
		print(key)
		settings[key] = config.get_value("video", key)
	return settings

func save_overlay(key : String, value : float) -> void:
	config.set_value("overlay", key, value)
	config.save(PATH_TO_CONFIG)

func load_overlay() -> Dictionary[String, float]:
	var settings : Dictionary[String, float] = {}
	for key in config.get_section_keys("overlay"):
		settings[key] = config.get_value("overlay", key)
	return settings

func load_game() -> Dictionary[String, float]:
	var settings : Dictionary[String, float] = {}
	for key in config.get_section_keys("game"):
		settings[key] = config.get_value("game", key)
	return settings

func save_game(key : String, value : float) -> void:
	config.set_value("game", key, value)
	config.save(PATH_TO_CONFIG)

func load_audio() -> Dictionary[String, float]:
	var settings : Dictionary[String, float] = {}
	for key in config.get_section_keys("audio"):
		settings[key] = config.get_value("audio", key)
	return settings

func save_audio(key : String, value : float) -> void:
	config.set_value("audio", key, value)
	config.save(PATH_TO_CONFIG)
