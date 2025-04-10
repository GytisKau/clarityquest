extends PanelContainer

@onready var title: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/Title
@onready var main_text: RichTextLabel = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/MainText
@onready var m_correct: TextureRect = $Mascots/Correct
@onready var m_incorrect: TextureRect = $Mascots/Incorrect
@onready var close_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer2/HFlowContainer/CloseButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close_button.text = Global.translation["Close"]
	m_correct.hide()
	m_incorrect.hide()
	hide()

func _on_close_button_pressed() -> void:
	hide()

func set_title(text: String):
	title.text = text

func set_body(text: String):
	main_text.text = text

func set_mascot(correct: bool):
	if correct:
		m_correct.show()
		m_incorrect.hide()
	else:
		m_correct.hide()
		m_incorrect.show()
