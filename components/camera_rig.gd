extends Camera3D
class_name CameraRig

@export var offset: Vector3 = Vector3(0, 5, -5)

## Node to follow
var target: CameraTarget

func _ready() -> void:
	set_process(false)

func set_target(new_target: CameraTarget) -> void:
	target = new_target
	set_process(true)

func _process(_delta: float) -> void:
	if not target: return
	look_at_from_position(target.global_position + offset, target.global_position)
