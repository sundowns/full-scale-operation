extends Node3D
class_name World

@onready var camera: CameraRig = $CameraRig
@onready var player: Player = $Player

func _ready() -> void:
	DependencyHelper.store("Camera", $CameraRig)
	#Callable(camera.set_target).call_deferred($Marker3D)
	#camera.set_target(player)
