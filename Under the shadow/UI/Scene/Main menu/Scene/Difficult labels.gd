extends VBoxContainer

var old_number : int = -1
var ascend : bool = false

func update_lists(level: int) -> void:
	get_child(max(old_number, level)).visible = !get_child(max(old_number, level)).visible
	old_number = level


func _on_check_box_pressed() -> void:
	ascend = !ascend
	if ascend:
		for level_l : Label in get_children():
			level_l.visible = false
	else:
		for level_l : Label in get_children().slice(0, old_number + 1):
			level_l.visible = true
	
