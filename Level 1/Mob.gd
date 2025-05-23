extends CharacterBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Minimum speed of the mob in meters per second.
@export var min_speed = 10
# Maximum speed of the mob in meters per second.
@export var max_speed = 18

# Emitted when the player jumped on the mob
signal squashed

func _physics_process(_delta):
	var _collided = move_and_slide()

var random_speed: float

## This function will be called from the Main scene.
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -90 and +90 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))

	# We calculate a random speed (integer)
	random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free() # Destroy this node
	get_tree().paused = not get_tree().paused


func _on_timer_timeout():
	queue_free()
