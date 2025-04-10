extends State
class_name StateIdle

@export var animation_player : AnimationPlayer

func Enter():
	animation_player.play("Idle loop")

func Update(_delta):
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"):
		if Input.is_action_pressed("Run"):
			state_transition.emit(self, "run")
		else:
			state_transition.emit(self, "walk")
