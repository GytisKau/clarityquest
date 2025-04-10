extends Control

@export_file var questoins_path_JSON: String
@onready var questions_container: Control = $Questions
@onready var score_label: Label = $"../ScoreContainer/ScoreLabel"
@onready var congrats: TextureRect = $"../Congrats"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var fog: TextureRect = $Fog
@onready var retry: ColorRect = $"../Retry"

var QuestionsJSON: Dictionary = {}
var QuestionsJSONCopy: Dictionary = {}
var CurrentQuestionGroup: Dictionary = {}
var group_question_count: int

func _ready() -> void:
	var questions_path = "res://questions/%s/Level 1.json" % Global.language_current
	
	Global.got_questions = 0
	fog.modulate = Color("#FFFFFF", 0.9)
	var dataClass = ReadData.new()
	QuestionsJSON = dataClass.load_question_data_from_json(questions_path)
	QuestionsJSONCopy = QuestionsJSON.duplicate(true)
	retry.hide()
	
	hide()

func _on_player_pause_signal():
	display_question()

func display_question():
	
	const questionType := [
		"ChooseTheCorrectAnswer",
		"MultipleChoice",
		#"FillInTheBlank_corrected"
		]
		
	randomize()
	
	var type: String = questionType[randi_range(0, 1)]

	
	# Check if need to reset all questions
	if QuestionsJSONCopy[type].is_empty():
		QuestionsJSONCopy[type] = QuestionsJSON[type].duplicate(true)
	
	# Change question group
	QuestionsJSONCopy[type].shuffle()
	CurrentQuestionGroup = QuestionsJSONCopy[type].pop_front()
	questions_container.display_question_group(CurrentQuestionGroup, type)
	show()

func questions_done() -> void:
	hide()
	if Global.got_questions == Global.total_points:
		if score_label.get_points() == Global.total_points:
			congrats.show()
			congrats.play_congrats_entrance()
		else:
			retry.show()
			retry.play_retry_entrance()
	else:
		update_fog()

func update_fog() -> void:
	var alpha: float = remap(score_label.getCompleteRatio(), 0, 1, 0.9, 0)
	fog.modulate = Color("#FFFFFF", alpha)

func _on_explainer_closed_explainer() -> void:
	get_tree().paused = false

func _on_player_new_pause_signal() -> void:
	display_question()
