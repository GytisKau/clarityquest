class_name ReadData
	# URL of the JSON file
var url : String = "https://example.com/data.json"
# HTTPRequest node
var http_request : HTTPRequest

func load_question_data_from_json(file_path: String) -> Dictionary:
	if !FileAccess.file_exists(file_path):
		printerr("No such file found: " + file_path)
		return {}
		
	var dataFile = FileAccess.open(file_path, FileAccess.READ)
	if dataFile == null:
		printerr(FileAccess.get_open_error())
		return {}
		
	var text = dataFile.get_as_text()
	if text.length() == 0:
		printerr("Empty JSON file: " + file_path)
		return {}
		
	var parsedResult = JSON.parse_string(text)
	return parsedResult

func load_question_data_from_url() -> void:
	#Create and add the HTTPRequest node to the scene
	http_request = HTTPRequest.new()
	
	#Connect the request_completed signal to a method to handle the response
	if !http_request.request_completed.is_connected(_on_request_completed):
		var status = http_request.request_completed.connect(_on_request_completed)
		if status == ERR_INVALID_PARAMETER:
			printerr("Cant connect callback to http_request node")
	
	#Make the request
	var error = http_request.request(url)
	if error != OK:
		print("An error occurred in the request: ", error)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		print("Response: %s" % response_text)
	else:
		print("HTTP Request failed with response code: %d" % response_code)
