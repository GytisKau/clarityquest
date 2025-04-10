extends Node3D

@export var SENS_HORIZONTAL: float = 1.8
@export var SENS_VERTICAL: float = 0.1

@onready var questions_control: Control = $"..".Questions
#@onready var cross: Label = $"..".cross
@onready var player: CharacterBody3D = $".."

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			get_selection(event.position)
	
	#if player.canMoveCamera and event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(-event.relative.x * SENS_HORIZONTAL))
		#$Camera3D.rotate_x(deg_to_rad(-event.relative.y * SENS_VERTICAL))

func _process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	rotate_y(deg_to_rad(-input_dir.x * SENS_HORIZONTAL))
	#$Camera3D.rotate_x(deg_to_rad(-input_dir.y * SENS_VERTICAL))

func get_selection(mouse_position: Vector2i):
	#var window_center: Vector2i = get_viewport().get_visible_rect().size / 2
	var from = $Camera3D.project_ray_origin(mouse_position)
	var to = from + $Camera3D.project_ray_normal(mouse_position) * 1000
	var worldspace = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.create(from, to)
	var result = worldspace.intersect_ray(params)
	
	if result and result["collider"].name == "CrowCollider":
		if questions_control != null and questions_control.has_method("display_question"):
			questions_control.display_question(result["collider"])
	
