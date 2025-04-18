extends Resource
class_name Skill

enum TypeSpell {NoType, Lunar, Blood, Suicide}
enum TypeApplication {AllWorld, AllArea, TargetsWorld, TargetsArea, Directional, DirectionalWithPreset, Self, BombLike, TilesEffects, Spawn} 
@export_category("Main")
@export var id : int
@export var forename : String
@export var cost_hp : int
@export var cost_will : int
@export var cooldown : int
@export var active : bool
@export_multiline var description : String
@export var icon : Texture2D
@export var skill_prop_in_evolve_tree : Dictionary
@export var type_spell : TypeSpell
@export var type_application : TypeApplication
var cooldown_timer : int = 0:
	set(value):
		cooldown_timer = clamp(cooldown_timer, 0 , 99)
func dmg_with_resist(dmg : int, resist : int, dmg_amp : int) -> int:
	return dmg + (dmg_amp / 100 + dmg) - (resist / 100 + dmg)
