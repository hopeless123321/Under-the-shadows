extends Control
class_name UnitOnShop

const SHOP_POPUP = preload("res://UI/Scene/Generator map UI/Rooms/Shop popup.tscn")

var unit : UnitOnTeam

@onready var shop: Shop = $"../../../../../../.."
@onready var hp_bar: TextureProgressBar = %"Hp bar"
@onready var will_bar: TextureProgressBar = %"Will bar"
@onready var hp_up: Button = %"Hp up"
@onready var will_up: Button = %"Will up"
@onready var unit_icon: TextureRect = $"MarginContainer/VBoxContainer/PanelContainer/Unit icon"


func set_param(unit_team : UnitOnTeam) -> void:
	unit =  unit_team
	unit_icon.texture = unit.icon_minimap
	hp_bar.max_value = unit.max_hp
	hp_bar.value = unit.hp
	will_bar.value = unit.will

func _on_hp_up_pressed() -> void:
	hp_up.disabled = true


func _on_will_up_pressed() -> void:
	will_up.disabled = true
	
func _on_panel_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_MASK_RIGHT and event.pressed:
			var popup : PanelContainer = SHOP_POPUP.instantiate()
			popup.global_position = get_global_mouse_position() - Vector2(8, 8)
			shop.add_child(popup)
			popup.connect_to(self)


func info() -> void:
	print("121212")
	
func sell() -> void:
	print('sell')
