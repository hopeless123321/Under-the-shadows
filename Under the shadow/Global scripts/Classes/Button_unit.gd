extends Button
class_name Unit_button

var unit_info : Unit_res


func _ready() -> void:
	connect("button_down", delete_unused)
	
func delete_unused() -> void:
	if unit_info == null and name != "New unit":
		queue_free()

func update(new_unit_info : Unit_res) -> void:
	text = ""
	unit_info = new_unit_info
	icon = unit_info.icon_select
