extends Resource
class_name Base_ability

@export var id : int
@export var name : String
@export_multiline var description : String
@export var cost_hp : int
@export var cost_will : int
@export var cooldown : int
@export var icon_in_description : Texture2D
@export_enum ("No type","Lunar","Blood","Suicide") var type_spell : String
@export_enum ("Enemy", "Ally", "Either") var type_unit : String
@export_enum ("Active", "Passive") var activity : String
@export var ability_script : Script
@export_enum ("Pure", "Magic", "Physical", "None") var type_dmg : String
@export var self_target : bool
var cooldown_timer : int:
	set(value):
		cooldown_timer = clamp(value, 0, 99)

func check_unit(tile_pos : Vector2i) -> bool:
	var character = Grid.get_unit(tile_pos)
	if character:
		if character.Classname == type_unit or type_unit == "Either":
			return true
	return false

func check_unit_enemy(character : Unit) -> bool:
	if character.Classname != type_unit:
		return true
	return false

func give_scp() -> Object:
	var instance = ability_script.new()
	return instance
