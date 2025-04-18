extends Node2D

const OFFSET : Vector2 = Vector2(8,8)
@onready var team_selection: TextureRect = $"Team selection"


var current_location_team : Room:
	set(value):
		if current_location_team != null:
			current_location_team.team_exit()
		current_location_team = value
		team_selection.global_position = current_location_team.global_position - OFFSET
		current_location_team.team_enter()

func available_room(target_room : Room) -> bool:
	if target_room in current_location_team.connected_room:
		return true
	return false
