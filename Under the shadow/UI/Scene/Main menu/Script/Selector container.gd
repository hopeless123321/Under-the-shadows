extends HBoxContainer
signal update_difficult_lists(level : int)
@onready var left_arrow: Button = $"Left arrow"
@onready var difficult: Label = $Difficult
@onready var right_arrow: Button = $"Right arrow"

var difficult_level : int = 0
var available : bool = false

func update(number : int) -> void:
	difficult_level = clamp(difficult_level + number, 0, 20)
	
	if difficult_level == 0:
		left_arrow.disabled = true
	elif difficult_level == 20:
		right_arrow.disabled = true
	else:
		left_arrow.disabled = false
		right_arrow.disabled = false

	difficult.text = "Level " + str(difficult_level)
	emit_signal("update_difficult_lists", difficult_level - 1)
func _on_left_arrow_pressed() -> void:
	update(-1)
func _on_right_arrow_pressed() -> void:
	update(1)
func _on_check_box_pressed() -> void:
	available = !available
	if difficult_level != 0:
		left_arrow.disabled = available
	if difficult_level != 20:
		right_arrow.disabled = available
	if available:
		difficult.text = "Level 0"
	else:
		difficult.text = "Level " + str(difficult_level)
