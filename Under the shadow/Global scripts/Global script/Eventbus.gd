extends Node

signal save_all
signal new_level
signal update_prop_ui
signal call_setting
signal next_room(room_type : String)
signal select_char(character_stats : Dictionary) 
signal target_camera_to(charachter_pos : Vector2i)
signal dying(character : Unit)
signal update_tile_pos(old_tile : Vector2i)
signal prop_char_change(dif : float, prop : String, positive : bool)
signal give_queue(node : Node)
signal end_turn(turn : int)
signal change_overlay(prop : String, value : float)
signal souls_changed(value : int)
