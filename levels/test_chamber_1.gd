extends Level

func initialise() -> bool:
	## code goes here
	Callable(play_starting_dialogue).call_deferred()
	return super()

func play_starting_dialogue() -> void:
	await get_tree().create_timer(0.5).timeout
	level_dialogue_manager.play("start")

@warning_ignore("unused_parameter")
func _on_dialogic_signal_event(argument) -> void: pass
