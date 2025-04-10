extends CharacterBody3D

@export var Questions: Control
@onready var walk: StateWalk = $FSM/Walk
@onready var run: StateRun = $FSM/Run

#var canMoveCamera: bool = false

func _ready():
	if Questions == null:
		printerr("Question Control is not set on Player")
		
	var joystick := TouchScreenJoystick.new()
	joystick.name = "joystick"
	joystick.background_color = Color(0, 0, 0, 0.08)
	joystick.base_radius = 100
	joystick.knob_radius = 35
	joystick.anti_aliased = true
	joystick.mode = 1
	joystick.smooth_reset = true
	joystick.change_opacity_when_touched = true
	joystick.from_opacity = 0
	joystick.to_opacity = 255
	joystick.use_input_actions = true
	joystick.position = Vector2(0, 64)
	joystick.size = Vector2(960, 425)
	add_child(joystick)
		
	walk.use_camera()
	run.use_camera()
