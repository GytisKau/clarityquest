extends Button

@onready var animationPlayer = $"../../AnimationPlayer"

func _on_pressed():
	animationPlayer.play("Fade out")
