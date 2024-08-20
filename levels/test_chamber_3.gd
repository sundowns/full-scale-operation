extends Level

@onready var toggleable_door: ToggleableDoor = $ToggleableDoor

func initialise() -> bool:
	## code goes here
	return super()

@warning_ignore("unused_parameter")
func _on_dialogic_signal_event(argument) -> void: pass

func _on_feather_sighted_player_entered() -> void:
	level_dialogue_manager.play("feather_spotted")

func _on_other_feather_sighted_player_entered() -> void:
	level_dialogue_manager.play("second_feather_spotted")

func _on_player_detection_area_player_entered() -> void:
	if toggleable_door.is_open:
		level_dialogue_manager.play("end")
