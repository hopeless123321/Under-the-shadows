extends Resource
class_name Status

var name : String
var text_for_tooltip : String
var duration := 0
var type : Type
var _value : float
enum Type {Constant, Once, Changing}


func calc_resist(value : int, resist : float) -> float:
	return value / resist
	
