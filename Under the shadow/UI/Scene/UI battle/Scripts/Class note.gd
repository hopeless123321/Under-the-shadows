extends Label

var selected_unit : Unit

func _ready() -> void:
	Eventbus.connect("select_char", update_ui)
	Eventbus.connect("update_prop_ui", update_prop_ui)
	
func update_ui(data : Dictionary) -> void:
	selected_unit = data["unit"]
	text = ""
	print(selected_unit.forename)
	text += data["name"] + "\n"
	for type in data['type']:
		text += type + ', '
	text = text.erase(text.length() - 2, 2)
	
func update_prop_ui() -> void:
	selected_unit.select()



