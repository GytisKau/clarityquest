extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_button_pressed() -> void:
	if get_tree().reload_current_scene() != OK:
		printerr("Cant reload current scene")
	
func play_retry_entrance() -> void:
	animation_player.play("Retry_Entrance")
