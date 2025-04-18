extends Relic

func initiation() -> void: 
	connect("new_room", execute)

func execute() -> void: 
	GlobalInfo.souls += 12

