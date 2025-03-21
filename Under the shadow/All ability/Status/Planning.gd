extends Status


func ending(unit: Unit) -> void:
	unit.dmg_amp -= _value
