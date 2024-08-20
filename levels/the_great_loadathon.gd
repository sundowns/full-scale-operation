extends Level

@onready var delay_timer: Timer = $DelayTimer
@onready var item_spawner: AllItemSpawner = $AllItemSpawner
@onready var lamp: Lamp = $Lamp
@onready var item_anchor: Node = $Items
@onready var crate: ItemCrate = $Crate

var movement_complete: bool = false
var dialogue_complete: bool = false
var lamp_effect_complete: bool = false
var items_complete: bool = false
var crate_effect_complete: bool = false

func initialise() -> bool:
	## code goes here
	super()
	AudioPlayer.muted = true
	Callable(commence_loadathon).call_deferred()
	return false ## prevent fading this scene in

func commence_loadathon() -> void:
	await get_tree().process_frame
	Callable(move_player_around).call_deferred()
	Callable(play_dialogue).call_deferred()
	Callable(spawn_items).call_deferred()
	Callable(lampma).call_deferred()
	Callable(cratema).call_deferred()

func fade_to_black() -> void:
	ScreenFade.fade_out()

func play_dialogue() -> void:
	Dialogic.start("blank")
	await Dialogic.timeline_ended
	dialogue_complete = true

func move_player_around() -> void:
	for frame in range(30):
		Input.parse_input_event(create_input("move_left", frame %2 == 0))
		if frame % 3 == 0:
			Input.parse_input_event(create_input("move_up"))
		if frame % 3 == 1:
			Input.parse_input_event(create_input("move_down"))
		await get_tree().physics_frame
	for frame in range(30):
		Input.parse_input_event(create_input("move_right", frame %2 == 0))
		if frame % 3 == 0:
			Input.parse_input_event(create_input("move_up"))
		if frame % 3 == 1:
			Input.parse_input_event(create_input("move_down"))
		await get_tree().physics_frame
	await get_tree().physics_frame
	Input.parse_input_event(create_input("move_right", false))
	await get_tree().physics_frame
	movement_complete = true

func spawn_items() -> void:
	Callable(item_spawner.spawn_all_items).call_deferred()
	await get_tree().process_frame
	for item in item_anchor.get_children():
		item._mark_as_target_for_pickup()
	await get_tree().process_frame
	for item in item_anchor.get_children():
		item._unmark_as_target_for_pickup()
	await get_tree().process_frame
	items_complete = true

func lampma() -> void:
	lamp.turn_on()
	await get_tree().process_frame
	lamp.turn_off()
	await get_tree().process_frame
	lamp_effect_complete = true

func cratema () -> void:
	crate.smash()
	await get_tree().create_timer(0.8).timeout
	crate_effect_complete = true

func _process(_delta: float) -> void:
	if is_finished_all():
		set_process(false)
		AudioPlayer.muted = false
		LevelManager.level_complete(false)

func is_finished_all() -> bool:
	return movement_complete and dialogue_complete and lamp_effect_complete and items_complete and crate_effect_complete

func create_input(action_name: String, pressed: bool = true) -> InputEventAction:
	var action := InputEventAction.new()
	action.action = action_name
	action.pressed = pressed
	return action
