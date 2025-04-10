extends Node

@export var mob_scene: PackedScene
@onready var player_new: CharacterBody3D = $PlayerNew
@onready var explainer: PanelContainer = $UserInterface/Explainer
@onready var congrats: TextureRect = $UserInterface/Congrats
@onready var http: HTTPRequest = $HTTPRequest
@onready var spawn_location: PathFollow3D = $SpawnPath/SpawnLocation

func _ready():
	if Global.use_tracking && OS.has_feature("web"):
		var window = JavaScriptBridge.get_interface("window")
		var track_url = window.location.href + "track.php"

		var url: String = "%s?player=%s&level=%s&lang=%s" % \
			[track_url, Global.player_id, 1, Global.language_current.to_lower()]
		if http.request(url) != OK:
			printerr("Cant make a request to url: " + track_url)
	
	player_new.set_walk_params(1.5, PI * 2)
	player_new.set_run_params(2.5, PI * 2)
	get_tree().paused = true
	explainer.show()
	congrats.hide()
	

func _on_mob_timer_timeout():
	spawn_location.progress_ratio = randf()
	var mob = mob_scene.instantiate()
	mob.initialize(spawn_location.position, player_new.position)
	add_child(mob)

func _on_retry_button_pressed() -> void:
	if get_tree().reload_current_scene() != OK:
		printerr("Cant reload current scene")
	
