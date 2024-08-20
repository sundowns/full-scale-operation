extends Node3D
class_name ToggleableDoor

@onready var animation_player: AnimationPlayer = $"wall-door-rotate/AnimationPlayer"

var is_open: bool =	false

func open() -> void:
	animation_player.play("open")
	is_open = true

func close() -> void:
	animation_player.play("close")
	is_open = false
