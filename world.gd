extends Node3D
class_name World

@onready var camera: CameraRig = $CameraRig
@onready var camera_target: Marker3D = $CameraTarget

func _ready() -> void:
	DependencyHelper.store("Camera", $CameraRig)
	camera.set_target(camera_target)
