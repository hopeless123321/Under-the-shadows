extends Resource
class_name ProbabiltyRoomSpawn

@export var probabality_room : Dictionary[Room.TypeRoom, int]:
	set(value): 
		probabality_room = value
		general_probabilty = probabality_room.values().reduce(
			func(value, accum): return accum + value
			)
var general_probabilty : int
	
