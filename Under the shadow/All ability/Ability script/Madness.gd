extends Script_ability

const name = "Madness"

var status_res = preload("res://All ability/Status/Madness.gd")
var first := true
var intitial_value := 15
var will_value := 20

func execute(_sender : Unit, repatient : Unit, _ability : Base_ability) -> void:
	if repatient.statuses.any(check_status_already.bind(name)):
		for status in repatient.statuses:
			if status.name == name:
				status._value += 10
	else:
		if first:
			first = false
			var instance = status_res.new()
			add_status(instance,
					   name, 
					   "Каждый ход будет теряться столько воли: ",
					   -1,
					   2,
					   10)
			repatient.statuses.append(instance)
		else:
			print("lol")
			repatient.will -= will_value
