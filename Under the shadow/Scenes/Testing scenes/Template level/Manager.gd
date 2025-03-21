extends Node2D
class_name Manager

var queue : Array[Unit]
var queue_prop : Array[Array]
var index := 0
var label_theme : Theme = preload("res://UI/All theme/Label/Label_Ui.tres")
var turn := 0

func init_level() -> void:
	Eventbus.connect("dying", free_unit)
	Eventbus.connect("prop_char_change", waiter)
	Eventbus.connect("give_queue", give_queue)
	for unit in get_tree().get_nodes_in_group("Units"):
		queue.append(unit)
	queue.sort_custom(sort_by_reaction)

func change_turn() -> void:
	queue[wrapi(index - 1, 0, queue.size())].change_state(queue[wrapi(index - 1, 0, queue.size())]._st.end_turn)
	queue[wrapi(index - 1, 0, queue.size())].end_turn()
	if index == 0:
		queue.clear()
		for unit in get_tree().get_nodes_in_group("Units"):
			queue.append(unit)
		queue.sort_custom(sort_by_reaction)
	queue[index].select()
	queue[index].change_state(queue[index]._st.wait)
	index = wrapi(index + 1, 0 , queue.size())
	if index == 1:
		turn += 1
		Eventbus.emit_signal("end_turn", turn)

func sort_by_reaction(a : Unit, b : Unit) -> bool:
	if a.reaction > b.reaction:
		return true
	else:
		return false

func _on_button_pressed() -> void:
	change_turn()

func free_unit(unit : Unit) -> void:
	queue.erase(unit) 
	
func waiter(dif : int, prop : String, pos : Vector2) -> void:
	queue_prop.append([dif, prop, pos])
	var timer_await = queue_prop.size() * 0.5
	await get_tree().create_timer(timer_await).timeout
	call_deferred("create_label")

func create_label() -> void:
	var prop_label = Label.new()
	prop_label.z_index = 1000
	prop_label.set("theme_override_font_sizes/font_size", 20)
	var timer := 1.5
	var dif = queue_prop.front()[0]
	var prop = queue_prop.front()[1]
	var pos = queue_prop.front()[2]
	prop_label.theme = label_theme
	if dif > 0:
		await get_tree().create_timer(1).timeout
		prop_label.text = "+" + str(dif) + prop
		prop_label.set("theme_override_colors/font_color", Color.GREEN)
	else:
		prop_label.set("theme_override_colors/font_color", Color.RED)
		prop_label.text = str(dif) + prop
	add_child(prop_label)
	prop_label.position = pos - Vector2(prop_label.size.x / 2, 40)
	var tween1 := create_tween()
	var tween2 := create_tween()
	tween1.tween_property(prop_label, "position", prop_label.position - Vector2(0, 30), timer)
	tween2.tween_property(prop_label, "modulate", Color("ffffff00"), timer)
	queue_prop.pop_front()
	await get_tree().create_timer(timer).timeout
	prop_label.queue_free()

func give_queue(node : Node) -> void:
	var actual_queue : Array[Unit] = []
	for counter in queue.size():
		actual_queue.append(queue[wrapi(index + counter, 0 ,queue.size())])
	node.queue = actual_queue
		
