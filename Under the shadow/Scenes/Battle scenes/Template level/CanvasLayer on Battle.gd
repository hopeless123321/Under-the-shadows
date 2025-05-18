extends CanvasLayer


func _ready() -> void:
	Eventbus.connect("reveal_map", reveal_hide_map)

func reveal_hide_map() -> void:
	visible = !visible
