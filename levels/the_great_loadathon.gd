extends Level

@onready var delay_timer: Timer = $DelayTimer

var movement_complete: bool = false
var lamp_effect_complete: bool = false

func initialise() -> void:
	## code goes here
	super()
	Callable(commence_loadathon).call_deferred()

func commence_loadathon() -> void:
	fade_to_black()
	Callable(move_player_around).call_deferred()

func fade_to_black() -> void:
	ScreenFade.fade_out()
	await ScreenFade.finished

func move_player_around() -> void:
	for frame in range(15):
		Input.parse_input_event(create_input("move_left", frame %2 == 0))
		if frame % 3 == 0:
			Input.parse_input_event(create_input("move_up"))
		if frame % 3 == 1:
			Input.parse_input_event(create_input("move_down"))
		await get_tree().physics_frame
	for frame in range(15):
		Input.parse_input_event(create_input("move_right", frame %2 == 0))
		if frame % 3 == 0:
			Input.parse_input_event(create_input("move_up"))
		if frame % 3 == 1:
			Input.parse_input_event(create_input("move_down"))
		await get_tree().physics_frame
	await get_tree().physics_frame
	Input.parse_input_event(create_input("move_right", false))
	await get_tree().physics_frame
	#Input.parse_input_event(create_input("move_right", false))
	#Input.parse_input_event(create_input("move_right", ))
	movement_complete = true

func _process(delta: float) -> void:
	if is_finished_all():
		set_process(false)
		LevelManager.level_complete()

func is_finished_all() -> bool:
	return movement_complete # TODO: add the others

func _on_dialogic_signal_event(argument) -> void: pass

func create_input(action_name: String, pressed: bool = true) -> InputEventAction:
	var action := InputEventAction.new()
	action.action = action_name
	action.pressed = pressed
	return action
