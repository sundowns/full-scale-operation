extends Node
class_name Game

@export var play_bg_music: bool = false

@onready var world_anchor: Node3D = $SubViewportContainer/SubViewport/WorldAnchor
@onready var ui_overlay: UiOverlay = $ui_overlay

var current_world: Level

#var is_first_level: bool = true

func _ready() -> void:
	if OS.has_feature("release") or play_bg_music:
		AudioPlayer.play_background_music()
	DependencyHelper.store("UI", $ui_overlay)
	LevelManager.next_level_requested.connect(self.load_next_level, CONNECT_DEFERRED)
	LevelManager.start_game()
	ui_overlay.visible = false

func clear_world() -> void:
	for child in world_anchor.get_children():
		child.queue_free()
	current_world = null

func load_next_level() -> void:
	clear_world()
	var new_world: Level = LevelManager.get_level_scene(LevelManager.current_level_index) .instantiate() as Level
	world_anchor.add_child(new_world)
	current_world = new_world
	new_world.initialise()
	#if not is_first_level:
	Callable(fade_world_in).call_deferred()
	#is_first_level = false

func fade_world_in() -> void:
	ScreenFade.fade_in()
	await ScreenFade.finished
	ui_overlay.visible = true
