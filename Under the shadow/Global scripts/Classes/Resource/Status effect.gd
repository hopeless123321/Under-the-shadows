extends Resource
class_name Status_effect

@export var duration : int
@export_enum("at the end turn", "at the begin turn", "once", "accumulate") var type_application : String
@export var mini_icon : Texture2D
