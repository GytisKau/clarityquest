extends CharacterBody3D

signal pauseSignal

@onready var walk: StateWalk = $FSM/Walk
@onready var run: StateRun = $FSM/Run

var joystick: TouchScreenJoystick

func _ready() -> void:
	joystick = TouchScreenJoystick.new()
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

func _physics_process(_delta) -> void:
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		if collision.get_collider() == null:
			continue
			
		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			joystick.finger_index = -1
			joystick.global_touch = Vector2.ZERO
			joystick.on_touch_released()
			get_viewport().set_input_as_handled()
			var mob = collision.get_collider()
			mob.squash()
			pauseSignal.emit()
			break
	
func set_run_params(speed: float, rotation_speed: float):
	run.speed = speed
	run.ROTATION_SPEED = rotation_speed
	
func set_walk_params(speed: float, rotation_speed: float):
	walk.speed = speed
	walk.ROTATION_SPEED = rotation_speed
