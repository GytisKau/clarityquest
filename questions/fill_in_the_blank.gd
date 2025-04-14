extends Control

@onready var question_container: HFlowContainer = $CenterContainer/VBoxContainer2/HFlowContainer
@onready var feedback_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/FeedbackButton
@onready var check_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/CheckButton
@onready var next_button: Button = $CenterContainer/VBoxContainer2/HBoxContainer/NextButton
@onready var topic_label: Label = $Topic

var question_group: Dictionary
var feedback: PanelContainer
var score_label: Label
var inputs: Array[LineEdit] = []

var question: Dictionary
var question_count: int
var correct_option: String
var stylebox_norm: StyleBox
var attempt: int = 0
var was_fullscreen := false

signal questions_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	feedback_button.text = Global.translation["Feedback"]
	check_button.text = Global.translation["Check"]
	next_button.text = Global.translation["Next"]
	_show_question()
	stylebox_norm = inputs[0].get_theme_stylebox("normal").duplicate(true)
	

func initialize(p_question_group: Dictionary, p_feedback: PanelContainer, p_score_label: Label) -> void:
	question_group = p_question_group
	feedback = p_feedback
	score_label = p_score_label
	question_count = question_group["questions"].size()
	print("FillInTheBlank initialized")

func _show_question():
	Global.got_questions += 1
	check_button.text = Global.translation["Check"]
	attempt = 0
	feedback_button.hide()
	next_button.hide()
	check_button.show()
	inputs.clear()
	for child in question_container.get_children():
		question_container.remove_child(child)
		child.queue_free()
		
	# Add question number
	var number = Label.new()
	number.text = str(Global.got_questions) + "/" + str(Global.total_points) + ". "
	question_container.add_child(number)
	
	topic_label.text = question_group["topic"]
	question = question_group["questions"].pop_back()
	var question_text: String = question["question"]
	var answers: Array = question["answers"].duplicate()
	print(answers)
	# Checking blank count because there are bad questions
	var blank_count : int = len(question_text.split("_", false)) - 1     
	if question_text.begins_with("_"): blank_count += 1                  
	if question_text.ends_with("_"): blank_count += 1
	
	if len(answers) != blank_count:
		printerr("Bad question: \"%s\"" % question_text)

	for partText: String in question_text.split("_", false):
		for word: String in partText.split(" ", false):
			var partLabel = Label.new()
			partLabel.text = word
			question_container.add_child(partLabel)
		
		if !answers.is_empty():
			var answer: Array = answers.pop_front()
			var lineEdit = LineEdit.new()
			lineEdit.expand_to_text_length = true
			lineEdit.caret_blink = true
			lineEdit.editing_toggled.connect(fullscreen_handle)

			for sub_answer: String in answer:
				if lineEdit.max_length < sub_answer.length():
					lineEdit.max_length = sub_answer.length()
				
			question_container.add_child(lineEdit)
			inputs.append(lineEdit)
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN && not inputs.is_empty():
		was_fullscreen = true

func _on_check_button_pressed() -> void:
	# Check empty inputs case
	var has_empty: bool = false
	for input: LineEdit in inputs:
		if input.text.is_empty():
			has_empty = true;
			var new_stylebox = stylebox_norm.duplicate(true)
			new_stylebox.border_color = Color(0.95, 1, 0)
			set_stylebox_border(new_stylebox, 2)
			input.add_theme_stylebox_override("normal", new_stylebox)
			input.add_theme_stylebox_override("focus", new_stylebox)
			
	if has_empty:
		return
	
	attempt += 1
	var answers: Array = question["answers"].duplicate(true)
	var passed: bool = true
	
	for i in answers.size():
		for j in answers[i].size():
			answers[i][j] = answers[i][j].to_lower()
	
	for i in inputs.size():	
		var new_stylebox = stylebox_norm.duplicate(true)
		set_stylebox_border(new_stylebox, 2)
		if answers[i].has(inputs[i].text.to_lower()):
			for answer in answers:
				answer.erase(inputs[i].text)
			new_stylebox.border_color = Color(0, 1, 0)
		else:
			passed = false
			if attempt < 3:
				new_stylebox.border_color = Color(0.95, 1, 0)
			else:
				# TODO: Remove the picked answer from the whole list like above
				inputs[i].text = answers[i].front()
				inputs[i].editable = false
				new_stylebox.border_color = Color(0.3, 0.3, 0.3)
				
		inputs[i].add_theme_stylebox_override("normal", new_stylebox)
		inputs[i].add_theme_stylebox_override("focus", new_stylebox)
	
	next_button.show()
	feedback.set_mascot(passed && attempt == 1)
	feedback_button.show()
	check_button.text = Global.translation["Check again"]
	
	if passed && attempt == 1:
		score_label.addPoints(1)
		feedback.set_title(Global.translation["Correct"])
		feedback.set_body(question["feedback_correct"])
	else:
		feedback.set_title(Global.translation["Incorrect"])
		feedback.set_body(question["feedback_incorrect"])

	# Let the user guess again
	if attempt < 3 && !passed: return
	
	display_correct_answers()
	check_button.hide()
	next_button.grab_focus()
		

func fullscreen_handle(toggled_on: bool) -> void:
	if not was_fullscreen: 
		return
	
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			print("Changing to Windowed")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.WINDOW_MODE_WINDOWED:
			print("Changing back to Fullscreen")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func display_correct_answers() -> void:
	var answers: Array = question["answers"].duplicate(true)
	for i in inputs.size():
		inputs[i].text = answers[i][0]

func set_stylebox_border(stylebox: StyleBoxFlat, thickness: int) -> void:
	stylebox.border_width_top = thickness
	stylebox.border_width_left = thickness
	stylebox.border_width_bottom = thickness
	stylebox.border_width_right = thickness

func _on_feedback_button_pressed() -> void:
	feedback.show()


func _on_next_button_pressed() -> void:
	if was_fullscreen and DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		print("Changing back to Fullscreen")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	if Global.got_questions == Global.total_points:
		questions_done.emit()
		return
		
	if question_group["questions"].is_empty():
		print("Yay baigesi klausimai")
		back_to_game()
	else:
		_show_question()
		
func back_to_game() -> void:
	print("Back to game")
	get_tree().paused = false
	questions_done.emit()
	
