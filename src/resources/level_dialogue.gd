extends Resource
class_name LevelDialogue

@export var label: String = ""
@export var timeline: DialogicTimeline
@export var one_shot: bool = true
@export var pause_game: bool = true

var has_run: bool = false

func play() -> void:
	if one_shot and has_run:
		return
	if Dialogic.current_timeline != null:
		push_warning("A timeline was already running, we should queue stuff??????")
		return
	has_run = true
	Dialogic.start(timeline)
	if pause_game:
		DependencyHelper.retrieve("World").pause_game()
		await Dialogic.timeline_ended
		DependencyHelper.retrieve("World").unpause_game()
