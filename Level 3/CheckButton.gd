extends Button

func _on_mouse_entered():
	mouse_default_cursor_shape = CursorShape.CURSOR_POINTING_HAND

func _on_mouse_exited():
	mouse_default_cursor_shape = CursorShape.CURSOR_ARROW
