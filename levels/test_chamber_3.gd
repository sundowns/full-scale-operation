extends Level

@onready var admin_sprite: Sprite3D = $AdminSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func initialise() -> bool:
	## code goes here
	Callable(start).call_deferred()
	return super()

func start() -> void:
	admin_sprite.visible = false
	await get_tree().create_timer(0.5).timeout
	level_dialogue_manager.play("prison_1")

func play_end_level_sequence() -> void:
	animation_player.play("raise_glass")
	await animation_player.animation_finished
	level_dialogue_manager.play("prison_4")
	await Dialogic.timeline_ended
	$Scale/RightDish/TestItemSprite.visible = false
	admin_sprite.visible = true
	animation_player.play("admin_escape")

@warning_ignore("unused_parameter")
func _on_dialogic_signal_event(argument) -> void: pass

func _on_scale_scale_valid() -> void:
	play_end_level_sequence()

func _on_first_player_detection_area_player_entered() -> void:
	level_dialogue_manager.play("prison_2")

func _on_anvil_sighting_detection_area_player_entered() -> void:
	level_dialogue_manager.play("prison_3")
