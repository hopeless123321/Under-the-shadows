extends PanelContainer


@onready var sell: Button = %Sell
@onready var info: Button = %Info


func _ready() -> void:
	if get_tree().get_first_node_in_group("PopupShop") != null:
		get_tree().get_first_node_in_group("PopupShop").queue_free()
	add_to_group("PopupShop")
		
func connect_to(node_to_connect : UnitOnShop) -> void:
	sell.connect("pressed", node_to_connect.info)
	info.connect("pressed", node_to_connect.sell)
	


func _on_mouse_exited() -> void:
	queue_free()
