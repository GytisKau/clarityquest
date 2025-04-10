extends Control

@onready var question_label: Label = $CenterContainer/VBoxContainer2/Question
@onready var buttons: VBoxContainer = $CenterContainer/VBoxContainer2/Buttons
@onready var feedback_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/FeedbackButton
@onready var next_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/NextButton
@onready var check_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/CheckButton
@onready var topic_label: Label = $Topic

var question: Dictionary
var question_count: int
var correct_option: String
var attempt: int = 0

var question_group: Dictionary
var feedback: PanelContainer
var score_label: Label

var disabled_stylebox: StyleBox
var button_group: ButtonGroup

signal questions_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_group = ButtonGroup.new()
	feedback_button.text = Global.translation["Feedback"]
	check_button.text = Global.translation["Check"]
	next_button.text = Global.translation["Next"]
	_show_question()
	disabled_stylebox = buttons.get_children()[0].get_theme_stylebox("disabled").duplicate()

func initialize(p_question_group: Dictionary, p_feedback: PanelContainer, p_score_label: Label) -> void:
	question_group = p_question_group
	score_label = p_score_label
	feedback = p_feedback
	question_count = question_group["questions"].size()
	print("ChooseTheCorrectAnswer initialized")

func _show_question() -> void:
	attempt = 0
	Global.got_questions += 1
	check_button.text = Global.translation["Check"]
	feedback_button.hide()
	next_button.hide()
	check_button.show()
	
	
	for child in buttons.get_children():
		buttons.remove_child(child)
		child.queue_free()	
	
	question = question_group["questions"].pop_back()
	topic_label.text = question_group["topic"]
	
	correct_option = question["correctOption"]
	print(correct_option)
	# Update UI with question data
	var options = question["options"]
	options.shuffle()
	#var number: String = str(question_count - question_group["questions"].size()) + "/" + str(question_count) + ". "
	var number: String = str(Global.got_questions) + "/" + str(Global.total_points) + ". "
	question_label.text = number + question["question"]
	for option in question["options"]: 
		var button: Button = Button.new()
		button.toggle_mode = true
		button.button_group = button_group
		button.text = option
		button.autowrap_mode = TextServer.AUTOWRAP_WORD
		#button.pressed.connect(CheckAwnswer.bind(button))
		buttons.add_child(button)
		

func _on_check_button_pressed() -> void:
	var options: Array = buttons.get_children()
	var correct: bool = false
	var pressed_button: Button = button_group.get_pressed_button()
	
	if pressed_button.disabled:
		print("disabled")
		return
	attempt += 1
	
	#pressed_button.pressed.disconnect(CheckAwnswer)
	pressed_button.disabled = true
	check_button.text = Global.translation["Check again"]
	
	var dis: StyleBoxFlat = disabled_stylebox.duplicate(true)
	if pressed_button.text == correct_option:
		dis.bg_color = Color(0, 0.7, 0)
		correct = true
		if attempt == 1:
			score_label.addPoints(1)
	else:
		dis.bg_color = Color(1, 0.8, 0)

	pressed_button.add_theme_stylebox_override("disabled", dis)
	
	# Let the user guess again
	if attempt < 3 && !correct: return
	
	for button: Button in options:
		if button.text == correct_option and button != pressed_button:
			set_stylebox_border(dis, 2)
			dis = disabled_stylebox.duplicate(true)
			dis.border_color = Color(0, 1, 0)
			button.add_theme_stylebox_override("disabled", dis)
			break
	
	# Update feedback after attempts
	if attempt == 1 and correct:
		feedback.set_title(Global.translation["Correct"])
		feedback.set_body(question["feedback_correct"])
	else:
		feedback.set_title(Global.translation["Incorrect"])
		feedback.set_body(question["feedback_incorrect"])
	
	feedback.set_mascot(attempt == 1 and correct)
	
	# Disable buttons
	for button: Button in buttons.get_children():
		button.disabled = true;
		#if button.pressed.is_connected(CheckAwnswer):
			#button.pressed.disconnect(CheckAwnswer)	
	
	feedback_button.show()
	next_button.show()
	next_button.grab_focus()
	check_button.hide()
		
func set_stylebox_border(stylebox: StyleBoxFlat, thickness: int) -> void:
	stylebox.border_width_top = thickness
	stylebox.border_width_left = thickness
	stylebox.border_width_bottom = thickness
	stylebox.border_width_right = thickness


func _on_feedback_button_pressed() -> void:
	feedback.show()

func _on_next_button_pressed() -> void:
	if Global.got_questions >= Global.total_points:
		questions_done.emit()
		return
		
	if question_group["questions"].is_empty():
		back_to_game()
	else:
		_show_question()
		
func back_to_game() -> void:
	print("Back to game")
	get_tree().paused = false
	questions_done.emit()
