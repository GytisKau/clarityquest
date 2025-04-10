extends Control

@onready var Mountains: Array = $Mountains.get_children()
@onready var Trees: Array = $Trees.get_children()

var mountain_pos: Array[float] = []

var original_rot: Array[float] = []
var tree_rotations: Array = [[0, -2], [0, 2], [0, 2], [-2, 2]]


func _ready():
	# saving original Mountain  positions
	for mountain: TextureRect in Mountains:
		mountain_pos.append(mountain.position.y)
	
	# saving original Tree rotaions
	for tree: TextureRect in Trees:
		original_rot.append(tree.rotation_degrees)

var time: float
func _process(delta):
	time += delta
	update_mountains()
	update_trees()


func update_mountains() -> void:
	#var mytime: float = time * 0.3
	
	var dy: float
	for i: int in range(Mountains.size()):
		dy = sin(time + i) * 7.5 * i / float(Mountains.size())
		Mountains[i].position.y = mountain_pos[i] + dy
		
		
func update_trees() -> void:
	#var mytime: float = time * 0.3
	
	var angle: float
	var d_angle: float
	for i: int in range(Trees.size()):
		angle = tree_rotations[i][1] - tree_rotations[i][0]
		d_angle = (sin(time + i) * angle + tree_rotations[i][1])
		Trees[i].rotation_degrees = original_rot[i] + d_angle
