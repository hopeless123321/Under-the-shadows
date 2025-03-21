extends Button


@onready var ghost = $"../Ghost"
@onready var enemy = $"../Enemy"
@onready var node_2d = $"../Node2D"
@onready var control = $"../Control"
@onready var sprite_2d = $"../Ghost/Sprite2D"




func _on_pressed():
	var lol : Array
	var prop = enemy.get_script().get_script_property_list()
	var new_ally = Ally.new()
	for propi in prop:
			var name_ = str(propi.name)
			new_ally.set(name_, enemy.get(name_))
	sprite_2d.get_parent().replace_by(new_ally)
		
	# через метод reparent перенести все ноды enemy к новой ноде  ally
	# присмотреться к replace by 

func _physics_process(delta):
	#if Input.is_action_just_pressed("LMB") and get_viewport().is_input_handled():
	if get_viewport().is_input_handled():
		print("dsds")
