extends Resource
## Resource Class that represent items that have unique effect and unique time applicaton tim e
class_name Relic
## Name relics
enum Rarity {
	COMMON,
	UNCOMMON, 
	RARE, 
	UNIQUEE, 
	SPEСIFIED,
	}
enum TimeApplication {
	BEGIN_BATTLE,
	END_BATTLE, 
	BEGIN_TURN, 
	END_TURN, 
	BEGIN_ROUND, 
	NEW_ROOM, 
	EVENT_ONLY, 
	SKILL_EFFECTED, 
	ON_APPEAR,
	}
enum Appears {
	EVENT, 
	ELITE_BATTLE, 
	SHOP, 
	BOSS,
	}
## Name relics
@export var name : String
## Visual represent on UI
@export var icon : Texture2D
## What doing relic 
@export_multiline var text_tooltip : String
## Description relic and his lore
@export_multiline var text_description : String
## Rarity relics like a reward
@export var rarity : Rarity
## When relics work. De-facto determine to what global signal connect relic
@export var trigger : TimeApplication
## Where relic can appear on game
@export var appear_in : Appears
## Cost on shop without discount
@export var cost : int 
## Some relics have unique, but limited for uses effect
@export var number_of_uses : int = -1


func _init() -> void: 
	match trigger:
		TimeApplication.BEGIN_BATTLE:
			pass
		TimeApplication.END_BATTLE:
			pass
		TimeApplication.BEGIN_TURN:
			pass
		TimeApplication.END_TURN:
			pass
		TimeApplication.BEGIN_ROUND:
			pass
		TimeApplication.EVENT_ONLY:
			pass
		TimeApplication.SKILL_EFFECTED:
			pass
		TimeApplication.ON_APPEAR:
			pass
		TimeApplication.NEW_ROOM:
			Eventbus.connect("new_room", used)

func used() -> void: 
	_execute()
	if number_of_uses != -1:
		number_of_uses -= 1
	if number_of_uses == 0: 
		delete()


## Virtual method that set logic with description 
func _execute() -> void:
	pass

## If number of uses is exhausted disconnect signal 
func delete() -> void: 
	pass
	# может быть сделать дисконект сигнала
