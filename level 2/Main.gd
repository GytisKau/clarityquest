extends Node
@onready var explainer: PanelContainer = $UserInterface/Explainer
@onready var retry: ColorRect = $UserInterface/Retry
@onready var congrats: TextureRect = $UserInterface/Congrats
@onready var http: HTTPRequest = $HTTPRequest

func _ready():
	if Global.use_tracking && OS.has_feature("web"):
		var window = JavaScriptBridge.get_interface("window")
		var track_url = window.location.href + "track.php"

		var url: String = "%s?player=%s&level=%s&lang=%s" % \
			[track_url, Global.player_id, 2, Global.language_current.to_lower()]
		if http.request(url) != OK:
			printerr("Cant make a request to url: " + track_url)
	
	explainer.show()
	retry.hide()
	congrats.hide()
	
