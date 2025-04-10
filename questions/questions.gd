extends Control

@export var ChooseTheCorrectAnswer: PackedScene
@export var MultipleChoice: PackedScene
@export var FillInTheBlank: PackedScene

@export var Feedback: PanelContainer
@export var Score_label: Label

func display_question_group(question_group: Dictionary, type: String) -> void:
	# Remove previous question
	for child in get_children():
		remove_child(child)
		
	# Pick scene type
	var scene
	match type:
		"ChooseTheCorrectAnswer":
			scene = ChooseTheCorrectAnswer.instantiate()
		"MultipleChoice":
			scene = MultipleChoice.instantiate()
		"FillInTheBlank":
			scene = FillInTheBlank.instantiate()
		"FillInTheBlank_corrected":
			scene = ChooseTheCorrectAnswer.instantiate()
	# Show questions from current group
	#feedback = FeedbackScene.instantiate()
	scene.initialize(question_group, Feedback, Score_label)
	scene.questions_done.connect(hide_questions)
	add_child(scene)
	#add_child(feedback)

func hide_questions() -> void:
	print("Hiding questions")
	get_parent().questions_done()

#func _on_close_button_pressed() -> void:
	#feedback.hide()
