extends TextureRect

@export var Badge: Image
@export var FileName: String = "Badge.png"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var badge_button: TextureButton = $BadgeButton

func _ready():
	badge_button.texture_normal = ImageTexture.create_from_image(Badge)
	hide()

func _on_button_pressed() -> void:
	if get_tree().reload_current_scene() != OK:
		printerr("Cant reload current scene")
	
func play_congrats_entrance() -> void:
	animation_player.play("Congrats_Entrance")

func _on_badge_button_pressed() -> void:
	if OS.has_feature('web'):
		print("Downloading badge!")
		var buffer: PackedByteArray = Badge.save_png_to_buffer()
		JavaScriptBridge.download_buffer(buffer, FileName, "image/png")	
	else:
		print("This is not web, cant download!")
	
