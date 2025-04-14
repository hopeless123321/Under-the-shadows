extends Node2D


var current_location_team : Room

func available_room(target_room : Room) -> bool:
	if target_room in current_location_team.connected_room:
		return true
	return false
