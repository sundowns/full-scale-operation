extends Level

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func initialise() -> bool:
	DependencyHelper.store("World", self)
	Callable(start).call_deferred()
	return true

func start() -> void:
	animation_player.play("party_time")
	AudioPlayer.play_party_music()
	await get_tree().create_timer(2.5).timeout
	level_dialogue_manager.play("start")
	await Dialogic.timeline_ended
	await get_tree().create_timer(2.5).timeout
	LevelManager.level_complete()

@warning_ignore("unused_parameter")
func _on_dialogic_signal_event(argument) -> void: pass
