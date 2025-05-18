@icon("res://Global scripts/Classes/Icons/Portal async.svg")
extends Portal
class_name AsymPortals 

## Can't teleport. Just recieve unit to teleport that position 
@export var reciever : bool 
## Teleportation portal
var connected_portals : AsymPortals

func _init(port_v : int, reciever_v : bool) -> void:
	add_to_group("Portals aSym")
	call_deferred("connect_to_portal")
	port = port_v
	reciever = reciever_v

func connect_to_portal() -> void:
	for asym_portlas : AsymPortals in get_tree().get_nodes_in_group("Portals aSym"):
		if asym_portlas.port == port and asym_portlas != self and !reciever:
			connected_portals = self
			break
			
func portals() -> void: 
	pass
