extends TouchScreenJoystick

#func _input(event: InputEvent) -> void:
	#if event is InputEventScreenTouch:
		#if event.pressed:
			#position = event.position
			#show()
		#if event.canceled:
			#hide()
