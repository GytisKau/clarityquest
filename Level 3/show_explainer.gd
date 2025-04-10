extends Button
@onready var explainer: PanelContainer = $"../Explainer"

func _on_pressed() -> void:
	explainer.show()
