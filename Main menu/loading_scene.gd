extends Control

@onready var loading: Label = $"Loading"

var progress = []
var scene_path := ""
var scene_load_status = 0

func _ready() -> void:
	scene_path = Global.current_level
	loading.text = Global.translation["Loading..."]
	if ResourceLoader.load_threaded_request(scene_path) != OK:
		printerr("Cant load threaded request to scene \"%s\"" % scene_path)
	print("Ready")
	
func _process(_delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_path)
		if get_tree().change_scene_to_packed(new_scene):
			printerr("Failed to load %s" % scene_path)
			
