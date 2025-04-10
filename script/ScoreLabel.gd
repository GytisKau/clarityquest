extends Label

var score: int = 0
var score_text: String = "Score: "
func _ready():
	score_text = Global.translation["Score"] + ": "
	_updateLabel()

func addPoints(points: int) -> void:
	score += points
	_updateLabel()

func getCompleteRatio() -> float:
	return float(score)/Global.total_points

func setTotalScore(points: int) -> void:
	Global.total_points = points

func clearPoints() -> void:
	score = 0
	_updateLabel()

func get_points() -> int:
	return score

func _updateLabel():
	text = score_text + str(score) + "/" + str(Global.total_points)

func hasZeroPoints() -> bool:
	return score == 0
