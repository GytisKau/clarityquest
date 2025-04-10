extends State
class_name StateRun

@export var animation_player : AnimationPlayer
@onready var player = $"../.."
@onready var visuals = $"../../visuals"
@onready var camera_mount

@export var speed: float = 4
@export var ROTATION_SPEED: float = PI * 2
var theta: float

var joystick : TouchScreenJoystick

func use_camera() -> void:
	camera_mount = $"../../camera mount"

func Enter():
	animation_player.play("Run loop")
	joystick = $"../../joystick"
	

func Update(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y))#.normalized()
	
	if camera_mount != null:
		direction = direction.rotated(Vector3(0, 1, 0), camera_mount.rotation.y)
	
	if direction:
		if Input.is_action_just_released("Run") or joystick.get_distance() < 90:
			state_transition.emit(self, "Walk")
			return
			
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
		
		
		theta = wrapf(atan2(direction.x, direction.z) + PI - visuals.rotation.y, -PI, PI)
		visuals.rotation.y += clamp(ROTATION_SPEED * delta, 0, abs(theta)) * sign(theta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed/5)
		player.velocity.z = move_toward(player.velocity.z, 0, speed/5)
		
		if player.velocity.x == 0 and player.velocity.z == 0:
			state_transition.emit(self, "Idle")	
	
	player.move_and_slide()
