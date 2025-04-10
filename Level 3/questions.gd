extends Control

@onready var questions_container: Control = $Questions
@onready var score_label: Label = $"../ScoreContainer/ScoreLabel"
@onready var congrats: TextureRect = $"../Congrats"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var fog: TextureRect = $Fog
@onready var explainer: PanelContainer = $"../Explainer"
@onready var retry: ColorRect = $"../Retry"
@onready var http: HTTPRequest = $"../HTTPRequest"

var QuestionsJSON: Dictionary = {}
var QuestionsJSONCopy: Dictionary = {}
var CurrentQuestionGroup: Dictionary = {}
var group_question_count: int

func _ready() -> void:
	if Global.use_tracking && OS.has_feature("web"):
		var window = JavaScriptBridge.get_interface("window")
		var track_url = window.location.href + "track.php"

		var url: String = "%s?player=%s&level=%s&lang=%s" % \
			[track_url, Global.player_id, 3, Global.language_current.to_lower()]
		if http.request(url) != OK:
			printerr("Cant make a request to url: " + track_url)
	
	var questions_path = "res://questions/%s/Level 3.json" % Global.language_current
	
	Global.got_questions = 0
	fog.modulate = Color("#FFFFFF", 0.9)
	
	#update_UI()
	
	explainer.show()
	congrats.hide()
	retry.hide()
	
	var dataClass = ReadData.new()
	QuestionsJSON = dataClass.load_question_data_from_json(questions_path)
	QuestionsJSONCopy = QuestionsJSON.duplicate(true)
	
	_display_question()
	

#func update_UI() -> void:
	#explainer.set_title(Global.translation["Level 3"]["title"])
	#explainer.set_main_text(Global.translation["Level 3"]["body"])
	

func _display_question():	
	const questionType := [
		"ChooseTheCorrectAnswer",
		"MultipleChoice",
		"FillInTheBlank"]
		
	randomize()
	var type: String = questionType[randi_range(0, 2)]
	#var type = "MultipleChoice"

	
	# Check if need to reset all questions
	if QuestionsJSONCopy[type].is_empty():
		QuestionsJSONCopy[type] = QuestionsJSON[type].duplicate(true)
	
	# Change question group
	QuestionsJSONCopy[type].shuffle()
	CurrentQuestionGroup = QuestionsJSONCopy[type].pop_front()
	questions_container.display_question_group(CurrentQuestionGroup, type)

func questions_done() -> void:
	if Global.got_questions == Global.total_points:
		if score_label.get_points() == Global.total_points:
			congrats.show()
			congrats.play_congrats_entrance()
		else:
			retry.show()
			retry.play_retry_entrance()
	else:
		update_fog()
		_display_question()
	
func update_fog() -> void:
	var alpha: float = remap(score_label.getCompleteRatio(), 0, 1, 0.9, 0)
	print(score_label.getCompleteRatio())
	fog.modulate = Color("#FFFFFF", alpha)
