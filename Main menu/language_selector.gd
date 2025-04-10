extends HBoxContainer

@export var button_group: ButtonGroup
@onready var label1: Label = $"../Button 1/Label"
@onready var label2: Label = $"../Button 2/Label"
@onready var label3: Label = $"../Button 3/Label"

func _ready() -> void:
	for button: Button in button_group.get_buttons():
		if button.text == Global.language_current:
			button.button_pressed = true
	
	var status = button_group.pressed.connect(press_language_select)
	if status == ERR_INVALID_PARAMETER:
		printerr("Cant connect callback to button_group")
	
	update_translation_data()
	update_UI()

func press_language_select(button: Button):
	Global.language_current = button.text
	update_translation_data()
	update_UI()
	
func update_translation_data() -> void:
	var json_path = "res://Translations/%s.json" % Global.language_current
	
	var dataClass = ReadData.new()
	var translation = dataClass.load_question_data_from_json(json_path)

	Global.translation = translation
		
func update_UI() -> void:
	if Global.translation.is_empty():
		return
	
	label1.text = Global.translation["Level 1"]["button"]
	label2.text = Global.translation["Level 2"]["button"]
	label3.text = Global.translation["Level 3"]["button"]
