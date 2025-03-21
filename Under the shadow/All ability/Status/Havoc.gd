extends Status


func execute(unit : Unit) -> void:
	var dmg = unit.hp * _value / 100
	unit.hp -= dmg
	
func ending(_unit : Unit) -> void:
	pass
