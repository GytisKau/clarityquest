extends Button

@onready var player = $"../../AnimationPlayer"

func _on_pressed():
	player.play("Fade out")
