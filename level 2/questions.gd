extends Control

@onready var questions_container: Control = $Questions
#@onready var cross: Label = $"../../Overlay/Cross"
@onready var score_label: Label = $"../ScoreContainer/ScoreLabel"
@onready var congrats: TextureRect = $"../Congrats"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var fog: TextureRect = $Fog
@onready var player: CharacterBody3D = $"../../Player"
@onready var crows: Node3D = $"../../Crows"
@onready var retry: ColorRect = $"../Retry"

var QuestionsJSON: Dictionary = {}
var QuestionsJSONCopy: Dictionary = {}
var CurrentQuestionGroup: Dictionary = {}
var group_question_count: int

func _ready() -> void:
	var questions_path = "res://questions/%s/Level 2.json" % Global.language_current
		
	fog.modulate = Color("#FFFFFF", 0.9)
	Global.got_questions = 0
	
	var dataClass = ReadData.new()
	QuestionsJSON = dataClass.load_question_data_from_json(questions_path)
	QuestionsJSONCopy = QuestionsJSON.duplicate(true)
	
	hide()

func display_question(collider: StaticBody3D) -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if OS.has_feature('web'):
		JavaScriptBridge.eval("""
			document.exitPointerLock();
		""")
	#cross.hide()
	
	for crow in crows.get_children():
		crow.enable_crow()
	collider.get_parent().disable_crow()
	
	show()
	
	_display_question()


func _display_question():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	const questionType := [
		"ChooseTheCorrectAnswer",
		"MultipleChoice",
		"FillInTheBlank"]
		
	randomize()
	var type: String = questionType[randi_range(0, 2)]
	
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
		#cross.show()
		updateFog()
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func updateFog() -> void:
	var alpha: float = remap(score_label.getCompleteRatio(), 0, 1, 0.9, 0)
	fog.modulate = Color("#FFFFFF", alpha)
	$"../../WorldEnvironment".environment.fog_density = remap(score_label.getCompleteRatio(), 0, 1, 0.05, 0)


func _on_explainer_closed_explainer() -> void:
	pass
	#player.canMoveCamera = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
