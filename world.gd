extends Node3D
class_name World

@onready var player: Player = $Player

func _ready() -> void:
	DependencyHelper.store("Items", $Items)
	AudioPlayer.play_background_music()
