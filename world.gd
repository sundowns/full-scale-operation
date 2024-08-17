extends Node3D
class_name World

@onready var camera: CameraRig = $CameraRig
@onready var player: Player = $Player

func _ready() -> void:
	DependencyHelper.store("Camera", $CameraRig)
	DependencyHelper.store("Items", $Items)
