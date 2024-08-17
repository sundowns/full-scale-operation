extends Camera3D
class_name CameraRig

## Node to follow
@export var target: Node3D

@export var offset_xz: Vector3 = Vector3(0, 0, 8)
@export_range(0, 1000000, 0.5) var fixed_height: float = 6.5
@export_range(0.1, 5, 0.1) var follow_speed: float = 1.7

func _ready() -> void:
	if not target:
		set_process(false)

func set_target(new_target: Node3D) -> void:
	target = new_target
	set_process(true)

func _process(delta: float) -> void:
	if not target: return
	var new_camera_position = target.global_position + offset_xz
	new_camera_position.y = fixed_height
	
	global_position = lerp(global_position, new_camera_position, delta * follow_speed)
