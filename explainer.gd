extends PanelContainer

@export var level: int
@onready var main_text: RichTextLabel = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/MainText
@onready var title: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/Title
@onready var close_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer2/HFlowContainer/CloseButton

signal closedExplainer

func _ready():
	close_button.text = Global.translation["Close"]
	
	var level_str = "Level " + str(level)
	if Global.translation.has(level_str): 
		if Global.translation[level_str].has("title"):
			set_title(Global.translation[level_str]["title"])
		else:
			set_title("No title translation")
		if Global.translation[level_str].has("body"):
			set_main_text(Global.translation[level_str]["body"])
		else:
			set_main_text("No body translation in this language")
	else:
		set_main_text("No translation in this language")
	show()
	
func set_title(new_title: String) -> void:
	title.text = new_title

func set_main_text(new_main_text: String) -> void:
	main_text.clear()
	main_text.append_text(new_main_text)

func _on_close_button_pressed() -> void:
	hide()
	closedExplainer.emit()
