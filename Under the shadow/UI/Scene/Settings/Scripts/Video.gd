extends MarginContainer

@onready var resolution_n : OptionButton = $VBoxContainer/GridContainer/Resolution
@onready var fullscreen_n : CheckBox = $VBoxContainer/GridContainer/fullscreen
@onready var vsync_n : CheckBox = $VBoxContainer/GridContainer/vsync
@onready var vineete_n : HSlider = $VBoxContainer/GridContainer2/Vineete
@onready var vinneete_opacity_n : HSlider = $"VBoxContainer/GridContainer2/Vinneete opacity"
@onready var aberration_n : HSlider = $VBoxContainer/GridContainer2/Aberration
@onready var britness_n : HSlider = $VBoxContainer/GridContainer2/Britness
@onready var curve_screen_n : HSlider = $VBoxContainer/GridContainer2/Curve_screen


const VHS = preload("res://Shaders/vhs.gdshader")
var fullsize := true
var vsync := true

const RESOLUTION_SIZE := [
	Vector2i(1024, 768),
	Vector2i(1152, 864),
	Vector2i(1280, 720),
	Vector2i(1280, 800),
	Vector2i(1280, 960),
	Vector2i(1280, 1024),
	Vector2i(1360, 768),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1680, 1050),
	Vector2i(1920, 1080)
]


func _ready() -> void:
	Eventbus.connect("save_all", save_all)
	call_deferred("load_settings")

func load_settings() -> void:
	var video_setting : Dictionary = Config.load_video()
	#resolution setup
	#for index in range(0, resolution_n.item_count):
		#if resolution_n.get_item_text(index) == video_setting.resolution:
			#resolution_n.select(index)
			#_on_resolution_item_selected(index)
			#break
	resolution_n.select(video_setting.resolution)
	fullscreen_n.button_pressed = video_setting.fullscreen
	fullsize = !video_setting.fullscreen
	_on_fulscreen_pressed()
	vsync_n.button_pressed = video_setting.vsync
	vsync = !video_setting.vsync
	_on_vsync_pressed()
	
	var overlay_setting : Dictionary = Config.load_overlay()
	
	vineete_n.value = overlay_setting.vineete_intensity
	_on_vineete_value_changed(overlay_setting.vineete_intensity)
	
	vinneete_opacity_n.value = overlay_setting.vineete_opacity
	_on_vinneete_opacity_value_changed(overlay_setting.vineete_opacity)
	
	aberration_n.value = overlay_setting.abberation
	_on_aberration_value_changed(overlay_setting.abberation)
	
	britness_n.value = overlay_setting.brithness
	_on_britness_value_changed(overlay_setting.brithness)
	
	curve_screen_n.value = overlay_setting.curve_screen
	_on_h_slider_value_changed(overlay_setting.curve_screen)
	
func _on_resolution_item_selected(index : int) -> void:
	DisplayServer.window_set_size(RESOLUTION_SIZE[index])

func _on_fulscreen_pressed() -> void:
	fullsize = !fullsize
	if fullsize:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vsync_pressed() -> void:
	vsync = !vsync
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_vineete_value_changed(value : float) -> void:
	Eventbus.emit_signal("change_overlay", "vignette_intensity", value)

func _on_aberration_value_changed(value : float) -> void:
	Eventbus.emit_signal("change_overlay", "aberration", value)

func _on_britness_value_changed(value : float) -> void:
	Eventbus.emit_signal("change_overlay", "brightness", value)

func _on_vinneete_opacity_value_changed(value : float) -> void:
	Eventbus.emit_signal("change_overlay", "vignette_opacity", value)

func _on_h_slider_value_changed(value : float) -> void:
	Eventbus.emit_signal("change_overlay", "warp_amount", value)

func save_all() -> void:
	Config.save_video("resolution", resolution_n.selected)
	Config.save_video("vsync", vsync)
	Config.save_video("fullscreen", fullsize)
	
	Config.save_overlay("vineete_intensity", vineete_n.value)
	Config.save_overlay("vineeete_opacity", vinneete_opacity_n.value)
	Config.save_overlay("abberation", aberration_n.value)
	Config.save_overlay("brithness", britness_n.value)
	Config.save_overlay("curve_screen", curve_screen_n.value)
	
