extends Node3D
class_name ToggleableDoor

@onready var animation_player: AnimationPlayer = $"wall-door-rotate/AnimationPlayer"

func open() -> void:
	animation_player.play("open")

func close() -> void:
	animation_player.play("close")
