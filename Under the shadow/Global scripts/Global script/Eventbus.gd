extends Node

## Setting or menu signals
signal to_main_menu
signal save_all
signal call_setting
signal change_overlay(prop : String, value : float)

## Ui signal
signal update_prop_ui
signal give_queue(node : Node)
signal reveal_map(on_battle : bool)

## Signal for evolution tree
signal get_unit_on_team(unit_prop : UnitOnTeam)
signal get_unit_prop(unit_prop : UnitProp)

## Change turn for all unit
signal new_turn_for_everyone(turn : int)

## Regular signal
signal new_room
signal begin_turn_all
signal end_turn_all
signal begin_battle
signal update_end_battle
signal next_room(room_type : String)

## Unit signal
signal update_tile_pos(old_tile : Vector2i)
signal dying(unit : Unit)
signal select_char(unit : UnitOnTeam) 
signal target_camera_to(unit_pos : Vector2i)
signal prop_char_change(dif : float, prop : String, positive : bool)
signal reveal_unit_hp_will(visible : bool)
signal reveal_result_skill(result_text : String)
signal create_spell(unit : Unit, skill_name : Skill)

## Other
signal souls_changed(value : int)
