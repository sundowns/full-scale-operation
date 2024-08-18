extends Camera3D
class_name CameraRig

## Node to follow
@export var target: Node3D

@export var offset: Vector3 = Vector3(0, 4, 5)
#@export_range(0, 1000000, 0.5) var fixed_height: float = 6.5
@export_range(0.1, 5, 0.1) var follow_speed: float = 1.7
@export var zoom_increment: float = 0.5
@export var zoom_in_limit: float = -3.5
@export var zoom_out_limit: float  = 1.0
var zoom: float = 0.0

var offset_normalized: Vector3 = Vector3.ZERO

func _ready() -> void:
	if not target:
		set_process(false)
	offset_normalized = offset.normalized()

func set_target(new_target: Node3D) -> void:
	target = new_target
	set_process(true)

func _process(delta: float) -> void:
	if not target: return
	Callable(move_towards_target).call_deferred(delta)
	
	if Input.is_action_just_released("scroll_up"):
		zoom -= zoom_increment
	elif Input.is_action_just_released("scroll_down"):
		zoom += zoom_increment
	zoom = clamp(zoom, zoom_in_limit, zoom_out_limit)

func move_towards_target(delta: float) -> void:
	var target_position = target.global_position
	if target is Player:
		target_position = target.get_extrapolated_position(delta)
	var new_camera_position = target_position + offset + (offset_normalized * zoom)
	var zoom_ratio: float = remap(zoom, zoom_in_limit, zoom_out_limit, 0, 1)
	
	global_position = lerp(global_position, new_camera_position, delta * (follow_speed * (1 + (1-zoom_ratio))))
