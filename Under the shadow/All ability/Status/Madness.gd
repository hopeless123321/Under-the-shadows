extends Status

var decrease_value := 5

func execute(unit : Unit) -> void:
	unit.will -= _value
	_value -= decrease_value
	if _value <= 0:
		ending(unit)
func ending(unit : Unit) -> void:
	unit.statuses.erase(self)
