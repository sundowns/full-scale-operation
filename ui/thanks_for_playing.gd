extends Control

func _on_quit_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Callable(quit).call_deferred()

func quit() -> void:
	get_tree().quit()
