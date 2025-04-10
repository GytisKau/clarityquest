extends Node
@onready var player = $AnimationPlayer
@export_file var mainScene
@onready var back_button: Button = $CanvasLayer/BackButton
@onready var information_label: RichTextLabel = $"CanvasLayer/Information Label"
@onready var entrance: Node2D = $CanvasLayer/entrance


func _ready():
	entrance.show()
	player.play("Fade in")
	
	if Global.translation.has("About"):
		information_label.text = Global.translation["About"]
	

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "Fade out"):
		if get_tree().change_scene_to_file(mainScene) != OK:
			printerr("Cant change to main menu")
