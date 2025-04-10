extends TextureButton

@export_file var level_path: String

var orginal_size: Vector2
var grow_size: Vector2
var loading_scene: Resource


func _ready() -> void:
	loading_scene = preload("res://Main menu/LoadingScene.tscn")
	orginal_size = get_parent_control().scale
	grow_size = orginal_size * 1.1
	
	if level_path == null:
		printerr("Level path not set on button \"%s\"" % self)

func grow_btn(endsize: Vector2, duration: float) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	var _tweener := tween.tween_property(get_parent_control(), 'scale', endsize, duration)

func _on_mouse_entered() -> void:
	grow_btn(grow_size, .1)

func _on_mouse_exited() -> void:
	grow_btn(orginal_size, .1)

func _on_pressed() -> void:
	if level_path == null:
		return
	
	Global.current_level = level_path
	var error: Error = get_tree().change_scene_to_packed(loading_scene)
	if error != OK:
		printerr("Cant change scene")
	
