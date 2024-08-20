extends Level

@onready var toggleable_door: ToggleableDoor = $ToggleableDoor


func initialise() -> bool:
	## code goes here
	Callable(play_starting_dialogue).call_deferred()
	return super()

func play_starting_dialogue() -> void:
	await get_tree().create_timer(0.5).timeout
	level_dialogue_manager.play("start")

@warning_ignore("unused_parameter")
func _on_dialogic_signal_event(argument) -> void: pass

func _on_player_detection_area_player_entered() -> void:
	level_dialogue_manager.play("scales_spotted")

func _on_player_detection_area_scale_crate_found_player_entered() -> void:
	level_dialogue_manager.play("crate_spotted")

func _on_crate_smashed() -> void:
	level_dialogue_manager.play("crate_broken")

func _on_exitarea_player_entered() -> void:
	if toggleable_door.is_open:
		level_dialogue_manager.play("end")
