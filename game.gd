extends Node
class_name Game

@onready var world_anchor: Node3D = $WorldAnchor

var current_world: Level

var current_level_index: int = -1

var levels: Array[PackedScene] = [
	preload("res://levels/test_world_1.tscn")
]

func _ready() -> void:
	AudioPlayer.play_background_music()
	load_next_level()

func clear_world() -> void:
	for child in world_anchor.get_children():
		child.queue_free()

func load_next_level() -> void:
	clear_world()
	current_level_index += 1
	var new_world: Level = levels[current_level_index].instantiate() as Level
	world_anchor.add_child(new_world)
	new_world.initialise()
