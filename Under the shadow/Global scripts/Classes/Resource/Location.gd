extends Resource
class_name Location

@export var name : String
@export_dir var map_pool : String
@export_dir var unit_list_pool : String 
@export_group("Generate setting")
@export var probabality_rooms : ProbabiltyRoomSpawn
@export var quantity_room : int
@export var quantity_loops_on_dungeon : int
@export_range(0, 100, 1, "suffix:percent") var percent_hidden_room : int
@export var exit_to : Array[Location]
@export_group("Generate level tilesets")
@export var wall_and_floor : TileSet
@export var object : TileSet
@export var decorations : TileSet
