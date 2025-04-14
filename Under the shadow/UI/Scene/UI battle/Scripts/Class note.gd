extends Label

var selected_unit : Unit

func _ready() -> void:
	Eventbus.connect("select_char", update_ui)
	Eventbus.connect("update_prop_ui", update_prop_ui)
	
func update_ui(unit : Unit) -> void:
	text = ""
	text += unit.forename + "\n"
	for type in unit.type:
		text += type + ', '
	text = text.erase(text.length() - 2, 2)
	
func update_prop_ui() -> void:
	selected_unit.select()



