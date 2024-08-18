extends Node
class_name Game

@onready var world_anchor: Node3D = $WorldAnchor

var current_world: Level

func _ready() -> void:
	AudioPlayer.play_background_music()
	LevelManager.next_level_requested.connect(self.load_next_level, CONNECT_DEFERRED)
	LevelManager.start_game()

func clear_world() -> void:
	for child in world_anchor.get_children():
		child.queue_free()

func load_next_level() -> void:
	clear_world()
	var new_world: Level = LevelManager.get_level_scene(LevelManager.current_level_index) .instantiate() as Level
	world_anchor.add_child(new_world)
	new_world.initialise()
