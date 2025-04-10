extends Node3D

class_name Crow

@onready var collision_shape_3d: CollisionShape3D = $CrowCollider/CollisionShape3D
@onready var visuals: Node3D = $Visuals

var HoverColor = Color(0, 0.8, 0)
var shader_material: ShaderMaterial
var original_color: Color

func disable_crow():
	collision_shape_3d.disabled = true;
	visuals.hide()
	
func enable_crow():
	collision_shape_3d.disabled = false;
	visuals.show()

func _ready():
	shader_material = $Visuals/outline.material_override
	original_color = shader_material.get_shader_parameter("color")
