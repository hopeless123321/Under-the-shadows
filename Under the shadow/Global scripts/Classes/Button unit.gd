extends Button
## Class for represent unit on Team
class_name Unit_button

## Storage information about unit that represent on Evolution tree
var unit_info : UnitOnTeam

func _ready() -> void:
	connect("button_down", delete_unused)
## Delete new unit if he doesn't assign with some unit on Evolution tree 
func delete_unused() -> void:
	if unit_info == null and name != "New unit":
		queue_free()
## Update information about unit if he assign with somebody in Evolution tree
func update(new_unit_info : UnitOnTeam) -> void:
	connect("mouse_entered", func() -> void: Eventbus.emit_signal("get_unit_on_team", unit_info))
	text = ""
	unit_info = new_unit_info
	icon = unit_info.icon_minimap
	
