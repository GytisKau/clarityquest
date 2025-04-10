extends Control
@onready var player = $AnimationPlayer
@onready var entrance: Control = $CanvasLayer/entrance

# Called when the node enters the scene tree for the first time.
func _ready():
	entrance.show()
	if Global.shared_variable == false:
		player.play("leaves_dissapearing", -1, 2)
		Global.shared_variable = true
	elif Global.shared_variable == true:
		player.play("Fade in")

	if OS.has_feature("web"):
		UpdatePlayerID(JavaScriptBridge.get_interface("localStorage"))
	else:
		print("The JavaScriptBridge singleton is NOT available")
		Global.player_id = "guest"
	

func UpdatePlayerID(localStorage: JavaScriptObject) -> void:
	var Player_ID: String = localStorage.getItem("ClarityQuest_Player_ID")
	if Player_ID.is_empty():
		localStorage.setItem("ClarityQuest_Player_ID", randi_range(100000000, 999999999))
		Player_ID = localStorage.getItem("ClarityQuest_Player_ID")
	
	if Player_ID.is_empty():
		printerr("Cant read localStorage for player_id")
		Global.player_id = "guest"
		return
		
	Global.player_id = Player_ID

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade out":
		entrance.hide()
		var error = get_tree().change_scene_to_file("res://About Scene.tscn")
		
		if error != OK:
			printerr("Can't change to About Scene")
			
		
	if anim_name == "leaves_dissapearing":
		entrance.hide()
		
	if anim_name == "Fade in":
		entrance.hide()
