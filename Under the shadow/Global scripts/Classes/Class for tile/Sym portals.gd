@icon("res://Global scripts/Classes/Icons/Portal sync .svg")
extends Portal
class_name SymPortals

var connected_portals : SymPortals

func _init(port_v : int) -> void:
	add_to_group("Portals Sym")
	call_deferred("connect_to_portal")
	port = port_v

func connect_to_portal() -> void:
	for sym_portlas : SymPortals in get_tree().get_nodes_in_group("Portals Sym"):
		if sym_portlas.port == port and sym_portlas != self:
			connected_portals = self
			break

func teleport() -> void: 
	pass
