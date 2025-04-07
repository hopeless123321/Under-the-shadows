extends Node

signal save_all
signal update_prop_ui
signal update_end_battle
signal call_setting
signal reveal_map
signal next_room(room_type : String)
signal select_char(character_stats : Dictionary) 
signal target_camera_to(charachter_pos : Vector2i)
signal dying(character : Unit)
signal update_tile_pos(old_tile : Vector2i)
signal souls_changed(value : int)
signal give_queue(node : Node)
signal end_turn(turn : int)
signal get_unit_prop(unit_prop : Unit_prop)
signal change_overlay(prop : String, value : float)
signal prop_char_change(dif : float, prop : String, positive : bool)
