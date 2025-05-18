@icon("res://Global scripts/Classes/Icons/Portal.svg")
extends Sprite2D
class_name Portal

var port : int
var tile_pos:
	get: 
		return  global_position / 64
var active : bool


func _ready() -> void:
	Eventbus.connect("end_turn_all", 
		func() -> void: 
			active = true)
	
