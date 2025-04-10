extends StaticBody3D 

var Questions: Array

func _ready():
	var question_node: Control = $"..".QuestionsNode
	Questions = question_node.Questions

func display_question():
	print(Questions, " Question!")
