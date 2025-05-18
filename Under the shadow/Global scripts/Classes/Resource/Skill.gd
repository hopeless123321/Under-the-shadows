extends Resource
class_name Skill

enum TypeSpell {NoType, Lunar, Blood, Suicide, Melee, Ranged, Magic, Fire}
enum TypeApplication {AllWorld, AllArea, TargetsWorld, TargetsArea, Directional, DirectionalWithPreset, Self, BombLike, TilesEffects, Spawn} 
@export_group("Main")
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
		cooldown_timer = clamp(value, 0 , 99)


## Custom enum type 
enum TypeDmgSkill {Magic, Pure, Phys, Will}
enum TypeAppUnit {Ally, Enemy, Either}
#region overrided function

## Basic function for override to subclass inheritence
func execute(sender : Unit, recievers : Array[Unit]) -> void:
	pass
	
func reveal_result_action(sender : Unit, recievers : Array[Unit]) -> String:
	var text : String 
	return text
	
#endregion
#region Reveal result functions
## func to reveal result of skill.
func reveal_dmg_with_resist(dmg_amp : int, resist : float, damage : Vector2i) -> Vector2i:
	## Spread dmg. Result of division ot multiply final dmg with resist
	var spraed_dmg : Vector2i
	var dmg_with_dmg_amp : Vector2i = Vector2i(damage.x * dmg_amp, damage.y * dmg_amp)  
	var resisit_fin : float = resist / 100 + 1
	if resist > 0:
		spraed_dmg = Vector2i(dmg_with_dmg_amp.x / resisit_fin, dmg_with_dmg_amp.y / resisit_fin)
	else: 
		spraed_dmg = Vector2i(dmg_with_dmg_amp.x * resisit_fin, dmg_with_dmg_amp.y * resisit_fin)
	return spraed_dmg
#endregion
#region Often used execute function
## Often used func
func calc_resist(unit : Unit, type_dmg : TypeDmgSkill) -> int:
	match type_dmg:
		TypeDmgSkill.Magic:
			return unit.unit_property.resist_will
		TypeDmgSkill.Phys:
			return unit.unit_property.resist_phys_dmg
		TypeDmgSkill.Will:
			return unit.unit_property.resist_will
	return 50

func dmg_with_resist(dmg_amp : int, resist : float, damage : Vector2i) -> int:
	var dmg_rng : int = randi_range(damage.x, damage.y) * dmg_amp
	if resist > 0:
		return dmg_rng / ((resist / 100) + 1)
	elif resist < 0: 
		return dmg_rng * ((resist / 100) + 1)
	return dmg_rng 

func will_dmg_resist(dmg : int, resist : float) -> int:
	if resist > 0:
		return dmg / ((resist / 100) + 1)
	elif resist < 0:
		return dmg * ((resist / 100) + 1)
	return dmg
#endregion 
	
