extends HBoxContainer

@onready var left_button : Button = $"Left button"
@onready var right_button : Button = $"Right button"
@onready var relic_handler: HBoxContainer = $"Relic Stash/Relic handler"
@onready var relic_stash: Control = $"Relic Stash"
@onready var ui_on_map: Control = $"../../../.."

var page_count : int
var current_page : int:
	set(value):
		current_page = clamp(value, 0, page_count)
		move_handler(current_page * -relic_stash.size.x) 
		if value == 0:
			left_button.disabled = true
		else:
			left_button.disabled = false
		if value == page_count:
			right_button.disabled = true
		else:
			right_button.disabled = false

func _ready() -> void:
	_on_ui_on_map_resized()

func move_handler(to_position_x : int) -> void:
	var move_tween : Tween = create_tween()
	move_tween.set_ease(Tween.EASE_IN_OUT)
	move_tween.set_trans(Tween.TRANS_SINE)
	move_tween.tween_property(relic_handler, "position", Vector2(to_position_x, 0), 1)

func _on_left_button_pressed() -> void:
	current_page -= 1

func _on_right_button_pressed() -> void:
	current_page += 1

func _on_ui_on_map_resized() -> void:
	if is_node_ready():
		relic_stash.custom_minimum_size.x = snapped(ui_on_map.size.x - 1160, 64)
		relic_handler.position.x = 0
		page_count = ceil(relic_handler.get_child_count() * 64 / relic_stash.custom_minimum_size.x) + 1
		current_page = 0
