extends Control

@onready var clouds: Array = $Clouds.get_children()
@onready var crows: Array = $Crows.get_children()
@onready var flying_crow: AnimatedSprite2D = $FlyingCrow

var cloud_pos: Array[float] = []
var time: float


func _ready():
	# saving original clouds positions
	for cloud: TextureRect in clouds:
		cloud_pos.append(cloud.position.y)
		
func _process(delta):
	time += delta
	update_clouds()
	update_crows()
	update_flying_crow()


func update_clouds() -> void:
	#var mytime: float = time * 0.3
	
	var dy: float
	for i: float in range(clouds.size()):
		dy = sin(time + i/2) * 7.5 # * i / float(clouds.size())
		clouds[i].position.y = cloud_pos[i] + dy
		
func update_crows() -> void:
	for crow: AnimatedSprite2D in crows:
		if !crow.is_playing():
			randomize()
			if randf_range(0, 1) < 0.002:
				crow.play("default")

func update_flying_crow() -> void:
	if flying_crow.offset.x < -5500:
		flying_crow.offset.x = 0
	
	flying_crow.offset.x -= 5;
