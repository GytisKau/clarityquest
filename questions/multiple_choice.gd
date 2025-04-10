extends Control

@onready var buttons: VBoxContainer = $CenterContainer/VBoxContainer2/Buttons
@onready var feedback_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/FeedbackButton
@onready var check_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/CheckButton
@onready var next_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/NextButton
@onready var question_label: Label = $CenterContainer/VBoxContainer2/Question
@onready var topic_label: Label = $Topic

var question_group: Dictionary
var feedback: PanelContainer
var score_label: Label

var question: Dictionary
var question_count: int
var correct_option: String

var attempt := 0

signal questions_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	feedback_button.text = Global.translation["Feedback"]
	check_button.text = Global.translation["Check"]
	next_button.text = Global.translation["Next"]
	_show_question()

func initialize(p_question_group: Dictionary, p_feedback: PanelContainer, p_score_label: Label) -> void:
	question_group = p_question_group
	feedback = p_feedback
	score_label = p_score_label
	question_count = question_group["questions"].size()
	print("MultipleChoice initialized")
	
func _show_question():
	Global.got_questions += 1
	check_button.text = Global.translation["Check"]
	attempt = 0
	feedback_button.hide()
	next_button.hide()
	check_button.show()
	
	for child in buttons.get_children():
		buttons.remove_child(child)
		child.queue_free()	
	
	question = question_group["questions"].pop_back()
	topic_label.text = question_group["topic"]
	
	feedback_button.hide()
	check_button.show()
	next_button.hide()
	
	
	var options: Array = question["options"].duplicate()
	print(question["answers"])
	# Display Question
	#var number: String = str(question_count - question_group["questions"].size()) + "/" + str(question_count) + ". "
	var number: String = str(Global.got_questions) + "/" + str(Global.total_points) + ". "
	question_label.text = number + question["question"]
	
	# Display Options
	for option_text in options:
		var button := CheckBox.new()
		button.toggle_mode = true
		button.autowrap_mode = TextServer.AUTOWRAP_WORD
		button.text = option_text
		buttons.add_child(button)

		
		
func _on_check_button_pressed():
	var number_selected := 0
	for toggle: Button in buttons.get_children():
		if toggle.button_pressed:
			number_selected += 1
			
	if number_selected == 0:
		return
	
	attempt += 1

	var answers: Array = question["answers"].duplicate()
	var count_correct: int = 0
	var count_incorrect: int = 0
	var disabled_stylebox = buttons.get_child(0).get_theme_stylebox("disabled").duplicate()

	for toggle: Button in buttons.get_children():
		var dis: StyleBoxFlat = disabled_stylebox.duplicate()
		
		if toggle.button_pressed:
			toggle.disabled = true
			if answers.has(toggle.text):
				count_correct += 1
				dis.bg_color = Color(0, 0.7, 0)
			else: 
				count_incorrect += 1
				dis.bg_color = Color(1, 0.7, 0)

			toggle.add_theme_stylebox_override("normal", dis)
			toggle.add_theme_stylebox_override("focus", dis)
			toggle.add_theme_stylebox_override("pressed", dis)	
			toggle.add_theme_stylebox_override("disabled", dis)
	
	var correct: bool = count_correct == answers.size() && count_incorrect == 0
	#print("Guess attempt: %s, Selected options: %s, Correct guess: %s" % 
		#[attempt, number_selected, correct])
	next_button.show()
	feedback.set_mascot(correct && attempt == 1)
	feedback_button.show()
	check_button.text = Global.translation["Check again"]
		
	if correct and attempt == 1:	
		score_label.addPoints(1)
		feedback.set_title(Global.translation["Correct"])
		feedback.set_body(question["feedback_correct"])
	else:
		feedback.set_title(Global.translation["Incorrect"])
		feedback.set_body(question["feedback_incorrect"])
	
	# Let the user guess again
	if number_selected == len(question["options"]) || attempt == 3 || correct: 
		display_correct_answers(disabled_stylebox)
		check_button.hide()
		next_button.grab_focus()

func display_correct_answers(stylebox: StyleBoxFlat) -> void:
	stylebox.bg_color = Color(0, 0.7, 0)
	var answers: Array = question["answers"].duplicate()
	for toggle: Button in buttons.get_children():
		if answers.has(toggle.text):
			toggle.add_theme_stylebox_override("normal", stylebox)

func set_stylebox_border(stylebox: StyleBoxFlat, thickness: int) -> void:
	stylebox.border_width_top = thickness
	stylebox.border_width_left = thickness
	stylebox.border_width_bottom = thickness
	stylebox.border_width_right = thickness


func _on_feedback_button_pressed() -> void:
	feedback.show()
	
func _on_next_button_pressed() -> void:
	if Global.got_questions == Global.total_points:
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
	
