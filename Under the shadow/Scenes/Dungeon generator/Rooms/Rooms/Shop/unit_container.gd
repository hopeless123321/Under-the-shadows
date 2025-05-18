extends VBoxContainer

const UNITS_ON_SHOP = preload("res://UI/Scene/Generator map UI/Rooms/Units on shop.tscn")

func _ready() -> void:
	for unit  : UnitOnTeam in UnitManager.team:
		var unit_on_shop : UnitOnShop = UNITS_ON_SHOP.instantiate()
		add_child(unit_on_shop)
		unit_on_shop.set_param(unit)
		
